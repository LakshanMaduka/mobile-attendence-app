import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/rounded_button.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/utils.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: kPrimaryColor),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Reset Password',
            style: TextStyle(color: kPrimaryColor),
          )),
      body: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter your email to \n reset your password',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, color: kPrimaryColor),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              child: TextFormField(
                textAlign: TextAlign.center,
                controller: emailController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(hintText: 'Email'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) =>
                    email != null && !EmailValidator.validate(email)
                        ? 'Enter valid email'
                        : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              child: ElevatedButton.icon(
                onPressed: resetPassword,
                style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50), primary: kPrimaryColor),
                icon: Icon(Icons.email_outlined),
                label: Text(
                  'Reset Password',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            )
            // RoundedButton(
            //   text: Text(
            //     'Reset Password',
            //     style: TextStyle(fontSize: 20),
            //   ),
            //   press: resetPassword,
            // ),
          ],
        ),
      ),
    );
  }

  Future resetPassword() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      Utils.showSnackBAr('Password Reset Email Sent');
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBAr(e.message);
      Navigator.of(context).pop();
    }
  }
}
