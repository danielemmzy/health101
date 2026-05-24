import 'package:health101/core/network/api_service.dart';

class ConsultationRepository {
  final ApiService _apiService = ApiService();

  Future<List<dynamic>> getAvailableDoctors() async {
    try {
      return await _apiService.getAvailableDoctors();
    } catch (e) {
      print("Error fetching doctors: $e");
      return [];
    }
  }

  Future<List<dynamic>> getMyConsultations() async {
    try {
      return await _apiService.getMyConsultations();
    } catch (e) {
      print("Error fetching my consultations: $e");
      return [];
    }
  }

  Future<dynamic> bookConsultation(Map<String, dynamic> data) async {
    try {
      return await _apiService.bookConsultation(data);
    } catch (e) {
      print("Error booking consultation: $e");
      rethrow;
    }
  }
}