import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_inappwebview/multi_inappwebview.dart';
import 'events.dart';

class NewNewWebViewWindow extends StatefulWidget {
  final Widget webview;
  const NewNewWebViewWindow(this.webview, {Key? key}) : super(key: key);

  @override
  _NewWebViewWrapperState createState() => _NewWebViewWrapperState();
}

class _NewWebViewWrapperState extends State<NewNewWebViewWindow> {
  String pageTitle = "Loading";
  late StreamSubscription eventListener;

  @override
  void initState() {
    eventListener = eventBus.on<ONewWebViewTitleChangeEvent>().listen((event) {
      setState(() {
        if (event.title.length > 1) {
          pageTitle = event.title;
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(pageTitle),
        ),
        body: Container(child: widget.webview));
  }

  @override
  void dispose() {
    eventListener.cancel();
    eventBus.fire(OnNewWebViewPopEvent());
    super.dispose();
  }
}
