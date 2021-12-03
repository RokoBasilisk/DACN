import 'package:flutter/material.dart';
import 'package:foodorder/components/text_field_container.dart';
import 'package:foodorder/style.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const RoundedPasswordField({
    Key? key, 
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        onChanged: onChanged,
        obscureText: true,
        decoration: const InputDecoration(
          hintText: "Password",
          icon: Icon(
            Icons.lock,
            color: purple,
          ),
          suffixIcon: Icon(
            Icons.visibility,
            color: purple,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}