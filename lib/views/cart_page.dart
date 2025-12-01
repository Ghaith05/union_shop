import 'package:flutter/material.dart';
import 'package:union_shop/data/cart.dart';

class CartPage extends StatelessWidget {
  static const routeName = '/cart';
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = CartService();
    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ValueListenableBuilder<List<CartItem>>(
          valueListenable: cart.items,
          builder: (context, items, _) {
            if (items.isEmpty) {
              return const Center(child: Text('Your cart is empty'));
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (ctx, i) {
                      final ci = items[i];
                      return ListTile(
                        leading: ci.product.images.isNotEmpty
                            ? Image.asset(ci.product.images.first,
                                width: 56, height: 56, fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const SizedBox())
                            : const SizedBox(width: 56, height: 56),
                        title: Text(ci.product.title),
                        subtitle: Text('£${ci.unitPrice.toStringAsFixed(2)}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: 'Decrease',
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () {
                                final newQty = ci.quantity - 1;
                                cart.updateQuantity(ci.product.id, newQty);
                              },
                            ),
                            Text('${ci.quantity}'),
                            IconButton(
                              tooltip: 'Increase',
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () {
                                cart.updateQuantity(ci.product.id, ci.quantity + 1);
                              },
                            ),
                            IconButton(
                              tooltip: 'Remove',
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () {
                                cart.removeProduct(ci.product.id);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total: £${cart.total.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ElevatedButton(
                      onPressed: () {
                        // "Place order" — no payment integration, just clear cart and confirm.
                        cart.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Order placed — thank you!')),
                        );
                        // Optionally navigate to a confirmation page or pop
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        child: Text('Checkout'),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}