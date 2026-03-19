import 'package:dio/dio.dart';
class Weather {
  final double temperature;
  final double windspeed;
  final int weatherCode;

  Weather({
    required this.temperature,
    required this.windspeed,
    required this.weatherCode,
  });

  // A factory constructor to convert JSON into a Weather object
  factory Weather.fromJson(Map<String, dynamic> json) {
    final current = json['current_weather'];
    return Weather(
      temperature: current['temperature'],
      windspeed: current['windspeed'],
      weatherCode: current['weathercode'],
    );
  }
}

class WeatherService {
  final Dio _dio = Dio();

  Future<Weather> fetchWeather(double lat, double lon) async {
    try {
      final response = await _dio.get(
        'https://api.open-meteo.com/v1/forecast',
        queryParameters: {
          'latitude': lat,
          'longitude': lon,
          'current_weather': true,
        },
      );

      if (response.statusCode == 200) {
        return Weather.fromJson(response.data);
      } else {
        throw Exception("Failed to load weather");
      }
    } on DioException catch (e) {
      // Dio gives you specific error types (timeout, response error, etc.)
      throw Exception("Network Error: ${e.message}");
    }
  }
}