import 'package:flutter/material.dart';
import 'package:growa/model/colors/colors.dart';
import 'package:growa/model/disease.dart';

class DiseaseDetailPage extends StatelessWidget {
  final DiseaseModel disease;

  const DiseaseDetailPage({super.key, required this.disease});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tint,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Disease Details",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: tint,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Illustration Header with Gradient
            Container(
              width: double.infinity,
              height: 250,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFE0F2F1), Colors.white],
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                child: disease.headerIllustration,
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. Title and Severity Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        disease.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _buildSeverityChip(disease.severity),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.eco_outlined,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${disease.type} Disease",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 3. Section Cards
                  _buildDetailCard(
                    title: "Description",
                    icon: Icons.warning_amber_rounded,
                    iconColor: Colors.green,
                    content: Text(
                      disease.fullDescription,
                      style: const TextStyle(
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ),

                  _buildDetailCard(
                    title: "Symptoms",
                    icon: Icons.science_outlined,
                    iconColor: Colors.orange,
                    content: _buildBulletList(disease.symptoms, Colors.orange),
                  ),

                  _buildDetailCard(
                    title: "Causes",
                    icon: Icons.air_outlined,
                    iconColor: Colors.blue,
                    content: _buildBulletList(disease.causes, Colors.blue),
                  ),

                  _buildDetailCard(
                    title: "Preventive Measures",
                    icon: Icons.check_circle_outline,
                    iconColor: Colors.teal,
                    backgroundColor: const Color(
                      0xFFE0F2F1,
                    ), // Light teal background
                    content: _buildBulletList(disease.prevention, Colors.teal),
                  ),

                  _buildDetailCard(
                    title: "Treatment",
                    icon: Icons.opacity_outlined,
                    iconColor: Colors.green,
                    content: _buildNumberedList(
                      disease.treatment,
                      Colors.green,
                    ),
                  ),

                  // 4. Action Button
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4CAF50), Color(0xFF1B5E20)],
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () {}, // Handle mark as reviewed
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Mark as Reviewed",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // UI Components
  Widget _buildSeverityChip(String severity) {
    bool isHigh = severity.toLowerCase() == "high";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isHigh ? const Color(0xFFFFEBEE) : const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isHigh ? Colors.red.shade200 : Colors.orange.shade200,
        ),
      ),
      child: Text(
        severity,
        style: TextStyle(
          color: isHigh ? Colors.red : Colors.orange,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Widget content,
    Color backgroundColor = Colors.white,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: iconColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          content,
        ],
      ),
    );
  }

  Widget _buildBulletList(List<String> items, Color bulletColor) {
    return Column(
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "• ",
                    style: TextStyle(
                      color: bulletColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildNumberedList(List<String> items, Color numberColor) {
    return Column(
      children: List.generate(
        items.length,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: numberColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  "${index + 1}",
                  style: TextStyle(
                    color: numberColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  items[index],
                  style: const TextStyle(color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
