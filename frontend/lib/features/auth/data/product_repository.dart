import 'package:health101/core/network/api_service.dart';

class ProductRepository {
  final ApiService _apiService = ApiService();
  
  // Get products by pharmacy with pagination
  Future<List<dynamic>> getProductsByPharmacy(int pharmacyId, {int skip = 0, int limit = 20}) async {
    try {
      return await _apiService.getProductsByPharmacy(pharmacyId, skip: skip, limit: limit);
    } catch (e) {
      print("Error fetching products: $e");
      return [];
    }
  }
  
  // Get single product detail
  Future<Map<String, dynamic>> getProductById(int productId) async {
    try {
      return await _apiService.getProductById(productId);
    } catch (e) {
      print("Error fetching product detail: $e");
      rethrow;
    }
  }
   // Get ALL products from all pharmacies
    Future<List<dynamic>> getAllProducts({int skip = 0, int limit = 50}) async {
    try {
      return await _apiService.getAllProducts(skip: skip, limit: limit);
    } catch (e) {
      print("Error fetching all products: $e");
      return [];
    }
  }
}
