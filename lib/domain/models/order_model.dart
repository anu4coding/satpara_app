import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_item_model.dart';

enum OrderStatus { placed, confirmed, shipped, delivered, cancelled }

/// Firestore collection: "orders" (also mirrored under users/{uid}/orders/{orderId})
class OrderModel {
  final String id;
  final String userId;
  final List<CartItemModel> items;
  final double totalAmount;
  final String address;
  final String phone;
  final String paymentMethod; // "COD" | "ONLINE"
  final OrderStatus status;
  final DateTime? createdAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.address,
    required this.phone,
    required this.paymentMethod,
    this.status = OrderStatus.placed,
    this.createdAt,
  });

  factory OrderModel.fromMap(String id, Map<String, dynamic> map) {
    return OrderModel(
      id: id,
      userId: map['userId'] ?? '',
      items: (map['items'] as List<dynamic>? ?? [])
          .map((e) => CartItemModel.fromMap(e['productId'] ?? '', e))
          .toList(),
      totalAmount: (map['totalAmount'] ?? 0).toDouble(),
      address: map['address'] ?? '',
      phone: map['phone'] ?? '',
      paymentMethod: map['paymentMethod'] ?? 'COD',
      status: OrderStatus.values.firstWhere(
        (s) => s.name == (map['status'] ?? 'placed'),
        orElse: () => OrderStatus.placed,
      ),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items
          .map((e) => {
                'productId': e.productId,
                ...e.toMap(),
              })
          .toList(),
      'totalAmount': totalAmount,
      'address': address,
      'phone': phone,
      'paymentMethod': paymentMethod,
      'status': status.name,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}
