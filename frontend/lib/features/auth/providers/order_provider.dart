import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/order_repository.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepository();
});

// My Orders Provider
final myOrdersProvider = FutureProvider<List<dynamic>>((ref) async {
  final repo = ref.watch(orderRepositoryProvider);
  return await repo.getMyOrders();
});

// Single Order Detail
final orderDetailProvider = FutureProvider.family<Map<String, dynamic>, int>((ref, orderId) async {
  final repo = ref.watch(orderRepositoryProvider);
  return await repo.getOrderById(orderId);
});

// Checkout Provider
final checkoutProvider = FutureProvider.family<Map<String, dynamic>, Map<String, dynamic>>((ref, data) async {
  final repo = ref.watch(orderRepositoryProvider);
  return await repo.checkout(
    deliveryAddress: data['delivery_address'],
    pharmacyId: data['pharmacy_id'],
    paymentMethod: data['payment_method'] ?? "cash",
  );
});