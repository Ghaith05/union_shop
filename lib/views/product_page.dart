import 'package:flutter/material.dart';
import 'package:union_shop/models/product.dart';

class ProductPage extends StatefulWidget {
  final Product product;
  const ProductPage({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  String? _selectedSize;
  String? _selectedColor;
  int? _selectedQty;
  int _selectedImageIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    // leave selections empty so the UI shows hint text by default
    _selectedQty = null;
    _pageController = PageController(initialPage: _selectedImageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    // Ensure we show at least 4 thumbnails by duplicating the first image when
    // the product has fewer than 4 images (matches requested UI).
    final images = <String>[];
    if (product.images.isNotEmpty) {
      images.addAll(product.images);
      while (images.length < 4) {
        images.add(images.first);
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // image carousel (page view) using local assets
            if (images.isNotEmpty)
              SizedBox(
                height: 260,
                child: Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (idx) =>
                            setState(() => _selectedImageIndex = idx),
                        itemCount: images.length,
                        itemBuilder: (context, i) => Image.asset(
                          images[i],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (_, __, ___) =>
                              Container(color: Colors.grey[300]),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 56,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        itemCount: images.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (ctx, i) {
                          final img = images[i];
                          final selected = i == _selectedImageIndex;
                          return GestureDetector(
                            onTap: () {
                              _pageController.animateToPage(i,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeInOut);
                              setState(() => _selectedImageIndex = i);
                            },
                            child: Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: selected
                                        ? Colors.black
                                        : Colors.transparent,
                                    width: 2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Image.asset(img,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      Container(color: Colors.grey[300])),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(height: 240, color: Colors.grey[300]),

            const SizedBox(height: 12),
            Text(product.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            // Show sale price when applicable
            if (product.onSale && product.salePrice != null)
              Row(
                children: [
                  Text(
                    '£${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '£${product.salePrice!.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent),
                  ),
                ],
              )
            else
              Text('£${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(product.description),
            const SizedBox(height: 16),
            // Row with Size, Color, Quantity selectors
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedSize,
                    hint: const Text('Size'),
                    items: const [
                      DropdownMenuItem(value: 'S', child: Text('S')),
                      DropdownMenuItem(value: 'M', child: Text('M')),
                      DropdownMenuItem(value: 'L', child: Text('L')),
                    ],
                    onChanged: (v) => setState(() => _selectedSize = v),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedColor,
                    hint: const Text('Color'),
                    items: const [
                      DropdownMenuItem(value: 'Red', child: Text('Red')),
                      DropdownMenuItem(value: 'Blue', child: Text('Blue')),
                      DropdownMenuItem(value: 'Black', child: Text('Black')),
                    ],
                    onChanged: (v) => setState(() => _selectedColor = v),
                  ),
                ),
                const SizedBox(width: 8),
                // Quantity selector (1..10)
                Expanded(
                  child: DropdownButton<int>(
                    isExpanded: true,
                    value: _selectedQty,
                    hint: const Text('Qty'),
                    items: List<DropdownMenuItem<int>>.generate(
                      10,
                      (index) => DropdownMenuItem(
                        value: index + 1,
                        child: Text('${index + 1}'),
                      ),
                    ),
                    onChanged: (v) => setState(() => _selectedQty = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Full-width Add to cart button (UI only)
            const SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: null,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('Add to cart', style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: null,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('Buy with shop', style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Share button at the bottom of the page (non-functional)
            const Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(onPressed: null, child: Text('Share')),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
