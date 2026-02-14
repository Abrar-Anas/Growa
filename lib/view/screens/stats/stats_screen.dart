import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:growa/model/colors/colors.dart';
import 'package:growa/model/growth_analysis_chart.dart';
import 'package:growa/model/sensoring_element.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tint,
      body: Padding(
        padding: const EdgeInsets.all(20).r,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 400.w,
                height: 400.h,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: black,
                      offset: Offset(0, 4),
                      blurRadius: 8.r,
                    ),
                  ],
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
                      PlantGrowthChart(),
                    ],
                  ),
                ),
              ),
              20.verticalSpace,
              Container(
                width: 400.w,
                height: 208.h,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: black,
                      offset: Offset(0, 4),
                      blurRadius: 8,
                    ),
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
                        children: [
                          lighting_conditon(),
                          10.horizontalSpace,
                          soil_health(),
                        ],
                      ),
                      10.verticalSpace,
                      Row(
                        children: [
                          humidity_level(),
                          10.horizontalSpace,
                          fertilization(),
                        ],
                      ),
                    ],
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
