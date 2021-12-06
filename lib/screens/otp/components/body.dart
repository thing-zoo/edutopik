import 'package:edutopik/screens/login/dialog/reAuthCode_dialog.dart';
import 'package:flutter/material.dart';
import 'package:edutopik/constants.dart';
import 'package:edutopik/size_config.dart';
import '../otp_screen.dart';
import 'background.dart';
import 'otp_form.dart';

class Body extends StatelessWidget {
  Body(
      {Key? key,
      required this.userId,
      required this.mobileId,
      required this.pass,
      required this.deleteDeviceUUID})
      : super(key: key);
  final String userId;
  final String mobileId;
  final String pass;
  String deleteDeviceUUID;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print(deleteDeviceUUID);
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                "assets/vertification.png",
                width: size.width * 0.32,
              ),
            ),
            SizedBox(height: size.height * 0.03),
            Text(
              "귀하의 휴대전화로 인증코드를 발송했습니다.",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: size.width * 0.035),
            ),
            SizedBox(height: size.height * 0.01),
            buildTimer(),
            SizedBox(height: size.height * 0.03),
            OtpForm(
                userId: userId,
                mobileId: mobileId,
                pass: pass,
                deleteDeviceUUID: deleteDeviceUUID),
            SizedBox(height: SizeConfig.screenHeight * 0.015),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => OtpScreen(
                      userId: userId,
                      mobileId: mobileId,
                      pass: pass,
                      deleteDeviceUUID: " ",
                    ),
                  ),
                );

                // OTP code resend
              },
              child: Text(
                "인증 코드 재전송",
                style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Row buildTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("해당 코드가 만료되기 "),
        TweenAnimationBuilder(
          tween: Tween(begin: 60.0, end: 0.0),
          duration: Duration(seconds: 60),
          builder: (_, dynamic value, child) => Text(
            "00:${value.toInt()}",
            style: TextStyle(color: kPrimaryColor),
          ),
        ),
        Text(" 초 전"),
      ],
    );
  }
}
