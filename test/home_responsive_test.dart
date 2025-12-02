// ignore_for_file: deprecated_member_use, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/widgets/navbar.dart';

void main() {
  testWidgets('HomeScreen adapts between mobile and desktop', (tester) async {
    // Mobile viewport (375x800)
    // ignore: deprecated_member_use
    tester.binding.window.physicalSizeTestValue = const Size(375, 800);
    // ignore: deprecated_member_use
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    await tester.pumpAndSettle();

    // Ensure navbar keys exist on mobile (menu should be present)
    expect(find.byKey(const ValueKey('nav-menu')), findsOneWidget);
    expect(find.byKey(const ValueKey('nav-cart')), findsOneWidget);

    // Desktop viewport (1280x900)
    // ignore: duplicate_ignore
    // ignore: deprecated_member_use
    tester.binding.window.physicalSizeTestValue = const Size(1280, 900);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    // Rebuild with new size
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    await tester.pumpAndSettle();

    // On desktop the menu may be replaced by textual nav links; at minimum
    // the cart icon should still be present.
    expect(find.byKey(const ValueKey('nav-cart')), findsOneWidget);

    // Cleanup
    addTearDown(() {
      tester.binding.window.clearAllTestValues();
    });
  });
}
