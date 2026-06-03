// lib/features/favourite/data/favourite_repository.dart
import 'package:health101/core/network/api_service.dart';

class FavouriteRepository {
  final ApiService _apiService = ApiService();

  Future<List<dynamic>> getFavourites() async {
    try {
      return await _apiService.getFavourites();
    } catch (e) {
      print("Error fetching favourites: $e");
      return [];
    }
  }

  Future<bool> addToFavourites(int productId) async {
    try {
      await _apiService.addToFavourites(productId);
      return true;
    } catch (e) {
      print("Error adding to favourites: $e");
      return false;
    }
  }

  Future<bool> removeFromFavourites(int productId) async {
    try {
      await _apiService.removeFromFavourites(productId);
      return true;
    } catch (e) {
      print("Error removing from favourites: $e");
      return false;
    }
  }
}