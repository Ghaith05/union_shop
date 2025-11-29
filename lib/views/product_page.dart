import 'package:flutter/material.dart';
import 'package:union_shop/models/product.dart';

class ProductPage extends StatelessWidget {
  final Product product;
  const ProductPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // image carousel (page view) using local assets
            if (product.images.isNotEmpty)
              SizedBox(
                height: 240,
                child: PageView.builder(
                  itemCount: product.images.length,
                  itemBuilder: (context, i) => Image.asset(
                    product.images[i],
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: Colors.grey[300]),
                  ),
                ),
              )
            else
              Container(height: 240, color: Colors.grey[300]),

            const SizedBox(height: 12),
            Text(product.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(product.description),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}