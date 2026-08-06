import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../providers/app_providers.dart';
import '../services/sms_template_matcher.dart';
import '../models/sms_template_model.dart';
import 'manage_templates_screen.dart';

/// Where "teach by example" actually happens. The user picks a message
/// that looked financial but matched no saved template, taps the token
/// that is the amount, marks whether it was money in or out, and saves.
/// That becomes a reusable template for every future message from the
/// same sender with the same surrounding wording.
class TeachSmsScreen extends ConsumerStatefulWidget {
  const TeachSmsScreen({super.key});

  @override
  ConsumerState<TeachSmsScreen> createState() => _TeachSmsScreenState();
}

class _TeachSmsScreenState extends ConsumerState<TeachSmsScreen> {
  List<Map<String, dynamic>> _unrecognized = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final rows = await ref.read(dbProvider).getUnrecognized();
    setState(() => _unrecognized = rows);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teach New Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt),
            tooltip: 'Learned patterns',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ManageTemplatesScreen()),
            ),
          ),
        ],
      ),
      body: _unrecognized.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Nothing to teach right now. When a message looks like a '
                'transaction alert but doesn\'t match anything you\'ve '
                'taught yet, it\'ll show up here.',
              ),
            )
          : ListView.builder(
              itemCount: _unrecognized.length,
              itemBuilder: (context, i) {
                final item = _unrecognized[i];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(item['senderId'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(item['body'], maxLines: 2, overflow: TextOverflow.ellipsis),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: () => _openTagging(item),
                          child: const Text('Teach'),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 20),
                          onPressed: () async {
                            await ref.read(dbProvider).dismissUnrecognized(item['id']);
                            _load();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _openTagging(Map<String, dynamic> item) {
    final tokens = SmsTemplateMatcher.tokenize(item['body']);
    int? selectedIndex;
    String direction = 'expense';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('From: ${item['senderId']}', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Tap the amount in this message:'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: List.generate(tokens.length, (i) {
                  final isSelected = selectedIndex == i;
                  return GestureDetector(
                    onTap: () => setSheetState(() => selectedIndex = i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.teal : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        tokens[i],
                        style: TextStyle(color: isSelected ? Colors.white : Colors.black87),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              const Text('This message means:'),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'expense', label: Text('Money out')),
                  ButtonSegment(value: 'income', label: Text('Money in')),
                ],
                selected: {direction},
                onSelectionChanged: (s) => setSheetState(() => direction = s.first),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: selectedIndex == null
                    ? null
                    : () async {
                        final template = SmsTemplateMatcher.buildTemplate(
                          id: const Uuid().v4(),
                          senderId: item['senderId'],
                          body: item['body'],
                          amountTokenIndex: selectedIndex!,
                          direction: direction,
                        );
                        await ref.read(dbProvider).insertTemplate(template);
                        await ref.read(dbProvider).dismissUnrecognized(item['id']);
                        if (context.mounted) Navigator.pop(ctx);
                        _load();
                      },
                child: const Text('Save this pattern'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
