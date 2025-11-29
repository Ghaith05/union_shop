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

            // Row with Size, Color, Quantity selectors (non-functional)
          Row(
            children: [
              Expanded(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: null,
                  hint: const Text('Size'),
                  items: const [
                    DropdownMenuItem(value: 'S', child: Text('S')),
                    DropdownMenuItem(value: 'M', child: Text('M')),
                    DropdownMenuItem(value: 'L', child: Text('L')),
                  ],
                  onChanged: (_) {}, // placeholder
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: null,
                  hint: const Text('Color'),
                  items: const [
                    DropdownMenuItem(value: 'Red', child: Text('Red')),
                    DropdownMenuItem(value: 'Blue', child: Text('Blue')),
                    DropdownMenuItem(value: 'Black', child: Text('Black')),
                  ],
                  onChanged: (_) {}, // placeholder
                ),
              ),
              const SizedBox(width: 8),
              // Quantity selector (1..10)
              Expanded(
                child: DropdownButton<int>(
                  isExpanded: true,
                  value: null,
                  hint: const Text('Qty'),
                  items: List<DropdownMenuItem<int>>.generate(
                    10,
                    (index) => DropdownMenuItem(
                      value: index + 1,
                      child: Text('${index + 1}'),
                    ),
                  ),
                  onChanged: (_) {}, // placeholder
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Full-width Add to cart button (non-functional)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {}, // placeholder - add-to-cart implementation is out of scope
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('Add to cart', style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Share button lower (non-functional)
            Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton(onPressed: () {}, child: const Text('Share')),
            ),
          const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}