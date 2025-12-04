import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/data/sample_data.dart';
import 'package:union_shop/views/product_page.dart';

void main() {
  testWidgets('ProductPage renders product title and price',
      (WidgetTester tester) async {
    final prod = sampleProducts.first;

    await tester.pumpWidget(MaterialApp(
      home: ProductPage(product: prod),
    ));

    // Title may appear in app bar and content; assert visible
    expect(find.text(prod.title), findsWidgets);
    expect(find.text('£${prod.price.toStringAsFixed(2)}'), findsOneWidget);

    // Dropdowns for Size, Color and Qty should be present (check by hint text)
    expect(find.text('Size'), findsOneWidget);
    expect(find.text('Color'), findsOneWidget);
    expect(find.text('Qty'), findsOneWidget);

    // Add to cart button and Share button present
    expect(find.widgetWithText(ElevatedButton, 'Add to cart'), findsOneWidget);
    expect(find.widgetWithText(OutlinedButton, 'Share'), findsOneWidget);
  });

  testWidgets('ProductPage dropdowns and qty selector work; actions disabled',
      (WidgetTester tester) async {
    final prod = sampleProducts.first;

    await tester.pumpWidget(MaterialApp(home: ProductPage(product: prod)));
    await tester.pumpAndSettle();

    // Initial hint texts present
    expect(find.text('Size'), findsOneWidget);
    expect(find.text('Color'), findsOneWidget);
    expect(find.text('Qty'), findsOneWidget);

    // Select Size -> 'M'
    await tester.tap(find.text('Size').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('M').last);
    await tester.pumpAndSettle();
    expect(find.text('M'), findsWidgets);

    // Select Color -> 'Blue'
    await tester.tap(find.text('Color').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Blue').last);
    await tester.pumpAndSettle();
    expect(find.text('Blue'), findsWidgets);

    // Select Qty -> '3'
    await tester.tap(find.text('Qty').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('3').last);
    await tester.pumpAndSettle();
    expect(find.text('3'), findsWidgets);

    // Buttons should be present. After selecting size/color/qty the Add button
    // must be enabled and Buy should also be enabled. Share remains disabled.
    final ElevatedButton addBtn =
        tester.widget(find.widgetWithText(ElevatedButton, 'Add to cart'));
    expect(addBtn.onPressed, isNotNull);

    final ElevatedButton buyBtn =
        tester.widget(find.widgetWithText(ElevatedButton, 'Buy with shop'));
    expect(buyBtn.onPressed, isNotNull);

    final OutlinedButton shareBtn =
        tester.widget(find.widgetWithText(OutlinedButton, 'Share'));
    expect(shareBtn.onPressed, isNull);
  });
}
