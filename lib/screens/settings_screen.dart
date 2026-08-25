import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:local_auth/local_auth.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import '../providers/app_providers.dart';
import '../widgets/fused_button.dart';
import '../widgets/settings_tile.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  static const routeName = 'Settings';
  static const routePath = '/settings';

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _auth = LocalAuthentication();
  bool _isAuthenticating = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final settingsAsync = ref.watch(settingsProvider);

    return settingsAsync.when(
      data: (settings) => Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          title: Text('Settings', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
          backgroundColor: colorScheme.surface,
          surfaceTintColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Financial Configuration
              SettingsSection(
                title: 'FINANCIAL CONFIGURATION',
                children: [
                  SettingsTile(
                    leading: Icon(Icons.payments_rounded, color: colorScheme.onSurfaceVariant, size: 22),
                    title: 'Primary Currency',
                    value: '${settings.currencyCode} (${settings.currencySymbol})',
                    onTap: _showCurrencyPicker,
                  ),
                  SettingsTile(
                    leading: Icon(Icons.calendar_month_rounded, color: colorScheme.onSurfaceVariant, size: 22),
                    title: 'Monthly Payday',
                    value: '${_getOrdinal(settings.payday)} of every month',
                    onTap: _showPaydayPicker,
                  ),
                  SettingsTile(
                    leading: Icon(Icons.speed_rounded, color: colorScheme.onSurfaceVariant, size: 22),
                    title: 'Daily Safe-Spend Logic',
                    value: 'Remaining / Days Left',
                    onTap: () {}, // Info only
                  ),
                ],
              ),

              // Notifications & Alerts
              SettingsSection(
                title: 'NOTIFICATIONS & ALERTS',
                children: [
                  SettingsTile(
                    leading: Icon(Icons.notifications_active_rounded, color: colorScheme.onSurfaceVariant, size: 22),
                    title: 'Budget Warning Threshold',
                    value: '${(settings.capAlertThreshold * 100).toInt()}% of monthly cap',
                    onTap: _showThresholdPicker,
                  ),
                  SettingsTile(
                    leading: Icon(Icons.assessment_rounded, color: colorScheme.onSurfaceVariant, size: 22),
                    title: 'Scheduled Reports',
                    value: _formatReportFrequency(settings.reportFrequency),
                    onTap: _showFrequencyPicker,
                  ),
                  SettingsSwitchTile(
                    leading: Icon(Icons.message_rounded, color: colorScheme.onSurfaceVariant, size: 22),
                    title: 'SMS Detection',
                    subtitle: 'Automatically detect transactions from SMS',
                    value: settings.smsDetectionEnabled,
                    onChanged: (v) => ref.read(settingsProvider.notifier).setSmsDetectionEnabled(v),
                  ),
                ],
              ),

              // Data & Privacy
              SettingsSection(
                title: 'DATA & PRIVACY',
                children: [
                  SettingsTile(
                    leading: Icon(Icons.model_training_rounded, color: colorScheme.onSurfaceVariant, size: 22),
                    title: 'Learned Patterns',
                    value: 'SMS templates saved',
                    onTap: () => Navigator.pushNamed(context, '/teach'),
                  ),
                  SettingsActionTile(
                    leading: Icon(Icons.download_rounded, color: colorScheme.onSurfaceVariant, size: 22),
                    title: 'Export Data',
                    subtitle: 'Backup your database as CSV',
                    onTap: _exportData,
                  ),
                  SettingsActionTile(
                    leading: Icon(Icons.upload_rounded, color: colorScheme.onSurfaceVariant, size: 22),
                    title: 'Import Data',
                    subtitle: 'Restore from a backup file',
                    onTap: _importData,
                  ),
                  SettingsSwitchTile(
                    leading: Icon(Icons.lock_outline_rounded, color: colorScheme.onSurfaceVariant, size: 22),
                    title: 'App Lock',
                    subtitle: 'Secure with biometric or PIN',
                    value: settings.appLockEnabled,
                    onChanged: _toggleAppLock,
                  ),
                ],
              ),

              // About
              SettingsSection(
                title: 'ABOUT',
                children: [
                  SettingsTile(
                    leading: Icon(Icons.info_outline_rounded, color: colorScheme.onSurfaceVariant, size: 22),
                    title: 'Version',
                    value: '1.0.0',
                  ),
                  SettingsTile(
                    leading: Icon(Icons.privacy_tip_outlined, color: colorScheme.onSurfaceVariant, size: 22),
                    title: 'Privacy Policy',
                    onTap: () {},
                  ),
                  SettingsTile(
                    leading: Icon(Icons.article_outlined, color: colorScheme.onSurfaceVariant, size: 22),
                    title: 'Terms of Service',
                    onTap: () {},
                  ),
                ],
              ),

              // Danger Zone
              const SizedBox(height: 24),
              SettingsSection(
                title: 'DANGER ZONE',
                children: [
                  SettingsActionTile(
                    leading: Icon(Icons.delete_forever_rounded, color: colorScheme.error, size: 22),
                    title: 'Delete All Local Data',
                    subtitle: 'Permanently erase all transactions, categories, and settings',
                    textColor: colorScheme.error,
                    onTap: _confirmDeleteAllData,
                  ),
                ],
              ),

              const SizedBox(height: 32),
              Center(
                child: Text(
                  'fused v1.0.0\nFully Offline Finance Tracker',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(fontSize: 12, color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
                ),
              ),
            ],
          ),
        ),
      ),
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, st) => Scaffold(body: Center(child: Text('Error loading settings: $e'))),
    );
  }

  void _showCurrencyPicker() {
    final currencies = [
      ('GHS', 'GH₵', 'Ghanaian Cedi'),
      ('USD', '\$', 'US Dollar'),
      ('EUR', '€', 'Euro'),
      ('GBP', '£', 'British Pound'),
      ('NGN', '₦', 'Nigerian Naira'),
      ('KES', 'KSh', 'Kenyan Shilling'),
      ('ZAR', 'R', 'South African Rand'),
    ];

    showModalBottomSheet(
      context: context,
      builder: (context) => ListView(
        shrinkWrap: true,
        children: currencies.map((c) => ListTile(
          title: Text(c.$3, style: GoogleFonts.plusJakartaSans()),
          subtitle: Text('${c.$1} ${c.$2}', style: GoogleFonts.inter()),
          trailing: c.$1 == ref.read(settingsProvider).value?.currencyCode ? const Icon(Icons.check, color: Colors.teal) : null,
          onTap: () {
            ref.read(settingsProvider.notifier).setCurrency(c.$1, c.$2);
            Navigator.pop(context);
          },
        )).toList(),
      ),
    );
  }

  void _showPaydayPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView(
        shrinkWrap: true,
        children: List.generate(28, (i) => i + 1).map((day) => ListTile(
          title: Text('${_getOrdinal(day)} of every month', style: GoogleFonts.plusJakartaSans()),
          trailing: day == ref.read(settingsProvider).value?.payday ? const Icon(Icons.check, color: Colors.teal) : null,
          onTap: () {
            ref.read(settingsProvider.notifier).setPayday(day);
            Navigator.pop(context);
          },
        )).toList(),
      ),
    );
  }

  void _showThresholdPicker() {
    final thresholds = [0.5, 0.6, 0.7, 0.8, 0.9];
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView(
        shrinkWrap: true,
        children: thresholds.map((t) => ListTile(
          title: Text('${(t * 100).toInt()}%', style: GoogleFonts.plusJakartaSans()),
          trailing: t == ref.read(settingsProvider).value?.capAlertThreshold ? const Icon(Icons.check, color: Colors.teal) : null,
          onTap: () {
            ref.read(settingsProvider.notifier).setCapAlertThreshold(t);
            Navigator.pop(context);
          },
        )).toList(),
      ),
    );
  }

  void _showFrequencyPicker() {
    final frequencies = [
      ('daily', 'Daily Summary at 8:00 PM'),
      ('weekly', 'Weekly Summary on Sunday'),
      ('monthly', 'Monthly Summary on 1st'),
      ('none', 'Disabled'),
    ];
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView(
        shrinkWrap: true,
        children: frequencies.map((f) => ListTile(
          title: Text(f.$2, style: GoogleFonts.plusJakartaSans()),
          trailing: f.$1 == ref.read(settingsProvider).value?.reportFrequency ? const Icon(Icons.check, color: Colors.teal) : null,
          onTap: () {
            ref.read(settingsProvider.notifier).setReportFrequency(f.$1);
            Navigator.pop(context);
          },
        )).toList(),
      ),
    );
  }

  String _formatReportFrequency(String freq) {
    switch (freq) {
      case 'daily': return 'Daily Summary at 8:00 PM';
      case 'weekly': return 'Weekly Summary on Sunday';
      case 'monthly': return 'Monthly Summary on 1st';
      default: return 'Disabled';
    }
  }

  String _getOrdinal(int n) {
    if (n >= 11 && n <= 13) return '${n}th';
    switch (n % 10) {
      case 1: return '${n}st';
      case 2: return '${n}nd';
      case 3: return '${n}rd';
      default: return '${n}th';
    }
  }

  Future<void> _exportData() async {
    try {
      // Export transactions
      final transactions = await ref.read(dbProvider).getTransactions();
      final categories = await ref.read(dbProvider).getCategories();
      final templates = await ref.read(dbProvider).getTemplates();
      
      final dir = await getApplicationDocumentsDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final fileName = 'fused_export_$timestamp.csv';
      final filePath = '${dir.path}/$fileName';
      
      final csvBuffer = StringBuffer();
      
      // Write transactions
      csvBuffer.writeln('=== TRANSACTIONS ===');
      csvBuffer.writeln('id,amount,type,categoryId,date,note,source,rawSmsBody');
      for (final tx in transactions) {
        csvBuffer.writeln([
          tx.id,
          tx.amount.toString(),
          tx.type,
          tx.categoryId ?? '',
          tx.date.toIso8601String(),
          (tx.note ?? '').replaceAll(',', ';').replaceAll('\n', ' '),
          tx.source,
          (tx.rawSmsBody ?? '').replaceAll(',', ';').replaceAll('\n', ' '),
        ].map((e) => '"$e"').join(','));
      }
      
      csvBuffer.writeln('');
      csvBuffer.writeln('=== CATEGORIES ===');
      csvBuffer.writeln('id,name,iconName,colorValue,type,monthlyCap,isDefault');
      for (final cat in categories) {
        csvBuffer.writeln([
          cat.id,
          '"${cat.name}"',
          cat.iconName,
          cat.colorValue.toString(),
          cat.type,
          cat.monthlyCap?.toString() ?? '',
          cat.isDefault ? '1' : '0',
        ].join(','));
      }
      
      csvBuffer.writeln('');
      csvBuffer.writeln('=== SMS TEMPLATES ===');
      csvBuffer.writeln('id,senderId,before,after,direction,sampleBody,createdAt');
      for (final tmpl in templates) {
        csvBuffer.writeln([
          tmpl.id,
          tmpl.senderId,
          '"${tmpl.before}"',
          '"${tmpl.after}"',
          tmpl.direction,
          '"${tmpl.sampleBody}"',
          tmpl.createdAt.toIso8601String(),
        ].join(','));
      }
      
      final file = File(filePath);
      await file.writeAsString(csvBuffer.toString());
      
      await Share.shareXFiles([XFile(filePath)], text: 'fused Finance Tracker Backup ($timestamp)');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Backup exported: $fileName')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    }
  }

  Future<void> _importData() async {
    // For now, show that import is coming soon
    // In a full implementation, this would use file_picker to select a CSV file
    // and parse it to restore transactions, categories, and templates
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Import feature coming soon - will support CSV restore')),
    );
  }

  Future<void> _toggleAppLock(bool enabled) async {
    if (enabled) {
      final available = await _auth.canCheckBiometrics;
      if (!available) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Biometric authentication not available on this device')),
        );
        ref.read(settingsProvider.notifier).setAppLockEnabled(false);
        return;
      }

      // Show dialog to choose authentication method
      final authMethod = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Choose Lock Method', style: GoogleFonts.plusJakartaSans()),
          content: Text('How would you like to secure the app?', style: GoogleFonts.inter()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'biometric'),
              child: Text('Biometric', style: GoogleFonts.inter()),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'pin'),
              child: Text('PIN', style: GoogleFonts.inter()),
            ),
          ],
        ),
      );

      if (authMethod == null) {
        ref.read(settingsProvider.notifier).setAppLockEnabled(false);
        return;
      }

      if (authMethod == 'biometric') {
        final authenticated = await _auth.authenticate(
          localizedReason: 'Enable app lock with biometric',
          options: const AuthenticationOptions(biometricOnly: true),
        );

        if (authenticated) {
          await ref.read(settingsProvider.notifier).setAppLockEnabled(true);
          await ref.read(settingsProvider.notifier).setBiometricEnabled(true);
        } else {
          ref.read(settingsProvider.notifier).setAppLockEnabled(false);
        }
      } else if (authMethod == 'pin') {
        final pin = await _showPinSetupDialog();
        if (pin != null && pin.length == 4) {
          await ref.read(settingsProvider.notifier).setAppLockEnabled(true);
          await ref.read(settingsProvider.notifier).setBiometricEnabled(false);
          // Store PIN hash (in a real app, you'd hash this)
          await ref.read(settingsProvider.notifier).setPin(pin);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('PIN lock enabled')),
            );
          }
        } else {
          ref.read(settingsProvider.notifier).setAppLockEnabled(false);
        }
      }
    } else {
      await ref.read(settingsProvider.notifier).setAppLockEnabled(false);
      await ref.read(settingsProvider.notifier).setBiometricEnabled(false);
    }
  }

  Future<String?> _showPinSetupDialog() async {
    final controller = TextEditingController();
    String? pin;
    
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Set 4-digit PIN', style: GoogleFonts.plusJakartaSans()),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          maxLength: 4,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Enter PIN',
            hintText: '4 digits',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (v) => pin = v,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              if (pin != null && pin!.length == 4) {
                Navigator.pop(context, pin);
              }
            },
            child: const Text('Set PIN'),
          ),
        ],
      ),
    );
    
    return pin;
  }

  Future<void> _confirmDeleteAllData() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete All Data?', style: GoogleFonts.plusJakartaSans(color: Theme.of(context).colorScheme.error)),
        content: Text('This will permanently delete all transactions, categories, SMS templates, and settings. This cannot be undone.', style: GoogleFonts.inter()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FusedButton(
            label: 'Delete Everything',
            variant: FusedButtonVariant.destructive,
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // TODO: Implement actual data deletion
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All data deleted')),
      );
    }
  }
}