import 'package:flutter/foundation.dart';
import 'package:union_shop/models/product.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get unitPrice => (product.onSale && product.salePrice != null)
      ? product.salePrice!
      : product.price;

  double get totalPrice => unitPrice * quantity;

  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'quantity': quantity,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        product:
            Product.fromJson(Map<String, dynamic>.from(json['product'] as Map)),
        quantity: (json['quantity'] as num).toInt(),
      );
}

class CartService {
  CartService._internal();
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;

  static const _prefsKey = 'union_shop_cart_v1';

  // Using ValueNotifier to avoid adding new dependencies — UI can use ValueListenableBuilder.
  final ValueNotifier<List<CartItem>> items = ValueNotifier<List<CartItem>>([]);

  void add(Product product, {int quantity = 1}) {
    final list = List<CartItem>.from(items.value);
    final idx = list.indexWhere((c) => c.product.id == product.id);
    if (idx >= 0) {
      list[idx].quantity += quantity;
    } else {
      list.add(CartItem(product: product, quantity: quantity));
    }
    items.value = list;
    _save();
  }

  void removeProduct(String productId) {
    final list = List<CartItem>.from(items.value)
      ..removeWhere((c) => c.product.id == productId);
    items.value = list;
    _save();
  }

  void updateQuantity(String productId, int quantity) {
    final list = List<CartItem>.from(items.value);
    final idx = list.indexWhere((c) => c.product.id == productId);
    if (idx >= 0) {
      if (quantity <= 0) {
        list.removeAt(idx);
      } else {
        list[idx].quantity = quantity;
      }
      items.value = list;
      _save();
    }
  }

  void clear() {
    items.value = [];
    _save();
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
      final doc = FirebaseFirestore.instance.doc('users/$uid/cart');
      final encoded = items.value.map((c) => c.toJson()).toList();
      await doc.set({'items': encoded});
    } catch (_) {
      // ignore server save failures
    }
  }

  /// Load cart from Firestore and merge with local items. Merge strategy:
  /// summed quantities for identical product IDs (local + remote).
  Future<void> loadFromServer(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance.doc('users/$uid/cart').get();
      if (!doc.exists) return;
      final data = doc.data();
      if (data == null) return;
      final remoteRaw = (data['items'] as List<dynamic>?) ?? [];
      final remoteItems = remoteRaw
          .map((e) => CartItem.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();

      // Build maps by productId
      final Map<String, int> remoteMap = {
        for (var r in remoteItems) r.product.id: r.quantity
      };
      final Map<String, int> localMap = {
        for (var l in items.value) l.product.id: l.quantity
      };

      // Merge: sum quantities
      final Set<String> allIds = {...remoteMap.keys, ...localMap.keys};
      final List<CartItem> merged = [];
      for (final id in allIds) {
        final remoteQty = remoteMap[id] ?? 0;
        final localQty = localMap[id] ?? 0;
        final totalQty = remoteQty + localQty;
        // Prefer richer product info from local if available, otherwise remote
        final existingLocal = items.value.firstWhere((e) => e.product.id == id,
            orElse: () => remoteItems.firstWhere((r) => r.product.id == id));
        if (totalQty > 0) {
          merged.add(
              CartItem(product: existingLocal.product, quantity: totalQty));
        }
      }

      items.value = merged;
      // Persist merged result locally
      await _save();
    } catch (_) {
      // ignore load errors — fall back to local state
    }
  }
}
