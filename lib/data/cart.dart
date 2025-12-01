import 'package:flutter/foundation.dart';
import 'package:union_shop/models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get unitPrice =>
      (product.onSale && product.salePrice != null) ? product.salePrice! : product.price;

  double get totalPrice => unitPrice * quantity;
}

class CartService {
  CartService._internal();
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;

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
  }

  void removeProduct(String productId) {
    final list = List<CartItem>.from(items.value)..removeWhere((c) => c.product.id == productId);
    items.value = list;
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
    }
  }

  void clear() {
    items.value = [];
  }

  double get total =>
      items.value.fold(0.0, (sum, item) => sum + item.totalPrice);

  bool get isEmpty => items.value.isEmpty;
}