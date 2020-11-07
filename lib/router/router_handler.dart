
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/ui/page/login_page.dart';
import 'package:lighthouse/ui/page/main_page.dart';
import 'package:lighthouse/ui/page/web_view_page.dart';

var webviewPageHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      String title = params['title']?.first;
      String url = params['url']?.first;
      return WebViewPage(url, title);
    });

var loginPageHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return LoginPage();
});

var mainPageHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return MainPage();
    });
