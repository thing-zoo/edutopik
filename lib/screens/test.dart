import 'package:edutopik/screens/media/play_time.dart';
import 'package:edutopik/screens/media/player_screen.dart';
import 'package:edutopik/screens/test_http.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key, required this.uuid}) : super(key: key);
  String uuid;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  WebViewController? _controller;

  @override
  Widget build(BuildContext context) {
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
          initialUrl: 'http://118.45.182.188/',
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
                    check_log: msg[12],
                  );

                  if (msg[0] == '"playLecture') {
                    if (msg[2] == "overload") {
                      _asyncConfirmDialog(msg[8], msg[9], playTime);
                    }
                    //미디어 플레이어로 이동
                    else {
                      startPlayer(msg[8], msg[9], playTime);
                    }
                  } else {
                    //중복이라는걸 알리는 메세지 -> uuid를 주면 그 값이랑 자기 값 비교해서 끄기
                  }
                })
          ]),
        ),
      ),
    );
  }

  //preUrl: 동영상링크 앞부분(공통), listUrl: 개별 동영상 링크 뒷부분, timeUrl: 마지막시청지점
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
          title: Text('알림'),
          content: Text('다른 기기에서 강의를 시청 중입니다.\n기기를 변경하시겠습니까?'),
          actions: <Widget>[
            ElevatedButton(
              child: Text('아니오'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: Text('예'),
              onPressed: () {
                //test2.asp열어서 덮어쓰기 해야함...
                Navigator.pop(context);
                startPlayer(preUrl, listUrl, playTime);
              },
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
