import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:growa/model/colors/colors.dart';
import 'dart:ui';
import 'package:gauge_indicator/gauge_indicator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        backgroundColor: tint,
        centerTitle: true,
        title: Text(
          "Growa",
          style: TextStyle(
            color: green,
            fontWeight: FontWeight.bold,
            fontSize: 30.sp,
          ),
        ),
      ),
      backgroundColor: tint,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20).r,
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 400,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 50,
                          width: 350,

                          child: Image.asset("assets/image/plant.png"),
                        ),
                        _glassSoilMoisture(),
                        _glassTemperatureBox(),
                        Positioned(
                          top: 150,
                          right: 200,
                          left: 10,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Stack(
                              children: [
                                // 1. The Blur Layer
                                BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 20,
                                    sigmaY: 20,
                                  ),
                                  child: SizedBox(
                                    width: 100.w,
                                    height: 60.h,
                                  ), // This empty container carries the blur
                                ),
                                // 2. The Tint and Border Layer
                                Container(
                                  width: 150.w,
                                  height: 87.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.2,
                                      ), // The "Edge"
                                      width: 1.5,
                                    ),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.white.withValues(
                                          alpha: 0.2,
                                        ), // Top-left sheen
                                        Colors.white.withValues(
                                          alpha: 0.05,
                                        ), // Bottom-right transparency
                                      ],
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Humidity",
                                          style: TextStyle(color: tfcolor),
                                        ),
                                        2.verticalSpace,

                                        // Inside your build method:
                                        SizedBox(
                                          height: 50,
                                          width: 200,
                                          child: AnimatedRadialGauge(
                                            duration: const Duration(
                                              milliseconds: 1500,
                                            ),
                                            value:
                                                75, // The percentage (0 to 100)
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
                                                background: Colors.grey
                                                    .withValues(alpha: 0.2),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ), // Your content here
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _growthAnalysis(),
                  10.verticalSpace,
                  Container(
                    width: 400.w,
                    height: 208.h,
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(20).r,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0).r,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Plant Details",
                                style: TextStyle(color: black, fontSize: 20.sp),
                              ),
                              Icon(Icons.arrow_circle_right, size: 25),
                            ],
                          ),
                          2.verticalSpace,
                          Text(
                            "Real-time conditions",
                            style: TextStyle(color: tfcolor, fontSize: 12.sp),
                          ),
                          5.verticalSpace,
                          Divider(height: 0.2.h, color: tfcolor),
                          10.verticalSpace,
                          Row(
                            children: [
                              _ligthCondition(),
                              10.horizontalSpace,
                              _soilHealth(),
                            ],
                          ),
                          10.verticalSpace,
                          Row(
                            children: [
                              _humidityLevel(),
                              10.horizontalSpace,
                              _fertililzation(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Positioned _glassTemperatureBox() {
    return Positioned(
      top: 150,
      right: 10,
      left: 200,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
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
              height: 87.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
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
                        value: 75, // The percentage (0 to 100)
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
          ],
        ),
      ),
    );
  }

  Positioned _glassSoilMoisture() {
    return Positioned(
      top: 10,
      right: 100,
      left: 100,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
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
              height: 66.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
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
                padding: const EdgeInsets.all(15.0),
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

  Container _fertililzation() {
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

  Container _humidityLevel() {
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

  Container _soilHealth() {
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

  Container _ligthCondition() {
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

  Container _growthAnalysis() {
    return Container(
      width: 400.w,
      height: 190.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,

          colors: [
            const Color.fromARGB(255, 207, 236, 126),

            const Color.fromARGB(255, 173, 218, 50),
          ],
        ),
        color: black,
        borderRadius: BorderRadius.circular(20).r,
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0).r,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Growth AnalysiS",
                  style: TextStyle(color: black, fontSize: 20.sp),
                ),
                Spacer(),
                Text(
                  "month",
                  style: TextStyle(color: black, fontSize: 12.sp),
                ),
                Icon(Icons.arrow_drop_down_outlined, size: 25),
              ],
            ),
            2.verticalSpace,
            Text(
              "1 Month Growth Time-Lapse",
              style: TextStyle(color: tfcolor, fontSize: 12.sp),
            ),
            5.verticalSpace,
            Divider(height: 0.2.h, color: tfcolor),
            Spacer(),
            Image.asset("assets/image/graph.png"),
          ],
        ),
      ),
    );
  }
}
