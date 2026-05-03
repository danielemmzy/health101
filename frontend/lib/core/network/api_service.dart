import 'package:dio/dio.dart';

class ApiService {
  late final Dio dio;

  ApiService() {
    dio = Dio(
      BaseOptions(
        baseUrl:
            'http://127.0.0.1:8000', // Change to your backend URL when deployed
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }

  // Login - Send as form data (required by FastAPI OAuth2)
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await dio.post(
      '/auth/login',
      data: {'username': email, 'password': password},
      options: Options(
        contentType:
            'application/x-www-form-urlencoded', 
      ),
    );
    return response.data;
  }

  // Register
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    String? fullName,
  }) async {
    final response = await dio.post(
      '/auth/register',
      data: {'email': email, 'password': password, 'full_name': fullName},
      options: Options(
    contentType: Headers.jsonContentType,
  ),
);
    return response.data;
  }

  

  // Cart
  Future<Map<String, dynamic>> getCartCount() async {
    final token = await _getToken();
    final response = await dio.get(
      '/cart/count',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response.data;
  }

  Future<Map<String, dynamic>> addToCart(int productId, {int quantity = 1}) async {
    final token = await _getToken();
    final response = await dio.post(
      '/cart/add',
      data: {'product_id': productId, 'quantity': quantity},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response.data;
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }
}
