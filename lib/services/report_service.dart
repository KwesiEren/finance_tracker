import '../database/database_helper.dart';
import '../models/data_models.dart';
import 'notification_service.dart';
import 'package:intl/intl.dart';

class ReportService {
  ReportService._internal();
  static final ReportService instance = ReportService._internal();

  final _db = DatabaseHelper.instance;
  final _notifications = NotificationService.instance;
  final _formatter = NumberFormat.currency(symbol: 'GH₵ ', decimalDigits: 0);

  Future<void> generateAndShowDailyReport() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final transactions = await _db.getTransactions(from: startOfDay, to: endOfDay);
    final income = transactions.where((t) => t.type == 'income').fold(0.0, (sum, t) => sum + t.amount);
    final expense = transactions.where((t) => t.type == 'expense').fold(0.0, (sum, t) => sum + t.amount);
    final net = income - expense;

    if (transactions.isEmpty) return;

    await _notifications.showReport(
      title: 'Daily Summary — ${DateFormat('MMM d').format(now)}',
      body: 'Income: ${_formatter.format(income)}  •  Expense: ${_formatter.format(expense)}  •  Net: ${_formatter.format(net)}',
    );
  }

  Future<void> generateAndShowMonthlyReport() async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 1);

    final transactions = await _db.getTransactions(from: startOfMonth, to: endOfMonth);
    final income = transactions.where((t) => t.type == 'income').fold(0.0, (sum, t) => sum + t.amount);
    final expense = transactions.where((t) => t.type == 'expense').fold(0.0, (sum, t) => sum + t.amount);
    final net = income - expense;

    if (transactions.isEmpty) return;

    await _notifications.showReport(
      title: 'Monthly Summary — ${DateFormat('MMMM yyyy').format(now)}',
      body: 'Income: ${_formatter.format(income)}  •  Expense: ${_formatter.format(expense)}  •  Net: ${_formatter.format(net)}',
    );
  }

  Future<ReportData> getDailyReport(DateTime day) async {
    final startOfDay = DateTime(day.year, day.month, day.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return _buildReport(startOfDay, endOfDay, 'Daily');
  }

  Future<ReportData> getMonthlyReport(DateTime month) async {
    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 1);
    return _buildReport(startOfMonth, endOfMonth, 'Monthly');
  }

  Future<ReportData> _buildReport(DateTime from, DateTime to, String period) async {
    final transactions = await _db.getTransactions(from: from, to: to);
    final income = transactions.where((t) => t.type == 'income').fold(0.0, (sum, t) => sum + t.amount);
    final expense = transactions.where((t) => t.type == 'expense').fold(0.0, (sum, t) => sum + t.amount);
    final net = income - expense;

    final spentByCategory = await _db.getSpentByCategory(from, to);
    final categories = await _db.getCategories();
    final categoryBreakdown = spentByCategory.entries.map((e) {
      final cat = categories.firstWhere((c) => c.id == e.key, orElse: () => CategoryModel(
        id: e.key,
        name: 'Unknown',
        iconName: 'category',
        colorValue: 0xFF757575,
        type: 'expense',
      ));
      return CategorySpending(
        category: cat,
        amount: e.value,
        percentage: expense > 0 ? (e.value / expense * 100) : 0,
      );
    }).toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));

    return ReportData(
      period: period,
      from: from,
      to: to,
      income: income,
      expense: expense,
      net: net,
      transactionCount: transactions.length,
      categoryBreakdown: categoryBreakdown,
    );
  }

  Future<List<ReportData>> getMonthlyReports({int months = 12}) async {
    final reports = <ReportData>[];
    final now = DateTime.now();
    for (int i = 0; i < months; i++) {
      final month = DateTime(now.year, now.month - i, 1);
      reports.add(await getMonthlyReport(month));
    }
    return reports;
  }
}

class ReportData {
  final String period;
  final DateTime from;
  final DateTime to;
  final double income;
  final double expense;
  final double net;
  final int transactionCount;
  final List<CategorySpending> categoryBreakdown;

  ReportData({
    required this.period,
    required this.from,
    required this.to,
    required this.income,
    required this.expense,
    required this.net,
    required this.transactionCount,
    required this.categoryBreakdown,
  });
}

class CategorySpending {
  final CategoryModel category;
  final double amount;
  final double percentage;

  CategorySpending({
    required this.category,
    required this.amount,
    required this.percentage,
  });
}