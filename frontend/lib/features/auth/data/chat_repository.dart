import 'package:health101/core/network/api_service.dart';

class ChatRepository {
  final ApiService _apiService = ApiService();

  Future<List<dynamic>> getChatHistory(int consultationId, {int skip = 0, int limit = 50}) async {
    try {
      return await _apiService.getChatHistory(consultationId, skip: skip, limit: limit);
    } catch (e) {
      print("Error fetching chat history: $e");
      return [];
    }
  }
}