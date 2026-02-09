import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                padding: EdgeInsets.only(top: 50, right: 33, left: 33).r,
                child: Column(
                  children: [
                    Image.asset(
                      "assets/icons/growa_icon_2.png",
                      width: 135.r,
                      height: 151.r,
                    ),
                    13.verticalSpace,
                    _nameTextField(),
                    15.verticalSpace,
                    _email(),
                    60.verticalSpace,
                    _newPassword(),
                    15.verticalSpace,
                    _confirmNewPassword(),
                    55.verticalSpace,
                    _signUpButton(),
                    35.verticalSpace,
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

  Stack _alreadySignText(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/image/leaf_sign_up_page.png",
          width: 406.9933111179363.r,
          fit: BoxFit.cover,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 33).r,
          child: Row(
            children: [
              Text(
                "Already have an account?",
                style: TextStyle(color: grey, fontSize: 14.r),
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
                    fontSize: 14.r,
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
          fontSize: 20.r,
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
          width: 24.r,
          height: 24.r,
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
  }

  TextField _nameTextField() {
    return TextField(
      cursorErrorColor: red,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: SizedBox(width: 22.r),
        hint: Text("Enter Your Name", style: TextStyle(color: tfcolor)),
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
}
