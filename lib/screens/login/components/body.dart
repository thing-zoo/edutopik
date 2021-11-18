import 'package:edutopik/screens/login/btn/already_have_an_account_acheck.dart';
import 'package:edutopik/screens/login/dialog/devOveruse_dialog.dart';
import 'package:edutopik/screens/login/dialog/incorrectAcc_dialog.dart';
import 'package:edutopik/screens/otp/components/device_info.dart';
import 'package:edutopik/widget/web_view.dart';
import 'package:flutter/material.dart';
import 'package:edutopik/screens/login/components/background.dart';
import 'package:edutopik/screens/login/btn/rounded_button.dart';
import 'package:edutopik/screens/login/btn/rounded_email_field.dart';
import 'package:edutopik/screens/login/btn/rounded_password_field.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import "package:http/http.dart" as http;

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
    String userEmail = "maanki@nate.com";
    String userPass = "2580";

    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Text(
            //   "LOGIN",
            //   style: TextStyle(fontWeight: FontWeight.bold),
            // ),
            // SizedBox(height: size.height * 0.03),
            Image.asset(
              "assets/logo.png",
              width: size.width * 0.6,
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

                //디바이스 번호
                final String mobileId = await getMobileId();
                print(mobileId);

                //암호화
                Digest hash_password;
                var password_bytes = utf8.encode(_controllerPassword.text);
                hash_password = sha256.convert(password_bytes);
                String hashed_password = hash_password.toString();

                Digest hash_mobileId;
                var mobileId_bytes = utf8.encode(mobileId);
                hash_mobileId = sha256.convert(mobileId_bytes);
                String hashed_mobileId = hash_mobileId.toString();

                String nonhased_email = _controllerEmail.text;

                var url = Uri.parse(
                    'http://118.45.182.188/seeun_test/login_proc.asp');

                http.Response response = await http.post(
                  url,
                  body: {
                    'device_id': hashed_mobileId,
                    'eMail': nonhased_email,
                    'userPW': hashed_password,
                  },
                );
                print('Response status: ${response.statusCode}');
                print('Response body: ${response.body}');

                /* 사용자 정보가 등록되어 있는지 확인하는 부분,
                디비에 해당 사용자 정보가 있는지 확인하는 절차 필요 */
                final int statusCode = response.statusCode;

                //final Map<String, dynamic> res =
                //  json.decode(utf8.decode(response.bodyBytes));

/*
                if (statusCode <= 200 || statusCode >= 400) {

                  if(res == ){
                      showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return DevOveruseDialog(userId: _controllerEmail.text, mobileId: hashed_mobileId.toString());
                      });
                  }
                  
                  /* 현재 로그인을 시도한 기기가 등록된 기기인지 확인하고

                  1. 등록된 기기가 아니고 2개의 기기 모두 등록 되어 있는 경우
                  if( )
                  showDialog(
                      context: context,
                      builder: (BuildContext context){
                        return LoginDialog();
                      });

                  2. 등록된 기기는 아니지만 등록된 기기가 2개가 되지 않았을 경우 
                  */

                  /* 사용자 로그인 완료 및 기기 등록 제한에 걸리지 않으면.. 웹뷰 페이지로 이동..
                  
                  Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                      WebViewScreen(url: 'http://118.45.182.188/'),    
                    ),
                  );
                  */
    }
                  
                } else {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return IncorrectAccDialog();
                      });
                  if (_controllerEmail.text == userEmail &&
                      _controllerPassword.text != userPass) {
                    print("password error");
                  } else if (_controllerEmail.text != userEmail &&
                      _controllerPassword.text == userPass) {
                    print("email error");
                  } else {
                    print("error");
                  }
                }*/
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
