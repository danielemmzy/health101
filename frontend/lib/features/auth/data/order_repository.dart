import 'package:health101/core/network/api_service.dart';

class OrderRepository {
  final ApiService _apiService = ApiService();

  Future<List<dynamic>> getMyOrders() async {
    try {
      return await _apiService.getMyOrders();
    } catch (e) {
      print("Error fetching orders: $e");
      return [];
    }
  }

  Future<Map<String, dynamic>> getOrderById(int orderId) async {
    try {
      return await _apiService.getOrderById(orderId);
    } catch (e) {
      print("Error fetching order detail: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> checkout({
    required String deliveryAddress,
    required int pharmacyId,
    String paymentMethod = "cash",
  }) async {
    try {
      final data = {
        "delivery_address": deliveryAddress,
        "pharmacy_id": pharmacyId,
        "payment_method": paymentMethod,
      };
      return await _apiService.checkout(data);
    } catch (e) {
      print("Error during checkout: $e");
      rethrow;
    }
  }
}