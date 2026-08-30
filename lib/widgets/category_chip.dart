import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/data_models.dart';

class CategoryChip extends StatelessWidget {
  final CategoryModel category;
  final bool selected;
  final VoidCallback? onTap;
  final bool showAmount;
  final double? spentAmount;
  final double? budgetAmount;

  const CategoryChip({
    super.key,
    required this.category,
    this.selected = false,
    this.onTap,
    this.showAmount = false,
    this.spentAmount,
    this.budgetAmount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final categoryColor = Color(category.colorValue);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? categoryColor : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? categoryColor : colorScheme.outlineVariant,
            width: selected ? 2 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: categoryColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getIconData(category.iconName),
              size: 24,
              color: selected ? colorScheme.onPrimary : categoryColor,
            ),
            const SizedBox(height: 4),
            Text(
              category.name,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected ? colorScheme.onPrimary : colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (showAmount && spentAmount != null && budgetAmount != null && budgetAmount! > 0) ...[
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: (spentAmount! / budgetAmount!).clamp(0.0, 1.0),
                minHeight: 4,
                borderRadius: BorderRadius.circular(2),
                backgroundColor: selected
                    ? colorScheme.onPrimary.withValues(alpha: 0.2)
                    : colorScheme.outlineVariant,
                valueColor: AlwaysStoppedAnimation(
                  spentAmount! > budgetAmount!
                      ? (selected ? colorScheme.error : colorScheme.error)
                      : (selected ? colorScheme.onPrimary : categoryColor),
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

class CategoryGrid extends StatelessWidget {
  final List<CategoryModel> categories;
  final String? selectedCategoryId;
  final ValueChanged<String>? onCategorySelected;
  final bool showAmounts;
  final Map<String, double>? spentAmounts;
  final Map<String, double>? budgetAmounts;

  const CategoryGrid({
    super.key,
    required this.categories,
    this.selectedCategoryId,
    this.onCategorySelected,
    this.showAmounts = false,
    this.spentAmounts,
    this.budgetAmounts,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: categories.map((category) {
        final isSelected = selectedCategoryId == category.id;
        return CategoryChip(
          category: category,
          selected: isSelected,
          onTap: () => onCategorySelected?.call(category.id),
          showAmount: showAmounts,
          spentAmount: spentAmounts?[category.id],
          budgetAmount: budgetAmounts?[category.id],
        );
      }).toList(),
    );
  }
}

class CategorySelector extends StatelessWidget {
  final List<CategoryModel> categories;
  final String? selectedCategoryId;
  final ValueChanged<String>? onCategorySelected;
  final String? filterType; // 'income' or 'expense'

  const CategorySelector({
    super.key,
    required this.categories,
    this.selectedCategoryId,
    this.onCategorySelected,
    this.filterType,
  });

  @override
  Widget build(BuildContext context) {
    final filteredCategories = filterType != null
        ? categories.where((c) => c.type == filterType).toList()
        : categories;

    return CategoryGrid(
      categories: filteredCategories,
      selectedCategoryId: selectedCategoryId,
      onCategorySelected: onCategorySelected,
    );
  }
}