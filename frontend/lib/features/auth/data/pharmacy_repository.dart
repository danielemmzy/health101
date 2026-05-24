import 'package:health101/core/network/api_service.dart';

class PharmacyRepository {
  final ApiService _apiService = ApiService();

  Future<List<dynamic>> getNearbyPharmacies({
    required double lat,
    required double lon,
    double radiusKm = 10.0,
    int limit = 10,
  }) async {
    try {
      return await _apiService.getNearbyPharmacies(
        lat: lat,
        lon: lon,
        radiusKm: radiusKm,
        limit: limit,
      );
    } catch (e) {
      print("Error fetching nearby pharmacies: $e");
      return [];
    }
  }
  Future<Map<String, dynamic>> getPharmacyById(int pharmacyId) async {
    try {
      final data = await _apiService.getPharmacyById(pharmacyId);
      return data;
    } catch (e) {
      print("Error fetching pharmacy detail: $e");
      rethrow;
    }
  }
}