import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  var isLoading = true.obs;
  var hasError = false.obs;

  var userName = "".obs;
  var userEmail = "".obs;
  var greenhouseAddress = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfileDetails();
  }

  Future<void> fetchProfileDetails() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token'); // Typical key for storing tokens

      var headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };
      
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      var dio = Dio();
      var response = await dio.request(
        'http://16.16.57.108/api/profile/details',
        options: Options(
          method: 'GET',
          headers: headers,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse data
        final data = response.data['data'] ?? response.data;
        
        userName.value = data['name'] ?? 'Unknown User';
        userEmail.value = data['email'] ?? 'No Email';
        
        // Assemble address
        String address = data['address'] ?? '';
        String city = data['city'] ?? '';
        String state = data['state'] ?? '';
        String pincode = data['pincode'] ?? '';
        String greenhouseName = data['greenhouse_name'] ?? '';
        
        List<String> addressParts = [];
        if (address.isNotEmpty) addressParts.add(address);
        if (city.isNotEmpty) addressParts.add(city);
        if (state.isNotEmpty) addressParts.add(state);
        if (pincode.isNotEmpty) addressParts.add(pincode);
        if (greenhouseName.isNotEmpty) addressParts.add(greenhouseName);
        
        if (addressParts.isNotEmpty) {
           greenhouseAddress.value = addressParts.join(', ');
        } else {
           greenhouseAddress.value = "Address not provided";
        }
      } else {
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
      print("Error fetching profile details: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
