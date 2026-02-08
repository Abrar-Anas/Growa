import 'package:flutter/material.dart';
import 'package:growa/model/colors/colors.dart';
import 'package:growa/view/screens/sign_in_screen/sign_in_screen.dart';

import 'package:growa/controllers/auth_service.dart';
import 'package:dio/dio.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final AuthService authService = AuthService();
  final ValueNotifier<bool> obscure = ValueNotifier<bool>(true);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsetsGeometry.only(top: 50, right: 33, left: 33),
                child: Column(
                  children: [
                    Image.asset(
                      "assets/icons/growa_icon_2.png",
                      width: 135,
                      height: 151,
                    ),
                    SizedBox(height: 20),
                    _nameTextField(),
                    SizedBox(height: 15),
                    _email(),
                    SizedBox(height: 95),
                    _newPassword(),
                    SizedBox(height: 15),
                    _confirmNewPassword(),
                    SizedBox(height: 62),
                    _signUpButton(context),
                    SizedBox(height: 43),
                  ],
                ),
              ),
              _alreadySignText(context),
            ],
          ),
        ),
      ),
    );
  }

  ValueListenableBuilder<bool> _newPassword() {
    return ValueListenableBuilder<bool>(
      valueListenable: obscure,
      builder: (context, value, child) {
        return TextField(
          controller: _passwordController,
          obscureText: !obscure.value,
          decoration: InputDecoration(
            hint: Text("Enter New Password", style: TextStyle(color: tfcolor)),
            prefixIcon: Image.asset(
              'assets/icons/lock-icon.png',
              width: 24,
              height: 24,
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                obscure.value = !obscure.value;
              },
              child: obscure.value
                  ? Image.asset(
                      "assets/icons/eye-line.png",
                      width: 24,
                      height: 24,
                    )
                  : Image.asset("assets/icons/eye-close-line.png"),
            ),
            filled: true,
            fillColor: tint,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: tint),
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: tint),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
    );
  }

  Stack _alreadySignText(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/image/leaf_sign_up_page.png",
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Padding(
          padding: const EdgeInsetsGeometry.only(left: 33),
          child: Row(
            children: [
              Text(
                "Already have an account?",
                style: TextStyle(color: grey, fontSize: 14),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(
                    MaterialPageRoute(
                      builder: (context) {
                        return SignInScreen();
                      },
                    ),
                  );
                },
                child: Text(
                  " Sign in",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: green,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  ElevatedButton _signUpButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: green),
      onPressed: () async {
        String name = _nameController.text.trim();
        String email = _emailController.text.trim();
        String password = _passwordController.text.trim();
        String confirmPassword = _confirmPasswordController.text.trim();

        if (name.isEmpty ||
            email.isEmpty ||
            password.isEmpty ||
            confirmPassword.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please fill in all fields")),
          );
          return;
        }

        if (password != confirmPassword) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Passwords do not match")),
          );
          return;
        }

        try {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) =>
                Center(child: CircularProgressIndicator(color: green)),
          );

          final response = await authService.signUp(
            name: name,
            email: email,
            password: password,
            passwordConfirmation: confirmPassword,
          );

          if (!context.mounted) return;
          Navigator.pop(context);

          if (response != null &&
              (response.statusCode == 200 || response.statusCode == 201)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registration Successful!")),
            );
            Navigator.pop(context); // Go back to sign in
          }
        } catch (e) {
          if (!context.mounted) return;
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }

          String errorMessage = "Registration Failed";
          if (e is DioException && e.response?.data != null) {
            errorMessage = e.response?.data['message'] ?? errorMessage;
          } else {
            errorMessage = e.toString();
          }

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(errorMessage)));
        }
      },
      child: Text(
        "Sign Up",
        style: TextStyle(
          color: white,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
    );
  }

  TextField _confirmNewPassword() {
    return TextField(
      controller: _confirmPasswordController,
      obscureText: true,
      decoration: InputDecoration(
        hint: Text("Confirm New Password", style: TextStyle(color: tfcolor)),
        prefixIcon: Image.asset(
          'assets/icons/lock-icon.png',
          width: 24,
          height: 24,
        ),
        filled: true,
        fillColor: tint,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: tint),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: tint),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  TextField _nameTextField() {
    return TextField(
      controller: _nameController,
      cursorErrorColor: red,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: SizedBox(width: 22),
        hint: Text("Enter Your Name", style: TextStyle(color: tfcolor)),
        filled: true,
        fillColor: tint,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: tint),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: tint),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: red),
        ),
      ),
    );
  }

  TextField _email() {
    return TextField(
      controller: _emailController,
      cursorErrorColor: red,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: Image.asset("assets/icons/mail-icon.png"),
        hint: Text("Enter Your Email", style: TextStyle(color: tfcolor)),
        filled: true,
        fillColor: tint,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: tint),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: tint),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: red),
        ),
      ),
    );
  }
}
