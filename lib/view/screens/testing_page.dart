import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebsocketTesting extends StatefulWidget {
  final String websocketUrl;

  const WebsocketTesting({
    Key? key,
    // TODO: Update this URL to match your server's address
    this.websocketUrl =
        'ws://51.21.132.209/app/nywcgjbzz5yhljss7pbt?protocol=7&client=js&version=8.4.0-rc2&flash=false',
  }) : super(key: key);

  @override
  State<WebsocketTesting> createState() => _WebsocketTestingState();
}

class _WebsocketTestingState extends State<WebsocketTesting> {
  late WebSocketChannel _channel;
  double? _humidity;
  String? _statusMessage;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _connectWebSocket();
  }

  void _connectWebSocket() {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(widget.websocketUrl));

      setState(() {
        _isConnected = true;
        _statusMessage = 'Connecting...';
      });

      _channel.stream.listen(
        (message) {
          try {
            // Parse the incoming JSON string from the WebSocket
            final decodedData = jsonDecode(message);

            // Expected JSON structure from Postman:
            // {
            //     "message": "...",
            //     "stored": true/false,
            //     "data": { "device_id": "...", "temperature": ..., "humidity": 5.2, ... }
            // }

            // Extract the nested 'data' map and then the 'humidity' value
            if (decodedData != null && decodedData['data'] != null) {
              final Map<String, dynamic> sensorData = decodedData['data'];

              if (sensorData.containsKey('humidity')) {
                setState(() {
                  _humidity = (sensorData['humidity'] as num).toDouble();
                  _statusMessage =
                      decodedData['message'] ?? 'Sensor data updated';
                });
              } else {
                setState(() {
                  _statusMessage = 'Humidity data not found in response';
                });
              }
            } else {
              // Not a standard data packet, but log the message anyway
              setState(() {
                _statusMessage =
                    decodedData['message'] ?? 'Waiting for humidity data...';
              });
            }
          } catch (e) {
            debugPrint('Error parsing incoming data: $e');
          }
        },
        onDone: () {
          setState(() {
            _isConnected = false;
            _statusMessage = 'WebSocket closed by server';
          });
        },
        onError: (error) {
          setState(() {
            _isConnected = false;
            _statusMessage = 'WebSocket connection error: $error';
          });
        },
      );
    } catch (e) {
      setState(() {
        _isConnected = false;
        _statusMessage = 'Failed to connect: $e';
      });
    }
  }

  /// Optional: Use this to test sending a mock payload to the server containing a dummy humidity.
  void _sendMockData() {
    if (_isConnected) {
      final mockPayload = {
        "device_id": "GH-TEST123",
        "temperature": 38.5,
        "humidity": 45.0, // Mock humidity
        "soil_moisture": 95.0,
      };

      // We send the JSON text. Make sure your server is expecting text JSON frames
      _channel.sink.add(jsonEncode(mockPayload));
    }
  }

  @override
  void dispose() {
    // Close the connection immediately when leaving this screen
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('WebSocket Humidity Test'),
        elevation: 0,
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.water_drop,
                  size: 64,
                  color: _isConnected ? Colors.blueAccent : Colors.grey,
                ),
              ),
              const SizedBox(height: 32),

              const Text(
                'Live Humidity',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              // Display the dynamic humidity reading
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _isConnected
                        ? Colors.blue.withOpacity(0.3)
                        : Colors.grey.shade300,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Text(
                  _humidity != null
                      ? '${_humidity!.toStringAsFixed(1)} %'
                      : '-- %',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: _isConnected ? Colors.blueAccent : Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Status indicator
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isConnected ? Colors.green : Colors.red,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _statusMessage ?? 'Disconnected',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),

              // Useful for manual simulation if necessary
              ElevatedButton.icon(
                onPressed: _isConnected ? _sendMockData : null,
                icon: const Icon(Icons.send),
                label: const Text('Send Mock Data'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
