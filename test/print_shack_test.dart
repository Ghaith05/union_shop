import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/print_shack.dart';
import 'package:union_shop/data/cart.dart';

void main() {
  setUp(() {
    CartService().clear();
  });

  testWidgets('Per Line dropdown shows second field and updates price',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PrintShackPage()));

    // Initially one line selected and price should be £3.00
    expect(find.text('£3.00'), findsOneWidget);
    expect(find.byKey(const ValueKey('print-line2')), findsNothing);

    // Open dropdown and select Two Lines
    await tester.tap(find.byKey(const ValueKey('print-lines')));
    await tester.pumpAndSettle();
    // Dropdown item text is 'Two Lines of Text' in the UI
    expect(find.text('Two Lines of Text'), findsOneWidget);
    await tester.tap(find.text('Two Lines of Text').first);
    await tester.pumpAndSettle();

    // Now line 2 should appear and price should be £5.00
    expect(find.byKey(const ValueKey('print-line2')), findsOneWidget);
    expect(find.text('£5.00'), findsOneWidget);
  });

  testWidgets('Add to cart adds personalised product to CartService',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PrintShackPage()));

    // Enter text for line 1
    await tester.enterText(find.byKey(const ValueKey('print-line1')), 'HELLO');

    // Select Two Lines and enter second line
    await tester.tap(find.byKey(const ValueKey('print-lines')));
    await tester.pumpAndSettle();
    expect(find.text('Two Lines of Text'), findsOneWidget);
    await tester.tap(find.text('Two Lines of Text').first);
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('print-line2')), 'WORLD');

    // Set quantity to 2
    // Ensure the quantity dropdown is visible (page may need scrolling), then open it
    await tester.ensureVisible(find.byKey(const ValueKey('print-qty')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('print-qty')));
    await tester.pumpAndSettle();
    expect(find.text('2'), findsWidgets);
    await tester.tap(find.text('2').first);
    await tester.pumpAndSettle();

    // Tap Add to cart
    await tester.tap(find.byKey(const ValueKey('print-add-to-cart')));
    await tester.pumpAndSettle();

    final items = CartService().items.value;
    expect(items.length, 1);
    expect(items.first.quantity, 2);
    expect(items.first.product.description, contains('HELLO'));
    expect(items.first.product.description, contains('WORLD'));

    // SnackBar confirmation
    expect(find.byType(SnackBar), findsOneWidget);
  });
}
