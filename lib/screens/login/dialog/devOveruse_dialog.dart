import 'dart:convert';

import 'package:edutopik/screens/login/btn/rounded_button_dialog.dart';
import 'package:edutopik/screens/otp/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import "package:http/http.dart" as http;
import 'package:edutopik/constants.dart';

class DevOveruseDialog extends StatefulWidget {
  DevOveruseDialog({
    Key? key,
    required this.userId,
    required this.mobileId,
    required this.pass,
  }) : super(key: key);
  final String userId;
  final String mobileId;
  final String pass;

  @override
  State<DevOveruseDialog> createState() => _DevOveruseDialogState();
}

class _DevOveruseDialogState extends State<DevOveruseDialog> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String deviceName1 = ".";
    String deviceName2 = ".";
    String deviceUUID1 = ".";
    String deviceUUID2 = ".";
    bool isCheck1 = false;
    bool isCheck2 = false;

    _showModalBottomSheet(context) {
      showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(60),
            topRight: Radius.circular(60),
          ),
        ),
        builder: (BuildContext context) {
          return Container(
            height: size.height * 0.45,
            width: size.width,
            child: Column(
              children: [
                SizedBox(height: size.height * 0.04),
                Text(
                  '변경 할 기기를 선택하세요.',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: size.height * 0.025),
                ),
                SizedBox(height: size.height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 60,
                            child: Icon(
                              Ionicons.phone_portrait_outline,
                              color: Colors.black,
                              size: 50,
                            ),
                          ),
                          Text(
                            deviceName1,
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(height: size.height * 0.01),
                        ],
                      ),
                      onPressed: () {
                        print("1");

                        isCheck1 = true;
                        isCheck2 = false;
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500)),
                    ),
                    SizedBox(width: size.width * 0.06),
                    ElevatedButton(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 60,
                            child: Icon(
                              Ionicons.phone_portrait_outline,
                              color: Colors.black,
                              size: 50,
                            ),
                          ),
                          Text(
                            deviceName2,
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(height: size.height * 0.01),
                        ],
                      ),
                      onPressed: () async {
                        print("2");
                        isCheck1 = false;
                        isCheck2 = true;
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.03),
                RoundedButtonForDialog(
                    text: "OK",
                    press: () async {
                      if (isCheck1 = true) //1번 기기 삭제
                      {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => OtpScreen(
                                userId: widget.userId,
                                mobileId: widget.mobileId,
                                pass: widget.pass,
                                deleteDeviceUUID: deviceUUID1),
                          ),
                        );
                      } else {
                        if (isCheck1 = true) //1번 기기 삭제
                        {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => OtpScreen(
                                  userId: widget.userId,
                                  mobileId: widget.mobileId,
                                  pass: widget.pass,
                                  deleteDeviceUUID: deviceUUID2),
                            ),
                          );
                        }
                      }
                    }),
              ],
            ),
          );
        },
      );
    }

    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: size.height * 0.45,
              width: size.width * 0.8,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 82, 10, 5),
                child: Column(
                  children: [
                    Text(
                      '이미 2대의 기기가 등록되어 있습니다.',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: size.height * 0.022),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Text(
                      '한 ID당 2대까지 기기등록이 가능합니다.',
                      style: TextStyle(fontSize: size.height * 0.02),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Text(
                      '2대를 모두 등록한 경우,',
                      style: TextStyle(fontSize: size.height * 0.02),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Text(
                      '본인인증 후 변경이 가능합니다.',
                      style: TextStyle(fontSize: size.height * 0.02),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Text(
                      '기기를 변경 하시겠습니까?',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: size.height * 0.022),
                    ),
                    SizedBox(height: size.height * 0.02),
                    RoundedButtonForDialog(
                        text: "OK",
                        press: () async {
                          /* 사용자 정보는 맞지만 기기가 이미 등록되어있는 경우에는 OTP 인증 하는 페이지로 간다!*/

                          //일단은 pop해서 dialog 없애고
                          Navigator.pop(context, true);
                          //기기 선택 Dialog

                          // 기기 선택 관련 dialog 추가적으로 필요함
                          //1. 일단 데이터 베이스에서 기기를 가져오자.
                          var url = Uri.parse(
                              'https://www.edutopik2.com/seeun_test/select_device.asp');

                          http.Response response = await http.post(
                            url,
                            body: {'eMail': widget.userId},
                          );

                          /* 사용자 정보가 등록되어 있는지 확인하는 부분 : 디비에 해당 사용자 정보가 있는지 확인하는 절차 필요 */

                          final int statusCode = response.statusCode;
                          final Map<String, dynamic> res =
                              json.decode(utf8.decode(response.bodyBytes));

                          print(statusCode);
                          print(res);

                          if (statusCode <= 200 || statusCode >= 400) {
                            print("서버 연결 성공");
                            deviceName1 = res['NAME1'];
                            deviceName2 = res['NAME2'];
                            deviceUUID1 = res['UUID1'];
                            deviceUUID2 = res['UUID2'];
                          }

                          _showModalBottomSheet(context);
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
