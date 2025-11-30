import 'package:flutter/material.dart';
import 'package:union_shop/views/product_page.dart';
import 'package:union_shop/views/about_page.dart';
import 'package:union_shop/views/collections_page.dart';
import 'package:union_shop/data/sample_data.dart';
import 'package:union_shop/views/collection_page.dart';
import 'package:union_shop/widgets/footer.dart';
import 'package:union_shop/views/authentication_page.dart';

void main() {
  runApp(const UnionShopApp());
}

class UnionShopApp extends StatelessWidget {
  const UnionShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Union Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4d2963)),
      ),
      home: const HomeScreen(),
      // Routes for navigation. Keep `home` as the default start screen.
      // When navigating to '/product' build ProductPage, and '/about' builds AboutPage.
// before: routes: { ... }
      routes: {
        // Keep About and Collections as simple.
        '/about': (context) => const AboutPage(),
        '/auth': (context) => const AuthenticationPage(),
        CollectionsPage.routeName: (context) => const CollectionsPage(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void navigateToProduct(BuildContext context) {
    // Open the collections page (browse) instead of a product that requires an argument
    Navigator.pushNamed(context, CollectionsPage.routeName);
  }

  void placeholderCallbackForButtons() {}

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        titleSpacing: 0,
        title: Row(
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
            const Spacer(),
            if (width > 360)
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.category,
                        color: Colors.grey, size: 20),
                    tooltip: 'Collections',
                    onPressed: () =>
                        Navigator.pushNamed(context, CollectionsPage.routeName),
                  ),
                  IconButton(
                    icon:
                        const Icon(Icons.search, color: Colors.grey, size: 20),
                    onPressed: placeholderCallbackForButtons,
                  ),
                  IconButton(
                    icon: const Icon(Icons.person_outline,
                        color: Colors.grey, size: 20),
                    onPressed: () => Navigator.pushNamed(context, '/auth'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.shopping_bag_outlined,
                        color: Colors.grey, size: 20),
                    onPressed: placeholderCallbackForButtons,
                  ),
                ],
              )
            else
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.grey, size: 20),
                onPressed: placeholderCallbackForButtons,
              ),
          ],
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
            onHelp: placeholderCallbackForButtons,
            onTerms: placeholderCallbackForButtons,
            onContact: placeholderCallbackForButtons,
          ),
          const SizedBox(height: 8),
          const Text('© University Union — All rights reserved',
              style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}
