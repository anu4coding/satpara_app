import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../repository/order_repository.dart';
import '../backend/firestore_service.dart';
import '../domain/models/order_model.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final orderRepo = OrderRepository(FirestoreService());

    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: StreamBuilder<List<OrderModel>>(
        stream: orderRepo.userOrders(auth.firebaseUser!.uid),
        builder: (context, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final orders = snap.data!;
          if (orders.isEmpty) return const Center(child: Text('No orders yet.'));
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final order = orders[i];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Order #${order.id.substring(0, 6)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(order.status.name.toUpperCase(),
                                style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('${order.items.length} item(s)', style: const TextStyle(color: AppColors.textMuted)),
                      const SizedBox(height: 4),
                      Text('${AppConstants.currencySymbol}${order.totalAmount.toStringAsFixed(0)}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
