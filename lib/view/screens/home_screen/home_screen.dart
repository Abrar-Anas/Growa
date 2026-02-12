import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:growa/model/colors/colors.dart';
import 'dart:ui';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:growa/model/glassbottomnav.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final ValueNotifier<double> leftPosition = ValueNotifier<double>(0.0);

  final ValueNotifier<int> activeIndex = ValueNotifier<int>(1);

  final ValueNotifier<int> navIndex = ValueNotifier(0);

  final List<IconData> icons = [Icons.auto_graph, Icons.home, Icons.person];

  final List<String> labelData = ["STATS", "HOME", "USER"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: _bottomNavigationBar(),
      drawer: Drawer(),
      appBar: _appBar(),
      backgroundColor: tint,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20).r,
              child: Column(
                children: [
                  _glassBoxs(),
                  _growthAnalysis(),
                  10.verticalSpace,
                  _plantDetails(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding _bottomNavigationBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double barWidth = constraints.maxWidth;
          double itemWidth = barWidth / icons.length;

          // Set initial position
          WidgetsBinding.instance.addPostFrameCallback((_) {
            leftPosition.value = activeIndex.value * itemWidth;
          });

          return GestureDetector(
            onHorizontalDragUpdate: (details) {
              leftPosition.value = (leftPosition.value + details.delta.dx)
                  .clamp(0.0, barWidth - itemWidth);
              activeIndex.value = (leftPosition.value / itemWidth).round();
            },
            onHorizontalDragEnd: (details) {
              int targetIndex = (leftPosition.value / itemWidth).round();
              activeIndex.value = targetIndex;
              leftPosition.value = targetIndex * itemWidth;
            },
            child: Container(
              height: 75,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 0.1,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // --- ZOOMING GLASS OVAL ---
                  ValueListenableBuilder<double>(
                    valueListenable: leftPosition,
                    builder: (context, pos, _) {
                      return AnimatedPositioned(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves
                            .easeOutBack, // Back curve adds a slight "overshoot" zoom
                        left: pos + (itemWidth * 0.1),
                        top: 12,
                        child: ValueListenableBuilder<int>(
                          valueListenable: activeIndex,
                          builder: (context, idx, _) {
                            // TweenAnimationBuilder handles the scale "zoom"
                            return TweenAnimationBuilder<double>(
                              tween: Tween<double>(begin: 0.8, end: 1.0),
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                              key: ValueKey(
                                idx,
                              ), // Re-triggers zoom on index change
                              builder: (context, scale, child) {
                                return Transform.scale(
                                  scale: scale,
                                  child: GlassOval(width: itemWidth * 0.8),
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),

                  // --- ICONS ---
                  Row(
                    children: List.generate(icons.length, (i) {
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            activeIndex.value = i;
                            leftPosition.value = i * itemWidth;
                          },
                          behavior: HitTestBehavior.opaque,
                          child: ValueListenableBuilder<int>(
                            valueListenable: activeIndex,
                            builder: (context, idx, _) {
                              return AnimatedScale(
                                duration: const Duration(milliseconds: 200),
                                scale: idx == i
                                    ? 1.2
                                    : 1.0, // Subtle icon zoom too
                                child: Column(
                                  children: [
                                    Spacer(),

                                    Icon(
                                      icons[i],
                                      color: idx == i ? green : Colors.white,
                                    ),
                                    Text(
                                      labelData[i],
                                      style: TextStyle(
                                        color: idx == i ? green : Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Spacer(),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

AppBar _appBar() {
  return AppBar(
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
  );
}

SizedBox _glassBoxs() {
  return SizedBox(
    width: double.infinity,
    height: 350.h,
    child: Stack(
      children: [
        Positioned(
          top: 50.h,
          width: 320.w,

          child: Image.asset("assets/image/plant.png"),
        ),
        _glassSoilMoisture(),
        _glassTemperatureBox(),
        _glassHumidity(),
      ],
    ),
  );
}

Container _plantDetails() {
  return Container(
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
          Row(children: [_ligthCondition(), 10.horizontalSpace, _soilHealth()]),
          10.verticalSpace,
          Row(
            children: [_humidityLevel(), 10.horizontalSpace, _fertililzation()],
          ),
        ],
      ),
    ),
  );
}

Positioned _glassHumidity() {
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

Positioned _glassTemperatureBox() {
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

Positioned _glassSoilMoisture() {
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
