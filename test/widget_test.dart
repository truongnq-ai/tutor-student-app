// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_template/main.dart';

void main() {
  testWidgets('App builds successfully', (WidgetTester tester) async {
    // Build our app wrapped in ProviderScope (required for Riverpod)
    // This test verifies that the app can be instantiated without throwing exceptions
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    // Wait for initial build and allow async operations to complete
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Verify that the app builds without errors
    // Check for any exceptions that might have occurred during build
    final exception = tester.takeException();
    if (exception != null) {
      fail('App build failed with exception: $exception');
    }

    // Verify that the widget tree is not empty
    expect(find.byType(ProviderScope), findsOneWidget);
  });
}
