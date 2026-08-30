import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../models/data_models.dart';
import '../providers/app_providers.dart';
import '../widgets/fused_button.dart';
import '../widgets/fused_text_field.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  static const routeName = 'Categories';
  static const routePath = '/categories';

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _iconController = TextEditingController();
  final _colorController = TextEditingController();
  final _capController = TextEditingController();

  String _selectedType = 'expense';
  String _selectedIcon = 'category';
  int _selectedColor = 0xFF757575;

  static const _icons = [
    'category', 'restaurant', 'directions_bus', 'signal_cellular_alt',
    'bolt', 'payments', 'account_balance_wallet', 'local_gas_station',
    'shopping_cart', 'movie', 'fitness_center', 'medical_services',
    'school', 'flight', 'hotel', 'local_grocery_store',
    'work', 'business_center', 'savings', 'attach_money',
    'trending_up', 'home', 'computer', 'store',
    'phone_android',
  ];

  static const _colors = [
    0xFF4285F4, 0xFF34A853, 0xFFFBBC05, 0xFFEA4335,
    0xFF9C27B0, 0xFF00BFA5, 0xFFFF6D00, 0xFF607D8B,
    0xFFE91E63, 0xFF673AB7, 0xFF009688, 0xFF795548,
    0xFF03A9F4, 0xFF8BC34A, 0xFFFFC107, 0xFF000000,
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _iconController.dispose();
    _colorController.dispose();
    _capController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final categories = ref.watch(categoriesProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text('Categories', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: _showAddCategoryDialog,
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Add category',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddCategoryDialog,
        icon: const Icon(Icons.add_rounded),
        label: Text('Add Category', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: categories.isEmpty
          ? _buildEmptyState(colorScheme)
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
              children: [
                _buildSection('Expense Categories', categories.where((c) => c.type == 'expense').toList(), colorScheme, emptyHint: 'No expense categories yet', emptySub: 'Tap + to add food, transport, bills, etc.', onAdd: _showAddCategoryDialog),
                const SizedBox(height: 24),
                _buildSection('Income Categories', categories.where((c) => c.type == 'income').toList(), colorScheme, emptyHint: 'No income categories yet', emptySub: 'Tap + to add salary, freelance, business, etc.', onAdd: _showAddCategoryDialog),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: colorScheme.primaryContainer.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(12)),
                  child: Row(children: [Icon(Icons.info_outline_rounded, size: 18, color: colorScheme.primary), const SizedBox(width: 8), Expanded(child: Text('Long-press delete or swipe left on any category. All categories are fully editable — including defaults.', style: GoogleFonts.inter(fontSize: 12, color: colorScheme.onSurfaceVariant)))]),
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.category_outlined, size: 64, color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            Text(
              'No categories yet',
              style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w600, color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 8),
            Text(
              'Create categories to organize your transactions',
              style: GoogleFonts.inter(fontSize: 14, color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FusedButton(
              label: 'Add Category',
              variant: FusedButtonVariant.primary,
              onPressed: _showAddCategoryDialog,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<CategoryModel> items, ColorScheme colorScheme, {String? emptyHint, String? emptySub, VoidCallback? onAdd}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12, left: 4),
          child: Row(children: [
            Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w700, color: colorScheme.onSurface)),
            const Spacer(),
            if (items.isNotEmpty) Text('${items.length}', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: colorScheme.onSurfaceVariant)),
          ]),
        ),
        if (items.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(12), border: Border.all(color: colorScheme.outlineVariant)),
            child: Column(children: [
              Icon(title.contains('Income') ? Icons.trending_up_rounded : Icons.shopping_bag_outlined, size: 32, color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
              const SizedBox(height: 8),
              Text(emptyHint ?? 'No categories', style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600, color: colorScheme.onSurfaceVariant)),
              const SizedBox(height: 4),
              Text(emptySub ?? 'Tap + to add', style: GoogleFonts.inter(fontSize: 12, color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7)), textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FusedButton(label: 'Add ${title.contains('Income') ? 'Income' : 'Expense'}', variant: FusedButtonVariant.outline, size: FusedButtonSize.small, onPressed: onAdd ?? _showAddCategoryDialog),
            ]),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final category = items[index];
              return _CategoryTile(
                category: category,
                onEdit: () => _showEditCategoryDialog(category),
                onDelete: () => _deleteCategory(category),
              );
            },
          ),
      ],
    );
  }

  void _showAddCategoryDialog() {
    _resetForm();
    _showCategoryDialog();
  }

  void _showEditCategoryDialog(CategoryModel category) {
    _nameController.text = category.name;
    _selectedIcon = category.iconName;
    _selectedColor = category.colorValue;
    _selectedType = category.type;
    _capController.text = category.monthlyCap?.toStringAsFixed(0) ?? '';
    _showCategoryDialog(category: category);
  }

  void _resetForm() {
    _nameController.clear();
    _selectedIcon = 'category';
    _selectedColor = _colors.first;
    _selectedType = 'expense';
    _capController.clear();
  }

  void _showCategoryDialog({CategoryModel? category}) {
    // Local copies for dialog state — fixes income/expense toggle not updating inside showDialog
    String localType = _selectedType;
    String localIcon = _selectedIcon;
    int localColor = _selectedColor;
    final isEditing = category != null;

    showDialog(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(isEditing ? 'Edit Category' : 'Add Category', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FusedTextField(
                        controller: _nameController,
                        label: 'Category Name',
                        hint: 'e.g., Food, Transport, Freelance',
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Required';
                          if (v.trim().length < 2) return 'At least 2 characters';
                          final exists = ref.read(categoriesProvider).any((c) => c.name.toLowerCase() == v.trim().toLowerCase() && c.id != category?.id);
                          if (exists) return 'Name already exists';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Type selector — now uses dialog-local state
                      Row(
                        children: ['expense', 'income'].map((type) {
                          final isSelected = localType == type;
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: ChoiceChip(
                                label: Text(type.capitalize(), style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
                                )),
                                selected: isSelected,
                                onSelected: (_) {
                                  setDialogState(() => localType = type);
                                  // Keep outer in sync for _saveCategory
                                  _selectedType = type;
                                  if (type == 'income') _capController.clear();
                                },
                                selectedColor: colorScheme.primary,
                                backgroundColor: colorScheme.surfaceContainerHighest,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 8),
                      Text(localType == 'income' ? 'Income stream (salary, freelance, etc.)' : 'Expense stream (food, transport, etc.)', style: GoogleFonts.inter(fontSize: 12, color: colorScheme.onSurfaceVariant)),
                      const SizedBox(height: 16),
                      // Icon picker
                      Align(alignment: Alignment.centerLeft, child: Text('Icon', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600))),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _icons.map((icon) {
                          final isSelected = localIcon == icon;
                          return InkWell(
                            onTap: () {
                              setDialogState(() => localIcon = icon);
                              _selectedIcon = icon;
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isSelected ? colorScheme.primaryContainer : colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? colorScheme.primary : colorScheme.outlineVariant,
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Icon(_getIconData(icon), color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant, size: 24),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      // Color picker
                      Align(alignment: Alignment.centerLeft, child: Text('Color', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600))),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _colors.map((color) {
                          final isSelected = localColor == color;
                          return InkWell(
                            onTap: () {
                              setDialogState(() => localColor = color);
                              _selectedColor = color;
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Color(color),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? Colors.white : Colors.transparent,
                                  width: 3,
                                ),
                                boxShadow: isSelected ? [
                                  BoxShadow(color: Color(color).withValues(alpha: 0.5), blurRadius: 8, spreadRadius: 2)
                                ] : null,
                              ),
                              child: isSelected ? const Icon(Icons.check_rounded, color: Colors.white, size: 24) : null,
                            ),
                          );
                        }).toList(),
                      ),
                      if (localType == 'expense') ...[
                        const SizedBox(height: 16),
                        FusedTextField(
                          controller: _capController,
                          label: 'Monthly Cap (optional)',
                          hint: 'e.g., 500',
                          keyboardType: TextInputType.number,
                        ),
                      ] else ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.green.withValues(alpha: 0.3))),
                          child: Row(children: [const Icon(Icons.info_outline_rounded, size: 18, color: Colors.green), const SizedBox(width: 8), Expanded(child: Text('No cap needed for income streams', style: GoogleFonts.inter(fontSize: 12, color: Colors.green.shade700)))]),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                FusedButton(
                  label: isEditing ? 'Save' : 'Create',
                  onPressed: () {
                    // Sync dialog state to outer before save
                    _selectedType = localType;
                    _selectedIcon = localIcon;
                    _selectedColor = localColor;
                    _saveCategory(category);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _saveCategory(CategoryModel? existing) async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    // Double-check duplicate (validator already did)
    final duplicate = ref.read(categoriesProvider).any((c) => c.name.toLowerCase() == name.toLowerCase() && c.id != existing?.id);
    if (duplicate) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Category name already exists')));
      return;
    }

    final isIncome = _selectedType == 'income';
    final category = CategoryModel(
      id: existing?.id ?? const Uuid().v4(),
      name: name,
      iconName: _selectedIcon,
      colorValue: _selectedColor,
      type: _selectedType,
      monthlyCap: isIncome ? null : (_capController.text.isEmpty ? null : double.tryParse(_capController.text)),
      isDefault: existing?.isDefault ?? false,
    );

    await ref.read(categoriesProvider.notifier).upsert(category);
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isIncome ? 'Income category "${category.name}" saved' : 'Category "${category.name}" saved'), backgroundColor: Colors.green));
    }
  }

  Future<void> _deleteCategory(CategoryModel category) async {
    final count = await ref.read(dbProvider).countTransactionsForCategory(category.id);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete ${category.name}?', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
        content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(count > 0 ? '$count transaction${count == 1 ? '' : 's'} use this category. They will become uncategorized (not deleted).' : 'This category will be permanently removed.', style: GoogleFonts.inter(fontSize: 14)),
          if (count > 0) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(12)),
              child: Row(children: [Icon(Icons.warning_amber_rounded, size: 20, color: Theme.of(context).colorScheme.error), const SizedBox(width: 8), Expanded(child: Text('$count linked transaction${count == 1 ? '' : 's'} will lose this category', style: GoogleFonts.inter(fontSize: 12, color: Theme.of(context).colorScheme.onErrorContainer)))]),
            ),
          ],
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FusedButton(
            label: 'Delete',
            variant: FusedButtonVariant.destructive,
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ref.read(categoriesProvider.notifier).remove(category.id);
      // Refresh transactions that were linked to this category (now uncategorized)
      ref.invalidate(transactionsProvider);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Deleted ${category.name}${count > 0 ? ' — $count transactions uncategorized' : ''}')));
    }
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'directions_bus': return Icons.directions_bus_rounded;
      case 'signal_cellular_alt': return Icons.signal_cellular_alt_rounded;
      case 'restaurant': return Icons.restaurant_rounded;
      case 'bolt': return Icons.electric_bolt_rounded;
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
      case 'phone_android': return Icons.phone_android_rounded;
      default: return Icons.category_rounded;
    }
  }
}

