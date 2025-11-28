import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/collections_page.dart';
import 'package:union_shop/data/sample_data.dart';

void main() {
  testWidgets('Collections page renders and navigates to detail',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        routes: {
          CollectionDetailPage.routeName: (ctx) {
            final args =
                ModalRoute.of(ctx)!.settings.arguments as CollectionItem;
            return CollectionDetailPage(collection: args);
          }
        },
        home: const CollectionsPage(),
      ),
    );

    // Verify collection cards exist
    for (final c in sampleCollections) {
      expect(find.byKey(ValueKey('collection-card-${c.id}')), findsOneWidget);
      expect(find.text(c.name), findsWidgets);
    }

    // Tap first and verify navigation
    final first = sampleCollections.first;
    await tester.tap(find.byKey(ValueKey('collection-card-${first.id}')));
    await tester.pumpAndSettle();

    expect(find.text(first.name), findsOneWidget);
  });
}
