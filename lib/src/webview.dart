import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MultiInAppWebView extends StatefulWidget implements WebView {
  final int maxNewWindow;

  ///The window id of a [CreateWindowAction.windowId].
  final int? windowId;

  /// custom loading widget
  Widget? progressWidget;

  /// loading progress of current webview controller , from 0 to 100
  int loadingProgress = 0;

  MultiInAppWebView({
    /// if you want to use new webview to open some url, return true
    required this.shouldOpenNewWindow,

    /// max number of new window
    this.maxNewWindow = 3,

    /// custom progress widget
    this.progressWidget,

    ///
    /// from flutter_inappwebview
    ///
    this.windowId,
    this.initialUrlRequest,
    this.initialFile,
    this.initialData,
    this.initialOptions,
    this.initialUserScripts,
    this.pullToRefreshController,
    this.contextMenu,
    this.onWebViewCreated,
    this.onLoadStart,
    this.onLoadStop,
    this.onLoadError,
    this.onLoadHttpError,
    this.onConsoleMessage,
    this.onProgressChanged,
    this.shouldOverrideUrlLoading,
    this.onLoadResource,
    this.onScrollChanged,
    this.onDownloadStart,
    this.onLoadResourceCustomScheme,
    this.onCreateWindow,
    this.onCloseWindow,
    this.onJsAlert,
    this.onJsConfirm,
    this.onJsPrompt,
    this.onReceivedHttpAuthRequest,
    this.onReceivedServerTrustAuthRequest,
    this.onReceivedClientCertRequest,
    this.onFindResultReceived,
    this.shouldInterceptAjaxRequest,
    this.onAjaxReadyStateChange,
    this.onAjaxProgress,
    this.shouldInterceptFetchRequest,
    this.onUpdateVisitedHistory,
    this.onPrint,
    this.onLongPressHitTestResult,
    this.onEnterFullscreen,
    this.onExitFullscreen,
    this.onPageCommitVisible,
    this.onTitleChanged,
    this.onWindowFocus,
    this.onWindowBlur,
    this.onOverScrolled,
    this.onZoomScaleChanged,
    this.androidOnSafeBrowsingHit,
    this.androidOnPermissionRequest,
    this.androidOnGeolocationPermissionsShowPrompt,
    this.androidOnGeolocationPermissionsHidePrompt,
    this.androidShouldInterceptRequest,
    this.androidOnRenderProcessGone,
    this.androidOnRenderProcessResponsive,
    this.androidOnRenderProcessUnresponsive,
    this.androidOnFormResubmission,
    @Deprecated('Use `onZoomScaleChanged` instead') this.androidOnScaleChanged,
    this.androidOnReceivedIcon,
    this.androidOnReceivedTouchIconUrl,
    this.androidOnJsBeforeUnload,
    this.androidOnReceivedLoginRequest,
    this.iosOnWebContentProcessDidTerminate,
    this.iosOnDidReceiveServerRedirectForProvisionalNavigation,
    this.iosOnNavigationResponse,
    this.iosShouldAllowDeprecatedTLS,
    this.gestureRecognizers,
    Key? key,
  }) : super(key: key);

  static of(BuildContext context, {bool root = false}) => root
      ? context.findRootAncestorStateOfType<_MultiInAppWebviewState>()
      : context.findAncestorStateOfType<_MultiInAppWebviewState>();

  @override
  _MultiInAppWebviewState createState() => _MultiInAppWebviewState();

  /// if you want to use new webview to open some url, return true
  bool Function(Uri url)? shouldOpenNewWindow;

  /// `gestureRecognizers` specifies which gestures should be consumed by the WebView.
  /// It is possible for other gesture recognizers to be competing with the web view on pointer
  /// events, e.g if the web view is inside a [ListView] the [ListView] will want to handle
  /// vertical drags. The web view will claim gestures that are recognized by any of the
  /// recognizers on this list.
  /// When `gestureRecognizers` is empty or null, the web view will only handle pointer events for gestures that
  /// were not claimed by any other gesture recognizer.
  final Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers;

  @override
  final void Function(InAppWebViewController controller)?
      androidOnGeolocationPermissionsHidePrompt;

  @override
  final Future<GeolocationPermissionShowPromptResponse?> Function(
          InAppWebViewController controller, String origin)?
      androidOnGeolocationPermissionsShowPrompt;

  @override
  final Future<PermissionRequestResponse?> Function(
      InAppWebViewController controller,
      String origin,
      List<String> resources)? androidOnPermissionRequest;

  @override
  final Future<SafeBrowsingResponse?> Function(
      InAppWebViewController controller,
      Uri url,
      SafeBrowsingThreat? threatType)? androidOnSafeBrowsingHit;

  @override
  final InAppWebViewInitialData? initialData;

  @override
  final String? initialFile;

  @override
  InAppWebViewGroupOptions? initialOptions;

  @override
  final URLRequest? initialUrlRequest;

  @override
  final UnmodifiableListView<UserScript>? initialUserScripts;

  @override
  final PullToRefreshController? pullToRefreshController;

  @override
  final ContextMenu? contextMenu;

  @override
  final void Function(InAppWebViewController controller, Uri? url)?
      onPageCommitVisible;

  @override
  final void Function(InAppWebViewController controller, String? title)?
      onTitleChanged;

  @override
  final void Function(InAppWebViewController controller)?
      iosOnDidReceiveServerRedirectForProvisionalNavigation;

  @override
  final void Function(InAppWebViewController controller)?
      iosOnWebContentProcessDidTerminate;

  @override
  final Future<IOSNavigationResponseAction?> Function(
      InAppWebViewController controller,
      IOSWKNavigationResponse navigationResponse)? iosOnNavigationResponse;

  @override
  final Future<IOSShouldAllowDeprecatedTLSAction?> Function(
      InAppWebViewController controller,
      URLAuthenticationChallenge challenge)? iosShouldAllowDeprecatedTLS;

  @override
  final Future<AjaxRequestAction> Function(
          InAppWebViewController controller, AjaxRequest ajaxRequest)?
      onAjaxProgress;

  @override
  final Future<AjaxRequestAction?> Function(
          InAppWebViewController controller, AjaxRequest ajaxRequest)?
      onAjaxReadyStateChange;

  @override
  final void Function(
          InAppWebViewController controller, ConsoleMessage consoleMessage)?
      onConsoleMessage;

  @override
  final Future<bool?> Function(InAppWebViewController controller,
      CreateWindowAction createWindowAction)? onCreateWindow;

  @override
  final void Function(InAppWebViewController controller)? onCloseWindow;

  @override
  final void Function(InAppWebViewController controller)? onWindowFocus;

  @override
  final void Function(InAppWebViewController controller)? onWindowBlur;

  @override
  final void Function(InAppWebViewController controller, Uint8List icon)?
      androidOnReceivedIcon;

  @override
  final void Function(
          InAppWebViewController controller, Uri url, bool precomposed)?
      androidOnReceivedTouchIconUrl;

  @override
  final void Function(InAppWebViewController controller, Uri url)?
      onDownloadStart;

  @override
  final void Function(InAppWebViewController controller, int activeMatchOrdinal,
      int numberOfMatches, bool isDoneCounting)? onFindResultReceived;

  @override
  final Future<JsAlertResponse?> Function(
          InAppWebViewController controller, JsAlertRequest jsAlertRequest)?
      onJsAlert;

  @override
  final Future<JsConfirmResponse?> Function(
          InAppWebViewController controller, JsConfirmRequest jsConfirmRequest)?
      onJsConfirm;

  @override
  final Future<JsPromptResponse?> Function(
          InAppWebViewController controller, JsPromptRequest jsPromptRequest)?
      onJsPrompt;

  @override
  final void Function(InAppWebViewController controller, Uri? url, int code,
      String message)? onLoadError;

  @override
  final void Function(InAppWebViewController controller, Uri? url,
      int statusCode, String description)? onLoadHttpError;

  @override
  final void Function(
          InAppWebViewController controller, LoadedResource resource)?
      onLoadResource;

  @override
  final Future<CustomSchemeResponse?> Function(
      InAppWebViewController controller, Uri url)? onLoadResourceCustomScheme;

  @override
  final void Function(InAppWebViewController controller, Uri? url)? onLoadStart;

  @override
  final void Function(InAppWebViewController controller, Uri? url)? onLoadStop;

  @override
  final void Function(InAppWebViewController controller,
      InAppWebViewHitTestResult hitTestResult)? onLongPressHitTestResult;

  @override
  final void Function(InAppWebViewController controller, Uri? url)? onPrint;

  @override
  final void Function(InAppWebViewController controller, int progress)?
      onProgressChanged;

  @override
  final Future<ClientCertResponse?> Function(InAppWebViewController controller,
      URLAuthenticationChallenge challenge)? onReceivedClientCertRequest;

  @override
  final Future<HttpAuthResponse?> Function(InAppWebViewController controller,
      URLAuthenticationChallenge challenge)? onReceivedHttpAuthRequest;

  @override
  final Future<ServerTrustAuthResponse?> Function(
      InAppWebViewController controller,
      URLAuthenticationChallenge challenge)? onReceivedServerTrustAuthRequest;

  @override
  final void Function(InAppWebViewController controller, int x, int y)?
      onScrollChanged;

  @override
  final void Function(
          InAppWebViewController controller, Uri? url, bool? androidIsReload)?
      onUpdateVisitedHistory;

  @override
  final void Function(InAppWebViewController controller)? onWebViewCreated;

  @override
  final Future<AjaxRequest?> Function(
          InAppWebViewController controller, AjaxRequest ajaxRequest)?
      shouldInterceptAjaxRequest;

  @override
  final Future<FetchRequest?> Function(
          InAppWebViewController controller, FetchRequest fetchRequest)?
      shouldInterceptFetchRequest;

  @override
  final Future<NavigationActionPolicy?> Function(
          InAppWebViewController controller, NavigationAction navigationAction)?
      shouldOverrideUrlLoading;

  @override
  final void Function(InAppWebViewController controller)? onEnterFullscreen;

  @override
  final void Function(InAppWebViewController controller)? onExitFullscreen;

  @override
  final void Function(InAppWebViewController controller, int x, int y,
      bool clampedX, bool clampedY)? onOverScrolled;

  @override
  final void Function(
          InAppWebViewController controller, double oldScale, double newScale)?
      onZoomScaleChanged;

  @override
  final Future<WebResourceResponse?> Function(
          InAppWebViewController controller, WebResourceRequest request)?
      androidShouldInterceptRequest;

  @override
  final Future<WebViewRenderProcessAction?> Function(
          InAppWebViewController controller, Uri? url)?
      androidOnRenderProcessUnresponsive;

  @override
  final Future<WebViewRenderProcessAction?> Function(
          InAppWebViewController controller, Uri? url)?
      androidOnRenderProcessResponsive;

  @override
  final void Function(
          InAppWebViewController controller, RenderProcessGoneDetail detail)?
      androidOnRenderProcessGone;

  @override
  final Future<FormResubmissionAction?> Function(
      InAppWebViewController controller, Uri? url)? androidOnFormResubmission;

  ///Use [onZoomScaleChanged] instead.
  @Deprecated('Use `onZoomScaleChanged` instead')
  @override
  final void Function(
          InAppWebViewController controller, double oldScale, double newScale)?
      androidOnScaleChanged;

  @override
  final Future<JsBeforeUnloadResponse?> Function(
      InAppWebViewController controller,
      JsBeforeUnloadRequest jsBeforeUnloadRequest)? androidOnJsBeforeUnload;

  @override
  final void Function(
          InAppWebViewController controller, LoginRequest loginRequest)?
      androidOnReceivedLoginRequest;
}

