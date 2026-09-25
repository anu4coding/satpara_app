import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../domain/models/product_model.dart';
import '../widgets/product_card.dart';
import '../widgets/category_card.dart';
import '../widgets/brand_logo.dart';
import '../utils/theme.dart';
import 'category_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final cartCount = context.watch<CartProvider>().totalItems;

    return Scaffold(
      appBar: AppBar(
        title: const BrandTitle(
          textColor: Colors.white,
          logoSize: 34,
          fontSize: 17,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ProfileScreen())),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const CartScreen())),
              ),
              if (cartCount > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                        color: AppColors.accent, shape: BoxShape.circle),
                    child: Text('$cartCount',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 10)),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: productProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {},
              child: ListView(
                padding: const EdgeInsets.only(bottom: 24),
                children: [
                  // Banner
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Give Your Skin the Care It Deserves',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 6),
                        Text('Natural & Handmade Soaps, Face Masks & More',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 13)),
                        SizedBox(height: 10),
                        Text('Use code FIRST10 for 10% off',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),

                  // Categories
                  if (productProvider.categories.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Shop by Category',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 110,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: productProvider.categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 16),
                        itemBuilder: (context, i) {
                          final cat = productProvider.categories[i];
                          return CategoryCard(
                            category: cat,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CategoryScreen(
                                    categoryId: cat.id, categoryName: cat.name),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Bestsellers
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Most Loved Products',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 12),
                  StreamBuilder<List<ProductModel>>(
                    stream: productProvider.bestsellers(),
                    builder: (context, snap) {
                      final products = snap.data ?? [];
                      if (products.isEmpty) return const SizedBox.shrink();
                      return _ProductGrid(products: products);
                    },
                  ),

                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('New Arrivals',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 12),
                  _ProductGrid(
                    products: productProvider.allProducts
                        .where((p) => p.isNewArrival)
                        .toList(),
                  ),

                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('All Products',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 12),
                  _ProductGrid(products: productProvider.allProducts),
                ],
              ),
            ),
    );
  }
}

class _ProductGrid extends StatelessWidget {
  final List<ProductModel> products;
  const _ProductGrid({required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('No products yet.',
            style: TextStyle(color: AppColors.textMuted)),
      );
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.62,
      ),
      itemBuilder: (context, i) => ProductCard(product: products[i]),
    );
  }
}
