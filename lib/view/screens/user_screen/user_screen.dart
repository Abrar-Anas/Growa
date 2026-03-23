import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:growa/controllers/profile_controller.dart';
import 'package:growa/model/colors/colors.dart';
import 'package:growa/view/screens/sign_in_screen/sign_in_screen.dart';

class UserScreen extends StatelessWidget {
  UserScreen({super.key});

  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tint,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 48.r,
                child: Icon(Icons.person_rounded, size: 56.sp, color: green),
              ),
              28.verticalSpace,

              // Info Card
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Obx(() {
                  if (profileController.isLoading.value) {
                    return Padding(
                      padding: EdgeInsets.all(32.h),
                      child: const Center(child: CircularProgressIndicator(color: Colors.green)),
                    );
                  }
                  
                  if (profileController.hasError.value) {
                     return Padding(
                      padding: EdgeInsets.all(32.h),
                      child: Center(
                        child: Text(
                          "Failed to load profile", 
                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      _buildInfoTile(
                        icon: Icons.person_outline_rounded,
                        label: "Name",
                        value: profileController.userName.value,
                        showDivider: true,
                      ),
                      _buildInfoTile(
                        icon: Icons.email_outlined,
                        label: "Email",
                        value: profileController.userEmail.value,
                        showDivider: true,
                      ),
                      _buildInfoTile(
                        icon: Icons.location_on_outlined,
                        label: "Greenhouse Address",
                        value: profileController.greenhouseAddress.value,
                        showDivider: false,
                      ),
                    ],
                  );
                }),
              ),

              const Spacer(),

              // Logout
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    foregroundColor: white,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.logout_rounded),
                  label: Text(
                    "Log Out",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => SignInScreen()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
    required bool showDivider,
  }) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: green, size: 22.sp),
              14.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    4.verticalSpace,
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(height: 1, indent: 56.w, color: Colors.grey.shade100),
      ],
    );
  }
}