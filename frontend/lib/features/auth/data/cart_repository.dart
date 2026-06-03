// lib/features/cart/data/cart_repository.dart
import 'package:health101/core/network/api_service.dart';

class CartRepository {
  final ApiService _apiService = ApiService();

  Future<List<dynamic>> getCart() async {
    try {
      return await _apiService.getCart();
    } catch (e) {
      print("Error fetching cart: $e");
      return [];
    }
  }

  Future<int> getCartCount() async {
    try {
      final data = await _apiService.getCartCount();
      return data['count'] ?? 0;
    } catch (e) {
      print("Error fetching cart count: $e");
      return 0;
    }
  }

  Future<dynamic> addToCart(int productId, {int quantity = 1}) async {
    try {
      return await _apiService.addToCart(productId, quantity: quantity);
    } catch (e) {
      print("Error adding to cart: $e");
      rethrow;
    }
  }

  Future<void> clearCart() async {
    try {
      await _apiService.clearCart();
    } catch (e) {
      print("Error clearing cart: $e");
    }
  }
}