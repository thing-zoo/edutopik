import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPageSinup extends StatefulWidget {
  WebViewPageSinup({key}) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPageSinup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebView(
          initialUrl: 'http://www.edutopik.com/member/join_agree.asp',
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
