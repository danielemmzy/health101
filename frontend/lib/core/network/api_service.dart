import 'package:dio/dio.dart';
import 'package:health101/core/utilis/token_storage.dart';

class ApiService {
  late final Dio dio;

  ApiService() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'http://127.0.0.1:8000',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Global Interceptor - Automatically adds Bearer token to ALL requests
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await TokenStorage.getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        } else {
          print("⚠️ No token found for request: ${options.uri}");
        }
        return handler.next(options);
      },
      onError: (error, handler) {
        print("❌ API Error [${error.response?.statusCode}]: ${error.response?.data}");
        return handler.next(error);
      },
    ));

    // Optional: Log all requests (helpful for debugging)
    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }

  // ==================== AUTH ====================
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await dio.post(
      '/auth/login',
      data: {'username': email, 'password': password},
      options: Options(contentType: 'application/x-www-form-urlencoded'),
    );
    return response.data;
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    String? fullName,
  }) async {
    final response = await dio.post(
      '/auth/register',
      data: {'email': email, 'password': password, 'full_name': fullName},
    );
    return response.data;
  }

  // ==================== CART ====================
  Future<Map<String, dynamic>> getCartCount() async {
    final response = await dio.get('/cart/count');
    return response.data;
  }

  Future<Map<String, dynamic>> addToCart(int productId, {int quantity = 1}) async {
    final response = await dio.post(
      '/cart/add',
      data: {'product_id': productId, 'quantity': quantity},
    );
    return response.data;
  }

  // ==================== CONSULTATIONS ====================
  Future<List<dynamic>> getAvailableDoctors() async {
    final response = await dio.get('/consultations/doctors');
    return response.data as List<dynamic>;
  }

  Future<List<dynamic>> getMyConsultations() async {
    final response = await dio.get('/consultations/me');
    return response.data as List<dynamic>;
  }

  Future<dynamic> bookConsultation(Map<String, dynamic> data) async {
    final response = await dio.post('/consultations/', data: data);
    return response.data;
  }

  // ==================== PRODUCTS ====================
  Future<List<dynamic>> getAllProducts({int skip = 0, int limit = 50}) async {
    final response = await dio.get(
      '/products',
      queryParameters: {'skip': skip, 'limit': limit},
    );
    return response.data as List<dynamic>;
  }

  Future<List<dynamic>> getProductsByPharmacy(int pharmacyId, {int skip = 0, int limit = 20}) async {
    final response = await dio.get(
      '/products/pharmacy/$pharmacyId',
      queryParameters: {'skip': skip, 'limit': limit},
    );
    return response.data as List<dynamic>;
  }

  Future<Map<String, dynamic>> getProductById(int productId) async {
    final response = await dio.get('/products/$productId');
    return response.data as Map<String, dynamic>;
  }

  // ==================== PHARMACIES ====================
  Future<List<dynamic>> getNearbyPharmacies({
    required double lat,
    required double lon,
    double radiusKm = 10.0,
    int limit = 10,
  }) async {
    final response = await dio.get(
      '/pharmacies/nearby',
      queryParameters: {'lat': lat, 'lon': lon, 'radius_km': radiusKm, 'limit': limit},
    );
    return response.data as List<dynamic>;
  }

  Future<Map<String, dynamic>> getPharmacyById(int pharmacyId) async {
    final response = await dio.get('/pharmacies/$pharmacyId');
    return response.data as Map<String, dynamic>;
  }

  // ==================== DOCTORS ====================
  Future<List<dynamic>> getTopDoctors({int limit = 10}) async {
    final response = await dio.get('/doctors/top?limit=$limit');
    return response.data as List<dynamic>;
  }

  Future<Map<String, dynamic>> getDoctorDetail(int doctorId) async {
    final response = await dio.get('/doctors/$doctorId');
    return response.data as Map<String, dynamic>;
  }
}


