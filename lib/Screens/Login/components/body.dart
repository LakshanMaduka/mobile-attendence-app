import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/fogotPaasordScreen/forgotpassword.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/utils.dart';
import '/Screens/Login/components/background.dart';

import '/components/already_have_an_account_acheck.dart';
import '/components/rounded_button.dart';
import '/components/rounded_input_field.dart';
import '/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';

class Body extends StatefulWidget {
  Body({
    Key? key,
  }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "SIGN IN",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              SizedBox(height: size.height * 0.03),
              Container(
                height: size.height * 0.3,
                child: Image.asset('assets/images/login.jpg'),
              ),
              SizedBox(height: size.height * 0.03),
              RoundedInputField(
                hintText: "Your Email",
                onChanged: (value) {},
                controller: emailController,
                validator: (email) =>
                    email != null && !EmailValidator.validate(email)
                        ? 'Enter valid email'
                        : null,
              ),
              RoundedPasswordField(
                hintText: "Password",
                onChanged: (value) {},
                controller: passwordController,
                validator: (psw) => psw!.isEmpty ? 'Password is empty' : null,
              ),
              RoundedButton(
                text: Text(
                  'SIGN IN',
                  style: TextStyle(fontSize: 15),
                ),
                press: signIn,
              ),
              SizedBox(height: size.height * 0.03),
              GestureDetector(
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: kPrimaryColor,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ForgotPasswordPage()));
                },
              ),
              SizedBox(height: size.height * 0.015),
              // AlreadyHaveAnAccountCheck(
              //   press: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) {
              //           return SignUpScreen();
              //         },
              //       ),
              //     );
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Future signIn() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBAr(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
