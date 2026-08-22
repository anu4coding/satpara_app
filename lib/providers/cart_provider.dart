import 'package:flutter/foundation.dart';
import '../repository/cart_repository.dart';
import '../domain/models/cart_item_model.dart';
import '../domain/models/product_model.dart';

class CartProvider extends ChangeNotifier {
  final CartRepository _repo;
  String? _uid;

  CartProvider(this._repo);

  List<CartItemModel> items = [];

  double get totalAmount =>
      items.fold(0, (sum, item) => sum + item.subtotal);

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  /// Call this once the user logs in (or on app start if already logged in)
  void bindUser(String uid) {
    _uid = uid;
    _repo.cart(uid).listen((cartItems) {
      items = cartItems;
      notifyListeners();
    });
  }

  Future<void> addToCart(ProductModel product, {int quantity = 1}) async {
    if (_uid == null) return;
    final existing = items.where((i) => i.productId == product.id).toList();
    if (existing.isNotEmpty) {
      await _repo.updateQuantity(_uid!, existing.first, existing.first.quantity + quantity);
    } else {
      await _repo.addToCart(_uid!, product, quantity: quantity);
    }
  }

  Future<void> updateQuantity(CartItemModel item, int quantity) async {
    if (_uid == null) return;
    if (quantity <= 0) {
      await removeFromCart(item.productId);
      return;
    }
    await _repo.updateQuantity(_uid!, item, quantity);
  }

  Future<void> removeFromCart(String productId) async {
    if (_uid == null) return;
    await _repo.removeFromCart(_uid!, productId);
  }

  Future<void> clearCart() async {
    if (_uid == null) return;
    await _repo.clearCart(_uid!);
  }
}