class _CategoryTile extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CategoryTile({required this.category, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final catColor = Color(category.colorValue);

    return Dismissible(
      key: Key(category.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.delete_outline_rounded, color: colorScheme.onErrorContainer, size: 28),
      ),
      onDismissed: (_) => onDelete(),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: catColor.withValues(alpha: 0.15),
            child: Icon(_getIconData(category.iconName), color: catColor),
          ),
          title: Text(category.name, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
          subtitle: category.monthlyCap != null
              ? Text('Cap: GH₵ ${category.monthlyCap!.toStringAsFixed(0)}', style: GoogleFonts.inter(fontSize: 12, color: colorScheme.onSurfaceVariant))
              : null,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: category.type == 'income' ? Colors.green.withValues(alpha: 0.15) : colorScheme.error.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  category.type.capitalize(),
                  style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: category.type == 'income' ? Colors.green : colorScheme.error),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(onPressed: onEdit, icon: Icon(Icons.edit_outlined, color: colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'directions_bus': return Icons.directions_bus_rounded;
      case 'signal_cellular_alt': return Icons.signal_cellular_alt_rounded;
      case 'restaurant': return Icons.restaurant_rounded;
      case 'bolt': return Icons.electric_bolt_rounded;
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
      case 'phone_android': return Icons.phone_android_rounded;
      default: return Icons.category_rounded;
    }
  }
}

extension StringExt on String {
  String capitalize() => '${this[0].toUpperCase()}${substring(1)}';
}