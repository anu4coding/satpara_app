import 'product_model.dart';

/// Local (and Firestore-synced) representation of one line in the cart.
/// Firestore path: users/{uid}/cart/{productId}
class CartItemModel {
  final String productId;
  final String name;
  final String image;
  final double price;
  int quantity;

  CartItemModel({
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
    this.quantity = 1,
  });

  double get subtotal => price * quantity;

  factory CartItemModel.fromProduct(ProductModel product, {int quantity = 1}) {
    return CartItemModel(
      productId: product.id,
      name: product.name,
      image: product.thumbnail,
      price: product.price,
      quantity: quantity,
    );
  }

  factory CartItemModel.fromMap(String id, Map<String, dynamic> map) {
    return CartItemModel(
      productId: id,
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      quantity: (map['quantity'] ?? 1) as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'price': price,
      'quantity': quantity,
    };
  }
}
