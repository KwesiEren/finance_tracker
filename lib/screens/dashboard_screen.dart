import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../models/data_models.dart';
import '../providers/app_providers.dart';
import '../services/sms_service.dart';
import '../widgets/fused_button.dart';
import '../widgets/budget_row.dart';
import '../widgets/transaction_tile.dart';

import '../widgets/category_chip.dart';
import '../widgets/fused_text_field.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  static const routeName = 'Dashboard';
  static const routePath = '/dashboard';

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final _smsService = SmsService();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final monthSummary = ref.watch(monthSummaryProvider);
    final categories = ref.watch(categoriesProvider);
    final transactions = ref.watch(transactionsProvider);
    final expenseCategories = categories.where((c) => c.type == 'expense').toList();
    final formatter = NumberFormat.currency(symbol: 'GH₵ ', decimalDigits: 0);

    // Build spent-by-category map for budgets
    final spentByCategory = <String, double>{};
    for (final tx in transactions) {
      if (tx.type == 'expense' && tx.categoryId != null) {
        spentByCategory[tx.categoryId!] = (spentByCategory[tx.categoryId!] ?? 0) + tx.amount;
      }
    }

    final safeToSpend = _calculateSafeToSpend(monthSummary.income, monthSummary.expense);
    final daysLeft = _daysLeftInMonth();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTransactionBottomSheet(context),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        icon: const Icon(Icons.add_rounded),
        label: Text('Add Transaction', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(transactionsProvider);
          ref.invalidate(categoriesProvider);
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Header with Safe to Spend
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Safe to Spend',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onPrimary.withValues(alpha: 0.8),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${formatter.currencySymbol}${safeToSpend.toStringAsFixed(0)}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 36,
                                fontWeight: FontWeight.w700,
                                color: colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: colorScheme.onPrimary.withValues(alpha: 0.2),
                          child: Text(
                            'FA',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1, color: Colors.white24),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSummaryItem(
                          'Monthly Balance',
                          '${formatter.format(monthSummary.income - monthSummary.expense)}',
                          colorScheme.onPrimary,
                        ),
                        _buildSummaryItem(
                          'Days Left',
                          '$daysLeft Days',
                          colorScheme.onPrimary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Pending SMS Alert
                    _buildPendingSmsAlert(colorScheme),
                    const SizedBox(height: 24),

                    // Budgets
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'My Budgets',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        TextButton(
                          onPressed: () => _navigateToCategories(),
                          child: Text(
                            'Adjust',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (expenseCategories.isEmpty)
                      _buildEmptyBudgets(colorScheme)
                    else
                      Column(
                        children: expenseCategories.map((category) {
                          final spent = spentByCategory[category.id] ?? 0;
                          final budget = category.monthlyCap ?? 0;
                          return BudgetRow(
                            category: category,
                            spent: spent,
                            budget: budget,
                            onTap: () => _navigateToCategories(),
                            onEdit: () => _editCategoryBudget(category),
                          );
                        }).toList(),
                      ),

                    const SizedBox(height: 24),

                    // Recent Transactions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Transactions',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => _navigateToReports(),
                          icon: Icon(Icons.history_rounded, size: 18, color: colorScheme.primary),
                          label: Text('All', style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: colorScheme.primary)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildRecentTransactions(transactions, categories, colorScheme),
                    const SizedBox(height: 100), // FAB space
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: color.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildPendingSmsAlert(ColorScheme colorScheme) {
    return Consumer(
      builder: (context, ref, _) {
        // We'll check pending SMS count via a future provider or stream
        return FutureBuilder<int>(
          future: _smsService.getPendingSmsCount(),
          builder: (context, snapshot) {
            final count = snapshot.data ?? 0;
            if (count == 0) return const SizedBox.shrink();

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: Row(
                children: [
                  Icon(Icons.model_training_rounded, color: colorScheme.onSecondaryContainer, size: 28),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$count New Message${count > 1 ? 's' : ''}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSecondaryContainer,
                          ),
                        ),
                        Text(
                          'Review detected transactions to update your budgets',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: colorScheme.onSecondaryContainer.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  FusedButton(
                    label: 'Review Now',
                    variant: FusedButtonVariant.outline,
                    size: FusedButtonSize.small,
                    onPressed: () => _navigateToPendingSms(),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyBudgets(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          Icon(Icons.account_balance_wallet_outlined, size: 48, color: colorScheme.onSurfaceVariant),
          const SizedBox(height: 12),
          Text(
            'No budgets set yet',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Add categories with monthly caps to track spending',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          FusedButton(
            label: 'Manage Categories',
            variant: FusedButtonVariant.primary,
            onPressed: _navigateToCategories,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions(
    List<TransactionModel> transactions,
    List<CategoryModel> categories,
    ColorScheme colorScheme,
  ) {
    final recent = transactions.take(5).toList();
    final categoryMap = {for (final c in categories) c.id: c};

    if (recent.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.receipt_long_outlined, size: 48, color: colorScheme.onSurfaceVariant),
              const SizedBox(height: 12),
              Text(
                'No transactions yet',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Tap the + button to add your first transaction',
                style: GoogleFonts.inter(fontSize: 13, color: colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: recent.map((tx) {
        final category = tx.categoryId != null ? categoryMap[tx.categoryId!] : null;
        return TransactionTile(
          transaction: tx,
          category: category,
          onTap: () {},
        );
      }).toList(),
    );
  }

  double _calculateSafeToSpend(double income, double expense) {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final daysLeft = daysInMonth - now.day + 1;
    final remaining = income - expense;
    if (daysLeft <= 0) return remaining;
    return (remaining / daysLeft).clamp(0, double.infinity);
  }

  int _daysLeftInMonth() {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    return daysInMonth - now.day + 1;
  }

  void _navigateToPendingSms() {
    // Navigate to tab index 1
    // For now, we'll use a simple approach
    Navigator.pushNamed(context, '/pending');
  }

  void _navigateToCategories() {
    // Navigate to tab index 4
    Navigator.pushNamed(context, '/categories');
  }

  void _navigateToReports() {
    Navigator.pushNamed(context, '/reports');
  }

  void _editCategoryBudget(CategoryModel category) {
    final controller = TextEditingController(text: category.monthlyCap?.toStringAsFixed(0) ?? '');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Set Budget for ${category.name}', style: GoogleFonts.plusJakartaSans()),
        content: FusedTextField(
          controller: controller,
          label: 'Monthly Cap',
          hint: 'Enter amount',
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FusedButton(
            label: 'Save',
            onPressed: () {
              final cap = double.tryParse(controller.text);
              ref.read(categoriesProvider.notifier).upsert(category.copyWith(monthlyCap: cap));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showAddTransactionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) => _AddTransactionSheet(scrollController: scrollController),
      ),
    );
  }
}

class _AddTransactionSheet extends ConsumerStatefulWidget {
  final ScrollController scrollController;

  const _AddTransactionSheet({required this.scrollController});

  @override
  ConsumerState<_AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends ConsumerState<_AddTransactionSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String _selectedType = 'expense';
  String? _selectedCategoryId;
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final categories = ref.watch(categoriesProvider);
    final filteredCategories = categories.where((c) => c.type == _selectedType).toList();

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              children: [
                Text(
                  'Add Transaction',
                  style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          // Form
          Expanded(
            child: SingleChildScrollView(
              controller: widget.scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Type selector
                    Row(
                      children: ['income', 'expense'].map((type) {
                        final isSelected = _selectedType == type;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ChoiceChip(
                              label: Text(
                                type.capitalize(),
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
                                ),
                              ),
                              selected: isSelected,
                              onSelected: (_) => setState(() => _selectedType = type),
                              selectedColor: colorScheme.primary,
                              backgroundColor: colorScheme.surfaceContainerHighest,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: isSelected ? colorScheme.primary : colorScheme.outlineVariant,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Amount
                    Text('Amount', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: colorScheme.onSurfaceVariant)),
                    const SizedBox(height: 8),
                    FusedCurrencyField(
                      controller: _amountController,
                      hint: '0.00',
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 24),

                    // Category
                    Text('Category', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: colorScheme.onSurfaceVariant)),
                    const SizedBox(height: 8),
                    CategorySelector(
                      categories: filteredCategories,
                      selectedCategoryId: _selectedCategoryId,
                      onCategorySelected: (id) => setState(() => _selectedCategoryId = id),
                    ),
                    const SizedBox(height: 24),

                    // Date
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime.now().subtract(const Duration(days: 365)),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) setState(() => _selectedDate = picked);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: colorScheme.outlineVariant),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today_rounded, color: colorScheme.onSurfaceVariant, size: 20),
                            const SizedBox(width: 12),
                            Text(
                              DateFormat('MMM d, yyyy').format(_selectedDate),
                              style: GoogleFonts.inter(fontSize: 16, color: colorScheme.onSurface),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Note
                    FusedTextField(
                      controller: _noteController,
                      label: 'Note (optional)',
                      hint: 'Add a note...',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 32),

                    // Save button
                    FusedButton(
                      label: 'Save Transaction',
                      variant: FusedButtonVariant.primary,
                      size: FusedButtonSize.large,
                      fullWidth: true,
                      onPressed: _saveTransaction,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveTransaction() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a category')),
      );
      return;
    }

    final amount = double.tryParse(_amountController.text.replaceAll(',', '')) ?? 0;
    if (amount <= 0) return;

    final transaction = TransactionModel(
      id: const Uuid().v4(),
      amount: amount,
      type: _selectedType,
      categoryId: _selectedCategoryId,
      date: _selectedDate,
      note: _noteController.text.isEmpty ? null : _noteController.text,
      source: 'manual',
    );

    await ref.read(transactionsProvider.notifier).add(transaction);
    if (mounted) Navigator.pop(context);
  }
}

extension StringExtension on String {
  String capitalize() => '${this[0].toUpperCase()}${substring(1)}';
}