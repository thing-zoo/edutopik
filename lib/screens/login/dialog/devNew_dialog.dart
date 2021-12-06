import 'package:edutopik/screens/login/btn/rounded_button_dialog.dart';
import 'package:edutopik/screens/otp/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class DevNewDialog extends StatelessWidget {
  DevNewDialog(
      {Key? key,
      required this.userId,
      required this.mobileId,
      required this.pass})
      : super(key: key);
  final String userId;
  final String mobileId;
  final String pass;
  String deleteDeviceUUID = " ";
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: size.height * 0.28,
              width: size.width * 0.8,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 70, 10, 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '새로운 기기로 로그인 하셨습니다.',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    // SizedBox(height: size.height * 0.02),
                    Text(
                      '해당 기기를 등록하시겠습니까?',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    // SizedBox(height: size.height * 0.02),
                    RoundedButtonForDialog(
                        text: "OK",
                        press: () async {
                          /* 사용자 정보는 맞지만 기기가 이미 등록되어있는 경우에는 OTP 인증 하는 페이지로 간다!
                  백앤드 칭구가 이거 이미 기기 등록 되어 있는지 확인 하는 매커니즘 여기에 추가해주면 될 것 가타
                   */
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => OtpScreen(
                                  userId: userId,
                                  mobileId: mobileId,
                                  pass: pass,
                                  deleteDeviceUUID: deleteDeviceUUID),
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
