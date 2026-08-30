import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/data_models.dart';
import 'package:intl/intl.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  final CategoryModel? category;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool showCategory;

  const TransactionTile({
    super.key,
    required this.transaction,
    this.category,
    this.onTap,
    this.onDelete,
    this.showCategory = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isIncome = transaction.type == 'income';
    final amountColor = isIncome ? Colors.green : colorScheme.onSurface;
    final categoryColor = category != null ? Color(category!.colorValue) : colorScheme.primary;

    final formatter = NumberFormat.currency(symbol: 'GH₵ ', decimalDigits: 2);
    final dateFormatter = DateFormat('MMM d, h:mm a');
    final dayFormatter = DateFormat('EEE, MMM d');

    final now = DateTime.now();
    final txDate = transaction.date;
    String dateStr;
    if (txDate.year == now.year && txDate.month == now.month && txDate.day == now.day) {
      dateStr = 'Today, ${DateFormat('h:mm a').format(txDate)}';
    } else if (txDate.year == now.year && txDate.month == now.month && txDate.day == now.day - 1) {
      dateStr = 'Yesterday, ${DateFormat('h:mm a').format(txDate)}';
    } else {
      dateStr = dayFormatter.format(txDate);
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: category != null
                  ? Icon(
                      _getIconData(category!.iconName),
                      size: 22,
                      color: categoryColor,
                    )
                  : Icon(
                      isIncome ? Icons.add_circle_rounded : Icons.remove_circle_rounded,
                      size: 22,
                      color: amountColor,
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          transaction.note?.isNotEmpty == true ? transaction.note! : 'Transaction',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (showCategory && category != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: categoryColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            category!.name,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: categoryColor,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dateStr,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isIncome ? '+' : '-'}${formatter.format(transaction.amount)}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: amountColor,
                  ),
                ),
                if (transaction.source == 'sms')
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'SMS',
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'directions_bus': return Icons.directions_bus_rounded;
      case 'phone_android': return Icons.phone_android_rounded;
      case 'signal_cellular_alt': return Icons.signal_cellular_alt_rounded;
      case 'restaurant': return Icons.restaurant_rounded;
      case 'bolt':
      case 'electric_bolt': return Icons.electric_bolt_rounded;
      case 'payments': return Icons.payments_rounded;
      case 'account_balance_wallet': return Icons.account_balance_wallet_rounded;
      case 'local_gas_station': return Icons.local_gas_station_rounded;
      case 'shopping_cart': return Icons.shopping_cart_rounded;
      case 'movie': return Icons.movie_rounded;
      case 'fitness_center': return Icons.fitness_center_rounded;
      case 'medical_services': return Icons.medical_services_rounded;
      case 'school': return Icons.school_rounded;
      case 'flight': return Icons.flight_rounded;
      case 'hotel': return Icons.hotel_rounded;
      case 'local_grocery_store': return Icons.local_grocery_store_rounded;
      case 'work': return Icons.work_rounded;
      case 'business_center': return Icons.business_center_rounded;
      case 'savings': return Icons.savings_rounded;
      case 'attach_money': return Icons.attach_money_rounded;
      case 'trending_up': return Icons.trending_up_rounded;
      case 'home': return Icons.home_rounded;
      case 'computer': return Icons.computer_rounded;
      case 'store': return Icons.store_rounded;
      case 'add_circle': return Icons.add_circle_rounded;
      case 'category':
      default: return Icons.category_rounded;
    }
  }
}

class TransactionList extends StatelessWidget {
  final List<TransactionModel> transactions;
  final Map<String, CategoryModel> categories;
  final VoidCallback? onTapTransaction;
  final bool showCategory;

  const TransactionList({
    super.key,
    required this.transactions,
    required this.categories,
    this.onTapTransaction,
    this.showCategory = true,
  });

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return _EmptyState();
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      separatorBuilder: (_, __) => const SizedBox.shrink(),
      itemBuilder: (context, index) {
        final tx = transactions[index];
        final category = categories[tx.categoryId ?? ''];
        return TransactionTile(
          transaction: tx,
          category: category,
          onTap: onTapTransaction,
          showCategory: showCategory,
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No transactions yet',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first transaction to get started',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}