import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/data/cart.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/views/cart_page.dart';

void main() {
  testWidgets('CartPage displays items, updates qty', (tester) async {
    // Prepare sample product and seed cart
    final product = Product.sample(
      id: 't-test',
      title: 'Test Product',
      collectionId: 'c1',
      price: 5.00,
      images: const [],
    );

    CartService().add(product, quantity: 2);

    await tester.pumpWidget(
      const MaterialApp(
        home: CartPage(),
      ),
    );

    // Item title and quantity 2 should be present (quantity field key check)
    expect(find.text('Test Product'), findsOneWidget);
    final qtyFinder = find.byKey(const ValueKey('cart-qty-input-t-test'));
    expect(qtyFinder, findsOneWidget);

    // Increase quantity (tap Increase icon)
    final increaseFinder =
        find.byKey(const ValueKey('cart-increase-btn-t-test'));
    await tester.tap(increaseFinder);
    await tester.pumpAndSettle();
    // Quantity should increase to 3 (check inside the qty field)
    expect(find.descendant(of: qtyFinder, matching: find.text('3')),
        findsOneWidget);

    // Decrease quantity (tap Decrease icon)
    final decreaseFinder =
        find.byKey(const ValueKey('cart-decrease-btn-t-test'));
    await tester.tap(decreaseFinder);
    await tester.pumpAndSettle();
    // Back to 2
    expect(find.descendant(of: qtyFinder, matching: find.text('2')),
        findsOneWidget);

    // Remove the item (the UI shows a confirmation dialog)
    final removeFinder = find.byKey(const ValueKey('cart-remove-text-t-test'));
    await tester.tap(removeFinder);
    await tester.pumpAndSettle();

    // Confirm removal in the dialog
    final confirmRemove = find.widgetWithText(ElevatedButton, 'Remove');
    expect(confirmRemove, findsOneWidget);
    await tester.tap(confirmRemove);
    await tester.pumpAndSettle();

    // Cart should now be empty
    expect(find.text('Your cart is empty'), findsOneWidget);

    // (checkout flow assertions removed — this test focuses on qty updates and removal)
  });
}
