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
    expect(find.text('\$${prod.price.toStringAsFixed(2)}'), findsOneWidget);

    // Dropdowns for Size, Color and Qty should be present (check by hint text)
    expect(find.text('Size'), findsOneWidget);
    expect(find.text('Color'), findsOneWidget);
    expect(find.text('Qty'), findsOneWidget);

    // Add to cart button and Share button present
    expect(find.widgetWithText(ElevatedButton, 'Add to cart'), findsOneWidget);
    expect(find.widgetWithText(OutlinedButton, 'Share'), findsOneWidget);
  });
}
