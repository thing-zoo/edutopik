import 'package:edutopik/screens/login/btn/rounded_button_dialog.dart';
import 'package:edutopik/screens/otp/otp_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class DevOveruseDialog extends StatelessWidget {
  const DevOveruseDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String phoneNumber;

    final FirebaseAuth _auth = FirebaseAuth.instance;

    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: size.height * 0.39,
              width: size.width * 0.8,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 82, 10, 5),
                child: Column(
                  children: [
                    Text(
                      '이미 2대의 기기가 등록되어 있습니다.',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Text(
                      '한 ID당 2대까지 기기등록이 가능합니다.',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Text(
                      '2대를 모두 등록한 경우,',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Text(
                      '본인인증 후 변경이 가능합니다.',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Text(
                      '기기를 변경 하시겠습니까?',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: size.height * 0.02),
                    RoundedButtonForDialog(
                        text: "OK",
                        press: () async {
                          /* 사용자 정보는 맞지만 기기가 이미 등록되어있는 경우에는 OTP 인증 하는 페이지로 간다!
                  백앤드 칭구가 이거 이미 기기 등록 되어 있는지 확인 하는 매커니즘 여기에 추가해주면 될 것 가타
                   */
                          await _auth.verifyPhoneNumber(
                            timeout: const Duration(seconds: 60),
                            codeAutoRetrievalTimeout: (String verificationId) {
                              // Auto-resolution timed out...
                            },
                            phoneNumber: "+8210" + "2523" + "9668",
                            verificationCompleted: (phoneAuthCredential) async {
                              print("otp 문자옴");
                            },
                            verificationFailed: (verificationFailed) async {
                              print(verificationFailed.code);
                              print("코드발송실패");
                            },
                            codeSent: (verificationId, resendingToken) async {
                              print("코드보냄");
                            },
                          );

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => OtpScreen(),
                            ),
                          );
                        }),
                  ],
                ),
              ),
            ),
            Positioned(
                top: -55,
                child: CircleAvatar(
                  backgroundColor: Colors.redAccent,
                  radius: 55,
                  child: Icon(
                    Ionicons.alert_outline,
                    color: Colors.white,
                    size: 85,
                  ),
                )),
          ],
        ));
  }
}
