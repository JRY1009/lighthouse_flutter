import 'dart:async';
import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:library_base/utils/device_util.dart';
import 'package:library_base/widget/button/back_button.dart';
import 'package:library_base/utils/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/styles.dart';

class InappWebviewPage extends StatefulWidget {
  final String url;
  final String title;
  final bool captureAllGestures;

  InappWebviewPage(this.url, this.title, {
    this.captureAllGestures = false,
  });
  _InappWebviewPageState createState() => _InappWebviewPageState();
}

class _InappWebviewPageState extends State<InappWebviewPage> {

  InAppWebViewController webviewController;

  double _opacity = DeviceUtil.isAndroid ? 0.0 : 1.0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
            onWillPop: () async {
              if (webviewController != null) {
                final bool canGoBack = await webviewController.canGoBack();
                if (canGoBack) {
                  // 网页可以返回时，优先返回上一页
                  await webviewController.goBack();
                  return Future.value(false);
                }
              }
              return Future.value(true);
            },
            child: Scaffold(
              appBar: AppBar(
                leading: BackButtonEx(),
                elevation: 1,
                brightness: Brightness.light,
                backgroundColor: Colours.white,
                centerTitle: true,
                title: Text(widget.title, style: TextStyles.textBlack18),
              ),
              body: Opacity(
                opacity: _opacity,
                // --- FIX_BLINK ---
                child: InAppWebView(
                  initialUrl: widget.url,
                  initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                      useShouldOverrideUrlLoading: true,
                      useOnLoadResource: true,
                      javaScriptEnabled: true,
                      incognito: true,
                      mediaPlaybackRequiresUserGesture: false,
                      clearCache: true,
                      javaScriptCanOpenWindowsAutomatically: false,
                    ),
                    android: AndroidInAppWebViewOptions(
                        hardwareAcceleration: true
                    ),
                    ios: IOSInAppWebViewOptions(
                        allowsAirPlayForMediaPlayback: false,
                        allowsInlineMediaPlayback: true),
                  ),

                  onWebViewCreated: (InAppWebViewController controller) {
                    webviewController = controller;
                    webviewController.addJavaScriptHandler(handlerName:'handlerFoo', callback: (args) {
                      // return data to JavaScript side!
                      return {
                        'bar': 'bar_value', 'baz': 'baz_value'
                      };
                    });
                    webviewController.addJavaScriptHandler(handlerName: 'handlerFooWithArgs', callback: (args) {
                      print(args);
                      // it will print: [1, true, [bar, 5], {foo: baz}, {bar: bar_value, baz: baz_value}]
                    });
                  },
                  onLoadStart: (InAppWebViewController controller, String url) {
                    setState(() {
                    });
                  },
                  onLoadStop: (InAppWebViewController controller, String url) async {
                    if (DeviceUtil.isAndroid) {
                      setState(() { _opacity = 1.0; });
                    }
                  },
                  gestureRecognizers: widget.captureAllGestures
                      ? (Set()
                    ..add(Factory<VerticalDragGestureRecognizer>(() {
                      return VerticalDragGestureRecognizer()
                        ..onStart = (DragStartDetails details) {}
                        ..onUpdate = (DragUpdateDetails details) {}
                        ..onDown = (DragDownDetails details) {}
                        ..onCancel = () {}
                        ..onEnd = (DragEndDetails details) {};
                    }))
                    ..add(Factory<HorizontalDragGestureRecognizer>(() {
                      return HorizontalDragGestureRecognizer()
                        ..onStart = (DragStartDetails details) {}
                        ..onUpdate = (DragUpdateDetails details) {}
                        ..onDown = (DragDownDetails details) {}
                        ..onCancel = () {}
                        ..onEnd = (DragEndDetails details) {};
                    })))
                      : null,
                )
            )
            ),
          );
  }
}

