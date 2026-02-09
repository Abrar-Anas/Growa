import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: "growa.nexariccreations.store",
    headers: {
      'Content-Type': 'application/json',
      ''
    }));
}
