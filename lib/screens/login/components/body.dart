import 'package:edutopik/screens/login/btn/already_have_an_account_acheck.dart';
import 'package:edutopik/screens/otp/otp_screen.dart';
import 'package:edutopik/widget/web_view.dart';
import 'package:flutter/material.dart';
import 'package:edutopik/screens/login/components/background.dart';
import 'package:edutopik/screens/login/btn/rounded_button.dart';
import 'package:edutopik/screens/login/btn/rounded_email_field.dart';
import 'package:edutopik/screens/login/btn/rounded_password_field.dart';

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
  void dispose() {
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
                  /* 사용자 정보는 맞지만 기기가 이미 등록되어있는 경우에는 OTP 인증 하는 페이지로 간다!
                  백앤드 칭구가 이거 이미 기기 등록 되어 있는지 확인 하는 매커니즘 여기에 추가해주면 될 것 가타
                  
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                         
                          OtpScreen(), 
                    ),
                  );
                  
                  */
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          WebViewScreen(url: 'http://118.45.182.188/'),
                      //OtpScreen(),
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
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => WebViewScreen(
                        url: 'http://www.edutopik.com/member/join_agree.asp'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
