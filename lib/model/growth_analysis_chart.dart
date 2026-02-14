import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';

import 'package:growa/model/colors/colors.dart';

class PlantGrowthChart extends StatelessWidget {
  const PlantGrowthChart({super.key});

  @override
  Widget build(BuildContext context) {
    // We'll use your original colors for the line and accents
    const Color accentGreen = Color.fromARGB(255, 173, 218, 50);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          height: 300.h,
          padding: const EdgeInsets.only(
            top: 24,
            bottom: 12,
            right: 20,
            left: 10,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20).r,
            // Glass effect gradient
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.1),
                Colors.white.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.white.withValues(alpha: 0.1),
                  strokeWidth: 1.r,
                ),
              ),
              titlesData: _buildTitles(),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: const [
                    FlSpot(0, 5),
                    FlSpot(1, 12),
                    FlSpot(2, 25),
                    FlSpot(3, 30),
                    FlSpot(4, 40),
                    FlSpot(5, 30),
                  ],
                  isCurved: true,
                  curveSmoothness: 0.35,
                  barWidth: 5.w,
                  // The line is now the primary green color
                  color: white.withValues(alpha: 0.2),
                  dotData: FlDotData(
                    show: false,
                    getDotPainter: (spot, percent, barData, index) =>
                        FlDotCirclePainter(
                          radius: 4,
                          color: Colors.white,
                          strokeWidth: 2,
                          strokeColor: accentGreen,
                        ),
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        white.withValues(alpha: 0.7),
                        white.withValues(alpha: 0.0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  FlTitlesData _buildTitles() {
    return FlTitlesData(
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40.sp,
          getTitlesWidget: (value, meta) => Text(
            '${value.toInt()}cm',
            style: const TextStyle(
              color: Colors.black54, // Darker text for glass contrast
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            const months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN'];
            if (value >= 0 && value < months.length) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  months[value.toInt()],
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }
}
