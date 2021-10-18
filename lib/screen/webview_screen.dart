import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  WebViewScreen({Key? key}) : super(key: key);

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebView(
          // initialUrl: 'http://m.edutopik.com/',
          initialUrl: 'http://118.45.182.188/', //for test
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
