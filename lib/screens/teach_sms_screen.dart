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
      floatingActionButton: FloatingActionButton.extended(onPressed: _showManualSmsDialog, icon: const Icon(Icons.add_rounded), label: Text('Add SMS', style: GoogleFonts.inter(fontWeight: FontWeight.w600)), backgroundColor: colorScheme.primary, foregroundColor: colorScheme.onPrimary),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            decoration: BoxDecoration(color: colorScheme.primary, borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28))),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Teach Fused', style: GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.w700, color: colorScheme.onPrimary)), IconButton(onPressed: () {}, icon: Icon(Icons.help_outline_rounded, color: colorScheme.onPrimary, size: 24))]),
          ),
          Expanded(child: _unrecognized.isEmpty ? _buildEmptyState(colorScheme) : _buildList(colorScheme)),
        ],
      ),
    );
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
    if (_amountTokenIndex != amountIndex) {
      _amountTokenIndex = amountIndex;
      _selectedBeforeTokens.clear();
      _selectedAfterTokens.clear();
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(12)), child: Text(item.body, style: GoogleFonts.inter(fontSize: 13, color: colorScheme.onSurfaceVariant, height: 1.4))),
      const SizedBox(height: 16),
      Row(children: [Expanded(child: Text('Select amount', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: colorScheme.onSurface))), DropdownButton<String>(value: _selectedDirection, items: ['expense', 'income'].map((d) => DropdownMenuItem(value: d, child: Text(d.capitalize()))).toList(), onChanged: (v) => setState(() => _selectedDirection = v!))]),
      const SizedBox(height: 8),
      Wrap(spacing: 8, runSpacing: 8, children: tokens.asMap().entries.map((entry) {
        final i = entry.key;
        final token = entry.value;
        final isAmount = i == amountIndex;
        return TokenChip(label: token, selected: isAmount, color: isAmount ? Colors.green : colorScheme.primary, onTap: () => setState(() => _amountTokenIndex = i));
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
    // Use matcher to build base then override with user selection if provided
    final base = await _smsService.getTemplatesForSender(item.senderId);
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
