import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:health101/core/utilis/token_storage.dart';

final dioProvider = Provider<Dio>((ref) => Dio());

final cartCountProvider = StateNotifierProvider<CartNotifier, int>((ref) {
  return CartNotifier();
});  

class CartNotifier extends StateNotifier<int> {
  CartNotifier() : super(0);

  Future<void> fetchCartCount() async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) {
        state = 0;
        return;
      }

      final response = await Dio().get(
        'http://127.0.0.1:8000/cart/count',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      state = response.data['count'] ?? 0;
    } catch (e) {
      state = 0;
    }
  }
}