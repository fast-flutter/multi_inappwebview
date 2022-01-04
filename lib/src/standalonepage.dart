import 'package:flutter/material.dart';
import 'package:multi_inappwebview/multi_inappwebview.dart';

class MultiInappWebViewNewPage extends StatelessWidget {
  String url;
  MultiInappWebViewNewPage(this.url) {
    print("url: $url");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New route"),
      ),
      body: Center(
          child: MultiInAppWebView(
        initialUrlRequest: URLRequest(url: Uri.tryParse(url)),
        shouldOpenNewWindow: (url) => true,
      )),
    );
  }
}
