import 'package:flutter/material.dart';
import 'package:union_shop/product_page.dart';
import 'package:union_shop/widgets/product_card.dart';

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
      // By default, the app starts at the '/' route, which is the HomeScreen
      initialRoute: '/',
      // When navigating to '/product', build and return the ProductPage
      // In your browser, try this link: http://localhost:49856/#/product
      routes: {'/product': (context) => const ProductPage()},
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void navigateToProduct(BuildContext context) {
    Navigator.pushNamed(context, '/product');
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
                    icon:
                        const Icon(Icons.search, color: Colors.grey, size: 20),
                    onPressed: placeholderCallbackForButtons,
                  ),
                  IconButton(
                    icon: const Icon(Icons.person_outline,
                        color: Colors.grey, size: 20),
                    onPressed: placeholderCallbackForButtons,
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
                    return GestureDetector(
                      onTap: () => navigateToProduct(context),
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.grey[200]!),
                            borderRadius: BorderRadius.circular(6)),
                        child: Row(
                          children: [
                            AspectRatio(
                              aspectRatio: 1,
                              child: Image.network(
                                'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282',
                                fit: BoxFit.cover,
                                errorBuilder: (c, e, s) =>
                                    Container(color: Colors.grey[200]),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Product ${i + 1}',
                                      style: const TextStyle(fontSize: 14)),
                                  const SizedBox(height: 6),
                                  const Text('£12.00',
                                      style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Footer
          Container(
            width: double.infinity,
            color: Colors.grey[50],
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              children: [
                const Text('Union Shop',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: placeholderCallbackForButtons,
                        child: const Text('Help')),
                    TextButton(
                        onPressed: placeholderCallbackForButtons,
                        child: const Text('Terms')),
                    TextButton(
                        onPressed: placeholderCallbackForButtons,
                        child: const Text('Contact')),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('© University Union — All rights reserved',
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ProductCard extracted to lib/widgets/product_card.dart
