import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../repository/order_repository.dart';
import '../backend/firestore_service.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';
import 'order_history_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _addressCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  String paymentMethod = 'COD';
  bool isPlacingOrder = false;

  // In a real app, inject this via Provider - simplified here for clarity.
  final _orderRepo = OrderRepository(FirestoreService());

  Future<void> _placeOrder() async {
    if (_addressCtrl.text.trim().isEmpty || _phoneCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill address and phone number')),
      );
      return;
    }
    setState(() => isPlacingOrder = true);
    final cart = context.read<CartProvider>();
    final auth = context.read<AuthProvider>();

    try {
      await _orderRepo.placeOrder(
        userId: auth.firebaseUser!.uid,
        items: cart.items,
        totalAmount: cart.totalAmount,
        address: _addressCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        paymentMethod: paymentMethod,
      );
      await cart.clearCart();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
        (r) => r.isFirst,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order placed successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to place order: $e')),
      );
    } finally {
      if (mounted) setState(() => isPlacingOrder = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Delivery Address',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _addressCtrl,
              maxLines: 3,
              decoration:
                  const InputDecoration(hintText: 'Full address with pincode'),
            ),
            const SizedBox(height: 16),
            const Text('Phone Number',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration:
                  const InputDecoration(hintText: '10-digit mobile number'),
            ),
            const SizedBox(height: 16),
            const Text('Payment Method',
                style: TextStyle(fontWeight: FontWeight.bold)),
            RadioGroup<String>(
              groupValue: paymentMethod,
              onChanged: (value) {
                if (value != null) {
                  setState(() => paymentMethod = value);
                }
              },
              child: const Column(
                children: [
                  RadioListTile<String>(
                    value: 'COD',
                    title: Text('Cash on Delivery'),
                  ),
                  RadioListTile<String>(
                    value: 'ONLINE',
                    title:
                        Text('Online Payment (Razorpay/UPI - integrate later)'),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Amount', style: TextStyle(fontSize: 16)),
                Text(
                    '${AppConstants.currencySymbol}${cart.totalAmount.toStringAsFixed(0)}',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary)),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: isPlacingOrder ? null : _placeOrder,
              child: isPlacingOrder
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Text('Place Order'),
            ),
          ],
        ),
      ),
    );
  }
}
