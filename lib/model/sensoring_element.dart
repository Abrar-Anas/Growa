import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:growa/model/colors/colors.dart';

// The floating elements hovering over the plant
class MinimalPlantStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const MinimalPlantStat({super.key, required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 6),
          )
        ],
        border: Border.all(color: Colors.grey.shade100, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: tint,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 14.sp, color: green),
          ),
          10.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: black,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  color: tfcolor,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class glass_soil_moisture extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 60.h,
      right: 15.w,
      child: MinimalPlantStat(
        icon: Icons.water_drop_rounded,
        value: "32%",
        label: "Moisture",
      ),
    );
  }
}

class glass_temperature extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 220.h,
      left: 10.w,
      child: MinimalPlantStat(
        icon: Icons.thermostat_rounded,
        value: "24°C",
        label: "Temperature",
      ),
    );
  }
}

class glass_Humidity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 170.h,
      right: 0.w,
      child: MinimalPlantStat(
        icon: Icons.air_rounded,
        value: "60%",
        label: "Humidity",
      ),
    );
  }
}

// Flat detailed items
class MinimalDetailItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const MinimalDetailItem({super.key, required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
        border: Border.all(color: Colors.grey.shade100, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey.shade100, width: 1),
            ),
            child: Icon(icon, size: 20.sp, color: green),
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: tfcolor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                2.verticalSpace,
                Text(
                  subtitle,
                  style: TextStyle(
                    color: black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class lighting_conditon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MinimalDetailItem(
      icon: Icons.wb_sunny_rounded,
      title: "Light",
      subtitle: "Minimal",
    );
  }
}

class humidity_level extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MinimalDetailItem(
      icon: Icons.water_drop_rounded,
      title: "Humidity",
      subtitle: "70%",
    );
  }
}

class soil_health extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MinimalDetailItem(
      icon: Icons.grass_rounded,
      title: "Soil",
      subtitle: "Dry",
    );
  }
}

class fertilization extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MinimalDetailItem(
      icon: Icons.energy_savings_leaf_rounded,
      title: "Fertilizer",
      subtitle: "Balanced",
    );
  }
}
