import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../domain/models/category_model.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onTap;
  const CategoryCard({super.key, required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: CachedNetworkImage(
              imageUrl: category.imageUrl,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
              placeholder: (c, u) => Container(width: 72, height: 72, color: Colors.grey.shade200),
              errorWidget: (c, u, e) => Container(
                width: 72,
                height: 72,
                color: Colors.grey.shade200,
                child: const Icon(Icons.spa_outlined),
              ),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 80,
            child: Text(
              category.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
