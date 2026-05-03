import 'package:health101/core/network/api_service.dart';

class CartRepository {
  final ApiService _apiService = ApiService();

  Future<int> getCartCount() async {
    try {
      final data = await _apiService.getCartCount();
      return data['count'] ?? 0;
    } catch (e) {
      return 0;
    }
  }

  Future<bool> addToCart(int productId, {int quantity = 1}) async {
    try {
      await _apiService.addToCart(productId, quantity: quantity);
      return true;
    } catch (e) {
      return false;
    }
  }
}