import 'package:flutter/foundation.dart';
import 'package:union_shop/models/product.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

class CartItem {
  final Product product;
  int quantity;
  final Map<String, String>? options;

  CartItem({required this.product, this.quantity = 1, this.options});

  double get unitPrice => (product.onSale && product.salePrice != null)
      ? product.salePrice!
      : product.price;

  double get totalPrice => unitPrice * quantity;

  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'quantity': quantity,
        'options': options,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        product:
            Product.fromJson(Map<String, dynamic>.from(json['product'] as Map)),
        quantity: (json['quantity'] as num).toInt(),
        options: json['options'] == null
            ? null
            : Map<String, String>.from(json['options'] as Map),
      );
}

class CartService {
  CartService._internal();
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;

  static const _prefsKey = 'union_shop_cart_v1';
  // Allow tests to disable server sync when running in unit tests.
  // Default to false to avoid trying to call Firebase from unit tests.
  static bool serverSyncEnabled = false;

  // Using ValueNotifier to avoid adding new dependencies — UI can use ValueListenableBuilder.
  final ValueNotifier<List<CartItem>> items = ValueNotifier<List<CartItem>>([]);

  static String _optionsKey(Map<String, String>? options) {
    if (options == null || options.isEmpty) return '';
    final entries = options.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return entries.map((e) => '${e.key}=${e.value}').join(',');
  }

  void add(Product product, {int quantity = 1, Map<String, String>? options}) {
    final normOptions = options ?? <String, String>{};
    final list = List<CartItem>.from(items.value);
    final idx = list.indexWhere((c) =>
        c.product.id == product.id &&
        mapEquals(c.options ?? <String, String>{}, normOptions));
    if (idx >= 0) {
      list[idx].quantity += quantity;
    } else {
      list.add(
          CartItem(product: product, quantity: quantity, options: options));
    }
    items.value = list;
    _save();
    // Try to push change to server in background if user is signed in.
    Future.microtask(() => _maybeSaveToServer());
  }

  void removeProduct(String productId, {Map<String, String>? options}) {
    final normOptions = options ?? <String, String>{};
    final list = List<CartItem>.from(items.value)
      ..removeWhere((c) =>
          c.product.id == productId &&
          mapEquals(c.options ?? <String, String>{}, normOptions));
    items.value = list;
    _save();
    Future.microtask(() => _maybeSaveToServer());
  }

  void updateQuantity(String productId, int quantity,
      {Map<String, String>? options}) {
    final normOptions = options ?? <String, String>{};
    final list = List<CartItem>.from(items.value);
    final idx = list.indexWhere((c) =>
        c.product.id == productId &&
        mapEquals(c.options ?? <String, String>{}, normOptions));
    if (idx >= 0) {
      if (quantity <= 0) {
        list.removeAt(idx);
      } else {
        list[idx].quantity = quantity;
      }
      items.value = list;
      _save();
      Future.microtask(() => _maybeSaveToServer());
    }
  }

  void clear() {
    items.value = [];
    _save();
    Future.microtask(() => _maybeSaveToServer());
  }

  double get total =>
      // ignore: avoid_types_as_parameter_names
      items.value.fold(0.0, (sum, item) => sum + item.totalPrice);

  bool get isEmpty => items.value.isEmpty;

  Future<void> loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_prefsKey);
      if (raw == null || raw.isEmpty) return;
      final decoded = jsonDecode(raw) as List<dynamic>;
      final loaded = decoded
          .map((e) => CartItem.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      items.value = loaded;
    } catch (_) {
      // Ignore errors during load; start with empty cart on failure.
    }
  }

  /// Alias used by higher-level callers to explicitly load the persisted cart.
  /// Kept separate to follow usage in other services (e.g. loadCart after login).
  Future<void> loadCart() async => loadFromPrefs();

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(items.value.map((c) => c.toJson()).toList());
      await prefs.setString(_prefsKey, encoded);
    } catch (_) {
      // Non-fatal: ignore save errors.
    }
  }

  /// Save the current cart to Firestore under `/users/{uid}/cart` as a simple
  /// document with an `items` array. Non-fatal — errors are ignored so local
  /// functionality still works when Firestore is unavailable.
  Future<void> saveToServer(String uid) async {
    try {
      if (kDebugMode) {
        // ignore: avoid_print
        print('CartService.saveToServer: called with uid="$uid"');
      }
      // Save items as a field on the user document: /users/{uid} -> { items: [...] }
      final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
      final encoded = items.value.map((c) => c.toJson()).toList();
      await docRef.set({'items': encoded});
      if (kDebugMode) {
        // ignore: avoid_print
        print(
            'CartService.saveToServer: saved ${encoded.length} items for uid=$uid');
      }
    } catch (e) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('CartService.saveToServer: error saving to Firestore: $e');
      }
    }
  }

  /// Load cart from Firestore and merge with local items. Merge strategy:
  /// summed quantities for identical product IDs (local + remote).
  Future<void> loadFromServer(String uid) async {
    try {
      if (kDebugMode) {
        // ignore: avoid_print
        print('CartService.loadFromServer: called with uid="$uid"');
      }
      final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
      final doc = await docRef.get();
      if (!doc.exists) {
        if (kDebugMode) {
          // ignore: avoid_print
          print(
              'CartService.loadFromServer: user document does not exist for uid=$uid');
        }
        return;
      }
      final data = doc.data();
      if (data == null) return;
      final remoteRaw = (data['items'] as List<dynamic>?) ?? [];
      final remoteItems = remoteRaw
          .map((e) => CartItem.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();

      // Build maps by productId|optionsKey so items with different
      // options (size/color combos) are treated as distinct entries.
      final Map<String, int> remoteMap = {
        for (var r in remoteItems)
          '${r.product.id}|${_optionsKey(r.options)}': r.quantity
      };
      final Map<String, int> localMap = {
        for (var l in items.value)
          '${l.product.id}|${_optionsKey(l.options)}': l.quantity
      };

      // Merge: sum quantities by key
      final Set<String> allKeys = {...remoteMap.keys, ...localMap.keys};
      final List<CartItem> merged = [];
      for (final key in allKeys) {
        final remoteQty = remoteMap[key] ?? 0;
        final localQty = localMap[key] ?? 0;
        final totalQty = remoteQty + localQty;
        // Find an existing item locally (prefer local product metadata)
        CartItem existingLocal;
        try {
          existingLocal = items.value.firstWhere(
              (e) => '${e.product.id}|${_optionsKey(e.options)}' == key);
        } catch (_) {
          existingLocal = remoteItems.firstWhere(
              (r) => '${r.product.id}|${_optionsKey(r.options)}' == key);
        }
        if (totalQty > 0) {
          merged.add(CartItem(
              product: existingLocal.product,
              quantity: totalQty,
              options: existingLocal.options));
        }
      }

      items.value = merged;
      // Persist merged result locally
      await _save();
      if (kDebugMode) {
        // ignore: avoid_print
        print(
            'CartService.loadFromServer: merged ${merged.length} items for uid=$uid');
      }
    } catch (e) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('CartService.loadFromServer: error loading from Firestore: $e');
      }
    }
  }

  Future<void> _maybeSaveToServer() async {
    if (!serverSyncEnabled) return;
    try {
      final fu = fb.FirebaseAuth.instance.currentUser;
      if (fu != null) {
        await saveToServer(fu.uid);
      }
    } catch (e) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('CartService._maybeSaveToServer: $e');
      }
    }
  }
}
