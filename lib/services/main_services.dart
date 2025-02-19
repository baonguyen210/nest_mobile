import 'package:dio/dio.dart';

class ApiService {
  final String baseUrl = "https://platform-family.onrender.com"; // API URL
  final Dio _dio = Dio(BaseOptions(
    baseUrl: "https://platform-family.onrender.com",
    headers: {
      "Content-Type": "application/json",
    },
  ));

  Future<Map<String, dynamic>> postRequest(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await _dio.post(endpoint, data: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception("Failed to fetch data: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
