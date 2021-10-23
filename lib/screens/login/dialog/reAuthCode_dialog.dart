import 'package:edutopik/screens/login/btn/rounded_button_dialog.dart';
import 'package:edutopik/screens/otp/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class ReAuthCodeDialog extends StatelessWidget {
  const ReAuthCodeDialog({Key? key}) : super(key: key);

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
              height: size.height * 0.23,
              width: size.width * 0.8,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 70, 10, 5),
                child: Column(
                  children: [
                    Text(
                      '인증 번호를 재 전송 했습니다.',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: size.height * 0.02),
                    RoundedButtonForDialog(
                      text: "OK",
                      press: () => Navigator.pop(context, true),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
                top: -55,
                child: CircleAvatar(
                  backgroundColor: Colors.green,
                  radius: 50,
                  child: Icon(
                    Ionicons.checkmark_circle,
                    color: Colors.white,
                    size: 100,
                  ),
                )),
          ],
        ));
  }
}
