import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';

/// Single source of truth for local storage. Everything lives on-device —
/// no backend, no account needed. This keeps the app fast, offline-capable,
/// and means the user's financial data never leaves their phone unless they
/// choose to export it.
class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Database? _db;
  final _uuid = const Uuid();

  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'finance_tracker.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        iconName TEXT NOT NULL,
        colorValue INTEGER NOT NULL,
        type TEXT NOT NULL,
        monthlyCap REAL,
        isDefault INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions (
        id TEXT PRIMARY KEY,
        amount REAL NOT NULL,
        type TEXT NOT NULL,
        categoryId TEXT,
        date TEXT NOT NULL,
        note TEXT,
        source TEXT NOT NULL,
        rawSmsBody TEXT,
        FOREIGN KEY (categoryId) REFERENCES categories (id) ON DELETE SET NULL
      )
    ''');

    // Pending SMS-detected transactions awaiting user confirmation/category.
    await db.execute('''
      CREATE TABLE pending_sms (
        id TEXT PRIMARY KEY,
        amount REAL NOT NULL,
        type TEXT NOT NULL,
        smsDate TEXT NOT NULL,
        rawSmsBody TEXT NOT NULL,
        suggestedCategoryId TEXT,
        dismissed INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await _insertStarterCategories(db);
  }

  /// Suggested starting point only — fully renameable/deletable by the user.
  Future<void> _insertStarterCategories(Database db) async {
    final starters = [
      {'name': 'Transport', 'icon': 'directions_bus', 'color': 0xFF4285F4, 'type': 'expense'},
      {'name': 'Airtime & Data', 'icon': 'phone_android', 'color': 0xFF34A853, 'type': 'expense'},
      {'name': 'Food', 'icon': 'restaurant', 'color': 0xFFFBBC05, 'type': 'expense'},
      {'name': 'Utilities', 'icon': 'bolt', 'color': 0xFFEA4335, 'type': 'expense'},
      {'name': 'Debt Repayment', 'icon': 'payments', 'color': 0xFF9C27B0, 'type': 'expense'},
      {'name': 'Salary', 'icon': 'account_balance_wallet', 'color': 0xFF00BFA5, 'type': 'income'},
    ];
    for (final s in starters) {
      await db.insert('categories', {
        'id': _uuid.v4(),
        'name': s['name'],
        'iconName': s['icon'],
        'colorValue': s['color'],
        'type': s['type'],
        'monthlyCap': null,
        'isDefault': 1,
      });
    }
  }

  // ---------------- Categories ----------------

  Future<List<CategoryModel>> getCategories() async {
    final db = await database;
    final rows = await db.query('categories', orderBy: 'name ASC');
    return rows.map((r) => CategoryModel.fromMap(r)).toList();
  }

  Future<void> upsertCategory(CategoryModel category) async {
    final db = await database;
    await db.insert('categories', category.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteCategory(String id) async {
    final db = await database;
    await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }

  // ---------------- Transactions ----------------

  Future<void> insertTransaction(TransactionModel tx) async {
    final db = await database;
    await db.insert('transactions', tx.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<TransactionModel>> getTransactions({
    DateTime? from,
    DateTime? to,
    String? categoryId,
  }) async {
    final db = await database;
    final where = <String>[];
    final args = <dynamic>[];

    if (from != null) {
      where.add('date >= ?');
      args.add(from.toIso8601String());
    }
    if (to != null) {
      where.add('date <= ?');
      args.add(to.toIso8601String());
    }
    if (categoryId != null) {
      where.add('categoryId = ?');
      args.add(categoryId);
    }

    final rows = await db.query(
      'transactions',
      where: where.isEmpty ? null : where.join(' AND '),
      whereArgs: args,
      orderBy: 'date DESC',
    );
    return rows.map((r) => TransactionModel.fromMap(r)).toList();
  }

  /// Sum spent per category within a date range — the core of budget checks
  /// and the reports screen.
  Future<Map<String, double>> getSpentByCategory(DateTime from, DateTime to) async {
    final db = await database;
    final rows = await db.rawQuery('''
      SELECT categoryId, SUM(amount) as total
      FROM transactions
      WHERE type = 'expense' AND date >= ? AND date <= ?
      GROUP BY categoryId
    ''', [from.toIso8601String(), to.toIso8601String()]);

    return {
      for (final r in rows)
        if (r['categoryId'] != null) r['categoryId'] as String: (r['total'] as num).toDouble()
    };
  }

  Future<double> getTotalByType(String type, DateTime from, DateTime to) async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT SUM(amount) as total FROM transactions
      WHERE type = ? AND date >= ? AND date <= ?
    ''', [type, from.toIso8601String(), to.toIso8601String()]);
    final total = result.first['total'];
    return total == null ? 0.0 : (total as num).toDouble();
  }

  Future<void> deleteTransaction(String id) async {
    final db = await database;
    await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  // ---------------- Pending SMS ----------------

  Future<void> insertPendingSms(Map<String, dynamic> row) async {
    final db = await database;
    await db.insert('pending_sms', row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getPendingSms() async {
    final db = await database;
    return db.query('pending_sms', where: 'dismissed = 0', orderBy: 'smsDate DESC');
  }

  Future<void> dismissPendingSms(String id) async {
    final db = await database;
    await db.update('pending_sms', {'dismissed': 1}, where: 'id = ?', whereArgs: [id]);
  }
}
