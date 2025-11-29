import 'package:flutter/material.dart';
import 'package:union_shop/data/sample_data.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/views/product_page.dart';

class CollectionPage extends StatelessWidget {
  static const routeName = '/collection';
  final CollectionItem collection;

  const CollectionPage({Key? key, required this.collection}) : super(key: key);
Widget _buildImage(String src, {double? width, double? height}) {
  return Image.asset(
    src,
    width: width,
    height: height,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) => Container(
      width: width,
      height: height,
      color: Colors.grey.shade200,
      alignment: Alignment.center,
      child: const Icon(Icons.image_not_supported, size: 28, color: Colors.grey),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final products = sampleProducts.where((p) => p.collectionId == collection.id).toList();

    return Scaffold(
      appBar: AppBar(title: Text(collection.name)),
      body: Column(
        children: [
          // small non-functional filter row
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                DropdownButton<String>(
                  value: 'All',
                  items: const [
                    DropdownMenuItem(value: 'All', child: Text('All')),
                    DropdownMenuItem(value: 'Low', child: Text('Price: Low')),
                    DropdownMenuItem(value: 'High', child: Text('Price: High')),
                  ],
                  onChanged: (_) {}, // placeholder
                ),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: 'All',
                  items: const [
                    DropdownMenuItem(value: 'All', child: Text('All')),
                    DropdownMenuItem(value: 'Size', child: Text('Size')),
                    DropdownMenuItem(value: 'Color', child: Text('Color')),
                  ],
                  onChanged: (_) {},
                ),
              ],
            ),
          ),

          // product list
          Expanded(
            child: products.isEmpty
                ? const Center(child: Text('No products in this collection.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: products.length,
                    itemBuilder: (ctx, i) {
                      final Product p = products[i];
                      return Card(
                        child: ListTile(
                          key: Key('collection-${collection.id}-product-$i'),
                          leading: p.images.isNotEmpty
                              ? SizedBox(width: 64, height: 64, child: _buildImage(p.images.first))
                              : null,
                          title: Text(p.title),
                          subtitle: Text('£${p.price.toStringAsFixed(2)}'),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (ctx) => ProductPage(product: p)),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}