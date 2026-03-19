import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:growa/controllers/auth_service.dart';
import 'package:growa/view/screens/dash_board/dash_board.dart';
import 'package:growa/view/screens/sign_in_screen/sign_in_screen.dart';

class GrowaRegisterPage extends StatelessWidget {
  const GrowaRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ApiService _apiService = ApiService();
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _productIDController = TextEditingController();
    final TextEditingController _addressController = TextEditingController();
    final TextEditingController _confirmPasswordController =
        TextEditingController();
    final TextEditingController _cityController = TextEditingController();
    final TextEditingController _pincodeController = TextEditingController();
    final TextEditingController _stateController = TextEditingController();
    final TextEditingController _greenhouse_name_Controller =
        TextEditingController();
    return Scaffold(
      body: Stack(
        children: [
          Icon(Icons.arrow_back),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE8F5E9),
                  Color(0xFFC8E6C9),
                  Color(0xFFA5D6A7),
                ],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Align(
                    alignment: AlignmentGeometry.topLeft,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) {
                              return SignInScreen();
                            },
                          ),
                        );
                      },
                      icon: Icon(Icons.arrow_back_ios),
                    ),
                  ),
                  _buildHeader(),
                  const SizedBox(height: 30),
                  _buildGlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionHeader("Personal Details", Icons.eco),
                        _customField(
                          "Full Name",
                          Icons.person_outline,
                          _nameController,
                        ),
                        _customField(
                          "Email Address",
                          Icons.email_outlined,
                          _emailController,
                        ),
                        _customField(
                          "Product ID",
                          Icons.qr_code_scanner_rounded,
                          _productIDController,
                          hint: "Found on your Growa Device",
                        ),
                        _customField(
                          "Password",
                          Icons.lock_outline,
                          isPassword: true,
                          _passwordController,
                        ),
                        _customField(
                          "Confirm Password",
                          Icons.lock_reset,
                          isPassword: true,
                          _confirmPasswordController,
                        ),
                        _customField(
                          "Green House Name",
                          Icons.house_outlined,
                          _greenhouse_name_Controller,
                        ),

                        const SizedBox(height: 20),
                        _sectionHeader("Green House Address", Icons.home),
                        _customField(
                          "Address Line 1",
                          Icons.home_work_outlined,
                          _addressController,
                        ),
                        _customField(
                          "State",
                          Icons.location_on,
                          _stateController,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: _customField(
                                "City",
                                Icons.location_city,
                                _cityController,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _customField(
                                "Pincode",
                                Icons.pin_drop,
                                isNumber: true,
                                _pincodeController,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        String name = _nameController.text.trim();
                        String email = _emailController.text.trim();
                        String password = _passwordController.text;
                        String confirmPassword =
                            _confirmPasswordController.text;
                        String productID = _productIDController.text;
                        String address = _addressController.text;
                        String city = _cityController.text;
                        String pincode = _pincodeController.text;
                        String state = _stateController.text;
                        String greenhouseName =
                            _greenhouse_name_Controller.text;

                        if (name.isEmpty || email.isEmpty || password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Fill Every Field")),
                          );
                          return;
                        }
                        if (confirmPassword != password) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Passwords do not match")),
                          );
                        }

                        final responese = await _apiService.signUp(
                          name,
                          email,
                          password,
                          confirmPassword,
                          productID,
                          address,
                          pincode,
                          city,
                          state,
                          greenhouseName,
                        );
                        if (responese?.statusCode == 201 ||
                            responese?.statusCode == 200) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) {
                                return DashBoard();
                              },
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "${responese?.data['message'] ?? 'Registration failed'}",
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        "Register",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Image.asset("assets/icons/app_icon.png", width: 135.r, height: 140.r),
        const Text(
          "Growa",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B5E20),
            letterSpacing: 1.5,
          ),
        ),
        Text(
          "Smart Plant Monitoring System",
          style: TextStyle(color: Colors.green[800], fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.4),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF2E7D32)),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
        ],
      ),
    );
  }

  Widget _customField(
    String label,
    IconData icon,
    TextEditingController controllerType, {
    bool isPassword = false,
    bool isNumber = false,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controllerType,
        obscureText: isPassword,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: const Color(0xFF43A047), size: 20),
          filled: true,
          fillColor: Colors.white.withOpacity(0.5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
