import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/collections_page.dart';
import 'package:union_shop/data/sample_data.dart';
// replaced CollectionDetailPage usage with push-based navigation; no direct import needed

void main() {
  testWidgets('Collections page renders and navigates to detail',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: CollectionsPage()),
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

  testWidgets('sort toggles ordering of displayed collections', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: CollectionsPage()));
    await tester.pumpAndSettle();

    // Ensure all collections are visible by selecting a sufficiently large page size
    await tester.tap(find.byKey(const ValueKey('collections-page-size')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('8').last);
    await tester.pumpAndSettle();

    // Ascending sort expected by default
    final asc = List<CollectionItem>.from(sampleCollections)
      ..sort((a, b) => a.name.compareTo(b.name));

    final firstName = asc.first.name;
    final lastName = asc.last.name;

    // The first name should appear above the last name in the layout
    final firstPos = tester.getTopLeft(find.text(firstName));
    final lastPos = tester.getTopLeft(find.text(lastName));
    expect(firstPos.dy < lastPos.dy, isTrue);

    // Change sort to descending
    await tester.tap(find.byKey(const ValueKey('collections-sort')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Name ↓').last);
    await tester.pumpAndSettle();

    // Positions should be reversed
    final firstPosAfter = tester.getTopLeft(find.text(firstName));
    final lastPosAfter = tester.getTopLeft(find.text(lastName));
    expect(firstPosAfter.dy > lastPosAfter.dy, isTrue);
  });

  testWidgets('pagination next and prev update page indicator', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: CollectionsPage()));
    await tester.pumpAndSettle();

    // Change page size to 2 so there are multiple pages
    await tester.tap(find.byKey(const ValueKey('collections-page-size')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('2').last);
    await tester.pumpAndSettle();

    // Should start on page 1
    expect(find.textContaining('Page 1 of'), findsOneWidget);

    // Navigate to next page
    await tester.tap(find.byKey(const ValueKey('collections-next')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Page 2 of'), findsOneWidget);

    // Navigate back
    await tester.tap(find.byKey(const ValueKey('collections-prev')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Page 1 of'), findsOneWidget);
  });

   testWidgets('filtering updates visible collections', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: CollectionsPage()));
    await tester.pumpAndSettle();

    // Use a substring of the first collection's name to filter
    final targetName = sampleCollections.first.name;
    final query = targetName.split(' ').first;

    // Type into the search field
    await tester.enterText(find.byKey(const ValueKey('collections-filter')), query);
    await tester.pumpAndSettle();

    // Expect the target collection to be visible
    expect(find.text(targetName), findsWidgets);

    // Pick a collection that does not contain the query and ensure it's hidden
    final nonMatch = sampleCollections.firstWhere((c) => !c.name.toLowerCase().contains(query.toLowerCase()), orElse: () => sampleCollections.first);
    if (nonMatch.name != targetName) {
      expect(find.text(nonMatch.name), findsNothing);
    }
  });
}
