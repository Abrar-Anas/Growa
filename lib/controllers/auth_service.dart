import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl:
          'https://growa.nexariccreations.store/api/', // Add trailing slash
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 5),
      headers: {'Accept': 'application/json'},
    ),
  );

  /// Save Token to SharedPreferences
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  /// Get Token from SharedPreferences
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  /// Sign In Method
  Future<Response?> signIn(String email, String password) async {
    try {
      FormData formData = FormData.fromMap({
        'email': email,
        'password': password,
      });

      final response = await _dio.post(
        'login',
        data: formData,
      ); // Remove leading slash

      if (response.statusCode == 200 || response.statusCode == 201) {
        String? token = response.data['access_token'] ?? response.data['token'];
        if (token != null) {
          await _saveToken(token);
        }
      }
      return response;
    } on DioException catch (e) {
      debugPrint('Sign In Error: ${e.response?.data ?? e.message}');
      rethrow;
    }
  }

  /// Sign Up Method
  Future<Response?> signUp({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      });

      final response = await _dio.post(
        'register',
        data: formData,
      ); // Remove leading slash

      if (response.statusCode == 200 || response.statusCode == 201) {
        String? token = response.data['access_token'] ?? response.data['token'];
        if (token != null) {
          await _saveToken(token);
        }
      }
      return response;
    } on DioException catch (e) {
      debugPrint('Sign Up Error: ${e.response?.data ?? e.message}');
      rethrow;
    }
  }

  /// Logout Method
  Future<Response?> logout() async {
    try {
      String? token = await getToken();
      final response = await _dio.post(
        'logout', // Remove leading slash
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('auth_token');
      }
      return response;
    } on DioException catch (e) {
      debugPrint('Logout Error: ${e.response?.data ?? e.message}');
      rethrow;
    }
  }
}
