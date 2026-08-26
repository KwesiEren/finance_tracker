import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../models/data_models.dart';
import '../models/sms_template_model.dart';
import '../providers/app_providers.dart';
import '../services/sms_service.dart';
import '../services/sms_template_matcher.dart';
import '../widgets/fused_button.dart';
import '../widgets/token_chip.dart';

extension StringExt on String {
  String capitalize() => '${this[0].toUpperCase()}${substring(1)}';
}

class TeachSmsScreen extends ConsumerStatefulWidget {
  const TeachSmsScreen({super.key});
  static const routeName = 'TeachSms';
  static const routePath = '/teach';
  @override
  ConsumerState<TeachSmsScreen> createState() => _TeachSmsScreenState();
}

class _TeachSmsScreenState extends ConsumerState<TeachSmsScreen> {
  final _smsService = SmsService();
  List<UnrecognizedSmsItem> _unrecognized = [];
  UnrecognizedSmsItem? _selectedItem;
  final Set<String> _selectedBeforeTokens = {};
  final Set<String> _selectedAfterTokens = {};
  int? _amountTokenIndex;
  String _selectedDirection = 'expense';
  final _manualSenderController = TextEditingController();
  final _manualBodyController = TextEditingController();

  @override
  void initState() { super.initState(); _loadUnrecognized(); }

  @override
  void dispose() {
    _manualSenderController.dispose();
    _manualBodyController.dispose();
    super.dispose();
  }

  Future<void> _loadUnrecognized() async {
    final items = await _smsService.getUnrecognizedItems();
    if (mounted) setState(() => _unrecognized = items);
  }

  List<String> _parseTokens(String body) => body.split(RegExp(r'\s+')).where((t) => t.isNotEmpty).toList();

  int _findAmountToken(String body) {
    final tokens = _parseTokens(body);
    for (int i = 0; i < tokens.length; i++) {
      if (tokens[i].contains(RegExp(r'(GH₵|GHS|\d+\.\d{2})'))) return i;
    }
    return -1;
  }

