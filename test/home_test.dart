import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/main.dart';

void main() {
  testWidgets(
      'HomeScreen renders title, CTA and featured product and navigates to product page',
      (WidgetTester tester) async {
    // Build the full app to include routes
    await tester.pumpWidget(const UnionShopApp());
    await tester.pumpAndSettle();

    // Check the main title is present
    expect(find.text('Union Shop'), findsOneWidget);

    // Check the hero CTA button
    expect(
        find.widgetWithText(ElevatedButton, 'Browse Products'), findsOneWidget);

    // Check at least one featured product is present
    // The sample data contains 'Union T-Shirt' as a featured product
    expect(find.text('Union T-Shirt'), findsWidgets);

    // Tap the CTA and verify navigation to the Collections page
    await tester.tap(find.widgetWithText(ElevatedButton, 'Browse Products'));
    await tester.pumpAndSettle();
    expect(find.text('Collections'), findsOneWidget);
  });

  testWidgets('tapping About in footer navigates to About page',
      (WidgetTester tester) async {
    await tester.pumpWidget(const UnionShopApp());
    await tester.pumpAndSettle();

    // The About button is in the footer; scroll the main ListView to bottom to ensure it's visible
    final mainList = find.byWidgetPredicate((widget) {
      return widget is ListView && widget.scrollDirection == Axis.vertical;
    });
    await tester.fling(mainList, const Offset(0, -800), 1000);
    await tester.pumpAndSettle();

    final aboutBtn = find.widgetWithText(TextButton, 'About');
    expect(aboutBtn, findsOneWidget);

    await tester.tap(aboutBtn);
    await tester.pumpAndSettle();

    // The AboutPage contains the heading 'Welcome to the Union Shop'
    expect(find.textContaining('Welcome to the Union Shop'), findsOneWidget);
  });
}
