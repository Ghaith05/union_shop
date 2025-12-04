import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:union_shop/data/auth_service.dart';
import 'package:union_shop/data/cart.dart';
import 'package:union_shop/firebase_options.dart';
import 'package:union_shop/views/about_page.dart';
import 'package:union_shop/views/print_shack_about.dart';
import 'package:union_shop/views/collections_page.dart';
import 'package:union_shop/views/authentication_page.dart';
import 'package:union_shop/views/account_dashboard.dart';
import 'package:union_shop/widgets/navbar.dart';
import 'package:union_shop/views/cart_page.dart';
import 'package:union_shop/views/print_shack.dart';
import 'package:union_shop/views/pay_page.dart';
import 'package:union_shop/views/search_results_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Enable syncing to server now that Firebase has been initialized.
    CartService.serverSyncEnabled = true;
  } catch (e) {
    // initialization may already have been done or failed; log for debugging
    // but continue so the app can still run in offline/dev fallback mode.
    // ignore: avoid_print
    print('Firebase.initializeApp() warning: $e');
  }
  // Load persisted cart, then initialize authentication service and wire Firebase auth state.
  await CartService().loadFromPrefs();
  await AuthenticationService().init();
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
        PayPage.routeName: (context) => const PayPage(),
        SearchResultsPage.routeName: (context) => const SearchResultsPage(),
      },
    );
  }
}
