import 'dart:convert';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:io';

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

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      deviceId: json['device_id'] ?? 'Unknown',
      temperature: (json['temperature'] ?? 0.0).toDouble(),
      humidity: (json['humidity'] ?? 0.0).toDouble(),
      soilMoisture: (json['soil_moisture'] ?? 0).toInt(),
    );
  }
}

class WebsocketController extends GetxController {
  WebSocketChannel? channel;

  // Connection status: 0 connected, 1 reconnecting, 2 disconnected
  var wsStatus = 2.obs;

  // Sensor observables
  var temperature = 23.5.obs;
  var humidity = 60.0.obs;
  var soilMoisture = 45.0.obs;
  var sunlight = 75.0.obs; // Simulated if not from WS

  // Control observables
  var pumpMode = false.obs;
  var exhaustMode = false.obs; // Ventilation/Fan
  var acMode = false.obs;
  var isAutomated = true.obs;

  @override
  void onInit() {
    super.onInit();
    connectToWebSocket();
  }

  Future<void> connectToWebSocket() async {
    try {
      wsStatus.value = 1; // Reconnecting

      // Close existing channel if any
      channel?.sink.close();
      channel = null;

      final ws = await WebSocket.connect(
        "ws://16.16.57.108/app/nywcgjbzz5yhljss7pbt?protocol=7&client=js&version=8.4.0-rc2&flash=false",
      ).timeout(const Duration(seconds: 10));

      // This enables auto-pinging on the mobile platform.
      // If network suddenly drops, the ping fails, and the stream instantly triggers onDone/onError.
      ws.pingInterval = const Duration(seconds: 5);

      channel = IOWebSocketChannel(ws);

      // Listen to the stream
      channel?.stream.listen(
        (message) {
          wsStatus.value = 0; // Connected
          _handleMessage(message);
        },
        onDone: () {
          wsStatus.value = 2; // Disconnected
          _reconnect();
        },
        onError: (error) {
          wsStatus.value = 2; // Disconnected
          _reconnect();
        },
      );

      // Subscribe to the channel
      _subscribe();
    } catch (e) {
      wsStatus.value = 2;
      _reconnect();
    }
  }

  void _subscribe() {
    final subscriptionMessage = {
      "event": "pusher:subscribe",
      "data": {
        "channel": "control.GH-112233"
      }
    };
    channel?.sink.add(jsonEncode(subscriptionMessage));
  }

  void _handleMessage(dynamic message) {
    try {
      final decodedMessage = jsonDecode(message);
      
      if (decodedMessage['event'] == 'App\\Events\\ControlUpdated') {
        final dataString = decodedMessage['data'];
        if (dataString != null && dataString is String) {
          final dataJson = jsonDecode(dataString);
          
          pumpMode.value = dataJson['pumpMode'] ?? pumpMode.value;
          exhaustMode.value = dataJson['exhaustMode'] ?? exhaustMode.value;
          acMode.value = dataJson['acMode'] ?? acMode.value;

          if (dataJson['data'] != null) {
            final sensorData = SensorData.fromJson(dataJson['data']);
            temperature.value = sensorData.temperature;
            humidity.value = sensorData.humidity;
            soilMoisture.value = sensorData.soilMoisture.toDouble();

            // Set fixed or placeholder if needed
            // sunlight.value = 75.0; 
          }
        }
      } else if (decodedMessage['event'] == 'pusher:connection_established') {
         wsStatus.value = 0;
      }
    } catch (e) {
      print("Error parsing websocket message: $e");
    }
  }

  void _reconnect() {
    Future.delayed(const Duration(seconds: 5), () {
      if (wsStatus.value != 0) {
        connectToWebSocket();
      }
    });
  }

  void toggleMode() {
    isAutomated.value = !isAutomated.value;
  }

  void toggleFan(bool value) {
    exhaustMode.value = value;
    // Potentially send update to server
  }

  void togglePump(bool value) {
    pumpMode.value = value;
    // Potentially send update to server
  }

  @override
  void onClose() {
    channel?.sink.close();
    super.onClose();
  }
}
