import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../domain/models/product_model.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final productRepo = context.read<ProductProvider>();
    return Scaffold(
      body: FutureBuilder<ProductModel?>(
        future: productRepo.allProducts
                .where((p) => p.id == widget.productId)
                .isNotEmpty
            ? Future.value(productRepo.allProducts.firstWhere((p) => p.id == widget.productId))
            : Future.value(null),
        builder: (context, snap) {
          if (!snap.hasData || snap.data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final product = snap.data!;
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 320,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: PageView(
                    children: product.images
                        .map((img) => CachedNetworkImage(imageUrl: img, fit: BoxFit.cover))
                        .toList(),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '${AppConstants.currencySymbol}${product.price.toStringAsFixed(0)}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                          const SizedBox(width: 8),
                          if (product.mrp > product.price)
                            Text(
                              '${AppConstants.currencySymbol}${product.mrp.toStringAsFixed(0)}',
                              style: const TextStyle(decoration: TextDecoration.lineThrough, color: AppColors.textMuted),
                            ),
                          const SizedBox(width: 8),
                          if (product.discountPercent > 0)
                            Text('${product.discountPercent.round()}% off',
                                style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          Text(' ${product.rating.toStringAsFixed(1)} (${product.reviewCount} reviews)',
                              style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
                        ],
                      ),
                      const Divider(height: 32),
                      const Text('Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 8),
                      Text(product.description, style: const TextStyle(color: AppColors.textMuted, height: 1.5)),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Text('Quantity', style: TextStyle(fontWeight: FontWeight.bold)),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () => setState(() => quantity = quantity > 1 ? quantity - 1 : 1),
                          ),
                          Text('$quantity', style: const TextStyle(fontSize: 16)),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () => setState(() => quantity++),
                          ),
                        ],
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: FutureBuilder<ProductModel?>(
        future: Future.value(
          context.read<ProductProvider>().allProducts.where((p) => p.id == widget.productId).isEmpty
              ? null
              : context.read<ProductProvider>().allProducts.firstWhere((p) => p.id == widget.productId),
        ),
        builder: (context, snap) {
          final product = snap.data;
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: product == null || !product.inStock
                    ? null
                    : () {
                        context.read<CartProvider>().addToCart(product, quantity: quantity);
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
                      },
                child: Text(product == null
                    ? 'Loading...'
                    : product.inStock
                        ? 'Add to Cart · ${AppConstants.currencySymbol}${(product.price * quantity).toStringAsFixed(0)}'
                        : 'Out of Stock'),
              ),
            ),
          );
        },
      ),
    );
  }
}
