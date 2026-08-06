import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../providers/app_providers.dart';
import '../models/transaction_model.dart';

/// SMS parsing tells us an amount and direction (income/expense), but never
/// a category — that's inherently personal. So every SMS-detected entry
/// waits here until the user picks a category and confirms, or dismisses it
/// as irrelevant (e.g. an OTP that matched the pattern by accident).
class PendingSmsScreen extends ConsumerStatefulWidget {
  const PendingSmsScreen({super.key});

  @override
  ConsumerState<PendingSmsScreen> createState() => _PendingSmsScreenState();
}

class _PendingSmsScreenState extends ConsumerState<PendingSmsScreen> {
  List<Map<String, dynamic>> _pending = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = ref.read(dbProvider);
    final rows = await db.getPendingSms();
    setState(() => _pending = rows);
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Detected Transactions')),
      body: _pending.isEmpty
          ? const Center(child: Text('No new SMS transactions to review.'))
          : ListView.builder(
              itemCount: _pending.length,
              itemBuilder: (context, i) {
                final item = _pending[i];
                final matchingCats =
                    categories.where((c) => c.type == item['type']).toList();

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${item['type'] == 'expense' ? '-' : '+'} ${item['amount']}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text(item['rawSmsBody'], maxLines: 2, overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.grey)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                decoration: const InputDecoration(labelText: 'Category'),
                                items: matchingCats
                                    .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
                                    .toList(),
                                onChanged: (v) => item['selectedCategoryId'] = v,
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.check_circle, color: Colors.green),
                              onPressed: () => _confirm(item),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () => _dismiss(item['id']),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Future<void> _confirm(Map<String, dynamic> item) async {
    final categoryId = item['selectedCategoryId'] as String?;
    if (categoryId == null) return;

    final tx = TransactionModel(
      id: const Uuid().v4(),
      amount: item['amount'],
      type: item['type'],
      categoryId: categoryId,
      date: DateTime.parse(item['smsDate']),
      source: TransactionSource.smsConfirmed,
      rawSmsBody: item['rawSmsBody'],
    );
    await ref.read(transactionsProvider.notifier).add(tx);
    await ref.read(dbProvider).dismissPendingSms(item['id']);
    _load();
  }

  Future<void> _dismiss(String id) async {
    await ref.read(dbProvider).dismissPendingSms(id);
    _load();
  }
}
