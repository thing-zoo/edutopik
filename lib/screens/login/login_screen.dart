import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:edutopik/screens/home_screen.dart';
import 'package:edutopik/screens/otp/components/device_info.dart';
import 'package:edutopik/widgets/web_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:edutopik/screens/login/components/body.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import "package:http/http.dart" as http;

//Show Loin screen
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  static final storage = new FlutterSecureStorage();
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String userInfo = ".";
  int check = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  _asyncMethod() async {
    //key값에 맞는 정보를 불러옴
    //(데이터가 없을때는 null을 반환을 합니다.) -> 이전에 로그인 하지 않은 경우

    userInfo = (await Body.storage.read(key: "login"))!;

    List<String> user = userInfo.split(' ');
    String userEmail = user[0];
    String userPassword = user[1];
    final String mobileId = await getMobileId();

    var url = Uri.parse('https://www.edutopik2.com/seeun_test/login_proc.asp');

    http.Response response = await http.post(
      url,
      body: {
        'eMail': userEmail,
        //hash 처리 안 한거
        'device_id': mobileId,
        'userPW': userPassword,
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    final int statusCode = response.statusCode;

    final Map<String, dynamic> res =
        json.decode(utf8.decode(response.bodyBytes));

    if (statusCode <= 200 || statusCode >= 400) {
      print("서버 연결 성공");

      if (res["IsRegister"] == "false") {
        // 등록된 기기가 아니네...
        //로그아웃 시키자
        Body.storage.delete(key: "login");
        print("로그아웃");

        //user의 정보가 있다면 바로 로그아웃 페이지로 넝어가게 합니다.
      }
    }
    Body.storage.delete(key: "login");

    print("User Info update");
    userInfo = (await Body.storage.read(key: "login"))!;

    if (userInfo != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => HomeScreen(uuid: mobileId, email: userEmail),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Firebase load fail"),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Body(storage: Body.storage);
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
