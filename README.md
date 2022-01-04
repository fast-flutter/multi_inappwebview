## Features

MultiInAppWebView is allow you to use multiple [flutter_inappwebview](https://pub.dev/packages/flutter_inappwebview) instance where open a new web page link.

## Getting started

Add this to your package's pubspec.yaml file:

```dart
dependencies:
  multi_inappwebview: ^0.0.2
```

## Usage

see `/example` folder.

```dart
import 'package:multi_inappwebview/multi_inappwebview.dart';


 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: MultiInAppWebView(
              initialUrlRequest:
                  URLRequest(url: Uri.tryParse('https://mall.lookingpet.com/')),
              maxNewWindow: 3,
              shouldOpenNewWindow: (uri) {
                if (uri.host != 'mall.lookingpet.com') {
                  return true;
                }
                return false;
              },
            )
      ),
    );
  }
```
