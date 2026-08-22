import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../domain/models/product_model.dart';
import '../providers/cart_provider.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';
import '../screens/product_detail_screen.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProductDetailScreen(productId: product.id)),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: CachedNetworkImage(
                    imageUrl: product.thumbnail,
                    fit: BoxFit.cover,
                    placeholder: (c, u) => Container(color: Colors.grey.shade200),
                    errorWidget: (c, u, e) => Container(
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image_not_supported_outlined),
                    ),
                  ),
                ),
                if (product.discountPercent > 0)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${product.discountPercent.round()}% Off',
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        '${AppConstants.currencySymbol}${product.price.toStringAsFixed(0)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                      const SizedBox(width: 6),
                      if (product.mrp > product.price)
                        Text(
                          '${AppConstants.currencySymbol}${product.mrp.toStringAsFixed(0)}',
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: product.inStock
                          ? () => context.read<CartProvider>().addToCart(product)
                          : null,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        side: const BorderSide(color: AppColors.primary),
                      ),
                      child: Text(
                        product.inStock ? 'Add to Cart' : 'Out of Stock',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
