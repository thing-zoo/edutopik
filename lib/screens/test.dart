import 'package:edutopik/screens/media/player_screen.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:edutopik/screens/test_http.dart';
import "package:http/http.dart" as http;

class JSTest extends StatefulWidget {
  JSTest({Key? key}) : super(key: key);
  @override
  _JSTestState createState() => _JSTestState();
}

class _JSTestState extends State<JSTest> {
  WebViewController? _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: ElevatedButton(
        child: Text('send to javascript'),
        onPressed: () {
          if (_controller != null) {
            _controller!.evaluateJavascript(
                'window.fromFlutter("this is title from Flutter")');
          }
        },
      )),
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
                  print(message.message);
                  
                  var msg = message.message.split('&');
                  print(msg[0]);
                  if(msg[0]=='"playLecture'){
                    if(msg[2]=="overload"){
                      _asyncConfirmDialog(msg[9],msg[10]);
                    }
                    //미디어 플레이어로 이동
                    else{
                      getPlayTime(msg[10], msg[1], msg[3], msg[4], msg[6], msg[7]);
                      startPlayer(msg[9],msg[10]);
                    }
                  }else{
                    //중복이라는걸 알리는 메세지 -> uuid를 주면 그 값이랑 자기 값 비교해서 끄기
                  }
                })
          ]),
        ),
      ),
    );
  }

  void startPlayer(listUrl, timeUrl) async{
    final Map<String, dynamic> res = await new Session().get(listUrl);
    print(res);

    // Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => PlayerScreen()),
    // );
  }

  Future getPlayTime(timeUrl, uid, ocode, scode, lmnum, lmtime) async{
    final Map<String, dynamic> res2 = await new Session().get('$timeUrl?uid=$uid&ocode=$ocode&scode=$scode&lm_num=$lmnum&lm_time=$lmtime');
    print(res2);
  }

  Future<void> _asyncConfirmDialog(listUrl, timeUrl) async {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('notice'),
          content: Text('really?'),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('ACCEPT'),
              onPressed: () {
                //test2.asp열어서 덮어쓰기 해야함...
                Navigator.pop(context);
                startPlayer(listUrl, timeUrl);
              },
            )
          ],
        );
      },
    );
  }
}

