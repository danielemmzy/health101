import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/network/api_service.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();

  Future<String> login(String email, String password) async {
    final data = await _apiService.login(email, password);
    final token = data['access_token'];

    // Save token locally
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);

    return token;
  }

  Future<String> register({
    required String email,
    required String password,
    String? fullName,
  }) async {
    final data = await _apiService.register(
      email: email,
      password: password,
      fullName: fullName,
    );
    final token = data['access_token'] ?? '';

    if (token.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', token);
    }
    return token;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }
}