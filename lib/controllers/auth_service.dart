import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://51.21.132.209/api/",
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

  Future<Map<String, dynamic>> getNotifications(String token) async {
    try {
      final response = await _dio.get(
        '/notifications',

        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Assuming the server returns a list of notifications
        return response.data;
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      throw Exception('Error fetching notifications: $e');
    }
  }

  Future<Response?> signUp(
    String name,
    String email,
    String password,
    String confirmPassword,
    String productID,
    String address,
    String city,
    String state,
    String pincode,
    String greenhouseName,
  ) async {
    try {
      final respone = await _dio.post(
        '/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': confirmPassword,
          'product_id': productID,
          'address': address,
          'city': city,
          'state': state,
          'pincode': pincode,
          'greenhouse_name': greenhouseName,
        },
      );
      return respone;
    } on DioException catch (e) {
      return e.response;
    }
  }

  Future<NotificationModel> fetchNotification() async {
    try {
      final response = await _dio.get("http://51.21.132.209/api/");
      // Assuming the response body is the JSON object { "id": 1, "message": "..." }
      return NotificationModel.fromJson(response.data);
    } catch (e) {
      throw Exception("Failed to load notification");
    }
  }

  Future<User> fetchSensorData() async {
    try {
      // Replace with your actual API endpoint
      final response = await _dio.get(
        'https://growa.nexariccreations.store/api/',
      );

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
    return User(name: json['name'], email: json['email']);
  }
}

class Sensor {
  final String temperature;
  final String email;

  Sensor({required this.temperature, required this.email});

  // A factory method to convert JSON into a User object
  factory Sensor.fromJson(Map<String, dynamic> json) {
    return Sensor(temperature: json['name'], email: json['email']);
  }
}

class NotificationModel {
  final int id;
  final String message;

  NotificationModel({required this.id, required this.message});

  // Factory to create an instance from JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      message: json['message'],
    );
  }
}