import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:growa/model/colors/colors.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'dart:ui';

class lighting_conditon extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      width: 140.w,
      height: 50.h,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 231, 231, 231),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0).r,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.wb_sunny_outlined, size: 20.sp, color: lightgreen),
            5.horizontalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Light Conditon",
                  style: TextStyle(color: black, fontSize: 13.sp),
                ),
                Text(
                  "Minimal",
                  style: TextStyle(color: black, fontSize: 10.sp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class glass_Humidity extends StatelessWidget {
  Widget build(BuildContext context) {
    return Positioned(
      top: 150.h,
      left: 5.w,
      width: 130.w,
      height: 100.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            // Move your gradient here
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.2),
                Colors.white.withValues(alpha: 0.05),
              ],
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: 100.w,
              height: 87.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1.5,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.2),
                    Colors.white.withValues(alpha: 0.05),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Humidity", style: TextStyle(color: tfcolor)),
                    2.verticalSpace,
                    SizedBox(
                      height: 50,
                      width: 200,
                      child: AnimatedRadialGauge(
                        duration: const Duration(milliseconds: 1500),
                        value: 75,
                        axis: GaugeAxis(
                          min: 0,
                          max: 100,
                          pointer: GaugePointer.needle(
                            width: 4,
                            height: 50,
                            color: Colors.black,
                            borderRadius: 16,
                          ),
                          degrees: 180,
                          style: GaugeAxisStyle(
                            thickness: 20,
                            background: Colors.grey.withValues(alpha: 0.2),
                          ),
                        ),
                      ),
                    ),
                  ],
                ), // Your content here
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class glass_soil_moisture extends StatelessWidget {
  Widget build(BuildContext context) {
    return Positioned(
      top: 10.h,
      right: 100.w,
      left: 100.w,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Stack(
          children: [
            // 1. The Blur Layer
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: SizedBox(
                width: 100.w,
                height: 60.h,
              ), // This empty container carries the blur
            ),
            // 2. The Tint and Border Layer
            Container(
              width: 150.w,
              height: 68.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2), // The "Edge"
                  width: 1.5,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.2), // Top-left sheen
                    Colors.white.withValues(
                      alpha: 0.05,
                    ), // Bottom-right transparency
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0).r,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Soil Moisture", style: TextStyle(color: tfcolor)),

                    Text(
                      "Dry & Cracked",
                      style: TextStyle(
                        color: black,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ), // Your content here
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class glass_temperature extends StatelessWidget {
  Widget build(BuildContext context) {
    return Positioned(
    top: 150.h,
    left: 200.w,
    width: 130.w,
    height: 100.h,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        decoration: BoxDecoration(),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 100.w,
            height: 87.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2), // The "Edge"
                width: 1.5,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.2), // Top-left sheen
                  Colors.white.withValues(
                    alpha: 0.05,
                  ), // Bottom-right transparency
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Temperature", style: TextStyle(color: tfcolor)),
                  2.verticalSpace,

                  // Inside your build method:
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: AnimatedRadialGauge(
                      duration: const Duration(milliseconds: 1500),
                      value: 50, // The percentage (0 to 100)
                      axis: GaugeAxis(
                        min: 0,
                        max: 100,
                        pointer: GaugePointer.needle(
                          width: 4,
                          height: 50,
                          color: Colors.black,
                          borderRadius: 16,
                        ),
                        degrees:
                            180, // Makes it a semi-circle like a speedometer
                        style: GaugeAxisStyle(
                          thickness: 20,
                          background: Colors.grey.withValues(alpha: 0.2),
                        ),
                      ),
                    ),
                  ),
                ],
              ), // Your content here
            ),
          ),
        ), // This empty container carries the blur
      ),
    ),
  );
  }
  }

class fertilization extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
    width: 140.w,
    height: 50.h,
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 231, 231, 231),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0).r,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.energy_savings_leaf, size: 20.sp, color: lightgreen),
          5.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Fertilization ",
                style: TextStyle(color: black, fontSize: 13.sp),
              ),
              Text(
                "Balanced",
                style: TextStyle(color: black, fontSize: 10.sp),
              ),
            ],
          ),
        ],
      ),
    ),
  );
    }
}

class humidity_level extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
    width: 140.w,
    height: 50.h,
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 231, 231, 231),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0).r,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.thermostat_outlined, size: 20.sp, color: lightgreen),
          5.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Humidity Level",
                style: TextStyle(color: black, fontSize: 13.sp),
              ),
              Text(
                "70%",
                style: TextStyle(color: black, fontSize: 10.sp),
              ),
            ],
          ),
        ],
      ),
    ),
  );
  }
}

class soil_health extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
    width: 140.w,
    height: 50.h,
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 231, 231, 231),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0).r,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.waves_outlined, size: 20.sp, color: lightgreen),
          5.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Soil Health",
                style: TextStyle(color: black, fontSize: 13.sp),
              ),
              Text(
                "Dry & Cracked",
                style: TextStyle(color: black, fontSize: 10.sp),
              ),
            ],
          ),
        ],
      ),
    ),
  );
  }
}
