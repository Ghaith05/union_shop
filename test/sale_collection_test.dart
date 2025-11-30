import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/collections_page.dart';
import 'package:union_shop/data/sample_data.dart';

void main() {
  testWidgets('Sale collection card exists and sale products show sale prices',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CollectionsPage()));

    // The Sale collection card should be present (id c3)
    expect(find.byKey(const ValueKey('collection-card-c3')), findsOneWidget);

    // Open the Sale collection
    await tester.tap(find.byKey(const ValueKey('collection-card-c3')));
    await tester.pumpAndSettle();

    // The collection page title should show 'Sale' (sampleCollections contains c3 named Sale)
    expect(find.text('Sale'), findsWidgets);

    // There should be two products in the sale collection (p4 and p5)
    expect(find.byKey(const Key('collection-c3-product-0')), findsOneWidget);
    expect(find.byKey(const Key('collection-c3-product-1')), findsOneWidget);

    // Assert sale-price rendering for product 0 (A5 Notebook)
    // Original price 6.99 should be present and sale price 4.99 should be present
    expect(find.text('£6.99'), findsOneWidget);
    expect(find.text('£4.99'), findsOneWidget);

    // Assert sale-price rendering for product 1 (Union Joggers)
    expect(find.text('£49.99'), findsOneWidget);
    expect(find.text('£29.99'), findsOneWidget);

    // Tap the first product to open ProductPage
    await tester.tap(find.byKey(const Key('collection-c3-product-0')));
    await tester.pumpAndSettle();

    // After navigation, the ProductPage should show the product title from sample data
    final p0 = sampleProducts.firstWhere((p) => p.id == 'p4');
    // title may appear in AppBar and body — assert at least one match
    expect(find.text(p0.title), findsWidgets);
  });
}
