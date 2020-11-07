import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:lighthouse/ui/widget/appbar/common_app_bar.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final String title;

  WebViewPage(this.url, this.title);
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: widget.url,
      withLocalStorage: true,
      withJavascript: true,
      hidden: true,
      key: _scaffoldKey,
      appBar: CommonAppBar(
        title: widget.title,
      ),
    );
  }
}
