import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MultiInAppWebView extends StatefulWidget {
  String initUrl;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions();

  MultiInAppWebView(
      {this.initUrl = 'https://mall.lookingpet.com/',
      InAppWebViewGroupOptions? options,
      Key? key})
      : super(key: key);

  @override
  _MultiInAppWebviewState createState() => _MultiInAppWebviewState();
}

class _MultiInAppWebviewState extends State<MultiInAppWebView> {
  String initUrl = '';

  List<InAppWebView> _inAppWebViews = [];
  List<InAppWebViewController> _inAppWebViewControllers = [];
  InAppWebView get _currnetWebView => _inAppWebViews.last;
  InAppWebViewController get _currnetWebViewController =>
      _inAppWebViewControllers.last;

  InAppWebView _createNewWebView() {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: Uri.tryParse(widget.initUrl)),
      initialOptions: widget.options,
      onWebViewCreated: (controller) => {
        _inAppWebViewControllers.add(controller),
      },
    );
  }

  distroyLastWindow() {
    if (_inAppWebViews.length > 1) {
      setState(() {
        _currnetWebViewController.callAsyncJavaScript(
            functionBody: "window.stop();");
        _inAppWebViews.removeLast();
        _inAppWebViewControllers.removeLast();
      });
    }
  }

  @override
  void initState() {
    //force options
    widget.options.crossPlatform.useShouldOverrideUrlLoading = true;
    widget.options.crossPlatform.javaScriptEnabled = true;
    widget.options.android.useHybridComposition = true;
    widget.options.ios.allowsLinkPreview = false;

    _inAppWebViews.add(_createNewWebView());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: WillPopScope(
            onWillPop: () async {
              if (await _currnetWebViewController.canGoBack()) {
                _currnetWebViewController.goBack();
                return Future.value(false);
              } else if (_inAppWebViews.length > 1) {
                distroyLastWindow();
                return Future.value(false);
              } else {
                return Future.value(true);
              }
            },
            child: Stack(
              children: _inAppWebViews,
            )));
  }
}
