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
  ];

  static const _colors = [
    0xFF4285F4, 0xFF34A853, 0xFFFBBC05, 0xFFEA4335,
    0xFF9C27B0, 0xFF00BFA5, 0xFFFF6D00, 0xFF607D8B,
    0xFFE91E63, 0xFF673AB7, 0xFF009688, 0xFF795548,
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
          ),
        ],
      ),
      body: categories.isEmpty
          ? _buildEmptyState(colorScheme)
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSection('Expense Categories', categories.where((c) => c.type == 'expense').toList(), colorScheme),
                const SizedBox(height: 24),
                _buildSection('Income Categories', categories.where((c) => c.type == 'income').toList(), colorScheme),
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

  Widget _buildSection(String title, List<CategoryModel> items, ColorScheme colorScheme) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12, left: 4),
          child: Text(
            title,
            style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w700, color: colorScheme.onSurface),
          ),
        ),
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
    showDialog(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        return AlertDialog(
          title: Text(category == null ? 'Add Category' : 'Edit Category', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FusedTextField(
                    controller: _nameController,
                    label: 'Category Name',
                    hint: 'e.g., Food, Transport',
                    validator: (v) => v?.isEmpty == true ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  // Type selector
                  Row(
                    children: ['expense', 'income'].map((type) {
                      final isSelected = _selectedType == type;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            label: Text(type.capitalize(), style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
                            )),
                            selected: isSelected,
                            onSelected: (_) => setState(() => _selectedType = type),
                            selectedColor: colorScheme.primary,
                            backgroundColor: colorScheme.surfaceContainerHighest,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  // Icon picker
                  Text('Icon', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _icons.map((icon) {
                      final isSelected = _selectedIcon == icon;
                      return InkWell(
                        onTap: () => setState(() => _selectedIcon = icon),
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
                  Text('Color', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _colors.map((color) {
                      final isSelected = _selectedColor == color;
                      return InkWell(
                        onTap: () => setState(() => _selectedColor = color),
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
                  if (_selectedType == 'expense') ...[
                    const SizedBox(height: 16),
                    FusedTextField(
                      controller: _capController,
                      label: 'Monthly Cap (optional)',
                      hint: 'e.g., 500',
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            FusedButton(
              label: category == null ? 'Create' : 'Save',
              onPressed: () => _saveCategory(category),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveCategory(CategoryModel? existing) async {
    if (!_formKey.currentState!.validate()) return;

    final category = CategoryModel(
      id: existing?.id ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      iconName: _selectedIcon,
      colorValue: _selectedColor,
      type: _selectedType,
      monthlyCap: _capController.text.isEmpty ? null : double.tryParse(_capController.text),
      isDefault: false,
    );

    await ref.read(categoriesProvider.notifier).upsert(category);
    if (mounted) Navigator.pop(context);
  }

  Future<void> _deleteCategory(CategoryModel category) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete ${category.name}?', style: GoogleFonts.plusJakartaSans()),
        content: Text('This will remove the category from future transactions. Existing transactions will keep the category name but lose the link.', style: GoogleFonts.inter()),
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
      default: return Icons.category_rounded;
    }
  }
}

extension StringExt on String {
  String capitalize() => '${this[0].toUpperCase()}${substring(1)}';
}