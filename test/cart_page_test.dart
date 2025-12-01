import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/data/cart.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/views/cart_page.dart';

void main() {
  testWidgets('CartPage displays items, updates qty, removes and checkout clears',
      (tester) async {
    // Prepare sample product and seed cart
    final product = Product.sample(
      id: 't-test',
      title: 'Test Product',
      collectionId: 'c1',
      price: 5.00,
      images: const [],
    );

    // Reset cart to deterministic state
    CartService().clear();
    CartService().add(product, quantity: 2);

    await tester.pumpWidget(
      const MaterialApp(
        home: CartPage(),
      ),
    );

    // Item title and quantity 2 should be present
    expect(find.text('Test Product'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);

    // Increase quantity (tap Increase icon)
    final increaseFinder = find.byTooltip('Increase').first;
    await tester.tap(increaseFinder);
    await tester.pumpAndSettle();

    // Quantity should increase to 3
    expect(find.text('3'), findsOneWidget);

    // Decrease quantity (tap Decrease icon)
    final decreaseFinder = find.byTooltip('Decrease').first;
    await tester.tap(decreaseFinder);
    await tester.pumpAndSettle();

    // Back to 2
    expect(find.text('2'), findsOneWidget);

    // Remove the item
    final removeFinder = find.byTooltip('Remove').first;
    await tester.tap(removeFinder);
    await tester.pumpAndSettle();

    // Cart should now be empty
    expect(find.text('Your cart is empty'), findsOneWidget);

    // Add again and test checkout clears cart
    CartService().add(product, quantity: 1);
    await tester.pumpAndSettle();

    expect(find.text('Test Product'), findsOneWidget);

    await tester.tap(find.text('Checkout'));
    await tester.pumpAndSettle();

    expect(find.text('Your cart is empty'), findsOneWidget);
  });
}