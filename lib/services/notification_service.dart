import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Local, on-device notifications — no server/push infra needed.
/// Two jobs: (1) fire when a category crosses its alert threshold or cap,
/// (2) deliver the daily/monthly report the user chose in Settings.
class NotificationService {
  NotificationService._internal();
  static final NotificationService instance = NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const settings = InitializationSettings(android: androidInit, iOS: iosInit);
    await _plugin.initialize(settings);
  }

  Future<void> showBudgetAlert({
    required String categoryName,
    required double spent,
    required double cap,
    required bool exceeded,
  }) async {
    final percent = ((spent / cap) * 100).round();
    final title = exceeded ? 'Budget exceeded: $categoryName' : 'Approaching limit: $categoryName';
    final body = exceeded
        ? 'You\'ve spent $spent of your $cap cap ($percent%).'
        : 'You\'re at $percent% of your $categoryName budget ($spent / $cap).';

    await _plugin.show(
      categoryName.hashCode,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'budget_alerts',
          'Budget Alerts',
          channelDescription: 'Alerts when a category nears or exceeds its cap',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> showReport({required String title, required String body}) async {
    await _plugin.show(
      'report'.hashCode,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'reports',
          'Spending Reports',
          channelDescription: 'Daily or monthly spending summaries',
          importance: Importance.defaultImportance,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
}
