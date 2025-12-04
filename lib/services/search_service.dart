import 'package:union_shop/models/product.dart';
import 'package:union_shop/data/sample_data.dart';

/// Simple local search service that searches the in-memory sampleProducts
/// list. Matches against title, description and category (case-insensitive).
class SearchService {
  /// Search products by [query]. Returns an empty list for empty queries.
  List<Product> search(String query, {int limit = 50}) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];

    final results = <Product>[];
    for (final p in sampleProducts) {
      final combined =
          '${p.title} ${p.description} ${p.category ?? ''}'.toLowerCase();
      if (combined.contains(q)) results.add(p);
      if (results.length >= limit) break;
    }
    return results;
  }
}
