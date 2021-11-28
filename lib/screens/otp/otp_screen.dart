import 'package:flutter/material.dart';
import 'package:edutopik/size_config.dart';

import 'components/body.dart';

class OtpScreen extends StatelessWidget {
  OtpScreen(
      {Key? key,
      required this.userId,
      required this.mobileId,
      required this.pass})
      : super(key: key);
  final String userId;
  final String mobileId;
  final String pass;
  static String routeName = "/otp";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("OTP Verification"),
      ),
      body: Body(userId: userId, mobileId: mobileId, pass: pass),
    );
  }
}
