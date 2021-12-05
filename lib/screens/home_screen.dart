import 'package:edutopik/constants.dart';
import 'package:edutopik/screens/media/play_time.dart';
import 'package:edutopik/screens/media/player_screen.dart';
import 'package:edutopik/widgets/session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key, required this.uuid, required this.email})
      : super(key: key);
  String uuid;
  String email;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  WebViewController? _controller;
  @override
  Widget build(BuildContext context) {
    String email = widget.email;
    String uuid = widget.uuid;
    return Scaffold(
      // appBar: AppBar(
      //     title: ElevatedButton(
      //   child: Text('send to javascript'),
      //   onPressed: () {
      //     if (_controller != null) {
      //       _controller!.evaluateJavascript(
      //           'window.fromFlutter("this is title from Flutter")');
      //     }
      //   },
      // )),
      body: SafeArea(
        child: WebView(
          initialUrl:
              'https://www.edutopik2.com/seeun_test/auto_login.asp?uid=$email&uuid=$uuid',
          onWebViewCreated: (WebViewController webviewController) {
            _controller = webviewController;
          },
          javascriptMode: JavascriptMode.unrestricted,
          javascriptChannels: Set.from([
            JavascriptChannel(
                name: 'JavaScriptChannel',
                onMessageReceived: (JavascriptMessage message) {
                  // print(message.message);

                  var msg = message.message.split('&');
                  PlayTime playTime = new PlayTime(
                    get_time_url: msg[10],
                    send_url: msg[11],
                    uid: msg[1],
                    ocode: msg[3],
                    scode: msg[4],
                    lm_num: int.parse(msg[6]),
                    lm_time: msg[7],
                    uuid: widget.uuid,
                    check_log_url: msg[12],
                  );

                  if (msg[2] == "overload") {
                    _asyncConfirmDialog(msg[8], msg[9], playTime);
                  }
                  //미디어 플레이어로 이동
                  else {
                    startPlayer(msg[8], msg[9], playTime);
                  }
                })
          ]),
        ),
      ),
    );
  }

  //preUrl: 동영상링크 앞부분(공통), listUrl: 개별 동영상 링크 뒷부분
  void startPlayer(preUrl, listUrl, PlayTime playTime) async {
    //개별 동영상 링크 리스트 가져오기
    String scode = playTime.scode;
    String uid = playTime.uid;
    String uuid = playTime.uuid;
    final Map<String, dynamic> res =
        await new Session().get('$listUrl?scode=$scode&uid=$uid&uuid=$uuid');
    List<List<String>> res2 = await makeUrlList(preUrl, res);
    List<String> urls = res2[0];
    List<String> titles = res2[1];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlayerScreen(
          urls: urls,
          titles: titles,
          playTime: playTime,
        ),
      ),
    );
  }

  Future<void> _asyncConfirmDialog(preUrl, listUrl, playTime) async {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('중복 시청 알림'),
          content: Text('다른 기기에서 강의를 시청 중입니다.\n기기를 변경하시겠습니까?'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          actions: <Widget>[
            ElevatedButton(
              child: Text('아니오'),
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                primary: kPrimaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
              ),
            ),
            ElevatedButton(
              child: Text('예'),
              onPressed: () {
                //test2.asp열어서 덮어쓰기 해야함...
                Navigator.pop(context);
                startPlayer(preUrl, listUrl, playTime);
              },
              style: ElevatedButton.styleFrom(
                primary: kPrimaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
              ),
            )
          ],
        );
      },
    );
  }
}

Future makeUrlList(preUrl, res) async {
  List<String> urls = (res["data"] as List)
      .map<String>((postUrl) => preUrl + '/' + postUrl)
      .toList();
  List<String> titles =
      (res["title"] as List).map<String>((title) => title).toList();
  // print(titles);
  return [urls, titles];
}
