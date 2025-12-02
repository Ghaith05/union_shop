// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/print_shack.dart';

void main() {
  testWidgets('PrintShack adapts between mobile and desktop', (tester) async {
    // Mobile
    tester.binding.window.physicalSizeTestValue = const Size(375, 800);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    await tester.pumpWidget(const MaterialApp(home: PrintShackPage()));
    await tester.pumpAndSettle();

    // Ensure keys for form controls exist
    expect(find.byKey(const ValueKey('print-lines')), findsOneWidget);
    expect(find.byKey(const ValueKey('print-line1')), findsOneWidget);
    expect(find.byKey(const ValueKey('print-add-to-cart')), findsOneWidget);

    // Desktop
    tester.binding.window.physicalSizeTestValue = const Size(1280, 900);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    await tester.pumpWidget(const MaterialApp(home: PrintShackPage()));
    await tester.pumpAndSettle();

    // Keys should remain
    expect(find.byKey(const ValueKey('print-lines')), findsOneWidget);
    expect(find.byKey(const ValueKey('print-line1')), findsOneWidget);
    expect(find.byKey(const ValueKey('print-add-to-cart')), findsOneWidget);

    addTearDown(() {
      tester.binding.window.clearAllTestValues();
    });
  });
}
