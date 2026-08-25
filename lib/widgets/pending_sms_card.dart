import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/data_models.dart';
import 'package:intl/intl.dart';
import '../widgets/fused_button.dart';

class PendingSmsCard extends ConsumerStatefulWidget {
  final PendingSmsItem item;
  final List<CategoryModel> categories;
  final ValueChanged<String>? onConfirm;
  final VoidCallback? onDismiss;
  final VoidCallback? onTeach;

  const PendingSmsCard({
    super.key,
    required this.item,
    required this.categories,
    this.onConfirm,
    this.onDismiss,
    this.onTeach,
  });

  @override
  ConsumerState<PendingSmsCard> createState() => _PendingSmsCardState();
}

class _PendingSmsCardState extends ConsumerState<PendingSmsCard> {
  String? _selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isIncome = widget.item.type == 'income';
    final amountColor = isIncome ? Colors.green : colorScheme.onSurface;

    final formatter = NumberFormat.currency(symbol: 'GH₵ ', decimalDigits: 2);
    final dateFormatter = DateFormat('MMM d, h:mm a');

    final txDate = widget.item.smsDate;
    final now = DateTime.now();
    String dateStr;
    if (txDate.year == now.year && txDate.month == now.month && txDate.day == now.day) {
      dateStr = 'Today, ${DateFormat('h:mm a').format(txDate)}';
    } else if (txDate.year == now.year && txDate.month == now.month && txDate.day == now.day - 1) {
      dateStr = 'Yesterday, ${DateFormat('h:mm a').format(txDate)}';
    } else {
      dateStr = dateFormatter.format(txDate);
    }

    final filteredCategories = widget.categories.where((c) => c.type == widget.item.type).toList();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: amountColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isIncome ? Icons.add_circle_rounded : Icons.remove_circle_rounded,
                    size: 24,
                    color: amountColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.senderId,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
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
                Text(
                  '${isIncome ? '+' : '-'}${formatter.format(widget.item.amount)}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: amountColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.item.rawSmsBody,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedCategoryId,
              hint: Text(
                'Select category',
                style: GoogleFonts.inter(color: colorScheme.onSurfaceVariant),
              ),
              decoration: InputDecoration(
                labelText: 'Category',
                labelStyle: GoogleFonts.inter(color: colorScheme.onSurfaceVariant),
                filled: true,
                fillColor: colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorScheme.outlineVariant),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorScheme.outlineVariant),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorScheme.primary, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              items: filteredCategories.map((cat) {
                final catColor = Color(cat.colorValue);
                return DropdownMenuItem(
                  value: cat.id,
                  child: Row(
                    children: [
                      Icon(
                        _getIconData(cat.iconName),
                        size: 18,
                        color: catColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        cat.name,
                        style: GoogleFonts.inter(fontSize: 14),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedCategoryId = value),
              style: GoogleFonts.inter(color: colorScheme.onSurface, fontSize: 14),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FusedButton(
                    label: 'Dismiss',
                    variant: FusedButtonVariant.ghost,
                    size: FusedButtonSize.medium,
                    onPressed: widget.onDismiss,
                    leadingIcon: Icon(Icons.close_rounded, size: 18),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FusedButton(
                    label: 'Confirm',
                    variant: FusedButtonVariant.primary,
                    size: FusedButtonSize.medium,
                    onPressed: _selectedCategoryId != null ? () => widget.onConfirm?.call(_selectedCategoryId!) : null,
                    leadingIcon: Icon(Icons.check_rounded, size: 18),
                  ),
                ),
              ],
            ),
            if (widget.onTeach != null) ...[
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: widget.onTeach,
                icon: Icon(Icons.school_outlined, size: 16, color: colorScheme.primary),
                label: Text(
                  'Teach pattern instead',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ],
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