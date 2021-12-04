import 'dart:convert';

import 'package:device_info/device_info.dart';
import 'package:edutopik/screens/home_screen.dart';
import 'package:edutopik/screens/login/btn/rounded_button.dart';
import 'package:edutopik/screens/otp/dialog/incorrectAuth_dialog.dart';
import 'package:edutopik/widgets/web_view.dart';
import 'package:flutter/material.dart';
import 'package:edutopik/size_config.dart';
import 'package:edutopik/constants.dart';
import "package:http/http.dart" as http;
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

String verificationId1 = "";

class OtpForm extends StatefulWidget {
  OtpForm(
      {Key? key,
      required this.userId,
      required this.mobileId,
      required this.pass,
      required this.deleteDeviceUUID})
      : super(key: key);
  final String userId;
  final String mobileId; //hashed
  final String pass;
  final String deleteDeviceUUID;

  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  String code = " "; //전체 코드

  final _controllerCode1 = TextEditingController();
  final _controllerCode2 = TextEditingController();
  final _controllerCode3 = TextEditingController();
  final _controllerCode4 = TextEditingController();
  final _controllerCode5 = TextEditingController();
  final _controllerCode6 = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _controllerCode1.dispose();
    _controllerCode2.dispose();
    _controllerCode3.dispose();
    _controllerCode4.dispose();
    _controllerCode5.dispose();
    _controllerCode6.dispose();
    pin2FocusNode!.dispose();
    pin3FocusNode!.dispose();
    pin4FocusNode!.dispose();
    pin5FocusNode!.dispose();
    pin6FocusNode!.dispose();
  }

  FocusNode? pin2FocusNode;
  FocusNode? pin3FocusNode;
  FocusNode? pin4FocusNode;
  FocusNode? pin5FocusNode;
  FocusNode? pin6FocusNode;

  @override
  void initState() {
    super.initState();
    //sendMessage(widget.userId);
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
    pin5FocusNode = FocusNode();
    pin6FocusNode = FocusNode();
  }

  void nextField(String value, FocusNode? focusNode) {
    if (value.length == 1) {
      focusNode!.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Form(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //1
              SizedBox(
                width: getProportionateScreenWidth(40),
                child: TextFormField(
                  autofocus: true,
                  obscureText: true,
                  style: TextStyle(fontSize: 20),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  controller: _controllerCode1,
                  onChanged: (value) {
                    nextField(value, pin2FocusNode);
                  },
                ),
              ),
              SizedBox(width: size.width * 0.02),
              //2
              SizedBox(
                width: getProportionateScreenWidth(40),
                child: TextFormField(
                  focusNode: pin2FocusNode,
                  obscureText: true,
                  style: TextStyle(fontSize: 20),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  controller: _controllerCode2,
                  onChanged: (value) => nextField(value, pin3FocusNode),
                ),
              ),
              SizedBox(width: size.width * 0.02),
              //3
              SizedBox(
                width: getProportionateScreenWidth(40),
                child: TextFormField(
                  focusNode: pin3FocusNode,
                  obscureText: true,
                  style: TextStyle(fontSize: 20),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  controller: _controllerCode3,
                  onChanged: (value) => nextField(value, pin4FocusNode),
                ),
              ),
              SizedBox(width: size.width * 0.02),
              //4
              SizedBox(
                width: getProportionateScreenWidth(40),
                child: TextFormField(
                  focusNode: pin4FocusNode,
                  obscureText: true,
                  style: TextStyle(fontSize: 20),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  controller: _controllerCode4,
                  onChanged: (value) => nextField(value, pin5FocusNode),
                ),
              ),
              SizedBox(width: size.width * 0.02),
              //5
              SizedBox(
                width: getProportionateScreenWidth(40),
                child: TextFormField(
                  focusNode: pin5FocusNode,
                  obscureText: true,
                  style: TextStyle(fontSize: 20),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  controller: _controllerCode5,
                  onChanged: (value) => nextField(value, pin6FocusNode),
                ),
              ),
              SizedBox(width: size.width * 0.02),
              //6
              SizedBox(
                width: getProportionateScreenWidth(40),
                child: TextFormField(
                  focusNode: pin6FocusNode,
                  obscureText: true,
                  style: TextStyle(fontSize: 20),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  controller: _controllerCode6,
                  onChanged: (value) {},
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.04),
          RoundedButton(
            text: "확인",
            press: () async {
              code = _controllerCode1.text +
                  _controllerCode2.text +
                  _controllerCode3.text +
                  _controllerCode4.text +
                  _controllerCode5.text +
                  _controllerCode6.text;

              try {
                /*PhoneAuthCredential phoneAuthCredential =
                    PhoneAuthProvider.credential(
                        verificationId: verificationId1, smsCode: code);

                final authCredential =
                    await _auth.signInWithCredential(phoneAuthCredential);

                print("인증번호가 맞나?");

                print(authCredential.user);*/

                if (code == "111111") {
                  // 인증코드가 맞으면
                  print("인증번호 맞음");
                  var url = Uri.parse(
                      'https://www.edutopik2.com/seeun_test/device_register.asp');

                  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                  IosDeviceInfo deviceName = await deviceInfo.iosInfo;
                  print('name ${deviceName.name}');

                  http.Response response = await http.post(
                    url,
                    body: {
                      'device_id': widget.mobileId,
                      'eMail': widget.userId,
                      'device_name': deviceName.name,
                      'delete_device': widget.deleteDeviceUUID
                    },
                  );

                  print('Response status: ${response.statusCode}');
                  print('Response body: ${response.body}');
                  final int statusCode = response.statusCode;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => HomeScreen(
                          uuid: widget.mobileId, email: widget.userId),
                    ),
                  );
                }
              } catch (e) {
                // 예외처리를 위한 코드
                // code for handling exception
                print(e);
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return IncorrectAuthDialog();
                    });
              }
            },
          ),
        ],
      ),
    );
  }
}

void sendMessage(String userId) async {
  var url = Uri.parse('https://www.edutopik2.com/seeun_test/user_info.asp');

  http.Response response = await http.post(
    url,
    body: {
      'eMail': userId,
    },
  );
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
  final int statusCode = response.statusCode;
  final Map<String, dynamic> res = json.decode(utf8.decode(response.bodyBytes));
  print(statusCode);
  print(res);

  if (statusCode <= 200 || statusCode >= 400) {
    await _auth.verifyPhoneNumber(
        timeout: const Duration(seconds: 60),
        codeAutoRetrievalTimeout: (verificationId) {
          // Auto-resolution timed out...
        },
        phoneNumber: res['Phone'],
        verificationCompleted: (phoneAuthCredential) async {
          print("otp 문자옴");
        },
        verificationFailed: (verificationFailed) async {
          print(verificationFailed.code);
          print("코드발송실패");
        },
        codeSent: (verificationId, resendingToken) async {
          print("코드보냄");
          verificationId1 = verificationId;
        });
  }
}
