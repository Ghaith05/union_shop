import 'package:flutter/material.dart';
import 'package:union_shop/widgets/navbar.dart';
import 'package:union_shop/data/cart.dart';
import 'package:union_shop/data/auth_service.dart';
import 'package:union_shop/data/user.dart';

class CartPage extends StatelessWidget {
  static const routeName = '/cart';
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = CartService();
    return Scaffold(
      appBar: buildAppBar(context, titleWidget: const Text('Your Cart')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ValueListenableBuilder<List<CartItem>>(
          valueListenable: cart.items,
          builder: (context, items, _) {
            // Always show an Account section above the cart. This section is
            // a compact Card that shows the signed-in user's email and a
            // Log out button; if not signed in it shows a Sign in button.
            return Column(
              children: [
                ValueListenableBuilder<User?>(
                  valueListenable: AuthenticationService().currentUser,
                  builder: (ctx, user, __) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: user == null
                                  ? const Text('Not signed in')
                                  : Text('Signed in as ${user.email}'),
                            ),
                            if (user == null)
                              ElevatedButton(
                                onPressed: () =>
                                    Navigator.pushNamed(ctx, '/auth'),
                                child: const Text('Sign in'),
                              )
                            else
                              ElevatedButton(
                                onPressed: () async {
                                  await AuthenticationService().signOut();
                                  if (!ctx.mounted) return;
                                  Navigator.pushNamedAndRemoveUntil(
                                      ctx, '/auth', (r) => false);
                                },
                                child: const Text('Log out'),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                if (items.isEmpty)
                  const Expanded(
                      child: Center(child: Text('Your cart is empty')))
                else
                  Expanded(
                    child: Column(
                      children: [
                        // Header row
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 4,
                                  child: Text('Product',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600))),
                              SizedBox(width: 24),
                              SizedBox(
                                  width: 96,
                                  child: Text('Price',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600))),
                              SizedBox(width: 24),
                              SizedBox(
                                  width: 120,
                                  child: Text('Quantity',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600))),
                              SizedBox(width: 24),
                              SizedBox(
                                  width: 96,
                                  child: Text('Total',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600))),
                            ],
                          ),
                        ),
                        const Divider(),
                        Expanded(
                          child: ListView.separated(
                            itemCount: items.length,
                            separatorBuilder: (_, __) => const Divider(),
                            itemBuilder: (ctx, i) {
                              final ci = items[i];
                              final qtyController = TextEditingController(
                                  text: ci.quantity.toString());
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Product image
                                    if (ci.product.images.isNotEmpty)
                                      SizedBox(
                                        width: 80,
                                        height: 80,
                                        child: Image.asset(
                                            ci.product.images.first,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) =>
                                                Container(
                                                    color: Colors.grey[200])),
                                      )
                                    else
                                      Container(
                                          width: 80,
                                          height: 80,
                                          color: Colors.grey[200]),
                                    const SizedBox(width: 16),
                                    // Title and description + remove link
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(ci.product.title,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600)),
                                          const SizedBox(height: 6),
                                          if (ci.product.description.isNotEmpty)
                                            Text(ci.product.description,
                                                style: const TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    color: Colors.black54)),
                                          const SizedBox(height: 8),
                                          GestureDetector(
                                            key: ValueKey(
                                                'cart-remove-text-${ci.product.id}'),
                                            onTap: () => cart
                                                .removeProduct(ci.product.id),
                                            child: const Text('Remove',
                                                style: TextStyle(
                                                    color: Color(0xFF4d2963),
                                                    decoration: TextDecoration
                                                        .underline)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                    // Unit price
                                    SizedBox(
                                        width: 96,
                                        child: Text(
                                            '£${ci.unitPrice.toStringAsFixed(2)}')),
                                    const SizedBox(width: 24),
                                    // Quantity input
                                    SizedBox(
                                      width: 120,
                                      child: Center(
                                        child: SizedBox(
                                          width: 80,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black54),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: TextField(
                                                    key: ValueKey(
                                                        'cart-qty-input-${ci.product.id}'),
                                                    controller: qtyController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    textAlign: TextAlign.center,
                                                    decoration:
                                                        const InputDecoration(
                                                      border: InputBorder.none,
                                                      isDense: true,
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 8,
                                                              horizontal: 6),
                                                    ),
                                                    onSubmitted: (val) {
                                                      final parsed =
                                                          int.tryParse(val) ??
                                                              ci.quantity;
                                                      cart.updateQuantity(
                                                          ci.product.id,
                                                          parsed);
                                                    },
                                                  ),
                                                ),
                                                // Up/Down small buttons
                                                Container(
                                                  width: 28,
                                                  decoration:
                                                      const BoxDecoration(
                                                    border: Border(
                                                        left: BorderSide(
                                                            color: Colors
                                                                .black12)),
                                                  ),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      IconButton(
                                                        key: ValueKey(
                                                            'cart-increase-btn-${ci.product.id}'),
                                                        padding:
                                                            EdgeInsets.zero,
                                                        constraints:
                                                            const BoxConstraints(
                                                                maxHeight: 22,
                                                                maxWidth: 22),
                                                        iconSize: 18,
                                                        icon: const Icon(Icons
                                                            .keyboard_arrow_up),
                                                        onPressed: () {
                                                          cart.updateQuantity(
                                                              ci.product.id,
                                                              ci.quantity + 1);
                                                        },
                                                      ),
                                                      IconButton(
                                                        key: ValueKey(
                                                            'cart-decrease-btn-${ci.product.id}'),
                                                        padding:
                                                            EdgeInsets.zero,
                                                        constraints:
                                                            const BoxConstraints(
                                                                maxHeight: 22,
                                                                maxWidth: 22),
                                                        iconSize: 18,
                                                        icon: const Icon(Icons
                                                            .keyboard_arrow_down),
                                                        onPressed: () {
                                                          final newQty =
                                                              ci.quantity - 1;
                                                          cart.updateQuantity(
                                                              ci.product.id,
                                                              newQty);
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                    // Line total
                                    SizedBox(
                                        width: 96,
                                        child: Text(
                                            '£${ci.totalPrice.toStringAsFixed(2)}')),
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
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            ElevatedButton(
                              onPressed: () {
                                // "Place order" — no payment integration, just clear cart and confirm.
                                cart.clear();
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Order placed — thank you!')));
                                // Optionally navigate to a confirmation page or pop
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 12),
                                child: Text('Checkout'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
