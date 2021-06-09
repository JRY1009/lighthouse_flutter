import 'dart:async';
import 'dart:core';

import 'package:library_base/widget/button/back_button.dart';
import 'package:library_base/utils/toast_util.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/styles.dart';

class WebViewPage extends StatefulWidget {
  final String? url;
  final String? title;

  WebViewPage(this.url, this.title);
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {

  final Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
        future: _controller.future,
        builder: (context, snapshot) {
          return WillPopScope(
            onWillPop: () async {
              if (snapshot.hasData) {
                final bool canGoBack = await snapshot.data!.canGoBack();
                if (canGoBack) {
                  // 网页可以返回时，优先返回上一页
                  await snapshot.data!.goBack();
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
                title: Text(widget.title ?? '', style: TextStyles.textBlack18),
              ),
              body: WebView(
                initialUrl: widget.url,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
                javascriptChannels: <JavascriptChannel>[_jsChannel(context),].toSet(),
              ),
            ),
          );
        }
    );
  }

  JavascriptChannel _jsChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'method',
        onMessageReceived: (JavascriptMessage message) {
          ToastUtil.success(message.message);
        });
  }
}

