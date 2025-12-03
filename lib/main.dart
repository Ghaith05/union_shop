import 'package:flutter/material.dart';
import 'package:union_shop/views/about_page.dart';
import 'package:union_shop/views/print_shack_about.dart';
import 'package:union_shop/views/collections_page.dart';
import 'package:union_shop/views/authentication_page.dart';
import 'package:union_shop/views/account_dashboard.dart';
import 'package:union_shop/widgets/navbar.dart';
import 'package:union_shop/views/cart_page.dart';
import 'package:union_shop/views/print_shack.dart';

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
        PrintShackAboutPage.routeName: (context) => const PrintShackAboutPage(),
        PrintShackPage.routeName: (context) => const PrintShackPage(),
        '/auth': (context) => const AuthenticationPage(),
        AccountDashboard.routeName: (context) => const AccountDashboard(),
        CollectionsPage.routeName: (context) => const CollectionsPage(),
        CartPage.routeName: (context) => const CartPage(),
      },
    );
  }
}
