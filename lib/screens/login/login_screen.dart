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
    //read 함수를 통하여 key값에 맞는 정보를 불러오게 됩니다. 이때 불러오는 결과의 타입은 String 타입임을 기억해야 합니다.
    //(데이터가 없을때는 null을 반환을 합니다.)

    //로그인이 되어 있는 기기는 해당 디바이스가 디비에서 삭제되어있을 경우 로그인 해제해야함
    userInfo = (await Body.storage.read(key: "login"))!;

    print(userInfo);

    List<String> user = userInfo.split(' ');
    String userEmail = user[0];
    String userPassword = user[1];

    final String mobileId = await getMobileId();
    print(mobileId);

    Digest hash_mobileId;
    var mobileId_bytes = utf8.encode(mobileId);
    hash_mobileId = sha256.convert(mobileId_bytes);
    String hashed_mobileId = hash_mobileId.toString();
    print("hashed mobileId");
    print(hashed_mobileId);

    String nonhased_email = userEmail;
    print("email");
    print(nonhased_email);
    check = 1;

    Digest hash_password;
    var password_bytes = utf8.encode(userPassword);
    hash_password = sha256.convert(password_bytes);
    String hashed_password = hash_password.toString();
    print("hashed password");
    print(hashed_password);

    var url = Uri.parse('http://118.45.182.188/seeun_test/login_proc.asp');

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

    final int statusCode = response.statusCode;

    final Map<String, dynamic> res =
        json.decode(utf8.decode(response.bodyBytes));

    if (statusCode <= 200 || statusCode >= 400) {
      print("서버 연결 성공");

      if (res["IsRegister"] == "false") {
        // 등록된 기기가 아니네...
        //로그아웃 시키자
        Body.storage.delete(key: "login");
        print("냠냠 로그아웃");

        //user의 정보가 있다면 바로 로그아웃 페이지로 넝어가게 합니다.
      }
    }
    Body.storage.delete(key: "login");

    print("User Info update");
    userInfo = (await Body.storage.read(key: "login"))!;

    if (userInfo != null) {
      //쿠키 넘기기
      print("쿠기 넘기기");
      var curl = Uri.parse('http://118.45.182.188/seeun_test/auto_login.asp');

      http.Response cresponse = await http.post(
        curl,
        body: {
          'device_id': hashed_mobileId,
          'eMail': nonhased_email,
          //'userPW': hashed_password,
        },
      );

      print('Response status: ${cresponse.statusCode}');
      print('Response body: ${cresponse.body}');

      final int cstatusCode = cresponse.statusCode;

      final Map<String, dynamic> cres =
          json.decode(utf8.decode(cresponse.bodyBytes));

      if (cstatusCode <= 200 || cstatusCode >= 400) {
        print(res);
      }

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => HomeScreen(uuid: hashed_mobileId),
          // builder: (_) => WebViewScreen(url: 'http://118.45.182.188/'),
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
