import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';
import '../models/sms_template_model.dart';

class ManageTemplatesScreen extends ConsumerStatefulWidget {
  const ManageTemplatesScreen({super.key});

  @override
  ConsumerState<ManageTemplatesScreen> createState() => _ManageTemplatesScreenState();
}

class _ManageTemplatesScreenState extends ConsumerState<ManageTemplatesScreen> {
  List<SmsTemplateModel> _templates = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final rows = await ref.read(dbProvider).getTemplates();
    setState(() => _templates = rows);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Learned Patterns')),
      body: _templates.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(24),
              child: Text('No patterns taught yet. Use the Teach tab to tag a '
                  'real message and the app will remember it.'),
            )
          : ListView.builder(
              itemCount: _templates.length,
              itemBuilder: (context, i) {
                final t = _templates[i];
                return ListTile(
                  title: Text(t.senderId, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    '${t.direction == 'expense' ? 'Money out' : 'Money in'}  ·  "${t.before} [amount] ${t.after}"',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () async {
                      await ref.read(dbProvider).deleteTemplate(t.id);
                      _load();
                    },
                  ),
                );
              },
            ),
    );
  }
}
