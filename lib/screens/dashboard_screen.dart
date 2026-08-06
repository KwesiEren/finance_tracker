import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';
import '../widgets/budget_progress_bar.dart';
import 'add_transaction_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    final transactions = ref.watch(transactionsProvider);
    final summary = ref.watch(monthSummaryProvider);
    final settings = ref.watch(settingsProvider);

    final now = DateTime.now();
    final daysLeftInMonth = DateTime(now.year, now.month + 1, 0).day - now.day + 1;
    final remaining = summary.income - summary.expense;
    final safeToSpendToday = daysLeftInMonth > 0 ? remaining / daysLeftInMonth : remaining;

    // Spend per category, computed client-side from the loaded month's transactions.
    final spentByCategory = <String, double>{};
    for (final t in transactions.where((t) => t.type == 'expense')) {
      spentByCategory[t.categoryId] = (spentByCategory[t.categoryId] ?? 0) + t.amount;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('This Month')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
        ),
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(transactionsProvider.notifier).loadCurrentMonth(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Income: ${settings.currencySymbol} ${summary.income.toStringAsFixed(2)}'),
                    Text('Spent: ${settings.currencySymbol} ${summary.expense.toStringAsFixed(2)}'),
                    Text('Remaining: ${settings.currencySymbol} ${remaining.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      'Safe to spend today: ${settings.currencySymbol} ${safeToSpendToday.toStringAsFixed(2)}',
                      style: TextStyle(color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Budgets', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...categories.where((c) => c.type == 'expense').map((cat) {
              final spent = spentByCategory[cat.id] ?? 0;
              return BudgetProgressBar(category: cat, spent: spent, currency: settings.currencySymbol);
            }),
          ],
        ),
      ),
    );
  }
}
