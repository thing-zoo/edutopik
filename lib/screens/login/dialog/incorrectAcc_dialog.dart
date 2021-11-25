import 'package:edutopik/screens/login/btn/rounded_button_dialog.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class IncorrectAccDialog extends StatelessWidget {
  const IncorrectAccDialog({Key? key}) : super(key: key);

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
              height: size.height * 0.245,
              width: size.width * 0.8,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 70, 10, 5),
                child: Column(
                  children: [
                    Text(
                      '아이디 또는 비밀번호가 일치하지 않습니다.',
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
                  backgroundColor: Colors.black,
                  radius: 50,
                  child: Icon(
                    Ionicons.person_circle_outline,
                    color: Colors.white,
                    size: 100,
                  ),
                )),
          ],
        ));
  }
}
