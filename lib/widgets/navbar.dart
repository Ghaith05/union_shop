import 'package:flutter/material.dart';
import 'package:union_shop/views/product_page.dart';
import 'package:union_shop/views/collection_page.dart';
import 'package:union_shop/views/collections_page.dart';
import 'package:union_shop/data/sample_data.dart';
import 'package:union_shop/widgets/footer.dart';
import 'package:union_shop/data/cart.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void navigateToProduct(BuildContext context) {
    // Open the collections page (browse) instead of a product that requires an argument
    Navigator.pushNamed(context, CollectionsPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        titleSpacing: 0,
        title: Builder(builder: (context) {
          final width = MediaQuery.of(context).size.width;
          final isDesktop = width >= 720; // adjust breakpoint as needed
          return Row(
            children: [
              GestureDetector(
                onTap: () => navigateToHome(context),
                child: Image.network(
                  'https://shop.upsu.net/cdn/shop/files/upsu_300x300.png?v=1614735854',
                  height: 28,
                  errorBuilder: (c, e, s) => const SizedBox(
                    height: 28,
                    child: Icon(Icons.image_not_supported, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              if (isDesktop) ...[
                TextButton(
                  key: const ValueKey('nav-home'),
                  onPressed: () => navigateToHome(context),
                  child:
                      const Text('Home', style: TextStyle(color: Colors.black)),
                ),
                const SizedBox(width: 8),
                TextButton(
                  key: const ValueKey('nav-collections'),
                  onPressed: () => navigateToProduct(context),
                  child:
                      const Text('Shop', style: TextStyle(color: Colors.black)),
                ),
                const SizedBox(width: 8),
                // Print Shack dropdown (desktop)
                PopupMenuButton<int>(
                  key: const ValueKey('nav-print'),
                  onSelected: (v) {
                    if (v == 1) Navigator.pushNamed(context, '/print-about');
                    if (v == 2) Navigator.pushNamed(context, '/print');
                  },
                  itemBuilder: (ctx) => const [
                    PopupMenuItem<int>(value: 1, child: Text('About')),
                    PopupMenuItem<int>(
                        value: 2, child: Text('Personalisation')),
                  ],
                  child: const Row(
                    children: [
                      Text(
                        'The Print Shack',
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                      Icon(Icons.arrow_drop_down, color: Colors.black),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  key: const ValueKey('nav-sale'),
                  onPressed: () {
                    // Navigate directly to the Sale collection page (collection id 'c3')
                    final saleCollection =
                        sampleCollections.firstWhere((c) => c.id == 'c3');
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (ctx) =>
                              CollectionPage(collection: saleCollection)),
                    );
                  },
                  child:
                      const Text('Sale', style: TextStyle(color: Colors.black)),
                ),
                const SizedBox(width: 8),
                TextButton(
                  key: const ValueKey('nav-about'),
                  onPressed: () {
                    Navigator.pushNamed(context, '/about');
                  },
                  child: const Text('About Us',
                      style: TextStyle(color: Colors.black)),
                ),
                const Spacer(),
                // Account icon (navigates to authentication)
                IconButton(
                  key: const ValueKey('nav-auth'),
                  icon: const Icon(Icons.person_outline, color: Colors.black),
                  tooltip: 'Account',
                  onPressed: () {
                    Navigator.pushNamed(context, '/auth');
                  },
                ),
                // Cart icon with badge (uses CartService ValueNotifier)
                ValueListenableBuilder<List<CartItem>>(
                  valueListenable: CartService().items,
                  builder: (context, items, _) {
                    final count =
                        items.fold<int>(0, (sum, it) => sum + it.quantity);
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          key: const ValueKey('nav-cart'),
                          icon: const Icon(Icons.shopping_bag_outlined,
                              color: Colors.black),
                          tooltip: 'Cart',
                          onPressed: () {
                            Navigator.pushNamed(context, '/cart');
                          },
                        ),
                        if (count > 0)
                          Positioned(
                            right: 4,
                            top: 6,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                  minWidth: 18, minHeight: 18),
                              child: Text(
                                '$count',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 11),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ] else ...[
                const Spacer(),
                PopupMenuButton<int>(
                  key: const ValueKey('nav-print'),
                  icon: const Icon(Icons.menu, color: Colors.grey, size: 20),
                  onSelected: (v) {
                    if (v == 1) Navigator.pushNamed(context, '/print-about');
                    if (v == 2) Navigator.pushNamed(context, '/print');
                  },
                  itemBuilder: (ctx) => const [
                    PopupMenuItem<int>(value: 1, child: Text('About')),
                    PopupMenuItem<int>(
                        value: 2, child: Text('Personalisation')),
                  ],
                ),
              ]
            ],
          );
        }),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                key: const ValueKey('drawer-home'),
                title: const Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                  navigateToHome(context);
                },
              ),
              ListTile(
                key: const ValueKey('drawer-collections'),
                title: const Text('Shop'),
                onTap: () {
                  Navigator.pop(context);
                  navigateToProduct(context);
                },
              ),
              ListTile(
                key: const ValueKey('drawer-sale'),
                title: const Text('Sale'),
                onTap: () {
                  Navigator.pop(context);
                  // Open the Sale collection directly (collection id 'c3')
                  final saleCollection =
                      sampleCollections.firstWhere((c) => c.id == 'c3');
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (ctx) =>
                            CollectionPage(collection: saleCollection)),
                  );
                },
              ),
              ListTile(
                key: const ValueKey('drawer-about'),
                title: const Text('About'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/about');
                },
              ),
              ListTile(
                key: const ValueKey('drawer-print'),
                title: const Text('Print Shack'),
                onTap: () {
                  Navigator.pop(context);
                  showDialog<void>(
                    context: context,
                    builder: (ctx) => SimpleDialog(
                      title: const Text('The Print Shack'),
                      children: [
                        SimpleDialogOption(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            Navigator.pushNamed(context, '/print-about');
                          },
                          child: const Text('About'),
                        ),
                        SimpleDialogOption(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            Navigator.pushNamed(context, '/print');
                          },
                          child: const Text('Personalisation'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const Divider(),
            ],
          ),
        ),
      ),
      body: ListView(
        children: [
          // Hero
          SizedBox(
            height: 300,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  'https://shop.upsu.net/cdn/shop/files/PortsmouthCityPostcard2_1024x1024@2x.jpg?v=1752232561',
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(color: Colors.grey[300]),
                ),
                // ignore: deprecated_member_use
                Container(color: Colors.black.withOpacity(0.45)),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Union Shop',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Official union merch and campus essentials.',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => navigateToProduct(context),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4d2963)),
                          child: const Text('Browse Products'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Featured
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Column(
              children: [
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Featured',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600))),
                const SizedBox(height: 12),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: width > 600 ? 2 : 1,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 3 / 1.2,
                  children: [
                    // Featured products (ordered): hoodie, t-shirt, jogger, notebook
                    'p2', // Union Hoodie
                    'p1', // Union T-Shirt
                    'p5', // Union Joggers
                    'p4', // A5 Notebook
                  ].map((id) {
                    final p = sampleProducts.firstWhere((s) => s.id == id);
                    return Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey[200]!),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => ProductPage(product: p),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: p.images.isNotEmpty
                                  ? Image.asset(
                                      p.images.first,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        color: Colors.grey[300],
                                        child: const Center(
                                          child: Icon(Icons.image_not_supported,
                                              color: Colors.grey),
                                        ),
                                      ),
                                    )
                                  : Container(color: Colors.grey[300]),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p.title,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black),
                                    maxLines: 2,
                                  ),
                                  const SizedBox(height: 4),
                                  // Show sale price when applicable
                                  p.onSale && p.salePrice != null
                                      ? Row(
                                          children: [
                                            Text(
                                              '£${p.price.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                color: Colors.grey,
                                                fontSize: 13,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              '£${p.salePrice!.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.redAccent,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        )
                                      : Text(
                                          '£${p.price.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                              fontSize: 13, color: Colors.grey),
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Footer
          SiteFooter(
            onAbout: () => Navigator.pushNamed(context, '/about'),
            onHelp: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Help page not implemented'))),
            onTerms: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Terms page not implemented'))),
            onContact: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Contact page not implemented'))),
          ),
          const SizedBox(height: 8),
          const Text('© University Union — All rights reserved',
              style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}
