import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('My Cart')),
      body: cart.items.isEmpty
          ? const Center(child: Text('Your cart is empty.'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: cart.items.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, i) {
                final item = cart.items[i];
                return Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: item.image, width: 64, height: 64, fit: BoxFit.cover,
                        errorWidget: (c, u, e) => Container(width: 64, height: 64, color: Colors.grey.shade200),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text('${AppConstants.currencySymbol}${item.price.toStringAsFixed(0)}',
                              style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () => cart.updateQuantity(item, item.quantity - 1),
                        ),
                        Text('${item.quantity}'),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () => cart.updateQuantity(item, item.quantity + 1),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
      bottomNavigationBar: cart.items.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total', style: TextStyle(fontSize: 16)),
                        Text(
                          '${AppConstants.currencySymbol}${cart.totalAmount.toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => Navigator.push(
                        context, MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                      ),
                      child: const Text('Proceed to Checkout'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