  void _showAddChoice() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Theme.of(ctx).colorScheme.outlineVariant, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            Text('Add SMS to Teach', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.inbox_rounded, color: Theme.of(ctx).colorScheme.primary),
              title: Text('Pick from Inbox', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
              subtitle: Text('Choose a real SMS (financial only)', style: GoogleFonts.inter(fontSize: 12)),
              onTap: () { Navigator.pop(ctx); _showInboxPicker(); },
            ),
            ListTile(
              leading: Icon(Icons.edit_rounded, color: Theme.of(ctx).colorScheme.tertiary),
              title: Text('Paste Manually', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
              subtitle: Text('Copy/paste sender + message', style: GoogleFonts.inter(fontSize: 12)),
              onTap: () { Navigator.pop(ctx); _showManualSmsDialog(); },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _showInboxPicker() async {
    final hasPerm = await _smsService.requestPermissions();
    if (!hasPerm && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('SMS permission required. Use Paste Manually instead.')));
      return;
    }
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(width: 40, height: 4, margin: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: Theme.of(context).colorScheme.outlineVariant, borderRadius: BorderRadius.circular(2))),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text('Pick a financial SMS', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w700))),
            const SizedBox(height: 8),
            Expanded(
              child: FutureBuilder(
                future: _smsService.getInboxForPicker(limit: 100),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                  final msgs = snapshot.data ?? [];
                  if (msgs.isEmpty) return Center(child: Padding(padding: const EdgeInsets.all(24), child: Text('No financial SMS found in last 100 messages', style: GoogleFonts.inter(color: Theme.of(context).colorScheme.onSurfaceVariant))));
                  return ListView.separated(
                    controller: scrollController,
                    itemCount: msgs.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final m = msgs[i];
                      final body = m.body ?? '';
                      final sender = m.address ?? 'Unknown';
                      final preview = body.length > 90 ? '${body.substring(0, 90)}...' : body;
                      return ListTile(
                        title: Text(sender, style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600)),
                        subtitle: Text(preview, style: GoogleFonts.inter(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant), maxLines: 2),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () async {
                          Navigator.pop(context);
                          await _smsService.insertUnrecognized({'id': const Uuid().v4(), 'senderId': sender, 'body': body, 'receivedAt': DateTime.now().toIso8601String(), 'dismissed': 0});
                          await _loadUnrecognized();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added SMS from $sender'), backgroundColor: Colors.green));
                            final newItem = _unrecognized.firstWhere((e) => e.body == body && e.senderId == sender, orElse: () => _unrecognized.first);
                            setState(() => _selectedItem = newItem);
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showManualSmsDialog() {
    _manualSenderController.clear();
    _manualBodyController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Manual SMS', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Paste an SMS to teach fused a new pattern.', style: GoogleFonts.inter(fontSize: 14, color: Theme.of(context).colorScheme.onSurfaceVariant)),
              const SizedBox(height: 16),
              TextField(
                controller: _manualSenderController,
                decoration: InputDecoration(labelText: 'Sender', hintText: 'e.g., MTN MoMo, GCB Bank', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), prefixIcon: const Icon(Icons.person_outline)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _manualBodyController,
                maxLines: 5,
                decoration: InputDecoration(labelText: 'Message Body', hintText: 'Paste SMS here...', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), alignLabelWithHint: true),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: GoogleFonts.inter())),
          FilledButton(
            onPressed: () async {
              final sender = _manualSenderController.text.trim();
              final body = _manualBodyController.text.trim();
              if (sender.isEmpty || body.isEmpty) return;
              Navigator.pop(context);
              // Add to unrecognized queue so user can teach it normally
              await _smsService.insertUnrecognized({'id': const Uuid().v4(), 'senderId': sender, 'body': body, 'receivedAt': DateTime.now().toIso8601String(), 'dismissed': 0});
              await _loadUnrecognized();
              if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added SMS from $sender to teach queue'), backgroundColor: Colors.green));
            },
            child: Text('Add to Queue', style: GoogleFonts.inter()),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      floatingActionButton: FloatingActionButton.extended(onPressed: _showAddChoice, icon: const Icon(Icons.add_rounded), label: Text('Add SMS', style: GoogleFonts.inter(fontWeight: FontWeight.w600)), backgroundColor: colorScheme.primary, foregroundColor: colorScheme.onPrimary),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            decoration: BoxDecoration(color: colorScheme.primary, borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28))),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Teach Fused', style: GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.w700, color: colorScheme.onPrimary)), IconButton(onPressed: () {}, icon: Icon(Icons.help_outline_rounded, color: colorScheme.onPrimary, size: 24))]),
          ),
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    labelColor: colorScheme.primary,
                    unselectedLabelColor: colorScheme.onSurfaceVariant,
                    indicatorColor: colorScheme.primary,
                    labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13),
                    tabs: [
                      Tab(text: 'To Teach (${_unrecognized.length})'),
                      const Tab(text: 'Active Templates'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _unrecognized.isEmpty ? _buildEmptyState(colorScheme) : _buildList(colorScheme),
                        _buildActiveTemplatesTab(colorScheme),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveTemplatesTab(ColorScheme colorScheme) {
    return FutureBuilder<List<SmsTemplateModel>>(
      future: ref.read(dbProvider).getTemplates(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        final templates = snapshot.data ?? [];
        if (templates.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_awesome_outlined, size: 64, color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  Text('No active templates', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w600, color: colorScheme.onSurfaceVariant)),
                  const SizedBox(height: 8),
                  Text('Teach an SMS to create your first template', style: GoogleFonts.inter(fontSize: 14, color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7)), textAlign: TextAlign.center),
                ],
              ),
            ),
          );
        }
        final grouped = <String, List<SmsTemplateModel>>{};
        for (final t in templates) grouped.putIfAbsent(t.senderId, () => []).add(t);
        return ListView(
          padding: const EdgeInsets.all(16),
          children: grouped.entries.map((e) {
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: colorScheme.outlineVariant)),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(backgroundColor: colorScheme.primaryContainer, child: Icon(Icons.badge_outlined, color: colorScheme.primary, size: 20)),
                        const SizedBox(width: 12),
                        Expanded(child: Text(e.key, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 15))),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: colorScheme.primaryContainer, borderRadius: BorderRadius.circular(20)),
                          child: Text('${e.value.length} template${e.value.length > 1 ? 's' : ''}', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: colorScheme.primary)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...e.value.map((t) {
                      final preview = t.sampleBody.length > 90 ? '${t.sampleBody.substring(0, 90)}...' : t.sampleBody;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(child: Text('${t.before} [AMOUNT] ${t.after}'.trim(), style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500))),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(color: t.direction == 'income' ? Colors.green.withValues(alpha: 0.15) : Colors.red.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
                                  child: Text(t.direction, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: t.direction == 'income' ? Colors.green : Colors.red)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text('"$preview"', style: GoogleFonts.inter(fontSize: 11, color: colorScheme.onSurfaceVariant, fontStyle: FontStyle.italic)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                TextButton.icon(onPressed: () => _testTemplate(t), icon: const Icon(Icons.play_arrow_rounded, size: 16), label: Text('Test', style: GoogleFonts.inter(fontSize: 12))),
                                const Spacer(),
                                IconButton(
                                  icon: Icon(Icons.delete_outline_rounded, size: 20, color: colorScheme.error),
                                  onPressed: () async {
                                    final ok = await showDialog<bool>(context: context, builder: (c) => AlertDialog(title: Text('Delete template?', style: GoogleFonts.plusJakartaSans()), content: Text('Delete template for ${e.key}?', style: GoogleFonts.inter()), actions: [TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')), FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Delete'))]));
                                    if (ok == true) { await ref.read(dbProvider).deleteTemplate(t.id); setState(() {}); }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Future<void> _testTemplate(SmsTemplateModel template) async {
    final controller = TextEditingController(text: template.sampleBody);
    final result = await showDialog<String>(context: context, builder: (c) => AlertDialog(title: Text('Test Template', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)), content: Column(mainAxisSize: MainAxisSize.min, children: [Text('Edit message to test:', style: GoogleFonts.inter(fontSize: 12)), const SizedBox(height: 8), TextField(controller: controller, maxLines: 4, decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), hintText: 'Paste test SMS...'))]), actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancel')), FilledButton(onPressed: () => Navigator.pop(c, controller.text), child: const Text('Test'))]));
    if (result == null || !mounted) return;
    final amount = SmsTemplateMatcher.match(template.senderId, result, [template]);
    if (!mounted) return;
    showDialog(context: context, builder: (c) => AlertDialog(title: Text(amount != null ? 'Match Found!' : 'No Match', style: GoogleFonts.plusJakartaSans(color: amount != null ? Colors.green : Theme.of(context).colorScheme.error)), content: Text(amount != null ? 'Extracted amount: GH₵ ${amount.toStringAsFixed(2)}\nDirection: ${template.direction}' : 'This message did not match.\n\nTemplate expects:\nbefore: "${template.before}"\nafter: "${template.after}"', style: GoogleFonts.inter()), actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text('Close'))]));
  }

  Widget _buildEmptyState(ColorScheme colorScheme) => Center(child: Padding(padding: const EdgeInsets.all(32), child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.school_outlined, size: 64, color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5)), const SizedBox(height: 16), Text('Nothing to teach', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w600, color: colorScheme.onSurfaceVariant)), const SizedBox(height: 8), Text('Tap + to add an SMS manually, or unrecognized messages will appear here', style: GoogleFonts.inter(fontSize: 14, color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7)), textAlign: TextAlign.center)])));

  Widget _buildList(ColorScheme colorScheme) => ListView.separated(padding: const EdgeInsets.all(24), itemCount: _unrecognized.length, separatorBuilder: (_, __) => const SizedBox(height: 12), itemBuilder: (context, index) {
        final item = _unrecognized[index];
        final isSelected = _selectedItem?.id == item.id;
        return Card(
          elevation: isSelected ? 4 : 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: isSelected ? colorScheme.primary : colorScheme.outlineVariant, width: isSelected ? 2 : 1)),
          child: InkWell(
            onTap: () => setState(() => _selectedItem = isSelected ? null : item),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [CircleAvatar(backgroundColor: colorScheme.primaryContainer, child: Icon(Icons.message_rounded, color: colorScheme.primary, size: 20)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(item.senderId, style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w600, color: colorScheme.onSurface)), Text(DateFormat('MMM d, h:mm a').format(item.receivedAt), style: GoogleFonts.inter(fontSize: 12, color: colorScheme.onSurfaceVariant))])), if (isSelected) Icon(Icons.expand_less, color: colorScheme.primary)]),
                if (isSelected) ...[const SizedBox(height: 16), _buildTeachInterface(item, colorScheme)],
              ]),
            ),
          ),
        );
      });

  Widget _buildTeachInterface(UnrecognizedSmsItem item, ColorScheme colorScheme) {
    final tokens = _parseTokens(item.body);
    final amountIndex = _findAmountToken(item.body);
    final candidates = SmsTemplateMatcher.findAmountCandidates(item.body);
    final hasMultiple = candidates.length > 1;
    if (_amountTokenIndex == null && amountIndex != -1) {
      _amountTokenIndex = amountIndex;
      _selectedBeforeTokens.clear();
      _selectedAfterTokens.clear();
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(12)), child: Text(item.body, style: GoogleFonts.inter(fontSize: 13, color: colorScheme.onSurfaceVariant, height: 1.4))),
      if (hasMultiple)
        Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.amber.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
          child: Row(children: [Icon(Icons.info_outline_rounded, size: 16, color: Colors.amber.shade700), const SizedBox(width: 6), Expanded(child: Text('Found ${candidates.length} numbers — tap the correct amount', style: GoogleFonts.inter(fontSize: 11, color: Colors.amber.shade800)))]),
        ),
      const SizedBox(height: 16),
      Row(children: [Expanded(child: Text(hasMultiple ? 'Tap the correct amount' : 'Select amount', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: colorScheme.onSurface))), DropdownButton<String>(value: _selectedDirection, items: ['expense', 'income'].map((d) => DropdownMenuItem(value: d, child: Text(d.capitalize()))).toList(), onChanged: (v) => setState(() => _selectedDirection = v!))]),
      const SizedBox(height: 8),
      Wrap(spacing: 8, runSpacing: 8, children: tokens.asMap().entries.map((entry) {
        final i = entry.key;
        final token = entry.value;
        final isCandidate = candidates.any((c) => c.index == i);
        final isSelected = i == _amountTokenIndex;
        Color col = colorScheme.primary;
        if (isSelected) col = Colors.green;
        else if (isCandidate) col = Colors.amber.shade700;
        return TokenChip(label: token, selected: isSelected, color: col, onTap: () => setState(() => _amountTokenIndex = i));
      }).toList()),
      const SizedBox(height: 12),
      Text('Tap tokens before/after amount to refine template', style: GoogleFonts.inter(fontSize: 11, color: colorScheme.onSurfaceVariant)),
      const SizedBox(height: 8),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('BEFORE', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: colorScheme.primary)), const SizedBox(height: 6), Wrap(spacing: 6, runSpacing: 6, children: tokens.asMap().entries.where((e) => e.key < (_amountTokenIndex ?? 999)).map((e) => TokenChip(label: e.value, selected: _selectedBeforeTokens.contains(e.value), color: colorScheme.primary, onTap: () => setState(() => _selectedBeforeTokens.contains(e.value) ? _selectedBeforeTokens.remove(e.value) : _selectedBeforeTokens.add(e.value)))).toList())])),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('AFTER', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: colorScheme.tertiary)), const SizedBox(height: 6), Wrap(spacing: 6, runSpacing: 6, children: tokens.asMap().entries.where((e) => e.key > (_amountTokenIndex ?? -1)).map((e) => TokenChip(label: e.value, selected: _selectedAfterTokens.contains(e.value), color: colorScheme.tertiary, onTap: () => setState(() => _selectedAfterTokens.contains(e.value) ? _selectedAfterTokens.remove(e.value) : _selectedAfterTokens.add(e.value)))).toList())])),
      ]),
      const SizedBox(height: 16),
      Row(children: [Expanded(child: FusedButton(label: 'Dismiss', variant: FusedButtonVariant.ghost, onPressed: () => _dismissItem(item.id))), const SizedBox(width: 12), Expanded(child: FusedButton(label: 'Create Template', variant: FusedButtonVariant.primary, onPressed: (_amountTokenIndex != null) ? () => _createTemplateFromSelection(item) : null))]),
    ]);
  }

  Future<void> _createTemplateFromSelection(UnrecognizedSmsItem item) async {
    if (_amountTokenIndex == null) return;
    final before = _selectedBeforeTokens.join(' ');
    final after = _selectedAfterTokens.join(' ');
    // Build simple template directly if no before/after selected, use matcher logic
    String finalBefore = before;
    String finalAfter = after;
    if (finalBefore.isEmpty && finalAfter.isEmpty) {
      // fallback: use 2 tokens before/after amount
      final tokens = _parseTokens(item.body);
      final idx = _amountTokenIndex!;
      finalBefore = tokens.sublist((idx - 2).clamp(0, tokens.length), idx).join(' ');
      finalAfter = idx + 1 < tokens.length ? tokens.sublist(idx + 1, (idx + 3).clamp(0, tokens.length)).join(' ') : '';
    }
    final template = SmsTemplateModel(id: Uuid().v4(), senderId: item.senderId, before: finalBefore, after: finalAfter, direction: _selectedDirection, sampleBody: item.body, createdAt: DateTime.now());
    await ref.read(dbProvider).insertTemplate(template);
    await _dismissItem(item.id);
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Template created for ${item.senderId}'), backgroundColor: Colors.green));
  }

  Future<void> _dismissItem(String id) async {
    await _smsService.dismissUnrecognized(id);
    await _loadUnrecognized();
    if (mounted) setState(() { if (_selectedItem?.id == id) _selectedItem = null; });
  }
}
