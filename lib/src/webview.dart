import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MultiInAppWebView extends StatefulWidget {
  final String initialUrl;
  final int maxNewWindow;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions();

  Future<NavigationActionPolicy?> Function(
          InAppWebViewController controller, NavigationAction navigationAction)?
      shouldOverrideUrlLoading;

  bool Function(Uri url)? shouldOpenNewWindow;

  MultiInAppWebView(
      {required this.initialUrl,
      this.shouldOverrideUrlLoading,
      this.shouldOpenNewWindow,
      this.maxNewWindow = 3,
      InAppWebViewGroupOptions? options,
      Key? key})
      : super(key: key);

  @override
  _MultiInAppWebviewState createState() => _MultiInAppWebviewState();
}

class _MultiInAppWebviewState extends State<MultiInAppWebView> {
  List<InAppWebView> _inAppWebViews = [];
  List<InAppWebViewController> _inAppWebViewControllers = [];
  InAppWebView get _currnetWebView => _inAppWebViews.last;
  InAppWebViewController get _currnetWebViewController =>
      _inAppWebViewControllers.last;

  _createNewWebView(String initUrl) {
    setState(() {
      _inAppWebViews.add(InAppWebView(
          initialUrlRequest: URLRequest(url: Uri.tryParse(initUrl)),
          initialOptions: widget.options,
          onWebViewCreated: (controller) => {
                _inAppWebViewControllers.add(controller),
              },
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            Uri curUri = await controller.getUrl() ?? Uri.parse(initUrl);
            Uri newUri = navigationAction.request.url!;

            /// handle ios back to a emty page
            // if (Platform.isIOS &&
            //     navigationAction.iosWKNavigationType ==
            //         IOSWKNavigationType.BACK_FORWARD) {
            //   Future.microtask(() {
            //     controller.goBack();
            //   });
            // }

            if (newUri != curUri &&
                navigationAction.androidIsRedirect != true) {
              bool bShouldOpenNew = false;
              if (widget.shouldOpenNewWindow != null) {
                bShouldOpenNew = widget.shouldOpenNewWindow!(newUri);

                if (bShouldOpenNew == true &&
                    _inAppWebViewControllers.length < widget.maxNewWindow) {
                  print('@@@ shouldOpenNewWindow true : ${newUri.toString()}');

                  Future.microtask(() {
                    _createNewWebView(newUri.toString());
                  });

                  return NavigationActionPolicy.CANCEL;
                }
              }
            }
          }));
    });
  }

  _distroyLastWebView() {
    if (_inAppWebViews.length > 1) {
      _currnetWebViewController.callAsyncJavaScript(
          functionBody: "window.stop();");
      setState(() {
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

    _createNewWebView(widget.initialUrl);
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
                _distroyLastWebView();
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
