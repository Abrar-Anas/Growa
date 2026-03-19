import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

/// A stateful, highly animated widget that automatically fetches real-time weather
/// and displays it using a professional Claymorphism design with continuous Lottie icon animations.
class RealtimeWeatherWidget extends StatefulWidget {
  final Color backgroundColor;
  final Color textColor;
  final Color accentColor;

  const RealtimeWeatherWidget({
    Key? key,
    this.backgroundColor = const Color(0xFFE8F5E9), // Professional light green
    this.textColor = const Color(0xFF2E3D36),
    this.accentColor = const Color(0xFF4CAF50),
  }) : super(key: key);

  @override
  State<RealtimeWeatherWidget> createState() => _RealtimeWeatherWidgetState();
}

class _RealtimeWeatherWidgetState extends State<RealtimeWeatherWidget>
    with SingleTickerProviderStateMixin {
  String _location = "Detecting...";
  String _temperature = "--";
  String _condition = "Loading";
  IconData _weatherIcon = Icons.cloud_outlined;
  String _lottieUrl =
      'https://assets1.lottiefiles.com/temp/lf20_VAmWRg.json'; // Default cloud
  bool _isLoading = true;
  String _errorMessage = "";

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    // Continuous animation controller for fallback icon effects
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _fetchWeather();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchWeather() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    try {
      Position position = await _determinePosition();
      await _getWeatherData(position.latitude, position.longitude);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  /// Check location services and request permissions
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    try {
      // 1. Try last known position for speed (bypasses emulator GPS hang)
      Position? lastKnown = await Geolocator.getLastKnownPosition();
      if (lastKnown != null) return lastKnown;

      // 2. Fallback to current position with strict timeout
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw Exception(
            'Timed out waiting for GPS. Make sure location is set in Emulator Extended Controls and open Google Maps once.',
          );
        },
      );
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  /// Map WMO Weather codes from Open-Meteo to readable conditions and Lottie icons
  void _mapWeatherCode(int code) {
    switch (code) {
      case 0:
        _condition = "Clear Sky";
        _weatherIcon = Icons.wb_sunny;
        _lottieUrl =
            'https://assets1.lottiefiles.com/packages/lf20_stqmoiku.json'; // Sun
        break;
      case 1:
      case 2:
      case 3:
        _condition = "Partly Cloudy";
        _weatherIcon = Icons.cloud;
        _lottieUrl =
            'https://assets1.lottiefiles.com/temp/lf20_VAmWRg.json'; // Cloud
        break;
      case 45:
      case 48:
        _condition = "Fog";
        _weatherIcon = Icons.cloud_outlined;
        _lottieUrl = 'https://assets1.lottiefiles.com/temp/lf20_VAmWRg.json';
        break;
      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
        _condition = "Drizzle";
        _weatherIcon = Icons.grain;
        _lottieUrl =
            'https://assets1.lottiefiles.com/temp/lf20_JA2XQk.json'; // Rain
        break;
      case 61:
      case 63:
      case 65:
      case 66:
      case 67:
      case 80:
      case 81:
      case 82:
        _condition = "Rain";
        _weatherIcon = Icons.water_drop;
        _lottieUrl =
            'https://assets1.lottiefiles.com/temp/lf20_JA2XQk.json'; // Rain
        break;
      case 71:
      case 73:
      case 75:
      case 77:
      case 85:
      case 86:
        _condition = "Snow";
        _weatherIcon = Icons.ac_unit;
        _lottieUrl =
            'https://assets1.lottiefiles.com/temp/lf20_WtPCZs.json'; // Snow
        break;
      case 95:
      case 96:
      case 99:
        _condition = "Thunderstorm";
        _weatherIcon = Icons.flash_on;
        _lottieUrl =
            'https://assets1.lottiefiles.com/temp/lf20_Jj2Qzw.json'; // Thunder
        break;
      default:
        _condition = "Unknown";
        _weatherIcon = Icons.broken_image;
        _lottieUrl = 'https://assets1.lottiefiles.com/temp/lf20_VAmWRg.json';
    }
  }

  /// Fetch weather using Open-Meteo API (No Key Required) and Reverse Geocoding
  Future<void> _getWeatherData(double lat, double lon) async {
    // 1. Reverse Geocoding via Nominatim
    final geoUrl =
        'https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$lon&format=json&zoom=10';
    try {
      final geoResponse = await http.get(
        Uri.parse(geoUrl),
        headers: {'User-Agent': 'FlutterWeatherWidget/1.0'},
      );
      if (geoResponse.statusCode == 200) {
        final geoData = json.decode(geoResponse.body);
        _location =
            geoData['name'] ??
            geoData['address']['city'] ??
            geoData['address']['town'] ??
            geoData['address']['county'] ??
            "Unknown Location";
      } else {
        _location =
            "Lat: ${lat.toStringAsFixed(2)}, Lon: ${lon.toStringAsFixed(2)}";
      }
    } catch (e) {
      _location =
          "Lat: ${lat.toStringAsFixed(2)}, Lon: ${lon.toStringAsFixed(2)}";
    }

    // 2. Weather from Open-Meteo (Free)
    final weatherUrl =
        'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current=temperature_2m,weather_code';

    try {
      final response = await http.get(Uri.parse(weatherUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (!mounted) return;
        setState(() {
          double temp = data['current']['temperature_2m'];
          _temperature = '${temp.round()}°C';
          _mapWeatherCode(data['current']['weather_code']);
          _isLoading = false;
        });
      } else {
        if (!mounted) return;
        setState(() {
          _errorMessage = "Failed to fetch weather data.";
          _isLoading = false;
        });
      }
    } catch (e) {
      print("HTTP Error: $e");
      if (!mounted) return;
      setState(() {
        _errorMessage = "Network Error: $e";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutQuart,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(32),
        // Soft, professional Claymorphic shadows for depth
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(8, 12),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.8),
            blurRadius: 24,
            offset: const Offset(-8, -12),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        switchInCurve: Curves.easeOutBack,
        switchOutCurve: Curves.easeInCirc,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.95, end: 1.0).animate(animation),
              child: child,
            ),
          );
        },
        child: _isLoading
            ? _buildAnimatedLoading()
            : _errorMessage.isNotEmpty
            ? _buildErrorView()
            : _buildWeatherView(),
      ),
    );
  }

  Widget _buildAnimatedLoading() {
    return Center(
      key: const ValueKey('loading'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              // Smooth pulsing scale for the loading icon
              final scale =
                  0.8 +
                  0.4 *
                      (0.5 +
                          0.5 *
                              math.sin(
                                _animationController.value * math.pi * 2,
                              ));
              return Transform.scale(
                scale: scale,
                child: Icon(
                  Icons.cloud_outlined,
                  size: 56,
                  color: widget.accentColor.withOpacity(0.8),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            "Detecting Atmosphere...",
            style: TextStyle(
              color: widget.textColor.withOpacity(0.7),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Column(
      key: const ValueKey('error'),
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            // Error icon shake softly left and right
            final offsetX =
                4 * math.sin(_animationController.value * math.pi * 10);
            return Transform.translate(
              offset: Offset(offsetX, 0),
              child: Icon(
                Icons.location_off_rounded,
                color: Colors.red.shade400,
                size: 56,
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        Text(
          _errorMessage,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: widget.textColor.withOpacity(0.8),
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: _fetchWeather,
          icon: Icon(Icons.refresh, color: widget.backgroundColor),
          label: Text(
            'Retry',
            style: TextStyle(
              color: widget.backgroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.textColor,
            elevation: 4,
            shadowColor: widget.textColor.withOpacity(0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherView() {
    return Column(
      key: const ValueKey('weather'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 20,
                        color: widget.accentColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _location,
                          style: TextStyle(
                            color: widget.textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.2,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Text(
                      _condition.toUpperCase(),
                      style: TextStyle(
                        color: widget.accentColor.withAlpha(200),
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return SizedBox(
                  width: 100,
                  height: 100,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      widget.accentColor,
                      BlendMode.srcATop,
                    ),
                    child: Lottie.network(
                      _lottieUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback to our custom implicit animated Icons if Lottie fails!
                        final isSun = _weatherIcon == Icons.wb_sunny;
                        final isThunder = _weatherIcon == Icons.flash_on;
                        final isRain =
                            _weatherIcon == Icons.water_drop ||
                            _weatherIcon == Icons.grain;

                        double offsetY =
                            8 *
                            math.sin(_animationController.value * math.pi * 2);
                        double offsetX = 0.0;
                        double rotation = 0.0;

                        if (isSun) {
                          rotation = _animationController.value * math.pi * 2;
                        } else if (isThunder) {
                          offsetX =
                              4 *
                              math.sin(
                                _animationController.value * math.pi * 20,
                              );
                        } else if (isRain) {
                          offsetY =
                              12 *
                              math.sin(
                                _animationController.value * math.pi * 4,
                              );
                        }

                        return Transform.translate(
                          offset: Offset(offsetX, offsetY),
                          child: Transform.rotate(
                            angle: rotation,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: widget.accentColor.withOpacity(
                                      isThunder &&
                                              (_animationController.value %
                                                      0.2 <
                                                  0.1)
                                          ? 0.6
                                          : 0.15,
                                    ),
                                    blurRadius: isThunder ? 25 : 15,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Icon(
                                _weatherIcon,
                                size: 56,
                                color: widget.accentColor,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutQuart,
          builder: (context, val, child) {
            return Transform.translate(
              offset: Offset(20 * (1 - val), 0),
              child: Opacity(
                opacity: val,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      _temperature.replaceAll(RegExp(r'[^0-9]'), ''),
                      style: TextStyle(
                        color: widget.textColor,
                        fontSize: 64,
                        fontWeight: FontWeight.w900,
                        height: 1.0,
                        letterSpacing: -4,
                      ),
                    ),
                    Text(
                      "°C",
                      style: TextStyle(
                        color: widget.textColor.withOpacity(0.6),
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
