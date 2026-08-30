import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database_helper.dart';
import '../models/data_models.dart';
import '../models/settings_data.dart';
import '../services/notification_service.dart';
import '../services/sms_refresh.dart';

final dbProvider = Provider((ref) => DatabaseHelper.instance);

/// All categories, user-editable. Refresh after any add/edit/delete.
final categoriesProvider =
    StateNotifierProvider<CategoriesNotifier, List<CategoryModel>>((ref) {
  return CategoriesNotifier(ref);
});

class CategoriesNotifier extends StateNotifier<List<CategoryModel>> {
  final Ref ref;
  CategoriesNotifier(this.ref) : super([]) {
    load();
  }

  Future<void> load() async {
    state = await ref.read(dbProvider).getCategories();
  }

  Future<void> upsert(CategoryModel category) async {
    await ref.read(dbProvider).upsertCategory(category);
    await load();
  }

  Future<void> remove(String id) async {
    await ref.read(dbProvider).deleteCategory(id);
    await load();
  }
}

/// Transactions for the currently viewed period (defaults to this month).
final transactionsProvider =
    StateNotifierProvider<TransactionsNotifier, List<TransactionModel>>((ref) {
  return TransactionsNotifier(ref);
});

class TransactionsNotifier extends StateNotifier<List<TransactionModel>> {
  final Ref ref;
  TransactionsNotifier(this.ref) : super([]) {
    loadCurrentMonth();
  }

  Future<void> loadCurrentMonth() async {
    final now = DateTime.now();
    final from = DateTime(now.year, now.month, 1);
    state = await ref.read(dbProvider).getTransactions(from: from, to: now);
  }

  /// Adds a transaction, then immediately checks whether its category
  /// just crossed the alert threshold or the hard cap.
  Future<void> add(TransactionModel tx) async {
    await ref.read(dbProvider).insertTransaction(tx);
    await loadCurrentMonth();
    if (tx.type == 'expense' && tx.categoryId != null) {
      await _checkBudget(tx.categoryId!);
    }
  }

  Future<void> _checkBudget(String categoryId) async {
    final categories = ref.read(categoriesProvider);
    final category = categories.where((c) => c.id == categoryId).firstOrNull;
    if (category == null || category.monthlyCap == null) return;

    final now = DateTime.now();
    final from = DateTime(now.year, now.month, 1);
    final spentByCategory = await ref.read(dbProvider).getSpentByCategory(from, now);
    final spent = spentByCategory[categoryId] ?? 0;
    final cap = category.monthlyCap!;
    final settingsAsync = ref.read(settingsProvider);

    final settings = settingsAsync.value;
    if (settings == null) return;

    if (spent >= cap) {
      await NotificationService.instance.showBudgetAlert(
        categoryName: category.name,
        spent: spent,
        cap: cap,
        exceeded: true,
      );
    } else if (spent / cap >= settings.capAlertThreshold) {
      await NotificationService.instance.showBudgetAlert(
        categoryName: category.name,
        spent: spent,
        cap: cap,
        exceeded: false,
      );
    }
  }
}

/// User settings — currency, payday, report frequency, alert threshold.
final settingsProvider = StateNotifierProvider<SettingsNotifier, AsyncValue<SettingsData>>((ref) {
  return SettingsNotifier();
});

final smsTickProvider = StreamProvider<void>((ref) async* {
  await for (final _ in smsRefreshController.stream) {
    yield null;
  }
});

final pendingSmsProvider = FutureProvider<List<PendingSmsItem>>((ref) async {
  // Rebuild whenever sms tables change
  ref.watch(smsTickProvider);
  final db = ref.watch(dbProvider);
  final rows = await db.getPendingSms();
  return rows.map((r) => PendingSmsItem.fromMap(r)).toList();
});

final unrecognizedSmsProvider = FutureProvider<List<UnrecognizedSmsItem>>((ref) async {
  ref.watch(smsTickProvider);
  final db = ref.watch(dbProvider);
  final rows = await db.getUnrecognized();
  return rows.map((r) => UnrecognizedSmsItem.fromMap(r)).toList();
});

/// Convenience: total income/expense for the currently loaded transaction list.
final monthSummaryProvider = Provider<({double income, double expense})>((ref) {
  final txs = ref.watch(transactionsProvider);
  double income = 0, expense = 0;
  for (final t in txs) {
    if (t.type == 'income') {
      income += t.amount;
    } else {
      expense += t.amount;
    }
  }
  return (income: income, expense: expense);
});
