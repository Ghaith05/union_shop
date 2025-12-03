import 'package:flutter/foundation.dart';
import 'package:union_shop/models/product.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(items.value.map((c) => c.toJson()).toList());
      await prefs.setString(_prefsKey, encoded);
    } catch (_) {
      // Non-fatal: ignore save errors.
    }
  }
}
