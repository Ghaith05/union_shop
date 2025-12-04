import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/services/search_service.dart';

void main() {
  final svc = SearchService();

  test('search finds product by title', () {
    final results = svc.search('hoodie');
    expect(results.isNotEmpty, isTrue);
    expect(
        results.any((p) => p.title.toLowerCase().contains('hoodie')), isTrue);
  });

  test('search finds by category', () {
    final results = svc.search('accessories');
    expect(results.isNotEmpty, isTrue);
    expect(
        results.every((p) =>
            (p.category ?? '').toLowerCase().contains('accessories') ||
            p.title.toLowerCase().contains('sticker')),
        isTrue);
  });

  test('empty query returns empty list', () {
    final results = svc.search('   ');
    expect(results, isEmpty);
  });
}
