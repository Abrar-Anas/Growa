
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:growa/controllers/auth_service.dart';
import 'package:growa/controllers/real_time_weather.dart';
import 'package:get/get.dart';
import 'package:growa/controllers/websocket_controller.dart';
import 'package:growa/view/screens/parameter_details.dart';
import 'dart:math';


/// ==========================================
/// PURE STATELESS CORE DASHBOARD
/// ==========================================
/// This architecture expects state to be passed down
/// from a state management solution (BLoC, Riverpod, Provider, etc.)
class HomeScreen extends StatelessWidget {
  final WebsocketController wsController = Get.put(WebsocketController());

  final String weatherTemp;
  final String weatherCondition;
  final String locationName;
  final IconData weatherIcon;
  final bool isWeatherLoading;

  final List<String> alerts;

  // Interaction Callbacks
  final VoidCallback? onToggleMode;
  final ValueChanged<bool>? onFanToggle;
  final ValueChanged<bool>? onPumpToggle;

  final ApiService apiService = ApiService();

  HomeScreen({
    Key? key,
    this.weatherTemp = '24°C',
    this.weatherCondition = 'Partly cloudy',
    this.locationName = 'Greenhouse 1',
    this.weatherIcon = Icons.cloud_queue_rounded,
    this.isWeatherLoading = false,
    this.alerts = const [
      "Humidity is dropping slightly faster than usual.",
      "Optimal sunlight exposure reached for today.",
      "Soil moisture is perfectly balanced.",
      "System running efficiently.",
    ],
    this.onToggleMode,
    this.onFanToggle,
    this.onPumpToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    // Future<Map<String, dynamic>> fetchNotification() async {
    //   final SharedPreferences prefs = await SharedPreferences.getInstance();
    //   // Get the token (defaulting to empty string if null)
    //   String? token = prefs.getString('token') ?? '';

    //   // 2. Now call your API service using that token
    //   return await apiService.getNotifications(token);
    // }

    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      extendBodyBehindAppBar: true,

      body: Stack(
        children: [
          // Background subtle texture
          Positioned.fill(
            child: Opacity(
              opacity: 0.08,
              child: Image.network(
                'https://images.unsplash.com/photo-1497250681554-fc1da9e34829?q=80&w=800&auto=format&fit=crop',
                fit: BoxFit.cover,
                colorBlendMode: BlendMode.darken,
                color: const Color(0xFF1B5E20),
                errorBuilder: (context, error, stackTrace) =>
                    Container(color: const Color(0xFFE8F5E9)),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 16.0,
              ),
              // Implicit entrance via TweenAnimationBuilder
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeOutCubic,
                builder: (context, animValue, child) {
                  return Opacity(
                    opacity: animValue,
                    child: Transform.translate(
                      offset: Offset(0, 30 * (1 - animValue)),
                      child: child,
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Smart Alerts Feature
                    // SizedBox(
                    //   height: 48,
                    //   child: ListView.builder(
                    //     scrollDirection: Axis.horizontal,
                    //     physics: const BouncingScrollPhysics(),
                    //     itemCount: alerts.length,
                    //     itemBuilder: (context, index) {
                    //       return Padding(
                    //         padding: const EdgeInsets.only(right: 12.0),
                    //         child: FutureBuilder<Map<String, dynamic>>(
                    //           future: fetchNotification(),
                    //           builder: (context, snapshot) {
                    //             if (snapshot.connectionState ==
                    //                 ConnectionState.waiting) {
                    //               return const Center(
                    //                 child: CircularProgressIndicator(),
                    //               );
                    //             } else if (snapshot.hasError) {
                    //               return Center(
                    //                 child: Text('Error: ${snapshot.error}'),
                    //               );
                    //             } else if (!snapshot.hasData ||
                    //                 snapshot.data!.isEmpty) {
                    //               return const Center(
                    //                 child: Text('No notifications found.'),
                    //               );
                    //             }

                    //             final notification = snapshot.data!;

                    //             return ListView.builder(
                    //               itemCount: 5,
                    //               itemBuilder: (context, index) {
                    //                 final note = notification[index];
                    //                 return Card(
                    //                   margin: const EdgeInsets.symmetric(
                    //                     horizontal: 10,
                    //                     vertical: 5,
                    //                   ),
                    //                   child: ListTile(
                    //                     leading: const Icon(
                    //                       Icons.notifications_active,
                    //                       color: Colors.orange,
                    //                     ),
                    //                     // Adjust these keys based on your actual server response body
                    //                     title: Text(
                    //                       "Message: ${notification.toString()}",
                    //                     ),
                    //                     subtitle: Text(
                    //                       note['created_at'] ?? '',
                    //                     ),
                    //                   ),
                    //                 );
                    //               },
                    //             );
                    //           },
                    //         ),
                    //       );
                    //     },
                    //   ),
                    // ),
                    const SizedBox(height: 24),

                    // Weather Card
                    RealtimeWeatherWidget(),
                    const SizedBox(height: 28),

                    const SectionHeader(title: 'Live Telemetry'),
                    const SizedBox(height: 16),
                    Obx(() => ParameterGrid(
                      temperature: FutureBuilder<User>(
                        future: apiService.fetchSensorData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: Text("User"));
                          } else if (snapshot.hasError) {
                            return Center(child: Text("Error"));
                          } else if (snapshot.hasData) {
                            return Text(
                              snapshot.data!.name,
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          return Center(child: Text("No data found"));
                        },
                      ),
                      temp: wsController.temperature.value,
                      humidity: wsController.humidity.value,
                      soilMoisture: wsController.soilMoisture.value,
                      sunlight: wsController.sunlight.value,
                    )),
                    const SizedBox(height: 32),

                    Obx(() => SectionHeader(
                      title: wsController.isAutomated.value
                          ? 'Auto Protocol Active'
                          : 'Manual Overrides',
                    )),
                    const SizedBox(height: 16),
                    Obx(() => SystemControlsClay(
                      isAutomated: wsController.isAutomated.value,
                      fanStatus: wsController.exhaustMode.value,
                      pumpStatus: wsController.pumpMode.value,
                      onFanToggle: (val) {
                        wsController.toggleFan(val);
                        onFanToggle?.call(val);
                      },
                      onPumpToggle: (val) {
                        wsController.togglePump(val);
                        onPumpToggle?.call(val);
                      },
                    )),
                    // Extra space for the plant image
                    
                  ],
                ),
              ),
            ),
          ),

          // Foreground Plant Decoration at base
          Positioned(
            bottom: -40,
            left: -30,
            right: -30,
            child: PointerInterceptor(
              child: Opacity(
                opacity: 0.15,
                child: Image.network(
                  'https://images.unsplash.com/photo-1599598425947-3300262108bf?q=80&w=800&auto=format&fit=crop', // Isolated Monstera leaf style
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Intercepts touches so the decorative image doesn't block scrolling under it
class PointerInterceptor extends StatelessWidget {
  final Widget child;
  const PointerInterceptor({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(child: child);
  }
}

// ==========================================
// STATELESS CLAYMORPHISM UI COMPONENTS
// ==========================================

class ClayContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool concave;
  final Color baseColor;

  const ClayContainer({
    Key? key,
    required this.child,
    this.borderRadius = 32,
    this.padding,
    this.concave = false,
    this.baseColor = const Color(0xFFE8F5E9),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      padding: padding,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: concave
            ? [
                const BoxShadow(
                  color: Colors.white,
                  blurRadius: 10,
                  offset: Offset(-5, -5),
                ),
                BoxShadow(
                  color: const Color(0xFFC8E6C9),
                  blurRadius: 10,
                  offset: const Offset(5, 5),
                ),
              ]
            : [
                const BoxShadow(
                  color: Colors.white,
                  blurRadius: 20,
                  offset: Offset(-10, -10),
                ),
                BoxShadow(
                  color: const Color(0xFFA5D6A7),
                  blurRadius: 20,
                  offset: const Offset(10, 10),
                ),
              ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: concave
              ? [
                  const Color(0xFFE0E0E0).withOpacity(0.1),
                  Colors.white.withOpacity(0.5),
                ]
              : [
                  Colors.white.withOpacity(0.9),
                  const Color(0xFFE8F5E9).withOpacity(0.5),
                ],
        ),
      ),
      child: child,
    );
  }
}

class ClayAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isAutomated;
  final int wsStatus;
  final VoidCallback onToggleMode;

  const ClayAppBar({
    Key? key,
    required this.isAutomated,
    required this.wsStatus,
    required this.onToggleMode,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(70);

  Color get _wsColor => wsStatus == 0
      ? const Color(0xFF10B981)
      : const Color(0xFFEF4444);
  String get _wsText => wsStatus == 0
      ? 'Connected'
      : 'Disconnected';

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 8,
          left: 16,
          right: 16,
        ),
        child: ClayContainer(
          borderRadius: 40,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF66BB6A),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF66BB6A).withOpacity(0.5),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.eco_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Growa',
                    style: TextStyle(
                      color: Color(0xFF1E293B),
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _ModeToggleBadge(
                    isAutomated: isAutomated,
                    onTap: onToggleMode,
                  ),
                  const SizedBox(width: 12),
                  _ConnectionBadgeFull(
                    color: _wsColor,
                    text: _wsText,
                    isPulsing: wsStatus != 0,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModeToggleBadge extends StatelessWidget {
  final bool isAutomated;
  final VoidCallback onTap;

  const _ModeToggleBadge({required this.isAutomated, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClayContainer(
        concave: true, // Pressed in look
        borderRadius: 30,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutBack,
          width: 80,
          height: 34,
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutBack,
                left: isAutomated ? 46 : 4,
                top: 4,
                bottom: 4,
                child: ClayContainer(
                  borderRadius: 20,
                  baseColor: isAutomated
                      ? Colors.white
                      : const Color(0xFF1E293B),
                  child: SizedBox(
                    width: 26,
                    child: Center(
                      child: Icon(
                        isAutomated ? Icons.auto_awesome : Icons.pan_tool,
                        size: 14,
                        color: isAutomated
                            ? const Color(0xFF10B981)
                            : Colors.white,
                      ),
                    ),
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

class _ConnectionBadgeFull extends StatelessWidget {
  final Color color;
  final String text;
  final bool isPulsing;

  const _ConnectionBadgeFull({
    required this.color,
    required this.text,
    required this.isPulsing,
  });

  @override
  Widget build(BuildContext context) {
    bool isDisconnected = text == 'Disconnected';
    
    if (isDisconnected) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFEF4444).withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }
    
    return ClayContainer(
      borderRadius: 20,
      concave: true,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Statelessly mapping connection drops with an implicit AnimatedContainer instead of a complex repeated AnimationController
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.5),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }
}

class ClayChip extends StatelessWidget {
  final String text;
  const ClayChip({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClayContainer(
      borderRadius: 24,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 14,
            color: Color(0xFF1B5E20),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }
}

class WeatherCardClay extends StatelessWidget {
  final bool isLoading;
  final String location;
  final String condition;
  final String temp;
  final IconData icon;

  const WeatherCardClay({
    Key? key,
    required this.isLoading,
    required this.location,
    required this.condition,
    required this.temp,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClayContainer(
      padding: const EdgeInsets.all(24),
      child: isLoading
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          size: 16,
                          color: Color(0xFF64748B),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          location,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      condition,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E293B),
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      temp,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1B5E20),
                        letterSpacing: -2,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(icon, size: 48, color: const Color(0xFFF59E0B)),
                  ],
                ),
              ],
            ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: Color(0xFF1E293B),
        letterSpacing: -0.5,
      ),
    );
  }
}

class ParameterGrid extends StatelessWidget {
  final Widget temperature;
  final double temp;
  final double humidity;
  final double soilMoisture;
  final double sunlight;

  const ParameterGrid({
    Key? key,
    required this.temperature,
    required this.temp,
    required this.humidity,
    required this.soilMoisture,
    required this.sunlight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: 0.85,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      clipBehavior: Clip.none,
      children: [
        ClayGaugeCard(
          title: 'Temperature',
          value: temp,
          minVal: 0,
          maxVal: 50,
          unit: '°C',
          icon: Icons.thermostat_rounded,
        ),
        ClayGaugeCard(
          title: 'Humidity',
          value: humidity,
          minVal: 0,
          maxVal: 100,
          unit: '%',
          icon: Icons.water_drop_outlined,
        ),
        ClayGaugeCard(
          title: 'Moisture',
          value: soilMoisture,
          minVal: 0,
          maxVal: 100,
          unit: '%',
          icon: Icons.grass_rounded,
        ),
        ClayGaugeCard(
          title: 'Air Quality',
          value: sunlight,
          minVal: 0,
          maxVal: 100,
          unit: '%',
          icon: Icons.light_mode_outlined,
        ),
      ],
    );
  }
}

class ClayGaugeCard extends StatelessWidget {
  final String title;
  final double value;
  final double minVal;
  final double maxVal;
  final String unit;
  final IconData icon;

  const ClayGaugeCard({
    Key? key,
    required this.title,
    required this.value,
    required this.minVal,
    required this.maxVal,
    required this.unit,
    required this.icon,
  }) : super(key: key);

  Color _getStatusColor(double normalized) {
    if (normalized < 0.33) return const Color(0xFF10B981);
    if (normalized < 0.66) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  @override
  Widget build(BuildContext context) {
    double normalized = ((value - minVal) / (maxVal - minVal)).clamp(0.0, 1.0);
    Color statusColor = _getStatusColor(normalized);

    // Implicit animation handling statelessly based on data changes over time
    return TweenAnimationBuilder(
      key: ValueKey(title),
      tween: Tween<double>(begin: 0, end: 1), // initial entrance scale
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutBack,
      builder: (context, double scaleVal, child) {
        return Transform.scale(
          scale: scaleVal,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 500),
                  reverseTransitionDuration: const Duration(milliseconds: 400),
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      ParameterDetailScreen(
                        title: title,
                        value: value,
                        min: minVal,
                        max: maxVal,
                        unit: unit,
                        icon: icon,
                        statusColor: statusColor,
                      ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOut,
                          ),
                          child: child,
                        );
                      },
                ),
              );
            },
            child: Hero(
              tag: 'card_$title',
              flightShuttleBuilder:
                  (
                    flightContext,
                    animation,
                    flightDirection,
                    fromHeroContext,
                    toHeroContext,
                  ) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      child: DefaultTextStyle(
                        style: DefaultTextStyle.of(toHeroContext).style,
                        child: toHeroContext.widget,
                      ),
                    );
                  },
              child: Material(
                type: MaterialType.transparency,
                child: ClayContainer(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ClayContainer(
                            concave: true,
                            borderRadius: 12,
                            padding: const EdgeInsets.all(6),
                            child: Icon(icon, color: statusColor, size: 18),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF64748B),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Center(
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white,
                                        blurRadius: 4,
                                        offset: Offset(-2, -2),
                                      ),
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 4,
                                        offset: Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                  // Animate the actual gauge value drawing statelessly
                                  child: TweenAnimationBuilder<double>(
                                    tween: Tween(begin: 0, end: normalized),
                                    duration: const Duration(milliseconds: 600),
                                    curve: Curves.easeOutCubic,
                                    builder: (context, animValue, _) {
                                      return CustomPaint(
                                        size: const Size(100, 100),
                                        painter: _ClayGaugePainter(
                                          value: animValue,
                                          color: statusColor,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    '${value.toStringAsFixed(1)}$unit',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF1E293B),
                                      letterSpacing: -1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class SystemControlsClay extends StatelessWidget {
  final bool isAutomated;
  final bool fanStatus;
  final bool pumpStatus;
  final ValueChanged<bool> onFanToggle;
  final ValueChanged<bool> onPumpToggle;

  const SystemControlsClay({
    Key? key,
    required this.isAutomated,
    required this.fanStatus,
    required this.pumpStatus,
    required this.onFanToggle,
    required this.onPumpToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ControlCard(
            title: 'Ventilation',
            subtitle: 'Air Circulation',
            icon: Icons.mode_fan_off_rounded,
            isActive: fanStatus,
            activeColor: const Color(0xFF3B82F6),
            isManual: !isAutomated,
            onChanged: onFanToggle,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ControlCard(
            title: 'Irrigation',
            subtitle: 'Water Supply',
            icon: Icons.water_drop_rounded,
            isActive: pumpStatus,
            activeColor: const Color(0xFF10B981),
            isManual: !isAutomated,
            onChanged: onPumpToggle,
          ),
        ),
      ],
    );
  }
}

class ControlCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isActive;
  final Color activeColor;
  final bool isManual;
  final ValueChanged<bool> onChanged;

  const ControlCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isActive,
    required this.activeColor,
    required this.isManual,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClayContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClayContainer(
                concave: true,
                padding: const EdgeInsets.all(8),
                borderRadius: 14,
                child: Icon(
                  icon,
                  color: isActive ? activeColor : Colors.grey.shade400,
                  size: 20,
                ),
              ),
              isManual
                  ? Switch(
                      value: isActive,
                      onChanged: onChanged,
                      activeColor: Colors.white,
                      activeTrackColor: activeColor,
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: Colors.grey.shade300,
                    )
                  : ClayContainer(
                      concave: true,
                      borderRadius: 12,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      child: Text(
                        isActive ? 'ON' : 'OFF',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: isActive ? activeColor : Colors.grey.shade400,
                        ),
                      ),
                    ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClayGaugePainter extends CustomPainter {
  final double value;
  final Color color;
  _ClayGaugePainter({required this.value, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint trackPaint = Paint()
      ..color = const Color(0xFFE0E0E0).withOpacity(0.5)
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    Paint progressPaint = Paint()
      ..color = color
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2) - 8;
    double startAngle = pi * 0.75;
    double sweepAngle = pi * 1.5;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      trackPaint,
    );
    double progressAngle = sweepAngle * value;
    if (value > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        progressAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ClayGaugePainter oldDelegate) =>
      oldDelegate.value != value || oldDelegate.color != color;
}
