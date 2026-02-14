import 'package:flutter/material.dart';
import 'package:growa/model/colors/colors.dart';

class UserScreen extends StatelessWidget {
  UserScreen({super.key});

  final ValueNotifier<bool> reminderSwitch = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tint,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1. Identity Section
            const CircleAvatar(
              backgroundColor: Colors.white,
              radius: 50,
              child: Icon(Icons.person, size: 70, color: Colors.green),
            ),
            const SizedBox(height: 12),
            const Text(
              "User Name",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text("abrar@gmail.com"),
            const SizedBox(height: 20),

            // 2. Quick Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatColumn("12", "Plants"),
                _buildStatColumn("94%", "Health"),
                _buildStatColumn("5", "Badges"),
              ],
            ),
            const Divider(height: 40),

            // 3. Garden Overview Section
            _buildSectionHeader("My Garden Zones"),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildZoneCard(Icons.weekend, "Living Room"),
                  _buildZoneCard(Icons.wb_sunny, "Balcony"),
                  _buildZoneCard(Icons.work, "Office"),
                ],
              ),
            ),
            const SizedBox(height: 20),

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
          style: const TextStyle(
            fontSize: 20,
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
        width: 110,
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.green),
            const SizedBox(height: 5),
            Text(label, style: const TextStyle(fontSize: 12)),
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
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
