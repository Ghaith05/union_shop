import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/views/product_page.dart';
import 'package:union_shop/data/cart.dart';


void main() {
  setUp(() async {
    // Reset cart between tests
    CartService().clear();
  });

  testWidgets('Add to cart button is disabled until size, color, qty selected',
      (WidgetTester tester) async {
    final product =
        Product.sample(id: 'p1', title: 'Product 1', collectionId: 'c1');

    await tester.pumpWidget(MaterialApp(home: ProductPage(product: product)));
    await tester.pumpAndSettle();

    final addBtnFinder = find.widgetWithText(ElevatedButton, 'Add to cart');
    expect(addBtnFinder, findsOneWidget);

    final ElevatedButton addBtn = tester.widget(addBtnFinder);
    expect(addBtn.onPressed, isNull);

    // Select only size and verify still disabled
    await tester.tap(find.text('Size'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('M').last);
    await tester.pumpAndSettle();

    final ElevatedButton addBtn2 = tester.widget(addBtnFinder);
    expect(addBtn2.onPressed, isNull);
  });

  testWidgets('Selecting size, color and qty enables Add and adds item',
      (WidgetTester tester) async {
    final product =
        Product.sample(id: 'p2', title: 'Product 2', collectionId: 'c1');

    await tester.pumpWidget(MaterialApp(home: ProductPage(product: product)));
    await tester.pumpAndSettle();

    // Select Size
    await tester.tap(find.text('Size'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('M').last);
    await tester.pumpAndSettle();

    // Select Color
    await tester.tap(find.text('Color'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Red').last);
    await tester.pumpAndSettle();

    // Select Qty = 2
    await tester.tap(find.text('Qty'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('2').last);
    await tester.pumpAndSettle();

    final addBtnFinder = find.widgetWithText(ElevatedButton, 'Add to cart');
    final ElevatedButton addBtn = tester.widget(addBtnFinder);
    expect(addBtn.onPressed, isNotNull);

    await tester.tap(addBtnFinder);
    await tester.pumpAndSettle();

    // Cart should have one item with quantity 2
    expect(CartService().items.value.length, 1);
    expect(CartService().items.value.first.quantity, 2);
  });
}
