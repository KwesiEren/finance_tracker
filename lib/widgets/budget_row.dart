import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/data_models.dart';
import 'package:intl/intl.dart';

class BudgetRow extends StatelessWidget {
  final CategoryModel category;
  final double spent;
  final double budget;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;

  const BudgetRow({
    super.key,
    required this.category,
    required this.spent,
    required this.budget,
    this.onTap,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final categoryColor = Color(category.colorValue);
    final percentage = budget > 0 ? (spent / budget).clamp(0.0, 1.0) : 0.0;
    final isOverBudget = spent > budget;
    final remaining = budget - spent;

    final formatter = NumberFormat.currency(symbol: 'GH₵ ', decimalDigits: 0);

    Color progressColor;
    if (isOverBudget) {
      progressColor = colorScheme.error;
    } else if (percentage >= 0.8) {
      progressColor = colorScheme.tertiary;
    } else {
      progressColor = categoryColor;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: categoryColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _getIconData(category.iconName),
                    size: 20,
                    color: categoryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        '${formatter.format(spent)} / ${formatter.format(budget)}',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onEdit != null)
                  IconButton(
                    onPressed: onEdit,
                    icon: Icon(
                      Icons.edit_outlined,
                      size: 20,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Stack(
              children: [
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: percentage,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: progressColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(percentage * 100).toInt()}% used',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isOverBudget ? colorScheme.error : colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  isOverBudget
                      ? 'Over by ${formatter.format(-remaining)}'
                      : '${formatter.format(remaining)} left',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isOverBudget ? colorScheme.error : colorScheme.onSurfaceVariant,
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
      case 'directions_bus':
        return Icons.directions_bus_rounded;
      case 'phone_android':
      case 'signal_cellular_alt':
        return Icons.signal_cellular_alt_rounded;
      case 'restaurant':
        return Icons.restaurant_rounded;
      case 'bolt':
      case 'electric_bolt':
        return Icons.electric_bolt_rounded;
      case 'payments':
        return Icons.payments_rounded;
      case 'account_balance_wallet':
        return Icons.account_balance_wallet_rounded;
      case 'local_gas_station':
        return Icons.local_gas_station_rounded;
      case 'add_circle':
        return Icons.add_circle_rounded;
      case 'category':
      default:
        return Icons.category_rounded;
    }
  }
}