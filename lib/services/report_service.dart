import 'package:workmanager/workmanager.dart';
import '../database/database_helper.dart';
import '../models/settings_model.dart';
import 'notification_service.dart';

const String reportTaskName = 'generateSpendingReport';

/// Runs in the background (via workmanager) to build and deliver the
/// user's chosen report — daily or monthly, set in Settings.
class ReportService {
  static Future<void> scheduleReports(ReportFrequency frequency) async {
    await Workmanager().cancelByUniqueName(reportTaskName);

    final frequencyDuration = frequency == ReportFrequency.daily
        ? const Duration(hours: 24)
        : const Duration(days: 30); // simple monthly approximation

    await Workmanager().registerPeriodicTask(
      reportTaskName,
      reportTaskName,
      frequency: frequencyDuration,
      inputData: {'frequency': frequency.name},
    );
  }

  /// Builds the actual summary text. Called both by the background
  /// dispatcher and by the in-app "Reports" screen for an on-demand view.
  static Future<String> buildSummary({required DateTime from, required DateTime to}) async {
    final db = DatabaseHelper.instance;
    final income = await db.getTotalByType('income', from, to);
    final expense = await db.getTotalByType('expense', from, to);
    final byCategory = await db.getSpentByCategory(from, to);
    final categories = await db.getCategories();

    final buffer = StringBuffer();
    buffer.writeln('Income: $income  |  Spent: $expense  |  Left: ${income - expense}');
    for (final cat in categories) {
      final spent = byCategory[cat.id] ?? 0;
      if (spent == 0) continue;
      final capText = cat.monthlyCap != null ? ' / cap ${cat.monthlyCap}' : '';
      buffer.writeln('${cat.name}: $spent$capText');
    }
    return buffer.toString();
  }

  static Future<void> deliverNow(ReportFrequency frequency) async {
    final now = DateTime.now();
    final from = frequency == ReportFrequency.daily
        ? DateTime(now.year, now.month, now.day)
        : DateTime(now.year, now.month, 1);

    final summary = await buildSummary(from: from, to: now);
    await NotificationService.instance.showReport(
      title: frequency == ReportFrequency.daily ? 'Today\'s Spending' : 'This Month\'s Spending',
      body: summary,
    );
  }
}

/// Top-level entry point required by workmanager for background execution.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final freqName = inputData?['frequency'] as String? ?? 'monthly';
    final frequency = ReportFrequency.values.firstWhere((f) => f.name == freqName);
    await ReportService.deliverNow(frequency);
    return Future.value(true);
  });
}
