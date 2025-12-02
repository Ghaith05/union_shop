import 'package:flutter/material.dart';
import 'package:union_shop/widgets/navbar.dart';
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
  int _pageSize = 4;
  // Note: product categories are now stored on the Product model (`category`).
  // Any previous view-level category mappings were removed in favor of
  // data-driven filtering.

  @override
  void initState() {
    super.initState();
    // Seed synchronously so tests that don't call pumpAndSettle see content.
    _products = sampleProducts
        .where((p) => p.collectionId == widget.collection.id)
        .toList();
    // Compute global categories from the entire sample dataset so the
    // filter dropdown consistently offers the same choices across
    // collections (so a user can select 'Accessories' even if the
    // current collection has no accessories).
    final categories = sampleProducts
        .map((p) => p.category)
        .where((c) => c != null && c.trim().isNotEmpty)
        .map((c) => c!.trim())
        .toSet()
        .toList()
      ..sort();
    _filterOptions = ['All products', ...categories];
    _selectedFilter = 'All products';
    _selectedSort = 'Featured';
    _loading = false;

    // Also fetch asynchronously to mimic a real service and refresh state.
    fetchProductsForCollection(widget.collection.id).then((list) {
      setState(() {
        _products = list;
      });
    }).catchError((e) {
      setState(() {
        _error = e.toString();
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
        child:
            const Icon(Icons.image_not_supported, size: 28, color: Colors.grey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: buildAppBar(context, titleWidget: Text(widget.collection.name)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Scaffold(
        appBar: buildAppBar(context, titleWidget: Text(widget.collection.name)),
        body: Center(child: Text('Error loading products: $_error')),
      );
    }
    // Apply filter using lightweight mapping; allow product-level overrides so
    // that a product (e.g. Sticker Pack) can be shown under Accessories even
    // if its collection is classified differently.
    // Show only products that belong to this collection, then apply selected category filter
    // --- pipeline: filter -> sort -> paginate/load-more ---
    // 1) Start from products that belong to this collection
    final base =
        _products.where((p) => p.collectionId == widget.collection.id).toList();

    // 2) Apply category filter (data-driven)
    final filtered = _selectedFilter == 'All products'
        ? base
        : base
            .where((p) =>
                (p.category ?? '').toLowerCase() ==
                _selectedFilter.toLowerCase())
            .toList();

    // 3) Apply sort
    if (_selectedSort == 'Price ↑') {
      filtered.sort((a, b) => a.price.compareTo(b.price));
    } else if (_selectedSort == 'Price ↓') {
      filtered.sort((a, b) => b.price.compareTo(a.price));
    } // otherwise keep original (Featured)

    // 4) Pagination calculations (pageSize computed from options)
    // Page size options for collection detail: 1, 2, or 4 items per page
    const pageSizeOptions = [1, 2, 4];
    final int pageSize =
        pageSizeOptions.contains(_pageSize) ? _pageSize : pageSizeOptions.first;
    final totalPages = (filtered.length / pageSize).ceil().clamp(1, 999);
    final clampedPageIndex = _pageIndex.clamp(0, totalPages - 1);
    final start = clampedPageIndex * pageSize;

    // 5) Build visibleProducts (page-by-page pagination only)
    final visibleProducts = filtered.skip(start).take(pageSize).toList();

    return Scaffold(
      appBar: buildAppBar(context, titleWidget: Text(widget.collection.name)),
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
                    const Text('FILTER BY',
                        style: TextStyle(letterSpacing: 1.2, fontSize: 12)),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      key: const ValueKey('collection-filter-dropdown'),
                      value: _selectedFilter,
                      items: _filterOptions
                          .map(
                              (o) => DropdownMenuItem(value: o, child: Text(o)))
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
                    const Text('SORT BY',
                        style: TextStyle(letterSpacing: 1.2, fontSize: 12)),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      key: const ValueKey('collection-sort-dropdown'),
                      value: _selectedSort,
                      items: const [
                        DropdownMenuItem(
                            value: 'Featured', child: Text('Featured')),
                        DropdownMenuItem(
                            value: 'Price ↑', child: Text('Price ↑')),
                        DropdownMenuItem(
                            value: 'Price ↓', child: Text('Price ↓')),
                      ],
                      onChanged: (v) {
                        if (v == null) return;
                        setState(() {
                          _selectedSort = v;
                          _pageIndex =
                              0; // reset page to first when sort changes
                        });
                      },
                    ),
                  ]),
                  ConstrainedBox(
                    constraints: BoxConstraints(minWidth: isWide ? 120 : 0),
                    child: Align(
                      alignment:
                          isWide ? Alignment.centerRight : Alignment.centerLeft,
                      child: Text('${filtered.length} products',
                          key: const ValueKey('collection-count')),
                    ),
                  ),
                ],
              );
            }),
          ),
          // product list
          Expanded(
            child: visibleProducts.isEmpty
                ? const Center(child: Text('No products in this collection.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: visibleProducts.length,
                    itemBuilder: (ctx, i) {
                      final Product p = visibleProducts[i];
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
          // --- pagination controls ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  ElevatedButton(
                    key: const ValueKey('collection-prev'),
                    onPressed: clampedPageIndex > 0
                        ? () {
                            setState(() {
                              _pageIndex = clampedPageIndex - 1;
                            });
                          }
                        : null,
                    child: const Text('Prev'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    key: const ValueKey('collection-next'),
                    onPressed: clampedPageIndex < totalPages - 1
                        ? () {
                            setState(() {
                              _pageIndex = clampedPageIndex + 1;
                            });
                          }
                        : null,
                    child: const Text('Next'),
                  ),
                ]),
                Row(children: [
                  Text('Page ${clampedPageIndex + 1} of $totalPages'),
                  const SizedBox(width: 12),
                  const Text('Page size:'),
                  const SizedBox(width: 8),
                  DropdownButton<int>(
                    key: const ValueKey('collection-page-size'),
                    value: pageSize,
                    items: pageSizeOptions
                        .map((v) =>
                            DropdownMenuItem(value: v, child: Text('$v')))
                        .toList(),
                    onChanged: (v) {
                      if (v == null) return;
                      setState(() {
                        _pageSize = v;
                        _pageIndex = 0; // reset when changing page size
                      });
                    },
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
