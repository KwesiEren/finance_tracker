// This is a basic Flutter widget test.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finance_tracker/main.dart';

void main() {
  testWidgets('App starts and shows onboarding', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: FusedApp()));

    // Verify that onboarding screen is shown (since onboardingComplete is false by default)
    expect(find.text('Your Data Stays Yours'), findsOneWidget);
    expect(find.text('Grant Permission & Start'), findsOneWidget);
  });
}