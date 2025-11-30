import 'package:flutter/material.dart';
import 'package:union_shop/data/sample_data.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/views/product_page.dart';
import 'package:union_shop/data/product_service.dart';

class CollectionPage extends StatefulWidget {
  static const routeName = '/collection';
  final CollectionItem collection;

  const CollectionPage({Key? key, required this.collection}) : super(key: key);

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  List<Product> _products = [];
  bool _loading = true;
  String? _error;
  List<String> _filterOptions = ['All products'];
  String _selectedFilter = 'All products';
  String _selectedSort = 'Featured';
  int _pageIndex = 0;
  int _pageSize = 8;

  @override
  void initState() {
    super.initState();
    // lazy load products for this collection
    fetchProductsForCollection(widget.collection.id).then((list) {
      // Product model doesn't include categories in sample data.
      setState(() {
        _products = list;
        _filterOptions = ['All products', 'Clothing', 'Accessories'];
        _selectedFilter = 'All products';
        _selectedSort = 'Featured';
        _loading = false;
      });
    }).catchError((e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    });
  }

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
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.collection.name)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.collection.name)),
        body: Center(child: Text('Error loading products: $_error')),
      );
    }
    final products = _products;

    return Scaffold(
      appBar: AppBar(title: Text(widget.collection.name)),
      body: Column(
        children: [
          // --- collection top-bar (filter/sort) ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: LayoutBuilder(builder: (context, constraints) {
              final isWide = constraints.maxWidth > 800;
              return Wrap(
                spacing: 12,
                runSpacing: 8,
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    const Text('FILTER BY', style: TextStyle(letterSpacing: 1.2, fontSize: 12)),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      key: const ValueKey('collection-filter-dropdown'),
                      value: _selectedFilter,
                      items: _filterOptions
                          .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                          .toList(),
                      onChanged: (v) {
                        if (v == null) return;
                        setState(() {
                          _selectedFilter = v;
                          _pageIndex = 0;
                        });
                      },
                    ),
                  ]),
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    const Text('SORT BY', style: TextStyle(letterSpacing: 1.2, fontSize: 12)),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      key: const ValueKey('collection-sort-dropdown'),
                      value: 'Featured',
                      items: const [
                        DropdownMenuItem(
                            value: 'Featured', child: Text('Featured')),
                        DropdownMenuItem(
                            value: 'Price ↑', child: Text('Price ↑')),
                        DropdownMenuItem(
                            value: 'Price ↓', child: Text('Price ↓')),
                      ],
                      onChanged: (_) {}, // wire later
                    ),
                  ]),
                  ConstrainedBox(
                    constraints: BoxConstraints(minWidth: isWide ? 120 : 0),
                    child: Align(
                      alignment:
                          isWide ? Alignment.centerRight : Alignment.centerLeft,
                      child: Text('${_products.length} products',
                          key: const ValueKey('collection-count')),
                    ),
                  ),
                ],
              );
            }),
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
                          key: Key(
                              'collection-${widget.collection.id}-product-$i'),
                          leading: p.images.isNotEmpty
                              ? SizedBox(
                                  width: 64,
                                  height: 64,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      _buildImage(p.images.first),
                                      if (p.onSale)
                                        Positioned(
                                          left: 0,
                                          top: 0,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Colors.redAccent,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: const Text('SALE',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ),
                                    ],
                                  ),
                                )
                              : null,
                          title: Text(p.title),
                          subtitle: p.onSale && p.salePrice != null
                              ? Row(
                                  children: [
                                    Text(
                                      '£${p.price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: Colors.grey),
                                    ),
                                    const SizedBox(width: 8),
                                    Text('£${p.salePrice!.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                )
                              : Text('£${p.price.toStringAsFixed(2)}'),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (ctx) => ProductPage(product: p)),
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
