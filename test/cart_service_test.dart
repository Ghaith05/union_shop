import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/data/cart.dart';
import 'package:union_shop/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    // Reset SharedPreferences mock and cart between tests
    SharedPreferences.setMockInitialValues({});
    CartService().items.value = [];
    // Disable server sync to avoid calling Firebase in unit tests
    CartService.serverSyncEnabled = false;
  });

  test('add() adds a product with correct quantity', () {
    final product = Product.sample(id: 'p1', title: 'P1', collectionId: 'c');
    final cart = CartService();

    cart.add(product, quantity: 2);

    expect(cart.items.value.length, 1);
    expect(cart.items.value.first.product.id, 'p1');
    expect(cart.items.value.first.quantity, 2);
  });

  test('add() merges quantity for same product', () {
    final product = Product.sample(id: 'p2', title: 'P2', collectionId: 'c');
    final cart = CartService();

    cart.add(product, quantity: 1);
    cart.add(product, quantity: 3);

    expect(cart.items.value.length, 1);
    expect(cart.items.value.first.quantity, 4);
  });

  test('removeProduct() removes item by productId', () {
    final p1 = Product.sample(id: 'a', title: 'A', collectionId: 'c');
    final p2 = Product.sample(id: 'b', title: 'B', collectionId: 'c');
    final cart = CartService();

    cart.add(p1);
    cart.add(p2);
    expect(cart.items.value.length, 2);

    cart.removeProduct('a');
    expect(cart.items.value.length, 1);
    expect(cart.items.value.first.product.id, 'b');
  });

  test('updateQuantity() sets and removes when quantity <= 0', () {
    final p = Product.sample(id: 'u1', title: 'U', collectionId: 'c');
    final cart = CartService();

    cart.add(p, quantity: 2);
    expect(cart.items.value.first.quantity, 2);

    cart.updateQuantity('u1', 5);
    expect(cart.items.value.first.quantity, 5);

    cart.updateQuantity('u1', 0);
    expect(cart.items.value.isEmpty, true);
  });

  test('clear() empties the cart', () {
    final p = Product.sample(id: 'c1', title: 'C', collectionId: 'c');
    final cart = CartService();

    cart.add(p);
    expect(cart.items.value.isNotEmpty, true);

    cart.clear();
    expect(cart.items.value.isEmpty, true);
  });

  test('persistence: add -> clear local -> loadFromPrefs restores items',
      () async {
    final p = Product.sample(id: 's1', title: 'S', collectionId: 'c');
    final cart = CartService();

    cart.add(p, quantity: 3);
    expect(cart.items.value.length, 1);

    // Wait briefly for async _save() to complete (writes to SharedPreferences).
    await Future.delayed(const Duration(milliseconds: 50));

    // Simulate app restart by clearing in-memory list then loading from prefs
    cart.items.value = [];
    expect(cart.items.value.isEmpty, true);

    await cart.loadFromPrefs();
    expect(cart.items.value.length, 1);
    expect(cart.items.value.first.product.id, 's1');
    expect(cart.items.value.first.quantity, 3);
  });
}
