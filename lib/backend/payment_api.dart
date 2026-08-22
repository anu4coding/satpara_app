import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentOrder {
  final String id;
  final int amount;
  final String currency;
  final String keyId;

  const PaymentOrder({required this.id, required this.amount, required this.currency, required this.keyId});

  factory PaymentOrder.fromJson(Map<String, dynamic> json) => PaymentOrder(
        id: json['id'] as String,
        amount: json['amount'] as int,
        currency: json['currency'] as String,
        keyId: json['keyId'] as String,
      );
}

class PaymentApi {
  static const baseUrl = String.fromEnvironment('PAYMENT_API_URL', defaultValue: 'http://localhost:8787');

  Future<PaymentOrder> createOrder({required int amountInRupees, String? receipt}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/payments/orders'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'amount': amountInRupees * 100, 'currency': 'INR', 'receipt': receipt}),
    );
    if (response.statusCode != 200) throw Exception(jsonDecode(response.body)['error'] ?? 'Payment order failed');
    return PaymentOrder.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<bool> verifyPayment({required String orderId, required String paymentId, required String signature}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/payments/verify'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'razorpay_order_id': orderId, 'razorpay_payment_id': paymentId, 'razorpay_signature': signature}),
    );
    return response.statusCode == 200 && (jsonDecode(response.body)['verified'] == true);
  }
}
