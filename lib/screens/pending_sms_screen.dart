import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../models/data_models.dart';
import '../providers/app_providers.dart';
import '../services/sms_service.dart';
import '../widgets/pending_sms_card.dart';

class PendingSmsScreen extends ConsumerStatefulWidget {
  const PendingSmsScreen({super.key});

  static const routeName = 'PendingSms';
  static const routePath = '/pending';

  @override
  ConsumerState<PendingSmsScreen> createState() => _PendingSmsScreenState();
}

class _PendingSmsScreenState extends ConsumerState<PendingSmsScreen> with WidgetsBindingObserver {
  final _smsService = SmsService();
  final _formatter = NumberFormat.currency(symbol: 'GH₵ ', decimalDigits: 2);

  @override
  void initState() { super.initState(); WidgetsBinding.instance.addObserver(this); }
  @override
  void dispose() { WidgetsBinding.instance.removeObserver(this); super.dispose(); }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) { if (state == AppLifecycleState.resumed) { _smsService.scanInbox(lookbackDays: 1); ref.invalidate(pendingSmsProvider); } }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final categories = ref.watch(categoriesProvider);
    final pendingAsync = ref.watch(pendingSmsProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: pendingAsync.when(
        loading: () => Center(child: CircularProgressIndicator(color: colorScheme.primary)),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (items) {
          final uncategorizedCount = items.length;
          final uncategorizedAmount = items.fold(0.0, (sum, item) => sum + item.amount);

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(28),
                      bottomRight: Radius.circular(28),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Review SMS',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: colorScheme.onPrimary,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.help_outline_rounded, color: colorScheme.onPrimary, size: 24),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.onPrimary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _StatItem(
                              label: 'To Review',
                              value: uncategorizedCount.toString(),
                              color: colorScheme.onPrimary,
                            ),
                            Container(width: 1, height: 30, color: colorScheme.onPrimary.withValues(alpha: 0.2)),
                            _StatItem(
                              label: 'Uncategorized',
                              value: _formatter.format(uncategorizedAmount),
                              color: colorScheme.onPrimary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (items.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: colorScheme.primary.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_rounded, color: colorScheme.primary, size: 24),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Confirm these transactions to update your budgets. Unrecognized messages can be taught in the \'Teach\' tab.',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: colorScheme.onSurface,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (items.isEmpty)
                        _buildEmptyState(colorScheme)
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: items.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final item = items[index];
                            final filteredCategories = categories.where((c) => c.type == item.type).toList();
                            return PendingSmsCard(
                              item: item,
                              categories: filteredCategories,
                              onConfirm: (categoryId) => _confirmItem(item, categoryId),
                              onDismiss: () => _dismissItem(item.id),
                              onTeach: () => _teachItem(item),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
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
            Icon(Icons.sms_outlined, size: 64, color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            Text(
              'No messages to review',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'SMS transactions will appear here automatically',
              style: GoogleFonts.inter(fontSize: 14, color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmItem(PendingSmsItem item, String categoryId) async {
    final transaction = TransactionModel(
      id: const Uuid().v4(),
      amount: item.amount,
      type: item.type,
      categoryId: categoryId,
      date: item.smsDate,
      note: null,
      source: 'sms',
      rawSmsBody: item.rawSmsBody,
    );

    await ref.read(transactionsProvider.notifier).add(transaction);
    await _smsService.dismissPendingSms(item.id);
    ref.invalidate(pendingSmsProvider);
    ref.invalidate(transactionsProvider);
    if (mounted) setState(() {});
  }

  Future<void> _dismissItem(String id) async {
    await _smsService.dismissPendingSms(id);
    ref.invalidate(pendingSmsProvider);
    if (mounted) setState(() {});
  }

  Future<void> _teachItem(PendingSmsItem item) async {
    await _smsService.insertUnrecognized({
      'id': const Uuid().v4(),
      'senderId': item.senderId,
      'body': item.rawSmsBody,
      'receivedAt': item.smsDate.toIso8601String(),
      'dismissed': 0,
    });
    await _smsService.dismissPendingSms(item.id);
    ref.invalidate(pendingSmsProvider);
    ref.invalidate(unrecognizedSmsProvider);
    if (mounted) setState(() {});
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.w700, color: color)),
        const SizedBox(height: 4),
        Text(label, style: GoogleFonts.inter(fontSize: 12, color: color.withValues(alpha: 0.7))),
      ],
    );
  }
}