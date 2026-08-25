import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/data_models.dart';
import 'package:intl/intl.dart';

class SpendingPieChart extends StatelessWidget {
  final Map<String, double> categorySpending;
  final List<CategoryModel> categories;
  final double total;
  final String? selectedCategoryId;
  final ValueChanged<String?>? onSectionTapped;

  const SpendingPieChart({
    super.key,
    required this.categorySpending,
    required this.categories,
    required this.total,
    this.selectedCategoryId,
    this.onSectionTapped,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (categorySpending.isEmpty) {
      return _EmptyChart(message: 'No spending data');
    }

    final sections = categorySpending.entries.map((entry) {
      final category = categories.firstWhere(
        (c) => c.id == entry.key,
        orElse: () => CategoryModel(
          id: entry.key,
          name: 'Unknown',
          iconName: 'category',
          colorValue: colorScheme.primary.value,
          type: 'expense',
        ),
      );
      final percentage = total > 0 ? (entry.value / total) * 100 : 0;
      final isSelected = selectedCategoryId == entry.key;
      
      return PieChartSectionData(
        value: entry.value,
        color: Color(category.colorValue),
        title: percentage >= 5 ? '${percentage.toInt()}%' : '',
        radius: isSelected ? 70 : 60,
        titleStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          shadows: [
            Shadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 2,
            ),
          ],
        ),
        badgeWidget: isSelected
            ? Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Icon(
                  _getIconData(category.iconName),
                  size: 16,
                  color: Color(category.colorValue),
                ),
              )
            : null,
        badgePositionPercentageOffset: 1.2,
      );
    }).toList();

    return AspectRatio(
      aspectRatio: 1.3,
      child: PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: 50,
          sectionsSpace: 2,
          startDegreeOffset: -90,
          borderData: FlBorderData(show: false),
          pieTouchData: PieTouchData(
            touchCallback: (event, response) {
              if (response != null && response.touchedSection != null) {
                final index = response.touchedSection!.touchedSectionIndex;
                if (index >= 0 && index < categorySpending.entries.length) {
                  final key = categorySpending.keys.elementAt(index);
                  onSectionTapped?.call(selectedCategoryId == key ? null : key);
                }
              } else {
                onSectionTapped?.call(null);
              }
            },
          ),
        ),
        swapAnimationDuration: const Duration(milliseconds: 400),
        swapAnimationCurve: Curves.easeOutCubic,
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

class _EmptyChart extends StatelessWidget {
  final String message;

  const _EmptyChart({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AspectRatio(
      aspectRatio: 1.3,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.pie_chart_outline_rounded,
              size: 64,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LegendList extends StatelessWidget {
  final Map<String, double> categorySpending;
  final List<CategoryModel> categories;
  final double total;
  final String? selectedCategoryId;
  final ValueChanged<String?>? onTap;

  const LegendList({
    super.key,
    required this.categorySpending,
    required this.categories,
    required this.total,
    this.selectedCategoryId,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final formatter = NumberFormat.currency(symbol: 'GH₵ ', decimalDigits: 0);

    if (categorySpending.isEmpty) {
      return const SizedBox.shrink();
    }

    final sortedEntries = categorySpending.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      children: sortedEntries.map((entry) {
        final category = categories.firstWhere(
          (c) => c.id == entry.key,
          orElse: () => CategoryModel(
            id: entry.key,
            name: 'Unknown',
            iconName: 'category',
            colorValue: colorScheme.primary.value,
            type: 'expense',
          ),
        );
        final percentage = total > 0 ? (entry.value / total) * 100 : 0;
        final isSelected = selectedCategoryId == entry.key;
        final catColor = Color(category.colorValue);

        return InkWell(
          onTap: () => onTap?.call(isSelected ? null : entry.key),
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? catColor.withValues(alpha: 0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isSelected ? Border.all(color: catColor, width: 1.5) : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: catColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    category.name,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                Text(
                  '${formatter.format(entry.value)} (${percentage.toInt()}%)',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? catColor : colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}