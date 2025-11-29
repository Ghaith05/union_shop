import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/collection_page.dart';
import 'package:union_shop/data/sample_data.dart';

void main() {
  testWidgets('CollectionDetailPage shows products for a collection',
      (WidgetTester tester) async {
    final collection = sampleCollections.first;

    await tester.pumpWidget(
      MaterialApp(
        home: CollectionPage(collection: collection),
      ),
    );

    // Expect the app bar title
    expect(find.text(collection.name), findsOneWidget);

    // Expect products from sampleProducts for this collection to be shown
    final products =
        sampleProducts.where((p) => p.collectionId == collection.id).toList();
    for (final p in products) {
      expect(find.text(p.title), findsOneWidget);
      expect(find.text('£${p.price.toStringAsFixed(2)}'), findsOneWidget);
    }
  });
}
