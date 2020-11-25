
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/ui/page/area_page.dart';
import 'package:lighthouse/ui/page/login_page.dart';
import 'package:lighthouse/ui/page/login_sms_page.dart';
import 'package:lighthouse/ui/page/main_page.dart';
import 'package:lighthouse/ui/page/milestone_page.dart';
import 'package:lighthouse/ui/page/modify_nickname_page.dart';
import 'package:lighthouse/ui/page/setting_page.dart';
import 'package:lighthouse/ui/page/spot_detail_page.dart';
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

var loginSmsPageHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return LoginSmsPage();
    });

var areaPageHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      String areaCode = params['areaCode']?.first;
      return AreaPage(areaCode);
    });

var mainPageHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return MainPage();
    });

var settingPageHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return SettingPage();
    });

var modifyNicknamePageHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return ModifyNicknamePage();
    });

var spotDetailPageHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      String spotCoin = params['spotCoin']?.first;
      return SpotDetailPage();
    });

var milestonePageHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return MileStonePage();
    });