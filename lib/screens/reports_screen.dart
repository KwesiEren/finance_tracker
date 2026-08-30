import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../providers/app_providers.dart';
import '../services/report_service.dart';
import '../widgets/spending_pie_chart.dart';
import '../widgets/report_list_item.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  static const routeName = 'Reports';
  static const routePath = '/reports';

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  final _reportService = ReportService.instance;
  String _selectedPeriod = 'monthly';
  DateTime _currentDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final categories = ref.watch(categoriesProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text('Reports', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      body: FutureBuilder<ReportData>(
        future: _selectedPeriod == 'monthly'
            ? _reportService.getMonthlyReport(_currentDate)
            : _reportService.getDailyReport(_currentDate),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: colorScheme.primary));
          }

          final report = snapshot.data;
          if (report == null) {
            return _buildEmptyState(colorScheme);
          }

          return CustomScrollView(
            slivers: [
              // Summary Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ReportSummaryCard(
                    income: report.income,
                    expense: report.expense,
                    net: report.net,
                    period: _formatPeriod(report.from, report.to),
                    transactionCount: report.transactionCount,
                  ),
                ),
              ),
              // Period Selector
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _PeriodSelector(
                    selectedPeriod: _selectedPeriod,
                    currentDate: _currentDate,
                    onPeriodChanged: (period) => setState(() => _selectedPeriod = period),
                    onDateChanged: (date) => setState(() => _currentDate = date),
                  ),
                ),
              ),
              // Pie Chart
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SpendingPieChart(
                    categorySpending: {for (var c in report.categoryBreakdown) c.category.id: c.amount},
                    categories: categories,
                    total: report.expense,
                    onSectionTapped: (categoryId) {
                      final cat = categories.where((c) => c.id == categoryId).firstOrNull;
                      if (cat != null && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${cat.name}: GH₵ ${report.categoryBreakdown.where((e) => e.category.id == categoryId).firstOrNull?.amount.toStringAsFixed(0) ?? "0"}')));
                      }
                    },
                  ),
                ),
              ),
              // Legend
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: LegendList(
                    categorySpending: {for (var c in report.categoryBreakdown) c.category.id: c.amount},
                    categories: categories,
                    total: report.expense,
                  ),
                ),
              ),
              // Monthly Reports List
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Recent Months', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w700)),
                          TextButton(onPressed: () => _showAllMonths(context), child: Text('View All', style: GoogleFonts.inter(fontWeight: FontWeight.w600))),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _MonthlyReportsList(reportService: _reportService),
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

  void _showAllMonths(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Theme.of(context).colorScheme.outlineVariant, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 16),
              Text('All Months', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              Expanded(child: _MonthlyReportsList(reportService: _reportService, months: 24, scrollController: scrollController)),
            ],
          ),
        ),
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
            Icon(Icons.bar_chart_outlined, size: 64, color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            Text('No data yet', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w600, color: colorScheme.onSurfaceVariant)),
            const SizedBox(height: 8),
            Text('Add transactions to see reports', style: GoogleFonts.inter(fontSize: 14, color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7))),
          ],
        ),
      ),
    );
  }

  String _formatPeriod(DateTime from, DateTime to) {
    if (_selectedPeriod == 'monthly') {
      return DateFormat('MMMM yyyy').format(from);
    } else {
      return DateFormat('MMM d, yyyy').format(from);
    }
  }
}

class _PeriodSelector extends ConsumerWidget {
  final String selectedPeriod;
  final DateTime currentDate;
  final ValueChanged<String> onPeriodChanged;
  final ValueChanged<DateTime> onDateChanged;

  const _PeriodSelector({
    required this.selectedPeriod,
    required this.currentDate,
    required this.onPeriodChanged,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Row(
          children: ['daily', 'monthly'].map((period) {
            final isSelected = selectedPeriod == period;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text(period.capitalize(), style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
                  )),
                  selected: isSelected,
                  onSelected: (_) => onPeriodChanged(period),
                  selectedColor: colorScheme.primary,
                  backgroundColor: colorScheme.surfaceContainerHighest,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: currentDate,
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
            );
            if (picked != null) onDateChanged(picked);
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today_rounded, color: colorScheme.onSurfaceVariant, size: 20),
                const SizedBox(width: 12),
                Text(
                  selectedPeriod == 'monthly'
                      ? DateFormat('MMMM yyyy').format(currentDate)
                      : DateFormat('MMM d, yyyy').format(currentDate),
                  style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MonthlyReportsList extends StatelessWidget {
  final ReportService reportService;
  final int months;
  final ScrollController? scrollController;

  const _MonthlyReportsList({required this.reportService, this.months = 6, this.scrollController});

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<List<ReportData>>(
      future: reportService.getMonthlyReports(months: months),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final reports = snapshot.data ?? [];
        if (reports.isEmpty) return const SizedBox.shrink();

        return ListView.separated(
          controller: scrollController,
          shrinkWrap: scrollController == null,
          physics: scrollController == null ? const NeverScrollableScrollPhysics() : const ClampingScrollPhysics(),
          itemCount: reports.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final report = reports[index];
            return ReportListItem(
              title: DateFormat('MMMM yyyy').format(report.from),
              period: '${report.transactionCount} transactions',
              income: report.income,
              expense: report.expense,
              net: report.net,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${DateFormat('MMMM yyyy').format(report.from)} — ${report.transactionCount} txns, net GH₵ ${report.net.toStringAsFixed(0)}')));
              },
            );
          },
        );
      },
    );
  }
}

extension StringExt on String {
  String capitalize() => '${this[0].toUpperCase()}${substring(1)}';
}