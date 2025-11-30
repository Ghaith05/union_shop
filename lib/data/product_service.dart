import 'dart:async';
import 'package:union_shop/data/sample_data.dart';
import 'package:union_shop/models/product.dart';

Future<List<Product>> fetchProductsForCollection(String collectionId) async {
  // async wrapper around sample data
  return Future.value(sampleProducts.where((p) => p.collectionId == collectionId).toList());
}