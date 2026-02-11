import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:growa/model/colors/colors.dart';
import 'package:growa/view/screens/home_screen/home_screen.dart';
import 'package:growa/view/screens/sign_up_screen/sign_up_screen.dart';

import 'package:growa/controllers/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Run this line:

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final ApiService _apiService = ApiService();

  final ValueNotifier<bool> obscure = ValueNotifier<bool>(true);

  final ValueNotifier<bool> isChecked = ValueNotifier<bool>(false);

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(33.0).r,
          child: Column(
            children: [
              _growaLogo(),
              _signInText(),
              5.verticalSpace,
              _subHeading(),
              10.verticalSpace,
              _emailTF(),
              15.verticalSpace,
              _passwordTF(),
              28.verticalSpace,
              _signInButton(context),
              35.verticalSpace,
              _rfText(),
              3.verticalSpace,
              _orText(),
              3.verticalSpace,
              Image.asset("assets/icons/google-icon.png"),
              185.verticalSpace,
              _createOne(context),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton _signInButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: green),
      onPressed: () async {
        final response = await _apiService.login(
          _emailController.text.trim(),
          _passwordController.text,
        );
        if (response?.statusCode == 200) {
          String token = response?.data['token'];
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_token', token);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) {
                return HomeScreen();
              },
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Login Failed ${response?.data['message'] ?? 'Check credinals'}",
              ),
            ),
          );
        }
      },
      child: Text(
        "Sign In",
        style: TextStyle(
          color: white,
          fontWeight: FontWeight.w600,
          fontSize: 20.r,
        ),
      ),
    );
  }

  Hero _growaLogo() {
    return Hero(
      tag: "grow logo",
      child: Image.asset(
        "assets/icons/growa-logo.png",
        width: 338.r,
        height: 185.r,
      ),
    );
  }

  Row _createOne(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "don’t have an account?",
          style: TextStyle(color: tfcolor, fontSize: 14.r),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 600),
                pageBuilder: (context, animation, secondaryAnimation) =>
                    SignUpScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0); // slide from right
                      const end = Offset.zero;
                      const curve = Curves.easeInOut;

                      var tween = Tween(
                        begin: begin,
                        end: end,
                      ).chain(CurveTween(curve: curve));

                      var fadeTween = Tween<double>(begin: 0.0, end: 1.0);

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: FadeTransition(
                          opacity: animation.drive(fadeTween),
                          child: child,
                        ),
                      );
                    },
              ),
            );
          },
          child: Text(
            " Create one",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14.r,
              color: green,
            ),
          ),
        ),
      ],
    );
  }

  Text _orText() {
    return Text(
      "────────  OR  ────────",
      style: TextStyle(color: grey, fontSize: 20.r),
    );
  }

  Row _rfText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ValueListenableBuilder(
          valueListenable: isChecked,
          builder: (context, value1, child) {
            return SizedBox(
              width: 18.r,
              height: 18.r,
              child: Checkbox(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(5.r),
                  side: BorderSide(width: 1.r),
                ),
                activeColor: green,
                value: value1,
                onChanged: (bool? value) {
                  isChecked.value = !value1;
                },
              ),
            );
          },
        ),
        Text(
          " Remember me?",
          style: TextStyle(color: grey, fontSize: 14.r),
        ),
        Spacer(),
        Text(
          "forgot password?",
          style: TextStyle(color: grey, fontSize: 14.r),
        ),
      ],
    );
  }

  ValueListenableBuilder<bool> _passwordTF() {
    return ValueListenableBuilder<bool>(
      valueListenable: obscure,
      builder: (context, value, child) {
        return TextField(
          controller: _passwordController,
          obscureText: !obscure.value,
          decoration: InputDecoration(
            hint: Text("Password", style: TextStyle(color: tfcolor)),
            prefixIcon: Image.asset(
              'assets/icons/lock-icon.png',
              width: 24.r,
              height: 24.r,
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                obscure.value = !obscure.value;
              },
              child: obscure.value
                  ? Image.asset(
                      "assets/icons/eye-line.png",
                      width: 24.r,
                      height: 24.r,
                    )
                  : Image.asset("assets/icons/eye-close-line.png"),
            ),
            filled: true,
            fillColor: tint,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: tint),
              borderRadius: BorderRadius.circular(12.r),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: tint),
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        );
      },
    );
  }

  TextField _emailTF() {
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
          borderRadius: BorderRadius.circular(12.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: tint),
          borderRadius: BorderRadius.circular(12.r),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: red),
        ),
      ),
    );
  }

  Text _subHeading() {
    return Text(
      "Sign In To Your Account Via Email",
      style: TextStyle(color: grey, fontSize: 15.r),
    );
  }

  Text _signInText() {
    return Text(
      "Sign In",
      style: TextStyle(
        color: black,
        fontWeight: FontWeight.bold,
        fontSize: 25.r,
      ),
    );
  }
}
