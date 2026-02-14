import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:growa/controllers/auth_service.dart';
import 'package:growa/model/colors/colors.dart';

class UserScreen extends StatelessWidget {
  UserScreen({super.key});

  final ApiService apiService = ApiService();

  final ValueNotifier<bool> reminderSwitch = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tint,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0).r,
        child: Column(
          children: [
            // 1. Identity Section
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 50,
              child: Icon(Icons.person, size: 70.sp, color: Colors.green),
            ),
            12.verticalSpace,
            FutureBuilder<User>(
              future: apiService.fetchUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
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

            FutureBuilder<User>(
              future: apiService.fetchUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: Text("email"));
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error"));
                } else if (snapshot.hasData) {
                  return Text(
                    snapshot.data!.email,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }
                return Center(child: Text("No data found"));
              },
            ),
            20.verticalSpace,

            // 2. Quick Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatColumn("12", "Plants"),
                _buildStatColumn("94%", "Health"),
                _buildStatColumn("5", "Badges"),
              ],
            ),
            Divider(height: 40.h),

            // 3. Garden Overview Section
            _buildSectionHeader("My Garden Zones"),
            SizedBox(
              height: 100.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildZoneCard(Icons.weekend, "Living Room"),
                  _buildZoneCard(Icons.wb_sunny, "Balcony"),
                  _buildZoneCard(Icons.work, "Office"),
                ],
              ),
            ),
            20.verticalSpace,

            // 4. Preferences & Settings
            _buildSectionHeader("Preferences"),
            ListTile(
              leading: const Icon(Icons.notifications_active),
              title: const Text("Watering Reminders"),
              trailing: ValueListenableBuilder(
                valueListenable: reminderSwitch,
                builder: (context, value, child) => Switch(
                  value: value,
                  onChanged: (val) {
                    reminderSwitch.value = val;
                  },
                  activeThumbColor: green,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.sensors),
              title: const Text("IoT Sensor Sync"),
              subtitle: const Text("Connected to 3 devices"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.bookmark),
              title: const Text("Saved Care Guides"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            100.verticalSpace,
          ],
        ),
      ),
    );
  }

  // Helper widget for Stats
  Widget _buildStatColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  // Helper widget for Zone Cards
  Widget _buildZoneCard(IconData icon, String label) {
    return Card(
      child: Container(
        width: 110.w,
        padding: const EdgeInsets.all(8).r,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.green),
            5.verticalSpace,
            Text(label, style: TextStyle(fontSize: 12.sp)),
          ],
        ),
      ),
    );
  }

  // Helper widget for Headers
  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0).w,
        child: Text(
          title,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
