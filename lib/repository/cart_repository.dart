import '../backend/firestore_service.dart';
import '../domain/models/cart_item_model.dart';
import '../domain/models/product_model.dart';

class CartRepository {
  final FirestoreService _service;
  CartRepository(this._service);

  Stream<List<CartItemModel>> cart(String uid) => _service.streamCart(uid);

  Future<void> addToCart(String uid, ProductModel product, {int quantity = 1}) {
    final item = CartItemModel.fromProduct(product, quantity: quantity);
    return _service.upsertCartItem(uid, item);
  }

  Future<void> updateQuantity(String uid, CartItemModel item, int quantity) {
    item.quantity = quantity;
    return _service.upsertCartItem(uid, item);
  }

  Future<void> removeFromCart(String uid, String productId) =>
      _service.removeCartItem(uid, productId);

  Future<void> clearCart(String uid) => _service.clearCart(uid);
}
