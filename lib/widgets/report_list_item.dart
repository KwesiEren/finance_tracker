import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ReportListItem extends StatelessWidget {
  final String title;
  final String period;
  final double income;
  final double expense;
  final double net;
  final VoidCallback? onTap;

  const ReportListItem({
    super.key,
    required this.title,
    required this.period,
    required this.income,
    required this.expense,
    required this.net,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final formatter = NumberFormat.currency(symbol: 'GH₵ ', decimalDigits: 0);
    final isPositive = net >= 0;

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
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                Text(
                  period,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _StatChip(
                  label: 'Income',
                  value: formatter.format(income),
                  color: Colors.green,
                  icon: Icons.arrow_downward_rounded,
                ),
                const SizedBox(width: 12),
                _StatChip(
                  label: 'Expense',
                  value: formatter.format(expense),
                  color: colorScheme.error,
                  icon: Icons.arrow_upward_rounded,
                ),
                const SizedBox(width: 12),
                _StatChip(
                  label: 'Net',
                  value: formatter.format(net.abs()),
                  color: isPositive ? Colors.green : colorScheme.error,
                  icon: isPositive ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 14, color: color),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReportSummaryCard extends StatelessWidget {
  final double income;
  final double expense;
  final double net;
  final String period;
  final int transactionCount;

  const ReportSummaryCard({
    super.key,
    required this.income,
    required this.expense,
    required this.net,
    required this.period,
    required this.transactionCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final formatter = NumberFormat.currency(symbol: 'GH₵ ', decimalDigits: 0);
    final isPositive = net >= 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isPositive
              ? [Colors.green.withValues(alpha: 0.15), Colors.green.withValues(alpha: 0.05)]
              : [colorScheme.error.withValues(alpha: 0.15), colorScheme.error.withValues(alpha: 0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: (isPositive ? Colors.green : colorScheme.error).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Summary: $period',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: (isPositive ? Colors.green : colorScheme.error).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$transactionCount transactions',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isPositive ? Colors.green : colorScheme.error,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _SummaryItem(label: 'Income', value: formatter.format(income), color: Colors.green)),
              Container(height: 40, width: 1, color: colorScheme.outlineVariant),
              Expanded(child: _SummaryItem(label: 'Expense', value: formatter.format(expense), color: colorScheme.error)),
              Container(height: 40, width: 1, color: colorScheme.outlineVariant),
              Expanded(child: _SummaryItem(label: 'Net', value: formatter.format(net.abs()), color: isPositive ? Colors.green : colorScheme.error)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SummaryItem({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}