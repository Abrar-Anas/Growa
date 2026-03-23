import 'package:flutter/material.dart';

class DiseaseModel {
  final int id;
  final String diseaseName;
  final String description;
  final String symptomsString;
  final String causesString;
  final String preventiveMeasuresString;
  final String treatmentString;
  final double confidenceValue;
  final String imageUrl;
  final String updatedAt;

  DiseaseModel({
    required this.id,
    required this.diseaseName,
    required this.description,
    required this.symptomsString,
    required this.causesString,
    required this.preventiveMeasuresString,
    required this.treatmentString,
    required this.confidenceValue,
    required this.imageUrl,
    required this.updatedAt,
  });

  factory DiseaseModel.fromJson(Map<String, dynamic> json) {
    return DiseaseModel(
      id: json['id'] ?? 0,
      diseaseName: json['disease_name'] ?? 'Unknown',
      description: json['description'] ?? '',
      symptomsString: json['symptoms'] ?? '',
      causesString: json['causes'] ?? '',
      preventiveMeasuresString: json['preventive_measures'] ?? '',
      treatmentString: json['treatment'] ?? '',
      confidenceValue: (json['confidence_value'] ?? 0.0).toDouble(),
      imageUrl: json['image_url'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  // Mappers to mimic original UI fields
  String get name => diseaseName;
  String get summary => description.length > 50 ? '${description.substring(0, 50)}...' : description;
  String get fullDescription => description;
  String get severity => confidenceValue > 90.0 ? "High" : "Medium";
  Color get severityColor => severity == "High" ? Colors.red.shade100 : Colors.orange.shade100;
  Color get severityTextColor => severity == "High" ? Colors.red : Colors.orange.shade700;
  String get type => "Fungal"; 
  IconData get categoryIcon => Icons.grass_outlined;
  
  String get updatedDate {
    try {
      final date = DateTime.parse(updatedAt);
      return "${date.day}/${date.month}/${date.year}";
    } catch (_) {
      return updatedAt;
    }
  }

  List<String> get symptoms => symptomsString.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  List<String> get causes => causesString.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  List<String> get prevention => preventiveMeasuresString.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  List<String> get treatment => treatmentString.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

  Widget get thumbnailIllustration {
    if (imageUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          imageUrl, 
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          errorBuilder: (c, e, s) => const Icon(Icons.eco, size: 80, color: Colors.green),
        ),
      );
    }
    return const Icon(Icons.eco, size: 80, color: Colors.green);
  }

  Widget get headerIllustration {
    if (imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl, 
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
        errorBuilder: (c, e, s) => const Icon(Icons.eco, size: 120, color: Colors.green),
      );
    }
    return const Icon(Icons.eco, size: 120, color: Colors.green);
  }
}
