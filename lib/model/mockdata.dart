import 'package:flutter/material.dart';

class DiseaseModel {
  final String id;
  final String name;
  final String summary;
  final String fullDescription;
  final String updatedDate;
  final String severity;
  final String type;
  final IconData categoryIcon;
  final Widget diseaseIllustration;

  // New fields to support the detailed view
  final List<String> symptoms;
  final List<String> causes;
  final List<String> prevention;
  final List<String> treatment;

  DiseaseModel({
    required this.id,
    required this.name,
    required this.summary,
    required this.fullDescription,
    required this.updatedDate,
    required this.severity,
    required this.type,
    required this.categoryIcon,
    required this.diseaseIllustration,
    this.symptoms = const [],
    this.causes = const [],
    this.prevention = const [],
    this.treatment = const [],
  });

  Color get severityColor =>
      severity == "High" ? Colors.red.shade100 : Colors.orange.shade100;
  Color get severityTextColor =>
      severity == "High" ? Colors.red : Colors.orange.shade700;
}

final List<DiseaseModel> mockDiseases = [
  DiseaseModel(
    id: "1",
    name: "Powdery Mildew",
    summary: "White powdery spots on leaves and stems. Common in humid...",
    fullDescription:
        "Powdery mildew is a fungal disease that affects a wide range of plants. It is characterized by white or gray powdery spots on leaves, stems, and sometimes flowers. The fungus thrives in warm, humid conditions with poor air circulation.",
    updatedDate: "2 days ago",
    severity: "High",
    type: "Fungal",
    categoryIcon: Icons.grass_outlined,
    diseaseIllustration: Icon(
      Icons.psychology,
      size: 80,
      color: Colors.pink.shade300,
    ),
    symptoms: [
      "White or gray powdery coating on leaves",
      "Distorted or stunted leaf growth",
      "Yellowing and premature leaf drop",
      "Reduced plant vigor and yield",
    ],
    causes: [
      "High humidity levels",
      "Poor air circulation",
      "Overcrowding of plants",
      "Inadequate sunlight",
    ],
    prevention: [
      "Maintain proper humidity levels (below 70%)",
      "Ensure good air circulation with fans",
      "Space plants adequately",
      "Remove infected leaves immediately",
      "Avoid overhead watering",
      "Monitor temperature and humidity regularly",
    ],
    treatment: [
      "Apply fungicide spray every 7-10 days",
      "Remove and destroy infected plant parts",
      "Improve ventilation in greenhouse",
      "Reduce humidity levels",
      "Use sulfur-based treatments",
      "Consider biological controls",
    ],
  ),
  DiseaseModel(
    id: "2",
    name: "Aphid Infestation",
    summary:
        "Small insects that feed on plant sap, causing leaf curl and stunt...",
    fullDescription:
        "Aphids are tiny pear-shaped insects that suck nutrient-rich liquids out of plants. In large numbers, they can weaken plants significantly, harming flowers and fruit.",
    updatedDate: "5 days ago",
    severity: "Medium",
    type: "Pest",
    categoryIcon: Icons.pest_control_outlined,
    diseaseIllustration: Icon(
      Icons.bug_report,
      size: 80,
      color: Colors.green.shade400,
    ),
    symptoms: [
      "Curled or yellowed leaves",
      "Sticky substance (honeydew) on leaves",
      "Stunted growth",
      "Visible small insects on stems",
    ],
    causes: [
      "Warm weather",
      "Excessive nitrogen in soil",
      "Lack of natural predators",
    ],
    prevention: [
      "Inspect new plants before bringing them in",
      "Encourage beneficial insects like ladybugs",
      "Use reflective mulches",
    ],
    treatment: [
      "Wipe or spray leaves with a mild solution of water and dish soap",
      "Use neem oil for organic control",
      "Prune away heavily infested parts",
    ],
  ),
];
