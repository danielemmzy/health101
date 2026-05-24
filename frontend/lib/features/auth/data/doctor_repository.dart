import 'package:health101/core/network/api_service.dart';

class DoctorRepository {
  final ApiService _apiService = ApiService();

  // Get top doctors with pagination
  Future<List<dynamic>> getTopDoctors({int limit = 10}) async {
    try {
      final data = await _apiService.getTopDoctors(limit: limit);
      return data;
    } catch (e) {
      print("Error fetching top doctors: $e");
      return [];
    }
  }
  // NEW: Get single doctor details
  Future<Map<String, dynamic>> getDoctorDetail(int doctorId) async {
    try {
      final data = await _apiService.getDoctorDetail(doctorId);
      return data;
    } catch (e) {
      print("Error fetching doctor detail: $e");
      return {};
    }
  }
}