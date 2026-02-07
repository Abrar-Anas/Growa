import 'package:flutter/material.dart';
import 'package:growa/model/colors/colors.dart';
import 'package:growa/view/screens/sign_up_screen/sign_up_screen.dart';

// Run this line:

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});
  final ValueNotifier<bool> obscure = ValueNotifier<bool>(true);
  final ValueNotifier<bool> isChecked = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(33.0),
          child: Column(
            children: [
              Image.asset("assets/icons/growa-logo.png"),
              _signInText(),
              SizedBox(height: 5),
              _subHeading(),
              SizedBox(height: 10),
              _emailTF(),
              SizedBox(height: 20),
              _passwordTF(),
              SizedBox(height: 34),
              _signUpButton(),
              SizedBox(height: 43),
              _rfText(),
              SizedBox(height: 3),
              _orText(),
              SizedBox(height: 3),
              Image.asset("assets/icons/google-icon.png"),
              SizedBox(height: 243),
              _createOne(context),
            ],
          ),
        ),
      ),
    );
  }

  Row _createOne(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("don’t have an account?", style: TextStyle(color: tfcolor)),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return SignUpScreen();
                },
              ),
            );
          },
          child: Text(
            " Create one",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
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
      style: TextStyle(color: grey, fontSize: 20),
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
              width: 18,
              height: 18,
              child: Checkbox(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(5),
                  side: BorderSide(width: 1),
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
        Text(" Remember me?", style: TextStyle(color: grey, fontSize: 14)),
        Spacer(),
        Text("forgot password?", style: TextStyle(color: grey, fontSize: 14)),
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

  ValueListenableBuilder<bool> _passwordTF() {
    return ValueListenableBuilder<bool>(
      valueListenable: obscure,
      builder: (context, value, child) {
        return TextField(
          obscureText: !obscure.value,
          decoration: InputDecoration(
            hint: Text("Password", style: TextStyle(color: tfcolor)),
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

  TextField _emailTF() {
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

  Text _subHeading() {
    return Text(
      "Sign In To Your Account Via Email",
      style: TextStyle(color: grey, fontSize: 15),
    );
  }

  Text _signInText() {
    return Text(
      "Sign In",
      style: TextStyle(color: black, fontWeight: FontWeight.bold, fontSize: 25),
    );
  }
}
