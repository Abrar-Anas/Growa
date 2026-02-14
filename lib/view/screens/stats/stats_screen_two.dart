import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:growa/model/growth_analysis_chart.dart';

class StatsScreenTwo extends StatelessWidget {
  const StatsScreenTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. High-Resolution Background
          Positioned.fill(
            child: Image.asset(
              "assets/image/background_plant.png",
              fit: BoxFit.cover,
            ),
          ),
          // 2. Subtle Gradient Overlay for Readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.4),
                    Colors.black.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.6),
                  ],
                ),
              ),
            ),
          ),

          // 3. Main Content
          SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0).w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    30.verticalSpace,

                    Text(
                      "Real-time Data",
                      style: TextStyle(
                        fontSize: 34.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const Text(
                      "VITAL STATISTICS",
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2,
                      ),
                    ),
                    30.verticalSpace,

                    // The Grid of Glass Cards
                    SizedBox(
                      height: 450.h,
                      width: double.infinity,
                      child: GridView.count(
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        childAspectRatio: 0.82,
                        children: const [
                          GlassConditionCard(
                            label: "Light",
                            value: 78,
                            unit: "lx",
                            icon: Icons.light_mode,
                            color: Colors.orangeAccent,
                          ),
                          GlassConditionCard(
                            label: "Moisture",
                            value: 15,
                            unit: "%",
                            icon: Icons.water_drop,
                            color: Colors.blueAccent,
                          ),
                          GlassConditionCard(
                            label: "Humidity",
                            value: 55,
                            unit: "%",
                            icon: Icons.cloud_queue,
                            color: Colors.cyanAccent,
                          ),
                          GlassConditionCard(
                            label: "Fertilizer",
                            value: 42,
                            unit: "mg",
                            icon: Icons.auto_awesome,
                            color: Colors.greenAccent,
                          ),
                        ],
                      ),
                    ),
                    30.verticalSpace,

                    ClipRRect(
                      borderRadius: BorderRadius.circular(20).r,
                      child: Container(
                        width: 400.w,
                        height: 400.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20).r,
                          // 1. Add a subtle border to define the glass edges
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                            width: 1.5,
                          ),
                          // 2. Use a semi-transparent gradient
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withValues(alpha: 0.2),
                              Colors.white.withValues(alpha: 0.05),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              offset: const Offset(0, 4),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: BackdropFilter(
                          // 3. Apply the blur effect
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(18.0).r,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Growth Analysis",
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "month",
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_drop_down_outlined,
                                      size: 25,
                                    ),
                                  ],
                                ),
                                2.verticalSpace,
                                Text(
                                  "1 Month Growth Time-Lapse",
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 12.sp,
                                  ),
                                ),
                                5.verticalSpace,
                                Divider(height: 1.h, color: Colors.black12),
                                const Spacer(),
                                const PlantGrowthChart(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    30.verticalSpace,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GlassConditionCard extends StatelessWidget {
  final String label;
  final double value;
  final String unit;
  final IconData icon;
  final Color color;

  const GlassConditionCard({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Outer shadow for the "Floating" effect
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 25.r,
            spreadRadius: -5,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 4),
                  blurRadius: 8.r,
                ),
              ],
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(28).r,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25),
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: Colors.white70, size: 16),
                    8.verticalSpace,
                    Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Gauge Widget
                SizedBox(
                  height: 90.h,
                  child: AnimatedRadialGauge(
                    duration: const Duration(seconds: 1),
                    value: value,
                    axis: GaugeAxis(
                      min: 0,
                      max: 100,
                      degrees: 180,
                      style: const GaugeAxisStyle(
                        thickness: 10,
                        background: Colors.white10,
                        segmentSpacing: 4,
                      ),
                      segments: [
                        const GaugeSegment(
                          from: 0,
                          to: 33,
                          color: Colors.redAccent,
                        ),
                        const GaugeSegment(
                          from: 33,
                          to: 66,
                          color: Colors.yellowAccent,
                        ),
                        const GaugeSegment(
                          from: 66,
                          to: 100,
                          color: Colors.greenAccent,
                        ),
                      ],
                      pointer: GaugePointer.needle(
                        color: Colors.white,
                        width: 8,
                        height: 35,
                        borderRadius: 5,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  "${value.toInt()} $unit",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
