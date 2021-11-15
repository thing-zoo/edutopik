import 'package:edutopik/screens/login/btn/rounded_button.dart';
import 'package:edutopik/widget/web_view.dart';
import 'package:flutter/material.dart';
import 'package:edutopik/size_config.dart';
import 'dart:math';
import 'package:edutopik/constants.dart';
import "package:http/http.dart" as http;
import 'device_info.dart';

class OtpForm extends StatefulWidget {
  const OtpForm({
    Key? key,
  }) : super(key: key);

  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  int auth_code1 = 0;
  int auth_code2 = 0;
  int auth_code3 = 0;
  int auth_code4 = 0;

  String code1 = " ";
  String code2 = " ";
  String code3 = " ";
  String code4 = " ";

  final _controllerCode1 = TextEditingController();
  final _controllerCode2 = TextEditingController();
  final _controllerCode3 = TextEditingController();
  final _controllerCode4 = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _controllerCode1.dispose();
    _controllerCode2.dispose();
    _controllerCode3.dispose();
    _controllerCode4.dispose();
    pin2FocusNode!.dispose();
    pin3FocusNode!.dispose();
    pin4FocusNode!.dispose();
  }

  FocusNode? pin2FocusNode;
  FocusNode? pin3FocusNode;
  FocusNode? pin4FocusNode;

  @override
  void initState() {
    super.initState();

    auth_code1 = Random().nextInt(9) + 1; //4자리수 코드 중 1번 째
    auth_code2 = Random().nextInt(9) + 1; //4자리수 코드 중 2번 째
    auth_code3 = Random().nextInt(9) + 1; //4자리수 코드 중 3번 째
    auth_code4 = Random().nextInt(9) + 1; //4자리수 코드 중 4번 째

    print(auth_code1);
    print(auth_code2);
    print(auth_code3);
    print(auth_code4);

    code1 = auth_code1.toString();
    code2 = auth_code2.toString();
    code3 = auth_code3.toString();
    code4 = auth_code4.toString();

    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
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
                width: getProportionateScreenWidth(55),
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
                width: getProportionateScreenWidth(55),
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
                width: getProportionateScreenWidth(55),
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
                width: getProportionateScreenWidth(55),
                child: TextFormField(
                  focusNode: pin4FocusNode,
                  obscureText: true,
                  style: TextStyle(fontSize: 20),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  controller: _controllerCode4,
                  onChanged: (value) {
                    if (value.length == 1) {
                      pin4FocusNode!.unfocus();
                      print(value);
                      // Then you need to check is the code is correct or not
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.04),
          RoundedButton(
            text: "확인",
            press: () async {
              if ((code1 == _controllerCode1) &&
                  (code2 == _controllerCode2) &&
                  (code3 == _controllerCode3) &&
                  (code4 == _controllerCode4)) {
                final String mobileId = await getMobileId();
                print(mobileId);

                var url = Uri.parse(
                    'http://118.45.182.188/seeun_test/login_proc.asp');

                http.Response response = await http.post(
                  url,
                  body: {
                    'device_id': mobileId,
                  },
                );
                print('Response status: ${response.statusCode}');
                print('Response body: ${response.body}');
              } else {}
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => WebViewScreen(url: 'http://118.45.182.188/'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
