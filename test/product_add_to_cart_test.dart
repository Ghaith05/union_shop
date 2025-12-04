import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/data/cart.dart';
import 'package:union_shop/views/product_page.dart';
import 'package:union_shop/models/product.dart';


void main() {
  testWidgets(
      'ProductPage Add to cart adds item to CartService and shows SnackBar',
      (tester) async {
    final product = Product.sample(
      id: 't2',
      title: 'Addable Product',
      collectionId: 'c1',
      price: 10.0,
      images: const [],
    );

    CartService().clear();

    await tester.pumpWidget(MaterialApp(home: ProductPage(product: product)));

    // Select required variants so the Add to cart button becomes enabled.
    // Ensure the controls are visible before tapping to avoid hit-test issues.
    await tester.ensureVisible(find.text('Size'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Size'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('M').last);
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Color'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Color'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Red').last);
    await tester.pumpAndSettle();

    // Select Qty = 1 to be explicit
    await tester.ensureVisible(find.text('Qty'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Qty'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('1').first);
    await tester.pumpAndSettle();

    // Ensure Add to cart button exists
    final addFinder = find.text('Add to cart');
    expect(addFinder, findsOneWidget);

    // Tap Add to cart
    await tester.tap(addFinder);
    await tester.pumpAndSettle();

    // The CartService should now contain the product
    final items = CartService().items.value;
    expect(items.length, 1);
    expect(items.first.product.id, product.id);
    // default qty should be 1 if no selection
    expect(items.first.quantity, 1);

    // SnackBar confirmation should be shown
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.textContaining('Added'), findsOneWidget);
  });
}
