import 'package:flutter/material.dart';
import '/components/text_field_container.dart';
import '/constants.dart';

class RoundedPasswordField extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const RoundedPasswordField(
      {Key? key,
      this.onChanged,
      this.hintText,
      required this.controller,
      this.validator})
      : super(key: key);

  @override
  State<RoundedPasswordField> createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool isHiddenPassword = true;

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        controller: widget.controller,
        obscureText: isHiddenPassword,
        onChanged: widget.onChanged,
        validator: widget.validator,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintText: widget.hintText,
          icon: Icon(
            Icons.lock,
            color: kPrimaryColor,
          ),
          suffixIcon: InkWell(
            child: isHiddenPassword
                ? Icon(
                    Icons.visibility,
                    color: kPrimaryColor,
                  )
                : Icon(
                    Icons.visibility_off,
                    color: kPrimaryColor,
                  ),
            onTap: changeShowingpassword,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  void changeShowingpassword() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }
}