class _MultiInAppWebviewState extends State<MultiInAppWebView> {
  List<InAppWebView> _inAppWebViews = [];
  List<InAppWebViewController> _inAppWebViewControllers = [];
  InAppWebView get currnetWebView => _inAppWebViews.last;
  InAppWebViewController get currnetWebViewController =>
      _inAppWebViewControllers.last;
  int _loadingProgress = 0;
  int get loadingProgress => _loadingProgress;
  set loadingProgress(int value) {
    setState(() {
      _loadingProgress = value;
      widget.loadingProgress = value;
    });
  }

  Widget _createNewWebView(String initUrl) {
    //force options
    widget.initialOptions ??= InAppWebViewGroupOptions();
    widget.initialOptions?.crossPlatform.useShouldOverrideUrlLoading = true;
    widget.initialOptions?.crossPlatform.javaScriptEnabled = true;
    widget.initialOptions?.android.useHybridComposition = true;
    widget.initialOptions?.ios.allowsLinkPreview = false;

    _inAppWebViews.add(InAppWebView(
      initialUrlRequest: URLRequest(url: Uri.tryParse(initUrl)),
      initialOptions: widget.initialOptions,
      onProgressChanged: (controller, progress) async {
        print('progress: $progress');
        setState(() {
          loadingProgress = progress;
        });

        if (widget.onProgressChanged != null) {
          widget.onProgressChanged!(controller, progress);
        }
      },
      onWebViewCreated: (controller) => {
        _inAppWebViewControllers.add(controller),
        if (widget.onWebViewCreated != null)
          {
            widget.onWebViewCreated!(controller),
          }
      },
      androidOnPermissionRequest: (
        InAppWebViewController controller,
        String origin,
        List<String> resources,
      ) async {
        return PermissionRequestResponse(
          resources: resources,
          action: PermissionRequestResponseAction.GRANT,
        );
      },
      onLoadError: (controller, url, code, errMsg) async {
        // NSURLErrorCancelled we can ignore it.
        if (Platform.isIOS && code == -999) {
          return;
        }

        if (widget.onLoadError != null) {
          widget.onLoadError!(controller, url, code, errMsg);
        } else {
          Fluttertoast.showToast(
              msg: errMsg,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1);
        }
      },
      onJsAlert: (controller, jsAlertRequest) async {
        if (jsAlertRequest.message?.isNotEmpty ?? false) {
          if (widget.onJsAlert != null) {
            return widget.onJsAlert!(controller, jsAlertRequest);
          } else {
            Fluttertoast.showToast(
                msg: jsAlertRequest.message!,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.SNACKBAR,
                timeInSecForIosWeb: 1);
            return JsAlertResponse(handledByClient: true);
          }
        }
      },
      shouldOverrideUrlLoading: (controller, navigationAction) async {
        NavigationActionPolicy? policy;

        if (widget.shouldOverrideUrlLoading != null) {
          policy = await widget.shouldOverrideUrlLoading!(
              controller, navigationAction);
        }

        if (policy != NavigationActionPolicy.CANCEL) {
          Uri curUri = await controller.getUrl() ?? Uri.parse(initUrl);
          Uri newUri = navigationAction.request.url!;

          if (newUri != curUri && navigationAction.androidIsRedirect != true) {
            bool bShouldOpenNew = false;
            if (widget.shouldOpenNewWindow != null) {
              bShouldOpenNew = widget.shouldOpenNewWindow!(newUri);

              if (bShouldOpenNew == true &&
                  _inAppWebViewControllers.length < widget.maxNewWindow) {
                print(
                    '@@@ MultiInAppWebView->shouldOpenNewWindow true : ${newUri.toString()}');

                Future.microtask(() {
                  //导航到新路由
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return WillPopScope(
                          onWillPop: () async {
                            //关闭当前页面
                            _distroyLastWebView();
                            Navigator.pop(context, false);
                            return false;
                          },
                          child: _createNewWebView(newUri.toString()));
                    }),
                  );

                  // _createNewWebView(newUri.toString());
                });

                policy = NavigationActionPolicy.CANCEL;
              } else {
                print(
                    '@@@ MultiInAppWebView->shouldOpenNewWindow false : ${newUri.toString()}');
              }
            }
          }
        }

        return policy;
      },
      onLoadStart: (controller, url) {
        loadingProgress = 0;

        if (widget.onLoadStart != null) {
          widget.onLoadStart!(controller, url);
        }
      },
      onLoadStop: (controller, url) {
        loadingProgress = 0;

        if (widget.onLoadStop != null) {
          widget.onLoadStop!(controller, url);
        }
      },
      initialFile: widget.initialFile,
      initialData: widget.initialData,
      initialUserScripts: widget.initialUserScripts,
      pullToRefreshController: widget.pullToRefreshController,
      contextMenu: widget.contextMenu,
      onLoadHttpError: widget.onLoadHttpError,
      onConsoleMessage: widget.onConsoleMessage,
      onLoadResource: widget.onLoadResource,
      onScrollChanged: widget.onScrollChanged,
      onDownloadStart: widget.onDownloadStart,
      onLoadResourceCustomScheme: widget.onLoadResourceCustomScheme,
      onCreateWindow: widget.onCreateWindow,
      onCloseWindow: widget.onCloseWindow,
      onJsConfirm: widget.onJsConfirm,
      onJsPrompt: widget.onJsPrompt,
      onReceivedHttpAuthRequest: widget.onReceivedHttpAuthRequest,
      onReceivedServerTrustAuthRequest: widget.onReceivedServerTrustAuthRequest,
      onReceivedClientCertRequest: widget.onReceivedClientCertRequest,
      onFindResultReceived: widget.onFindResultReceived,
      shouldInterceptAjaxRequest: widget.shouldInterceptAjaxRequest,
      onAjaxReadyStateChange: widget.onAjaxReadyStateChange,
      shouldInterceptFetchRequest: widget.shouldInterceptFetchRequest,
      onUpdateVisitedHistory: widget.onUpdateVisitedHistory,
      onAjaxProgress: widget.onAjaxProgress,
      onPrint: widget.onPrint,
      onLongPressHitTestResult: widget.onLongPressHitTestResult,
      onEnterFullscreen: widget.onEnterFullscreen,
      onExitFullscreen: widget.onExitFullscreen,
      onPageCommitVisible: widget.onPageCommitVisible,
      onTitleChanged: widget.onTitleChanged,
      onWindowFocus: widget.onWindowFocus,
      onWindowBlur: widget.onWindowBlur,
      onOverScrolled: widget.onOverScrolled,
      onZoomScaleChanged: widget.onZoomScaleChanged,
      androidOnSafeBrowsingHit: widget.androidOnSafeBrowsingHit,
      androidOnGeolocationPermissionsShowPrompt:
          widget.androidOnGeolocationPermissionsShowPrompt,
      androidOnGeolocationPermissionsHidePrompt:
          widget.androidOnGeolocationPermissionsHidePrompt,
      androidShouldInterceptRequest: widget.androidShouldInterceptRequest,
      androidOnRenderProcessGone: widget.androidOnRenderProcessGone,
      androidOnRenderProcessResponsive: widget.androidOnRenderProcessResponsive,
      androidOnRenderProcessUnresponsive:
          widget.androidOnRenderProcessUnresponsive,
      androidOnFormResubmission: widget.androidOnFormResubmission,
      androidOnScaleChanged: widget.androidOnScaleChanged,
      androidOnReceivedIcon: widget.androidOnReceivedIcon,
      androidOnReceivedTouchIconUrl: widget.androidOnReceivedTouchIconUrl,
      androidOnJsBeforeUnload: widget.androidOnJsBeforeUnload,
      androidOnReceivedLoginRequest: widget.androidOnReceivedLoginRequest,
      iosOnWebContentProcessDidTerminate:
          widget.iosOnWebContentProcessDidTerminate,
      iosOnDidReceiveServerRedirectForProvisionalNavigation:
          widget.iosOnDidReceiveServerRedirectForProvisionalNavigation,
      iosOnNavigationResponse: widget.iosOnNavigationResponse,
      iosShouldAllowDeprecatedTLS: widget.iosShouldAllowDeprecatedTLS,
      gestureRecognizers: widget.gestureRecognizers,
    ));

    return _inAppWebViews.last;
  }

  _distroyLastWebView() {
    if (_inAppWebViews.length > 1) {
      currnetWebViewController.callAsyncJavaScript(
          functionBody: "window.stop();");
      setState(() {
        _inAppWebViews.removeLast();
        _inAppWebViewControllers.removeLast();
        loadingProgress = 0;
      });
    }
  }

  @override
  void initState() {
    _createNewWebView(
        widget.initialUrlRequest?.url.toString() ?? 'about:blank');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: WillPopScope(
            onWillPop: () async {
              print('WillPopScope');
              if (await currnetWebViewController.canGoBack()) {
                currnetWebViewController.goBack();
                return Future.value(false);
              } else if (_inAppWebViews.length > 1) {
                _distroyLastWebView();
                return Future.value(false);
              } else {
                return Future.value(true);
              }
            },
            child: Stack(children: [
              /// webviews
              Stack(
                children: [_inAppWebViews.first],
              ),

              /// loading progress
              Visibility(
                  child: widget.progressWidget ??
                      LinearProgressIndicator(value: loadingProgress / 100),
                  visible: (loadingProgress > 0 && loadingProgress < 90)),
            ])));
  }
}
