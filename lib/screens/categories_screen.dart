import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/category_model.dart';
import '../providers/app_providers.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEditDialog(context, ref, null),
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, i) {
          final cat = categories[i];
          return ListTile(
            leading: CircleAvatar(backgroundColor: Color(cat.colorValue)),
            title: Text(cat.name),
            subtitle: Text(cat.monthlyCap != null
                ? 'Cap: ${cat.monthlyCap!.toStringAsFixed(0)}  ·  ${cat.type}'
                : 'No cap set  ·  ${cat.type}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showEditDialog(context, ref, cat),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => ref.read(categoriesProvider.notifier).remove(cat.id),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref, CategoryModel? existing) {
    final nameController = TextEditingController(text: existing?.name ?? '');
    final capController =
        TextEditingController(text: existing?.monthlyCap?.toStringAsFixed(0) ?? '');
    String type = existing?.type ?? 'expense';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(existing == null ? 'New Category' : 'Edit Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
              const SizedBox(height: 12),
              TextField(
                controller: capController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Monthly cap (optional)'),
              ),
              const SizedBox(height: 12),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'expense', label: Text('Expense')),
                  ButtonSegment(value: 'income', label: Text('Income')),
                ],
                selected: {type},
                onSelectionChanged: (s) => setState(() => type = s.first),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                final cap = double.tryParse(capController.text);
                final model = CategoryModel(
                  id: existing?.id ?? const Uuid().v4(),
                  name: nameController.text,
                  iconName: existing?.iconName ?? 'category',
                  colorValue: existing?.colorValue ?? 0xFF607D8B,
                  type: type,
                  monthlyCap: cap,
                  isDefault: existing?.isDefault ?? false,
                );
                ref.read(categoriesProvider.notifier).upsert(model);
                Navigator.pop(ctx);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
