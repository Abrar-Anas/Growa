import 'package:flutter/material.dart';
import 'package:growa/model/colors/colors.dart';
import 'package:growa/view/screens/sign_in_screen/sign_in_screen.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});
  final ValueNotifier<bool> obscure = ValueNotifier<bool>(true);

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
                    _signUpButton(),
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

  ElevatedButton _signUpButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: green),
      onPressed: () {},
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
      obscureText: false,
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
