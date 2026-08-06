import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workmanager/workmanager.dart';
import 'services/notification_service.dart';
import 'services/sms_service.dart';
import 'services/report_service.dart';
import 'screens/dashboard_screen.dart';
import 'screens/categories_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/pending_sms_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.instance.init();

  // Background task runner for scheduled reports (see report_service.dart).
  await Workmanager().initialize(callbackDispatcher);

  // SMS listening is opt-in and Android-only — request permission,
  // then start listening only if granted. iOS builds simply skip this.
  final smsService = SmsService();
  final granted = await smsService.requestPermissions();
  if (granted) {
    smsService.startListening();
  }

  runApp(const ProviderScope(child: FinanceTrackerApp()));
}

class FinanceTrackerApp extends StatelessWidget {
  const FinanceTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Tracker',
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: const RootNav(),
    );
  }
}

class RootNav extends StatefulWidget {
  const RootNav({super.key});

  @override
  State<RootNav> createState() => _RootNavState();
}

class _RootNavState extends State<RootNav> {
  int _index = 0;

  static const _screens = [
    DashboardScreen(),
    PendingSmsScreen(),
    ReportsScreen(),
    CategoriesScreen(),
  ];

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
          NavigationDestination(icon: Icon(Icons.bar_chart_outlined), label: 'Reports'),
          NavigationDestination(icon: Icon(Icons.category_outlined), label: 'Categories'),
        ],
      ),
    );
  }
}
