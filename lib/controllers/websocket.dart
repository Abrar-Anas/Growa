import 'dart:convert';

class SensorData {
  final String deviceId;
  final double temperature;
  final double humidity;
  final int soilMoisture;

  SensorData({
    required this.deviceId,
    required this.temperature,
    required this.humidity,
    required this.soilMoisture,
  });

  // This factory handles the nested "data" object from your JSON
  factory SensorData.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return SensorData(
      deviceId: data['device_id'] ?? 'Unknown',
      // We use .toDouble() to ensure 38.5 doesn't crash if it comes as 38
      temperature: (data['temperature'] ?? 0.0).toDouble(),
      humidity: (data['humidity'] ?? 0.0).toDouble(),
      soilMoisture: (data['soil_moisture'] ?? 0).toInt(),
    );
  }
}