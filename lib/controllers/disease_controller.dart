import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:growa/model/disease.dart';

class DiseaseController extends GetxController {
  var isLoading = true.obs;
  var diseaseList = <DiseaseModel>[].obs;
  var filteredDiseases = <DiseaseModel>[].obs;
  var hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDiseases();
  }

  Future<void> fetchDiseases() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      
      final response = await http.get(Uri.parse('http://16.16.57.108/api/disease'));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success'] == true) {
          final List<dynamic> diseaseJson = data['data'];
          diseaseList.value = diseaseJson.map((json) => DiseaseModel.fromJson(json)).toList();
          filteredDiseases.value = diseaseList;
        } else {
          hasError.value = true;
        }
      } else {
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
      print("Error fetching diseases: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void search(String query) {
    if (query.isEmpty) {
      filteredDiseases.value = diseaseList;
    } else {
      filteredDiseases.value = diseaseList
          .where((disease) => disease.diseaseName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  Future<DiseaseModel?> getDiseaseById(int id) async {
    try {
      final response = await http.get(Uri.parse('http://16.16.57.108/api/disease/$id'));
      if (response.statusCode == 200) {
         final Map<String, dynamic> data = jsonDecode(response.body);
         if (data['success'] == true) {
            return DiseaseModel.fromJson(data['data']);
         }
      }
    } catch (e) {
      print("Error fetching disease detail: $e");
    }
    return null;
  }
}
