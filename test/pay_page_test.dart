import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/data/cart.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/views/pay_page.dart';

void main() {
  testWidgets('PayPage clears cart and navigates home when Pay pressed',
      (tester) async {
    // Disable server sync to avoid Firebase warnings in unit tests.
    CartService.serverSyncEnabled = false;

    // Prepare sample product and seed cart
    final product = Product.sample(
      id: 'p-pay',
      title: 'Pay Product',
      collectionId: 'c-pay',
      price: 10.00,
      images: const [],
    );

    // Ensure deterministic starting state
    CartService().clear();
    CartService().add(product, quantity: 2);

    // Provide routes so PayPage can navigate to '/' (home) as implemented.
    await tester.pumpWidget(
      MaterialApp(
        initialRoute: '/pay',
        routes: {
          '/': (ctx) => const Scaffold(body: Center(child: Text('Home'))),
          '/pay': (ctx) => const PayPage(),
        },
      ),
    );

    await tester.pumpAndSettle();

    // PayPage should show contact input and the order summary containing our product
    expect(find.byKey(const ValueKey('pay-contact')), findsOneWidget);
    expect(find.text('Pay Product'), findsOneWidget);

    // Press Pay button
    await tester.tap(find.byKey(const ValueKey('pay-button')));
    await tester.pumpAndSettle();

    // After pressing Pay, app should navigate to home
    expect(find.text('Home'), findsOneWidget);

    // And the cart should be cleared
    expect(CartService().isEmpty, isTrue);
  });
}
