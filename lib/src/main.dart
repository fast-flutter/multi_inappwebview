import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MultiInAppWebView extends StatefulWidget {
  String initUrl;

  MultiInAppWebView({this.initUrl = '', Key? key}) : super(key: key);

  @override
  _MultiInAppWebviewState createState() => _MultiInAppWebviewState();
}

class _MultiInAppWebviewState extends State<MultiInAppWebView> {
  String initUrl = '';

  List<InAppWebView> _inAppWebViews = [];
  late InAppWebView _currnetWebView;

  InAppWebView getCurrentWebView() {
    return _currnetWebView;
  }

  InAppWebView _createNewWebView(InAppWebViewGroupOptions options) {
    return InAppWebView(
      initialOptions: options,
    );
  }

  @override
  void initState() {
    initUrl =
        widget.initUrl.isEmpty ? 'https://www.example.com/' : widget.initUrl;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [],
    );
  }
}
