import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a single product (e.g. Rose Soap, Turmeric Pickle)
/// Firestore collection: "products"
class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price; // current selling price
  final double mrp; // original price (for showing discount / strike-through)
  final String categoryId; // e.g. "soap", "face-mask", "pickle"
  final String categoryName; // display name e.g. "Soap"
  final List<String> images; // image URLs (hosted on Firebase Storage or CDN)
  final int stock;
  final double rating;
  final int reviewCount;
  final bool isFeatured;
  final bool isBestseller;
  final bool isNewArrival;
  final List<String> tags; // e.g. ["chemical-free", "handmade"]
  final DateTime? createdAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.mrp,
    required this.categoryId,
    required this.categoryName,
    required this.images,
    this.stock = 0,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isFeatured = false,
    this.isBestseller = false,
    this.isNewArrival = false,
    this.tags = const [],
    this.createdAt,
  });

  double get discountPercent {
    if (mrp <= 0 || mrp <= price) return 0;
    return ((mrp - price) / mrp) * 100;
  }

  bool get inStock => stock > 0;

  String get thumbnail => images.isNotEmpty ? images.first : '';

  factory ProductModel.fromMap(String id, Map<String, dynamic> map) {
    return ProductModel(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      mrp: (map['mrp'] ?? 0).toDouble(),
      categoryId: map['categoryId'] ?? '',
      categoryName: map['categoryName'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      stock: (map['stock'] ?? 0) as int,
      rating: (map['rating'] ?? 0).toDouble(),
      reviewCount: (map['reviewCount'] ?? 0) as int,
      isFeatured: map['isFeatured'] ?? false,
      isBestseller: map['isBestseller'] ?? false,
      isNewArrival: map['isNewArrival'] ?? false,
      tags: List<String>.from(map['tags'] ?? []),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'mrp': mrp,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'images': images,
      'stock': stock,
      'rating': rating,
      'reviewCount': reviewCount,
      'isFeatured': isFeatured,
      'isBestseller': isBestseller,
      'isNewArrival': isNewArrival,
      'tags': tags,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}
