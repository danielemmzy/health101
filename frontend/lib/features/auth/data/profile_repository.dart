// lib/features/profile/data/profile_repository.dart
import 'package:health101/core/network/api_service.dart';

class ProfileRepository {
  final ApiService _apiService = ApiService();

  // Get current user profile
  Future<Map<String, dynamic>> getProfile() async {
    try {
      return await _apiService.getProfile();
    } catch (e) {
      print("Error fetching profile: $e");
      rethrow;
    }
  }

  // Update user profile
  Future<Map<String, dynamic>> updateProfile({
    String? fullName,
    String? phone,
    String? address,
  }) async {
    try {
      return await _apiService.updateProfile(
        fullName: fullName,
        phone: phone,
        address: address,
      );
    } catch (e) {
      print("Error updating profile: $e");
      rethrow;
    }
  }
}