// lib/features/favourite/providers/favourite_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/favourite_repository.dart';

final favouriteRepositoryProvider = Provider<FavouriteRepository>((ref) {
  return FavouriteRepository();
});

// Get all favourites
final favouritesProvider = FutureProvider<List<dynamic>>((ref) async {
  final repo = ref.watch(favouriteRepositoryProvider);
  return await repo.getFavourites();
});

// Add to favourites (simple version)
final addToFavouriteProvider = FutureProvider.family<bool, int>((ref, productId) async {
  final repo = ref.watch(favouriteRepositoryProvider);
  final success = await repo.addToFavourites(productId);
  
  if (success) {
    ref.invalidate(favouritesProvider); // Refresh favourites list
  }
  return success;
});

// Remove from favourites
final removeFromFavouriteProvider = FutureProvider.family<bool, int>((ref, productId) async {
  final repo = ref.watch(favouriteRepositoryProvider);
  final success = await repo.removeFromFavourites(productId);
  
  if (success) {
    ref.invalidate(favouritesProvider); // Refresh favourites list
  }
  return success;
});