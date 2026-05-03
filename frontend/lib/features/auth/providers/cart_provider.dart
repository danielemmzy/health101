import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/cart_repository.dart';

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepository();
});

final cartCountProvider = StateNotifierProvider<CartNotifier, int>((ref) {
  return CartNotifier(ref.watch(cartRepositoryProvider));
});

class CartNotifier extends StateNotifier<int> {
  final CartRepository _repository;

  CartNotifier(this._repository) : super(0);

  Future<void> fetchCartCount() async {
    state = await _repository.getCartCount();
  }

  Future<void> addToCart(int productId, {int quantity = 1}) async {
    final success = await _repository.addToCart(productId, quantity: quantity);
    if (success) {
      await fetchCartCount(); // Refresh badge
    }
  }
}