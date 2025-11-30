import 'package:flutter/material.dart';
import 'package:union_shop/widgets/product_card.dart';
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
          // Sale banner (tappable) - opens the Sale collection
          Builder(
            builder: (context) {
              final saleCollection = sampleCollections.firstWhere(
                (c) => c.name.toLowerCase() == 'sale' || c.id == 'c3',
                orElse: () => sampleCollections.first,
              );
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: GestureDetector(
                  key: const Key('sale-collection-card'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) =>
                            CollectionPage(collection: saleCollection),
                      ),
                    );
                  },
                  child: Card(
                    clipBehavior: Clip.hardEdge,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: SizedBox(
                      height: 140,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            saleCollection.image.isNotEmpty
                                ? saleCollection.image.first
                                : 'assets/images/collections/Sale.png',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                Container(color: Colors.grey[300]),
                          ),
                          // ignore: deprecated_member_use
                          Container(color: Colors.black.withOpacity(0.35)),
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  saleCollection.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text('Up to 50% off — shop sale items',
                                    style: TextStyle(color: Colors.white70)),
                              ],
                            ),
                          ),
                          Positioned(
                            left: 8,
                            top: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text('SALE',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Categories
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Categories',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                SizedBox(
                  height: 120,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 6,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, i) {
                      return InkWell(
                        onTap: placeholderCallbackForButtons,
                        child: Container(
                          width: 110,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 56,
                                width: 56,
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(6)),
                                child: const Icon(Icons.category,
                                    color: Colors.grey),
                              ),
                              const SizedBox(height: 8),
                              Text('Category ${i + 1}',
                                  style: const TextStyle(fontSize: 13)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

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
                  children: List.generate(4, (i) {
                    return Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey[200]!),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: ProductCard(
                        title: 'Product ${i + 1}',
                        price: '£12.00',
                        imageUrl:
                            'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282',
                      ),
                    );
                  }),
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
