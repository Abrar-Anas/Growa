import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:growa/model/colors/colors.dart';
import 'package:growa/model/sensoring_element.dart';
import 'package:growa/view/screens/stats/stats_screen.dart';
import 'package:animations/animations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tint,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20).r,
              child: Column(
                children: [
                  _glassBoxs(),
                  ExpandableCard(),
                  20.verticalSpace,
                  _plantDetails(),
                  80.verticalSpace,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
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
        glass_soil_moisture(),
        glass_temperature(),
        glass_Humidity(),
      ],
    ),
  );
}

Container _plantDetails() {
  return Container(
    width: 400.w,
    height: 208.h,
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(color: Colors.black26, offset: Offset(0, 4), blurRadius: 8),
      ],
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
            children: [lighting_conditon(), 10.horizontalSpace, soil_health()],
          ),
          10.verticalSpace,
          Row(
            children: [humidity_level(), 10.horizontalSpace, fertilization()],
          ),
        ],
      ),
    ),
  );
}

class ExpandableCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      // The duration of the animation
      transitionType: ContainerTransitionType.fadeThrough,
      transitionDuration: const Duration(
        milliseconds: 500,
      ), // Slightly slower for elegance
      openElevation: 0,
      closedElevation: 4,
      closedColor: lightgreen,
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20).r,
      ),
      // 1. The "Small" version of your container
      closedBuilder: (context, action) {
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
      },
      // 2. The screen it expands into
      openBuilder: (context, action) {
        return StatsScreen();
      },
    );
  }
}
