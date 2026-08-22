import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../domain/models/product_model.dart';
import '../widgets/product_card.dart';

class CategoryScreen extends StatelessWidget {
  final String categoryId;
  final String categoryName;
  const CategoryScreen({super.key, required this.categoryId, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    final productProvider = context.read<ProductProvider>();
    return Scaffold(
      appBar: AppBar(title: Text(categoryName)),
      body: StreamBuilder<List<ProductModel>>(
        stream: productProvider.productsByCategory(categoryId),
        builder: (context, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final products = snap.data!;
          if (products.isEmpty) {
            return const Center(child: Text('No products in this category yet.'));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.62,
            ),
            itemBuilder: (context, i) => ProductCard(product: products[i]),
          );
        },
      ),
    );
  }
}
