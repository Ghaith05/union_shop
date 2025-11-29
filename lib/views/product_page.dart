import 'package:flutter/material.dart';
import 'package:union_shop/models/product.dart';

// Minimal ProductPage placeholder so '/product' route exists.
class ProductPage extends StatelessWidget {
  final Product product;
  const ProductPage({Key? key, required this.product}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product')),
      body: const Center(child: Text('Product detail / list placeholder')),
    );
  }
}
