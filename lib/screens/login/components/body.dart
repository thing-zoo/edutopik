import 'package:edutopik/screens/home_screen.dart';
import 'package:edutopik/screens/login/btn/already_have_an_account_acheck.dart';
import 'package:edutopik/screens/login/dialog/devNew_dialog.dart';
import 'package:edutopik/screens/login/dialog/devOveruse_dialog.dart';
import 'package:edutopik/screens/login/dialog/incorrectAcc_dialog.dart';
import 'package:edutopik/screens/login/dialog/nonEmailFormat_dialog.dart';
import 'package:edutopik/screens/otp/components/device_info.dart';
import 'package:edutopik/widgets/web_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:edutopik/screens/login/components/background.dart';
import 'package:edutopik/screens/login/btn/rounded_button.dart';
import 'package:edutopik/screens/login/btn/rounded_email_field.dart';
import 'package:edutopik/screens/login/btn/rounded_password_field.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Body extends StatefulWidget {
  const Body({Key? key, required storage}) : super(key: key);
  static final storage = new FlutterSecureStorage();

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _controllerEmail = TextEditingController();
  final _controllerPassword = TextEditingController();
  String userInfo = "";
  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    int emailCheck = 1;

    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/logo.png",
              width: size.width * 0.6,
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              controller: _controllerEmail,
              hintText: "Your Email",
              onChanged: (text) {
                //hint 역할
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
                await Body.storage.write(
                    key: "login",
                    value: _controllerEmail.text.toString() +
                        " " +
                        _controllerPassword.text.toString());

                print(_controllerEmail.text);
                print(_controllerPassword.text);

                Pattern pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = new RegExp(pattern.toString());
                if (!regExp.hasMatch(_controllerEmail.text)) {
                  emailCheck = 0;
                }
                if (emailCheck == 1) {
                  //디바이스 번호(UUID)
                  final String mobileId = await getMobileId();
                  print(mobileId);

                  //암호화 - sha256
                  Digest hash_password;
                  var password_bytes = utf8.encode(_controllerPassword.text);
                  hash_password = sha256.convert(password_bytes);
                  String hashed_password = hash_password.toString();
                  print("hashed password");
                  print(hashed_password);

                  Digest hash_mobileId;
                  var mobileId_bytes = utf8.encode(mobileId);
                  hash_mobileId = sha256.convert(mobileId_bytes);
                  String hashed_mobileId = hash_mobileId.toString();
                  print("hashed mobileId");
                  print(hashed_mobileId);

                  String nonhased_email = _controllerEmail.text;
                  print("email");
                  print(nonhased_email);

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

                  final Map<String, dynamic> res =
                      json.decode(utf8.decode(response.bodyBytes));

                  if (statusCode <= 200 || statusCode >= 400) {
                    print("서버 연결 성공");

                    if (res["IsLogin"] == "true") {
                      // 로그인 정보가 등록되어 있다면
                      print("로그인 정보가 등록 된 사용자");
                      if (res["IsRegister"] == "true") //UUID가 등록되어 있는 기기라면
                      {
                        print("UUID 등록 된 기기 ");
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => HomeScreen(uuid: hashed_mobileId, email:nonhased_email),
                          ),
                        );
                      } // 등록이 안되어 있으면
                      else {
                        if (res["CountUUID"] == "2") {
                          //기기 바꿀래 물어봐야지
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return DevOveruseDialog(
                                    userId: _controllerEmail.text,
                                    mobileId: hashed_mobileId.toString(),
                                    pass: hashed_password);
                              });
                        } else {
                          //기기 새로 등록할래 물어봐야지c

                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return DevNewDialog(
                                    userId: _controllerEmail.text,
                                    mobileId: hashed_mobileId.toString(),
                                    pass: hashed_password);
                              });
                        }
                      }
                    } else {
                      print("로그인 정보 업슴");
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return IncorrectAccDialog();
                          });
                    }
                  }
                } else {
                  emailCheck = 1;
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return NonEmailFormatDialog();
                      });
                }
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => WebViewScreen(
                      url: 'http://www.edutopik.com/member/join_agree.asp',
                    ),
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
