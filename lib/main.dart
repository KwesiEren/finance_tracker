import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workmanager/workmanager.dart';
import 'providers/app_providers.dart';
import 'services/notification_service.dart';
import 'services/sms_service.dart';
import 'services/report_service.dart';
import 'screens/onboarding_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/pending_sms_screen.dart';
import 'screens/teach_sms_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/categories_screen.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();
    final reportService = ReportService.instance;
    switch (task) {
      case 'dailyReport':
        await reportService.generateAndShowDailyReport();
        break;
      case 'monthlyReport':
        await reportService.generateAndShowMonthlyReport();
        break;
      case 'smsPoll':
        try {
          final sms = SmsService();
          await sms.scanInbox(lookbackDays: 2);
        } catch (e) {
          debugPrint('smsPoll failed: $e');
        }
        break;
    }
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await NotificationService.instance.init();
  } catch (e) {
    debugPrint('NotificationService init failed: $e');
  }

  try {
    await Workmanager().initialize(callbackDispatcher);
    await _schedulePeriodicReports();
    await _scheduleSmsPolling();
  } catch (e) {
    debugPrint('Workmanager init failed: $e');
  }

  // SMS listening is opt-in and Android-only
  try {
    final smsService = SmsService();
    final granted = await smsService.requestPermissions();
    if (granted) {
      smsService.startListening();
      // Keep foreground service alive on OEMs when user has detection enabled
      try {
        await smsService.startForeground();
      } catch (_) {}
    }
  } catch (e) {
    debugPrint('SMS service init failed: $e');
  }

  runApp(const ProviderScope(child: FusedApp()));
}

Future<void> _schedulePeriodicReports() async {
  // Daily report at 8 PM
  await Workmanager().registerPeriodicTask(
    'dailyReport',
    'dailyReport',
    frequency: const Duration(hours: 24),
    initialDelay: _timeUntilNextRun(20, 0), // 8 PM
    constraints: Constraints(networkType: NetworkType.notRequired),
  );

  // Monthly report on 1st at 9 AM
  await Workmanager().registerPeriodicTask(
    'monthlyReport',
    'monthlyReport',
    frequency: const Duration(days: 30),
    initialDelay: _timeUntilNextMonthlyRun(),
    constraints: Constraints(networkType: NetworkType.notRequired),
  );
}

Future<void> _scheduleSmsPolling() async {
  await Workmanager().registerPeriodicTask(
    'smsPoll_unique',
    'smsPoll',
    frequency: const Duration(minutes: 15),
    initialDelay: const Duration(minutes: 5),
    constraints: Constraints(networkType: NetworkType.notRequired, requiresBatteryNotLow: false),
    existingWorkPolicy: ExistingWorkPolicy.replace,
  );
}

Duration _timeUntilNextRun(int hour, int minute) {
  final now = DateTime.now();
  var target = DateTime(now.year, now.month, now.day, hour, minute);
  if (target.isBefore(now)) {
    target = target.add(const Duration(days: 1));
  }
  return target.difference(now);
}

Duration _timeUntilNextMonthlyRun() {
  final now = DateTime.now();
  var target = DateTime(now.year, now.month, 1, 9, 0);
  if (target.isBefore(now)) {
    target = DateTime(now.year, now.month + 1, 1, 9, 0);
  }
  return target.difference(now);
}

class FusedApp extends ConsumerWidget {
  const FusedApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);

    return MaterialApp(
      title: 'fused',
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      home: settingsAsync.when(
        data: (settings) => settings.onboardingComplete ? const RootNav() : const OnboardingScreen(),
        loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (e, st) => Scaffold(body: Center(child: Text('Error loading settings: $e'))),
      ),
      routes: {
        '/onboarding': (_) => const OnboardingScreen(),
        '/dashboard': (_) => const RootNav(),
      },
    );
  }
}

class RootNav extends ConsumerStatefulWidget {
  const RootNav({super.key});

  @override
  ConsumerState<RootNav> createState() => _RootNavState();
}

class _RootNavState extends ConsumerState<RootNav> with WidgetsBindingObserver {
  int _index = 0;
  final _smsService = SmsService();

  late final List<Widget> _screens = [
    const DashboardScreen(),
    const PendingSmsScreen(),
    const TeachSmsScreen(),
    const ReportsScreen(),
    const CategoriesScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Start SMS listening if enabled (after settings load)
    Future.microtask(() async {
      // Wait a bit for settings to load from DB
      await Future.delayed(const Duration(milliseconds: 500));
      final settings = ref.read(settingsProvider).value;
      if (settings?.smsDetectionEnabled == true) {
        final granted = await _smsService.requestPermissions();
        if (granted) {
          _smsService.startListening();
          await _smsService.startForeground();
        }
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Catch SMS missed while backgrounded (listenInBackground:false)
      _smsService.scanInbox(lookbackDays: 1);
      // Ensure listening is active if user has it enabled
      final settings = ref.read(settingsProvider).value;
      if (settings?.smsDetectionEnabled == true) {
        () async {
          final granted = await _smsService.requestPermissions();
          if (granted) {
            _smsService.startListening();
            await _smsService.startForeground();
          }
        }();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.sms_outlined), label: 'Detected'),
          NavigationDestination(icon: Icon(Icons.school_outlined), label: 'Teach'),
          NavigationDestination(icon: Icon(Icons.bar_chart_outlined), label: 'Reports'),
          NavigationDestination(icon: Icon(Icons.category_outlined), label: 'Categories'),
        ],
      ),
    );
  }
}