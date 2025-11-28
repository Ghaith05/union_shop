import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/product.dart';

void main() {
  test('Product.sample creates product with defaults', () {
    final p = Product.sample(id: 'x', title: 'T', collectionId: 'c');
    expect(p.id, 'x');
    expect(p.title, 'T');
    expect(p.collectionId, 'c');
    expect(p.images, isNotNull);
  });
}
