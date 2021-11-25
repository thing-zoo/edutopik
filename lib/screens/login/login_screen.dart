import 'package:edutopik/widget/web_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:edutopik/screens/login/components/body.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
    check = 1;
    //read 함수를 통하여 key값에 맞는 정보를 불러오게 됩니다. 이때 불러오는 결과의 타입은 String 타입임을 기억해야 합니다.
    //(데이터가 없을때는 null을 반환을 합니다.)
    userInfo = (await Body.storage.read(key: "login"))!;

    print(userInfo);

    //user의 정보가 있다면 바로 로그아웃 페이지로 넝어가게 합니다.
    if (userInfo != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => WebViewScreen(url: 'http://118.45.182.188/'),
        ),
      );
    }

    return userInfo;
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
            if (check != 0) {
              check = 0;
              return Body(storage: Body.storage);
            }
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
