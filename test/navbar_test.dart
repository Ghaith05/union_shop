import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/main.dart';

void main() {
  testWidgets('desktop shows textual nav buttons and no menu icon',
      (WidgetTester tester) async {
    // Set window size to desktop
    // ignore: deprecated_member_use
    tester.binding.window.physicalSizeTestValue = const Size(800, 600);
    // ignore: deprecated_member_use
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      // ignore: deprecated_member_use
      tester.binding.window.clearPhysicalSizeTestValue();
      // ignore: deprecated_member_use
      tester.binding.window.clearDevicePixelRatioTestValue();
    });

    await tester.pumpWidget(const UnionShopApp());
    await tester.pumpAndSettle();

    // Desktop should show textual nav buttons
    expect(find.byKey(const ValueKey('nav-home')), findsOneWidget);
    expect(find.byKey(const ValueKey('nav-collections')), findsOneWidget);
    expect(find.byKey(const ValueKey('nav-sale')), findsOneWidget);
    expect(find.byKey(const ValueKey('nav-about')), findsOneWidget);
    expect(find.byKey(const ValueKey('nav-auth')), findsOneWidget);

    // Menu icon should not be present on desktop
    expect(find.byKey(const ValueKey('nav-menu')), findsNothing);
  });

  testWidgets('mobile shows menu icon and hides textual nav buttons',
      (WidgetTester tester) async {
    // Set window size to mobile
    // ignore: deprecated_member_use
    tester.binding.window.physicalSizeTestValue = const Size(360, 800);
    // ignore: deprecated_member_use
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      // ignore: deprecated_member_use
      tester.binding.window.clearPhysicalSizeTestValue();
      // ignore: deprecated_member_use
      tester.binding.window.clearDevicePixelRatioTestValue();
    });

    await tester.pumpWidget(const UnionShopApp());
    await tester.pumpAndSettle();

    // Mobile should show menu icon
    expect(find.byKey(const ValueKey('nav-menu')), findsOneWidget);

    // Textual nav buttons should not be present on mobile
    expect(find.byKey(const ValueKey('nav-home')), findsNothing);
    expect(find.byKey(const ValueKey('nav-collections')), findsNothing);
    expect(find.byKey(const ValueKey('nav-sale')), findsNothing);
    expect(find.byKey(const ValueKey('nav-about')), findsNothing);
    expect(find.byKey(const ValueKey('nav-auth')), findsNothing);
  });
}
