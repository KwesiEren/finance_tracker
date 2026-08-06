import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/app_providers.dart';
import '../models/settings_model.dart';
import '../services/report_service.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    final transactions = ref.watch(transactionsProvider);
    final settings = ref.watch(settingsProvider);

    final spentByCategory = <String, double>{};
    for (final t in transactions.where((t) => t.type == 'expense')) {
      spentByCategory[t.categoryId] = (spentByCategory[t.categoryId] ?? 0) + t.amount;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Report frequency', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SegmentedButton<ReportFrequency>(
            segments: const [
              ButtonSegment(value: ReportFrequency.daily, label: Text('Daily')),
              ButtonSegment(value: ReportFrequency.monthly, label: Text('Monthly')),
            ],
            selected: {settings.reportFrequency},
            onSelectionChanged: (s) async {
              final newSettings = settings.copyWith(reportFrequency: s.first);
              ref.read(settingsProvider.notifier).state = newSettings;
              await ReportService.scheduleReports(s.first);
            },
          ),
          const SizedBox(height: 24),
          const Text('Spending by category', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          if (spentByCategory.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Text('No spending recorded yet this month.'),
            )
          else
            SizedBox(
              height: 220,
              child: PieChart(
                PieChartData(
                  sections: spentByCategory.entries.map((e) {
                    final cat = categories.where((c) => c.id == e.key).firstOrNull;
                    return PieChartSectionData(
                      value: e.value,
                      title: cat?.name ?? 'Other',
                      color: cat != null ? Color(cat.colorValue) : Colors.grey,
                      radius: 90,
                      titleStyle: const TextStyle(fontSize: 11, color: Colors.white),
                    );
                  }).toList(),
                ),
              ),
            ),
          const SizedBox(height: 24),
          FilledButton.icon(
            icon: const Icon(Icons.notifications_active_outlined),
            label: const Text('Send report now'),
            onPressed: () => ReportService.deliverNow(settings.reportFrequency),
          ),
        ],
      ),
    );
  }
}
