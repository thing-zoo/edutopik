import 'package:edutopik/screens/login/btn/rounded_button_dialog.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class SimultaneousAccessDialog extends StatelessWidget {
  const SimultaneousAccessDialog({Key? key}) : super(key: key);

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
              height: size.height * 0.35,
              width: size.width * 0.8,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 82, 10, 5),
                child: Column(
                  children: [
                    Text(
                      '이미 다른 기기에서 수강 중입니다.',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Text(
                      '다른기기의 수강을 강제 종료한 후',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Text(
                      '현재 기기로 수강하시겠습니까?',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: size.height * 0.02),
                    RoundedButtonForDialog(
                        text: "OK",
                        press: () {
                          /* 강제 종료 */
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
