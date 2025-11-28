import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/main.dart';

void main() {
  testWidgets('HomeScreen renders title, CTA and featured product and navigates to product page', (WidgetTester tester) async {
    // Build the full app to include routes
    await tester.pumpWidget(const UnionShopApp());
    await tester.pumpAndSettle();

    // Check the main title is present
    expect(find.text('Union Shop'), findsOneWidget);

    // Check the hero CTA button
    expect(find.widgetWithText(ElevatedButton, 'Browse Products'), findsOneWidget);

    // Check at least one featured product is present
    expect(find.text('Product 1'), findsWidgets);

    // Tap the CTA and verify navigation to the ProductPage placeholder
    await tester.tap(find.widgetWithText(ElevatedButton, 'Browse Products'));
    await tester.pumpAndSettle();
    expect(find.text('Product detail / list placeholder'), findsOneWidget);
  });
}
