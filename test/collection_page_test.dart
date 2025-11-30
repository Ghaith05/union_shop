import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/data/sample_data.dart';
import 'package:union_shop/views/collection_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpCollectionPage(
      WidgetTester tester, String collectionId) async {
    final collection =
        sampleCollections.firstWhere((c) => c.id == collectionId);
    await tester.pumpWidget(
      MaterialApp(home: CollectionPage(collection: collection)),
    );
    // Wait for async product fetch and frames to settle
    await tester.pumpAndSettle();
  }

  testWidgets('New Arrivals Accessories filter shows Sticker Pack',
      (tester) async {
    await pumpCollectionPage(tester, 'c1');

    // Open filter dropdown
    await tester.tap(find.byKey(const ValueKey('collection-filter-dropdown')));
    await tester.pumpAndSettle();

    // Select 'Accessories'
    await tester.tap(find.text('Accessories').last);
    await tester.pumpAndSettle();

    // Expect Sticker Pack to be visible
    expect(find.text('Sticker Pack'), findsOneWidget);
  });

  testWidgets(
      'Sale Accessories filter shows A5 Notebook and not Joggers under Accessories',
      (tester) async {
    await pumpCollectionPage(tester, 'c3');

    // Open filter dropdown
    await tester.tap(find.byKey(const ValueKey('collection-filter-dropdown')));
    await tester.pumpAndSettle();

    // Select 'Accessories'
    await tester.tap(find.text('Accessories').last);
    await tester.pumpAndSettle();

    // Expect A5 Notebook present
    expect(find.text('A5 Notebook'), findsOneWidget);
    // Union Joggers should not be in Accessories (they are Clothing)
    expect(find.text('Union Joggers'), findsNothing);
  });

  testWidgets('New Arrivals Clothing filter shows Union T-Shirt',
      (tester) async {
    await pumpCollectionPage(tester, 'c1');

    // Open filter dropdown
    await tester.tap(find.byKey(const ValueKey('collection-filter-dropdown')));
    await tester.pumpAndSettle();

    // Select 'Clothing'
    await tester.tap(find.text('Clothing').last);
    await tester.pumpAndSettle();

    // Expect Union T-Shirt to be visible
    expect(find.text('Union T-Shirt'), findsOneWidget);
  });

  testWidgets(
      'Best Sellers Clothing filter shows Union Hoodie and Accessories shows none',
      (tester) async {
    await pumpCollectionPage(tester, 'c2');

    // Open filter dropdown and select Clothing
    await tester.tap(find.byKey(const ValueKey('collection-filter-dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Clothing').last);
    await tester.pumpAndSettle();
    expect(find.text('Union Hoodie'), findsOneWidget);

    // Now select Accessories - should be none
    await tester.tap(find.byKey(const ValueKey('collection-filter-dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Accessories').last);
    await tester.pumpAndSettle();
    expect(find.text('Union Hoodie'), findsNothing);
    // Expect the "No products" message
    expect(find.text('No products in this collection.'), findsOneWidget);
  });
}
