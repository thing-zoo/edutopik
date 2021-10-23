import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
          initialUrl: 'http://118.45.182.188/test.asp',
          onWebViewCreated: (WebViewController webviewController) {
            _controller = webviewController;
          },
          javascriptMode: JavascriptMode.unrestricted,
          javascriptChannels: Set.from([
            JavascriptChannel(
                name: 'JavaScriptChannel',
                onMessageReceived: (JavascriptMessage message) {
                  print(message.message);
                })
          ]),
        ),
      ),
    );
  }
}
