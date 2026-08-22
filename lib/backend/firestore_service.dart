import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/models/product_model.dart';
import '../domain/models/category_model.dart';
import '../domain/models/cart_item_model.dart';
import '../domain/models/order_model.dart';
import '../domain/models/user_model.dart';

/// Single source of truth for all Firestore reads & writes.
/// Keep this file "dumb" - no business logic, just DB calls.
/// Repositories (lib/repository) wrap these and add app logic.
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Collections
  CollectionReference get _products => _db.collection('products');
  CollectionReference get _categories => _db.collection('categories');
  CollectionReference get _users => _db.collection('users');
  CollectionReference get _orders => _db.collection('orders');

  // ---------------- PRODUCTS ----------------

  Stream<List<ProductModel>> streamAllProducts() {
    return _products.orderBy('createdAt', descending: true).snapshots().map(
        (snap) => snap.docs
            .map((d) => ProductModel.fromMap(d.id, d.data() as Map<String, dynamic>))
            .toList());
  }

  Stream<List<ProductModel>> streamProductsByCategory(String categoryId) {
    return _products
        .where('categoryId', isEqualTo: categoryId)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => ProductModel.fromMap(d.id, d.data() as Map<String, dynamic>))
            .toList());
  }

  Stream<List<ProductModel>> streamFeaturedProducts() {
    return _products
        .where('isFeatured', isEqualTo: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => ProductModel.fromMap(d.id, d.data() as Map<String, dynamic>))
            .toList());
  }

  Stream<List<ProductModel>> streamBestsellers() {
    return _products
        .where('isBestseller', isEqualTo: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => ProductModel.fromMap(d.id, d.data() as Map<String, dynamic>))
            .toList());
  }

  Future<ProductModel?> getProductById(String id) async {
    final doc = await _products.doc(id).get();
    if (!doc.exists) return null;
    return ProductModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
  }

  /// Simple client-side search by name (Firestore has no native full-text
  /// search). For production, consider Algolia or Typesense.
  Future<List<ProductModel>> searchProducts(String query) async {
    final snap = await _products.get();
    final q = query.toLowerCase();
    return snap.docs
        .map((d) => ProductModel.fromMap(d.id, d.data() as Map<String, dynamic>))
        .where((p) => p.name.toLowerCase().contains(q))
        .toList();
  }

  Future<void> addProduct(ProductModel product) =>
      _products.doc(product.id).set(product.toMap());

  Future<void> updateProduct(String id, Map<String, dynamic> data) =>
      _products.doc(id).update(data);

  Future<void> deleteProduct(String id) => _products.doc(id).delete();

  // ---------------- CATEGORIES ----------------

  Stream<List<CategoryModel>> streamCategories() {
    return _categories.snapshots().map((snap) => snap.docs
        .map((d) => CategoryModel.fromMap(d.id, d.data() as Map<String, dynamic>))
        .toList());
  }

  Future<void> addCategory(CategoryModel category) =>
      _categories.doc(category.id).set(category.toMap());

  // ---------------- CART (per-user subcollection) ----------------

  CollectionReference _cartRef(String uid) =>
      _users.doc(uid).collection('cart');

  Stream<List<CartItemModel>> streamCart(String uid) {
    return _cartRef(uid).snapshots().map((snap) => snap.docs
        .map((d) => CartItemModel.fromMap(d.id, d.data() as Map<String, dynamic>))
        .toList());
  }

  Future<void> upsertCartItem(String uid, CartItemModel item) =>
      _cartRef(uid).doc(item.productId).set(item.toMap());

  Future<void> removeCartItem(String uid, String productId) =>
      _cartRef(uid).doc(productId).delete();

  Future<void> clearCart(String uid) async {
    final snap = await _cartRef(uid).get();
    final batch = _db.batch();
    for (final doc in snap.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  // ---------------- USERS ----------------

  Future<void> createUserProfile(UserModel user) =>
      _users.doc(user.uid).set(user.toMap(), SetOptions(merge: true));

  Future<UserModel?> getUserProfile(String uid) async {
    final doc = await _users.doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
  }

  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) =>
      _users.doc(uid).update(data);

  // ---------------- ORDERS ----------------

  Future<String> placeOrder(OrderModel order) async {
    final doc = await _orders.add(order.toMap());
    // Mirror under the user for fast "my orders" queries
    await _users.doc(order.userId).collection('orders').doc(doc.id).set(order.toMap());
    return doc.id;
  }

  Stream<List<OrderModel>> streamUserOrders(String uid) {
    return _users
        .doc(uid)
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => OrderModel.fromMap(d.id, d.data()))
            .toList());
  }
}
