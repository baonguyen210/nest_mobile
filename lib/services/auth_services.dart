import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: "https://platform-family.onrender.com", // Thay bằng API của bạn
    headers: {
      "Content-Type": "application/json",
    },
  ));

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        "/login",
        data: {
          "email": email,
          "password": password,
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Failed to login: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Login error: $e");
    }
  }
}
