import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://growa.nexariccreations.store/api/",
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  Future<Response?> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );
      return response;
    } on DioException catch (e) {
      return e.response;
    }
  }

  Future<Response?> signUp(String name, String email, String password, String confirmPassword) async {
    try {
      final respone = await _dio.post(
        '/register',
        data: {'name': name, 'email': email, 'password': password, 'password_confirmation' : confirmPassword},
      );
      return respone;
    } on DioException catch (e) {
      return e.response;
    }
  }

  Future<User> fetchUserData() async {
    try {
      // Replace with your actual API endpoint
      final response = await _dio.get('https://growa.nexariccreations.store/api/');
      
      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      } else {
        throw Exception('Failed to load user');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }
}

class User {
  final String name;
  final String email;

  User({required this.name, required this.email});

  // A factory method to convert JSON into a User object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
    );
  }
}