import 'package:flutter/material.dart';
import 'package:union_shop/widgets/navbar.dart';
import 'package:union_shop/data/cart.dart';

class PayPage extends StatefulWidget {
  static const routeName = '/pay';
  const PayPage({Key? key}) : super(key: key);

  @override
  State<PayPage> createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  final _contactController = TextEditingController();

  @override
  void dispose() {
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartService();
    return Scaffold(
      appBar: buildAppBar(context, titleWidget: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(builder: (ctx, constraints) {
          final isWide = constraints.maxWidth >= 900;
          Widget left = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Contact',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              TextField(
                key: const ValueKey('pay-contact'),
                controller: _contactController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Email or mobile phone number',
                ),
              ),
              const SizedBox(height: 16),
              // We won't implement delivery address for now; reserve space
              const Text('Delivery',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              const Text(
                  'Enter delivery details at checkout (not required for this demo).',
                  style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  key: const ValueKey('pay-button'),
                  onPressed: () {
                    // Simple flow: show order placed, clear cart, and return to home.
                    cart.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Order placed')));
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/', (r) => false);
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14.0),
                    child: Text('Pay', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ),
            ],
          );

          Widget right = Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Order summary',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  ValueListenableBuilder<List<CartItem>>(
                    valueListenable: cart.items,
                    builder: (context, items, _) {
                      if (items.isEmpty)
                        return const Text('Your cart is empty');
                      return Column(
                        children: items
                            .map((ci) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6.0),
                                  child: Row(
                                    children: [
                                      if (ci.product.images.isNotEmpty)
                                        SizedBox(
                                            width: 48,
                                            height: 48,
                                            child: Image.asset(
                                                ci.product.images.first,
                                                fit: BoxFit.cover,
                                                errorBuilder: (_, __, ___) =>
                                                    Container(
                                                        color:
                                                            Colors.grey[200])))
                                      else
                                        Container(
                                            width: 48,
                                            height: 48,
                                            color: Colors.grey[200]),
                                      const SizedBox(width: 12),
                                      Expanded(
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                            Text(ci.product.title),
                                            if (ci
                                                .product.description.isNotEmpty)
                                              Text(ci.product.description,
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12))
                                          ])),
                                      Text(
                                          '£${ci.totalPrice.toStringAsFixed(2)}')
                                    ],
                                  ),
                                ))
                            .toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),
                  const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Subtotal'),
                        Text('£' /* replaced below */)
                      ]),
                  const SizedBox(height: 4),
                  ValueListenableBuilder<List<CartItem>>(
                    valueListenable: cart.items,
                    builder: (context, items, _) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('£${cart.total.toStringAsFixed(2)}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold))
                        ]),
                  ),
                ],
              ),
            ),
          );

          if (isWide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: left),
                const SizedBox(width: 24),
                SizedBox(width: 360, child: right),
              ],
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [left, const SizedBox(height: 16), right],
            ),
          );
        }),
      ),
    );
  }
}
