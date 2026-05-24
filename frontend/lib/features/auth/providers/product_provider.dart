import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/product_repository.dart';

// Provider for ProductRepository
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository();
});

// Provider for fetching products by pharmacy
final productsByPharmacyProvider = FutureProvider.family<List<dynamic>, int>(
  (ref, pharmacyId) async {
    final repository = ref.watch(productRepositoryProvider);
    return await repository.getProductsByPharmacy(pharmacyId);
  },
);

// Provider for fetching single product details
final productDetailProvider = FutureProvider.family<Map<String, dynamic>, int>(
  (ref, productId) async {
    final repository = ref.watch(productRepositoryProvider);
    return await repository.getProductById(productId);
  },
);

// NEW: Provider for fetching ALL products from all pharmacies
final allProductsProvider = FutureProvider<List<dynamic>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return await repository.getAllProducts();
});