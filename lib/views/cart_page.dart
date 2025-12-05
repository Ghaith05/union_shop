import 'package:flutter/material.dart';
import 'package:union_shop/widgets/navbar.dart';
import 'package:union_shop/data/cart.dart';
import 'package:union_shop/views/account_dashboard.dart';
import 'package:union_shop/views/pay_page.dart';

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
          builder: (context, items, _) => Column(
            children: [
              // This Card seems misplaced for a cart page logic.
              // It might be intended for a different context.
              const Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: AccountDashboardBody(),
                ),
              ),
              const SizedBox(height: 8),
              if (items.isEmpty)
                const Expanded(
                  child: Center(child: Text('Your cart is empty')),
                )
              else
                Expanded(
                  child: LayoutBuilder(
                    builder: (ctx, constraints) {
                      final isNarrow = constraints.maxWidth < 600;
                      return Column(
                        children: [
                          if (!isNarrow)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      'Product',
                                      style: TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  SizedBox(width: 24),
                                  SizedBox(
                                    width: 96,
                                    child: Text(
                                      'Price',
                                      style: TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  SizedBox(width: 24),
                                  SizedBox(
                                    width: 120,
                                    child: Text(
                                      'Quantity',
                                      style: TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  SizedBox(width: 24),
                                  SizedBox(
                                    width: 96,
                                    child: Text(
                                      'Total',
                                      style: TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const Divider(),
                          Expanded(
                            child: ListView.separated(
                              itemCount: items.length,
                              separatorBuilder: (_, __) => const Divider(),
                              itemBuilder: (ctx2, i) {
                                final ci = items[i];
                                final qtyController = TextEditingController(text: ci.quantity.toString());

                                Widget removeAction(BuildContext dctx) => GestureDetector(
                                      key: ValueKey('cart-remove-text-${ci.product.id}'),
                                      onTap: () async {
                                        final confirmed = await showDialog<bool>(
                                          context: ctx2,
                                          builder: (dctx2) => AlertDialog(
                                            title: const Text('Remove item'),
                                            content: Text(
                                              'Remove "${ci.product.title}" from your cart?',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.of(dctx2).pop(false),
                                                child: const Text('Cancel'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () => Navigator.of(dctx2).pop(true),
                                                child: const Text('Remove'),
                                              ),
                                            ],
                                          ),
                                        );
                                        if (confirmed == true) {
                                          cart.removeProduct(ci.product.id);
                                        }
                                      },
                                      child: const Text(
                                        'Remove',
                                        style: TextStyle(
                                          color: Color(0xFF4d2963),
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    );

                                if (!isNarrow) {
                                  // Wide layout (Desktop/Tablet)
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        // Product Image
                                        if (ci.product.images.isNotEmpty)
                                          SizedBox(
                                            width: 80,
                                            height: 80,
                                            child: Image.asset(
                                              ci.product.images.first,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) => Container(color: Colors.grey[200]),
                                            ),
                                          )
                                        else
                                          Container(
                                            width: 80,
                                            height: 80,
                                            color: Colors.grey[200],
                                          ),
                                        const SizedBox(width: 16),
                                        // Product Details
                                        Expanded(
                                          flex: 4,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                ci.product.title,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              // Display options or parsed description
                                              if (ci.options != null && ci.options!.isNotEmpty)
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 6),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: ci.options!.entries
                                                        .map(
                                                          (e) => Text(
                                                            '${e.key}: ${e.value}',
                                                            style: const TextStyle(
                                                              fontStyle: FontStyle.italic,
                                                              color: Colors.black54,
                                                            ),
                                                          ),
                                                        )
                                                        .toList(),
                                                  ),
                                                )
                                              else if (ci.product.description.isNotEmpty)
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 6),
                                                  child: Builder(
                                                    builder: (_) {
                                                      final lines = ci.product.description
                                                          .split(RegExp(r'[\r\n]+'))
                                                          .map((s) => s.trim())
                                                          .where((s) => s.isNotEmpty)
                                                          .toList();
                                                      final colorLine = lines.firstWhere(
                                                        (l) => l.toLowerCase().startsWith('color:'),
                                                        orElse: () => '',
                                                      );
                                                      final sizeLine = lines.firstWhere(
                                                        (l) => l.toLowerCase().startsWith('size:'),
                                                        orElse: () => '',
                                                      );
                                                      final other = lines
                                                          .where(
                                                            (l) => !l.toLowerCase().startsWith('color:') && !l.toLowerCase().startsWith('size:'),
                                                          )
                                                          .toList();

                                                      return Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          if (other.isNotEmpty)
                                                            Text(
                                                              other.join(' '),
                                                              style: const TextStyle(
                                                                fontStyle: FontStyle.italic,
                                                                color: Colors.black54,
                                                              ),
                                                            ),
                                                          if (colorLine.isNotEmpty)
                                                            Padding(
                                                              padding: const EdgeInsets.only(top: 6),
                                                              child: Text(
                                                                colorLine,
                                                                style: const TextStyle(
                                                                  fontStyle: FontStyle.italic,
                                                                  color: Colors.black54,
                                                                ),
                                                              ),
                                                            ),
                                                          if (sizeLine.isNotEmpty)
                                                            Padding(
                                                              padding: const EdgeInsets.only(top: 2),
                                                              child: Text(
                                                                sizeLine,
                                                                style: const TextStyle(
                                                                  fontStyle: FontStyle.italic,
                                                                  color: Colors.black54,
                                                                ),
                                                              ),
                                                            ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ),
                                              const SizedBox(height: 8),
                                              removeAction(ctx2),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 24),
                                        // Unit Price
                                        SizedBox(
                                          width: 96,
                                          child: Text('£${ci.unitPrice.toStringAsFixed(2)}'),
                                        ),
                                        const SizedBox(width: 24),
                                        // Quantity Adjustment
                                        SizedBox(
                                          width: 120,
                                          child: Center(
                                            child: SizedBox(
                                              width: 80,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.black54),
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: TextField(
                                                        key: ValueKey('cart-qty-input-${ci.product.id}'),
                                                        controller: qtyController,
                                                        keyboardType: TextInputType.number,
                                                        textAlign: TextAlign.center,
                                                        decoration: const InputDecoration(
                                                          border: InputBorder.none,
                                                          isDense: true,
                                                          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                                                        ),
                                                        onSubmitted: (val) {
                                                          final parsed = int.tryParse(val) ?? ci.quantity;
                                                          cart.updateQuantity(ci.product.id, parsed);
                                                        },
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 28,
                                                      decoration: const BoxDecoration(
                                                        border: Border(
                                                          left: BorderSide(color: Colors.black12),
                                                        ),
                                                      ),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          IconButton(
                                                            key: ValueKey('cart-increase-btn-${ci.product.id}'),
                                                            padding: EdgeInsets.zero,
                                                            constraints: const BoxConstraints(maxHeight: 22, maxWidth: 22),
                                                            iconSize: 18,
                                                            icon: const Icon(Icons.keyboard_arrow_up),
                                                            onPressed: () => cart.updateQuantity(ci.product.id, ci.quantity + 1),
                                                          ),
                                                          IconButton(
                                                            key: ValueKey('cart-decrease-btn-${ci.product.id}'),
                                                            padding: EdgeInsets.zero,
                                                            constraints: const BoxConstraints(maxHeight: 22, maxWidth: 22),
                                                            iconSize: 18,
                                                            icon: const Icon(Icons.keyboard_arrow_down),
                                                            onPressed: () => cart.updateQuantity(ci.product.id, ci.quantity - 1),
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
                                        // Total Price
                                        SizedBox(
                                          width: 96,
                                          child: Text('£${ci.totalPrice.toStringAsFixed(2)}'),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                // Narrow layout (Mobile)
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Product Image
                                          if (ci.product.images.isNotEmpty)
                                            SizedBox(
                                              width: 64,
                                              height: 64,
                                              child: Image.asset(
                                                ci.product.images.first,
                                                fit: BoxFit.cover,
                                                errorBuilder: (_, __, ___) => Container(color: Colors.grey[200]),
                                              ),
                                            )
                                          else
                                            Container(
                                              width: 64,
                                              height: 64,
                                              color: Colors.grey[200],
                                            ),
                                          const SizedBox(width: 12),
                                          // Product Details
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  ci.product.title,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                // Display options or parsed description
                                                if (ci.options != null && ci.options!.isNotEmpty)
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      for (final e in ci.options!.entries)
                                                        Text(
                                                          '${e.key}: ${e.value}',
                                                          style: const TextStyle(
                                                            fontStyle: FontStyle.italic,
                                                            color: Colors.black54,
                                                          ),
                                                        ),
                                                      const SizedBox(height: 6),
                                                      removeAction(ctx2),
                                                    ],
                                                  )
                                                else
                                                  Builder(
                                                    builder: (_) {
                                                      final lines = ci.product.description
                                                          .split(RegExp(r'[\r\n]+'))
                                                          .map((s) => s.trim())
                                                          .where((s) => s.isNotEmpty)
                                                          .toList();
                                                      final colorLine = lines.firstWhere(
                                                        (l) => l.toLowerCase().startsWith('color:'),
                                                        orElse: () => '',
                                                      );
                                                      final sizeLine = lines.firstWhere(
                                                        (l) => l.toLowerCase().startsWith('size:'),
                                                        orElse: () => '',
                                                      );
                                                      final other = lines
                                                          .where(
                                                            (l) => !l.toLowerCase().startsWith('color:') && !l.toLowerCase().startsWith('size:'),
                                                          )
                                                          .toList();

                                                      return Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          if (other.isNotEmpty)
                                                            Text(
                                                              other.join(' '),
                                                              style: const TextStyle(
                                                                fontStyle: FontStyle.italic,
                                                                color: Colors.black54,
                                                              ),
                                                            ),
                                                          if (colorLine.isNotEmpty)
                                                            Padding(
                                                              padding: const EdgeInsets.only(top: 6),
                                                              child: Text(
                                                                colorLine,
                                                                style: const TextStyle(
                                                                  fontStyle: FontStyle.italic,
                                                                  color: Colors.black54,
                                                                ),
                                                              ),
                                                            ),
                                                          if (sizeLine.isNotEmpty)
                                                            Padding(
                                                              padding: const EdgeInsets.only(top: 2),
                                                              child: Text(
                                                                sizeLine,
                                                                style: const TextStyle(
                                                                  fontStyle: FontStyle.italic,
                                                                  color: Colors.black54,
                                                                ),
                                                              ),
                                                            ),
                                                          const SizedBox(height: 6),
                                                          removeAction(ctx2),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      // Price, Quantity, Total Row (Narrow)
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '£${ci.unitPrice.toStringAsFixed(2)}',
                                            style: const TextStyle(fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            width: 140,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(color: Colors.black54),
                                                      borderRadius: BorderRadius.circular(6),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: TextField(
                                                            key: ValueKey('cart-qty-input-${ci.product.id}'),
                                                            controller: qtyController,
                                                            keyboardType: TextInputType.number,
                                                            textAlign: TextAlign.center,
                                                            decoration: const InputDecoration(
                                                              border: InputBorder.none,
                                                              isDense: true,
                                                              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                                                            ),
                                                            onSubmitted: (val) {
                                                              final parsed = int.tryParse(val) ?? ci.quantity;
                                                              cart.updateQuantity(ci.product.id, parsed);
                                                            },
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 28,
                                                          decoration: const BoxDecoration(
                                                            border: Border(
                                                              left: BorderSide(color: Colors.black12),
                                                            ),
                                                          ),
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              IconButton(
                                                                key: ValueKey('cart-increase-btn-${ci.product.id}'),
                                                                padding: EdgeInsets.zero,
                                                                constraints: const BoxConstraints(maxHeight: 22, maxWidth: 22),
                                                                iconSize: 18,
                                                                icon: const Icon(Icons.keyboard_arrow_up),
                                                                onPressed: () => cart.updateQuantity(ci.product.id, ci.quantity + 1),
                                                              ),
                                                              IconButton(
                                                                key: ValueKey('cart-decrease-btn-${ci.product.id}'),
                                                                padding: EdgeInsets.zero,
                                                                constraints: const BoxConstraints(maxHeight: 22, maxWidth: 22),
                                                                iconSize: 18,
                                                                icon: const Icon(Icons.keyboard_arrow_down),
                                                                onPressed: () => cart.updateQuantity(ci.product.id, ci.quantity - 1),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            '£${ci.totalPrice.toStringAsFixed(2)}',
                                            style: const TextStyle(fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Total and Checkout Button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total: £${cart.total.toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) => const PayPage(),
                                    ),
                                  );
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
            ],
          ),
        ),
      ),
    );
  }
}