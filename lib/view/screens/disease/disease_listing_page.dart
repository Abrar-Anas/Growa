import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growa/model/colors/colors.dart';
import 'package:growa/model/disease.dart';
import 'package:growa/controllers/disease_controller.dart';
import 'package:growa/view/screens/disease/disease_details_page.dart';

class DiseaseListPage extends StatelessWidget {
  const DiseaseListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DiseaseController controller = Get.put(DiseaseController());

    void _onSearchChanged(String query) {
      controller.search(query);
    }

    // Theme setup for consistent design
    final theme = ThemeData(
      scaffoldBackgroundColor: const Color(0xFFF7F8FA), // Light background
      fontFamily: 'Roboto', // Replace with your app font
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: Colors.black),
      ),
    );

    return Theme(
      data: theme,
      child: Scaffold(
        backgroundColor: tint,
        body: Column(
          children: [
            // 1. Search and Filter Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Expanded(
                child: TextField(
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: "Search diseases...",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),

            // 2. The Scrollable List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (controller.hasError.value) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Failed to load diseases."),
                        ElevatedButton(
                          onPressed: () => controller.fetchDiseases(),
                          child: const Text("Retry"),
                        )
                      ],
                    ),
                  );
                }

                final currentList = controller.filteredDiseases;
                if (currentList.isEmpty) {
                  return const Center(
                    child: Text("No diseases found matching that name."),
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.fetchDiseases,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: currentList.length,
                    separatorBuilder: (ctx, idx) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final disease = currentList[index];
                      return DiseaseListCard(disease: disease);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Stateless Card widget for the list item
class DiseaseListCard extends StatelessWidget {
  final DiseaseModel disease;

  const DiseaseListCard({super.key, required this.disease});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black26, offset: Offset(0, 4), blurRadius: 8),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DiseaseDetailPage(disease: disease),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Disease Illustration Container
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF9EE), // Very pale green
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: disease.thumbnailIllustration,
                ),
                const SizedBox(width: 16),

                // 2. Info Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            disease.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          // Severity Chip
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: disease.severityColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              disease.severity,
                              style: TextStyle(
                                fontSize: 12,
                                color: disease.severityTextColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        disease.summary,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Footer Row (Type and Date)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                disease.categoryIcon,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                disease.type,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "Updated ${disease.updatedDate}",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
