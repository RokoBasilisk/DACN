import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodorder/Screens/Login/components/background.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodorder/components/already_have_an_account.dart';
import 'package:foodorder/components/rounded_input_field.dart';
import 'package:foodorder/components/rounded_password_field.dart';
import 'package:foodorder/components/roundedbutton.dart';
import 'package:foodorder/models/user_model.dart';
import 'package:http/http.dart' as http;

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String username = "";
    String password = "";

    return Background(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "SIGNUP",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: size.height * 0.03),
          SvgPicture.asset(
            "assets/icons/signup.svg",
            height: size.height * 0.35,
          ),
          SizedBox(height: size.height * 0.03),
          RoundedInputField(
              hintText: "Your Username",
              onChanged: (value) {
                username = value;
              }),
          RoundedPasswordField(
            onChanged: (value) {
              password = value;
            },
          ),
          RoundedButton(
            text: "SIGNUP",
            press: () async {
              final data =
                 await createUser(UserModel(username: username, password: password));
              handle(data, context);
            },
          ),
          SizedBox(height: size.height * 0.03),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.of(context).pushNamed("/login");
            },
          ),
        ],
      ),
    );
  }
}

void handle(data, BuildContext context) {
  final bool success = data['success'];

  if (success) {
    Navigator.of(context).pushNamed("/login");
  }
}

Future<Map> createUser(UserModel user) async {
  final newUser = json.encode(user);
  final Uri apiURL = Uri.http("192.168.1.12:5000", "api/customer/register");
  final response = await http.post(apiURL,
      headers: {"Content-Type": "application/json"}, body: newUser);
  if (response.statusCode == 200) {
    final String responseString = response.body;
    return jsonDecode(responseString);
  } else {
    final String responseString = response.body;
    return jsonDecode(responseString);
  }
}
