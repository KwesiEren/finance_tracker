import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/app_providers.dart';
import '../widgets/fused_button.dart';
import '../widgets/step_indicator.dart';
import '../widgets/token_chip.dart';
import '../services/sms_service.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  static const routeName = 'Onboarding';
  static const routePath = '/onboarding';

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _currentStep = 0;
  final _pageController = PageController();
  final _smsService = SmsService();

  static const _totalSteps = 3;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  Future<void> _grantPermissionAndStart() async {
    final granted = await _smsService.requestPermissions();
    if (granted) {
      _smsService.startListening();
      await _smsService.scanInbox(lookbackDays: 30);
    }
    if (mounted) {
      ref.read(settingsProvider.notifier).setOnboardingComplete(true);
      _navigateToDashboard();
    }
  }

  void _skipToManual() {
    ref.read(settingsProvider.notifier).setOnboardingComplete(true);
    _navigateToDashboard();
  }

  void _navigateToDashboard() {
    Navigator.of(context).pushReplacementNamed('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Step Indicator
            Padding(
              padding: const EdgeInsets.all(24),
              child: StepIndicator(
                currentStep: _currentStep,
                totalSteps: _totalSteps,
                labels: const ['Privacy', 'Teach', 'Permission'],
              ),
            ),
            // Page View
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildPrivacyStep(),
                  _buildTeachStep(),
                  _buildPermissionStep(),
                ],
              ),
            ),
            // Bottom Actions
            _buildBottomActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyStep() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 24),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.security_rounded,
              color: Colors.green,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Your Data Stays Yours',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'fused is fully offline. We never upload your messages or bank details to any server.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 15,
              color: colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeachStep() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Demo SMS tokens
    final tokens = [
      ('Payment', false),
      ('of', false),
      ('GH₵ 45.00', true),
      ('made', false),
      ('to', false),
      ('KFC', false),
      ('Osu.', false),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.school_rounded, color: colorScheme.primary, size: 24),
              const SizedBox(width: 8),
              Text(
                'HOW TO TEACH FUSED',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Tap the amount in this SMS to help the app recognize future alerts from this sender:',
            style: GoogleFonts.inter(
              fontSize: 15,
              color: colorScheme.onSurface,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          // SMS Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'From: MobileMoney',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      'Just now',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: tokens.map((token) {
                    return TokenChip(
                      label: token.$1,
                      selected: token.$2,
                      color: token.$2 ? Colors.green : colorScheme.primary,
                      onTap: null, // Demo only
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_rounded, color: Colors.green, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Detected GH₵ 45.00 as an Expense',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionStep() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded, color: colorScheme.primary, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'On the next screen, Android will ask for SMS permission. This is only used to scan for these patterns locally on your phone.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: colorScheme.primary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_currentStep == _totalSteps - 1) ...[
            FusedButton(
              label: 'Grant Permission & Start',
              variant: FusedButtonVariant.primary,
              size: FusedButtonSize.large,
              fullWidth: true,
              onPressed: _grantPermissionAndStart,
            ),
            const SizedBox(height: 16),
            FusedButton(
              label: "I'll enter transactions manually",
              variant: FusedButtonVariant.ghost,
              size: FusedButtonSize.medium,
              fullWidth: true,
              onPressed: _skipToManual,
            ),
          ] else ...[
            FusedButton(
              label: 'Continue',
              variant: FusedButtonVariant.primary,
              size: FusedButtonSize.large,
              fullWidth: true,
              onPressed: _nextStep,
            ),
            const SizedBox(height: 16),
            FusedButton(
              label: 'Skip Setup',
              variant: FusedButtonVariant.ghost,
              size: FusedButtonSize.medium,
              fullWidth: true,
              onPressed: _skipToManual,
            ),
          ],
        ],
      ),
    );
  }
}