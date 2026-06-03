import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/cart_repository.dart';

final cartRepositoryProvider = Provider<CartRepository>((ref) => CartRepository());

// Main Cart Provider
final cartProvider = FutureProvider<List<dynamic>>((ref) async {
  final repo = ref.watch(cartRepositoryProvider);
  return await repo.getCart();
});

// Cart Count Provider (for badge)
final cartCountProvider = StateNotifierProvider<CartCountNotifier, int>((ref) {
  final repo = ref.watch(cartRepositoryProvider);
  return CartCountNotifier(repo);
});

class CartCountNotifier extends StateNotifier<int> {
  final CartRepository _repository;

  CartCountNotifier(this._repository) : super(0);

  Future<void> fetchCartCount() async {
    final count = await _repository.getCartCount();
    state = count;
  }

  void increment() => state++;
  void decrement() => state = state > 0 ? state - 1 : 0;
}

// Add to Cart Action
final addToCartProvider = FutureProvider.family<void, Map<String, dynamic>>((ref, params) async {
  final repo = ref.watch(cartRepositoryProvider);
  await repo.addToCart(params['productId'], quantity: params['quantity'] ?? 1);
  ref.read(cartCountProvider.notifier).fetchCartCount(); // Refresh count
});