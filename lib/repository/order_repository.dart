import '../backend/firestore_service.dart';
import '../domain/models/order_model.dart';
import '../domain/models/cart_item_model.dart';

class OrderRepository {
  final FirestoreService _service;
  OrderRepository(this._service);

  Future<String> placeOrder({
    required String userId,
    required List<CartItemModel> items,
    required double totalAmount,
    required String address,
    required String phone,
    required String paymentMethod,
  }) {
    final order = OrderModel(
      id: '',
      userId: userId,
      items: items,
      totalAmount: totalAmount,
      address: address,
      phone: phone,
      paymentMethod: paymentMethod,
    );
    return _service.placeOrder(order);
  }

  Stream<List<OrderModel>> userOrders(String uid) =>
      _service.streamUserOrders(uid);
}
