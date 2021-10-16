import 'package:flutter/material.dart';
import 'package:edutopik/screen/login/components/background.dart';
import 'package:edutopik/screen/login/btn/rounded_button.dart';
import 'package:edutopik/screen/login/btn/rounded_email_field.dart';
import 'package:edutopik/screen/login/btn/rounded_password_field.dart';
import 'package:edutopik/widget/webviewpage.dart';

class Body extends StatefulWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _controllerEmail = TextEditingController();
  final _controllerPassword = TextEditingController();

  @override
  void dispoes() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                "assets/logo.png",
                width: size.width * 0.6,
              ),
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              controller: _controllerEmail,
              hintText: "Your Email",
              onChanged: (text) {
                print(text);
              },
            ),
            RoundedPasswordField(
              controller: _controllerPassword,
              onChanged: (text) {
                print(text);
              },
            ),
            SizedBox(height: size.height * 0.03),
            RoundedButton(
              text: "LOGIN",
              press: () async {
                print(_controllerEmail.text);
                print(_controllerPassword.text);
                /*사용자 정보가 등록되어 있는지 확인하는 부분 - 나중에 백엔드 친구가 해주면 추가하께 >_< */
                if (_controllerEmail.text == "wlwl1011@naver.com" &&
                    _controllerPassword.text == "123") {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => WebViewPage(),
                    ),
                  );
                } else if (_controllerEmail.text == "wlwl1011@naver.com" &&
                    _controllerPassword.text != "123") {
                  print("password error");
                } else if (_controllerEmail.text != "wlwl1011@naver.com" &&
                    _controllerPassword.text == "123") {
                  print("email error");
                } else {
                  print("error");
                }
/*
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => MyHomePage(),
                  ),
                );*/
              },
            ),
            SizedBox(height: size.height * 0.03),
          ],
        ),
      ),
    );
  }
}
