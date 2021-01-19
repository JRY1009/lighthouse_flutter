
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/ui/module_home/page/global_quote_page.dart';
import 'package:lighthouse/ui/module_home/page/milestone_page.dart';
import 'package:lighthouse/ui/module_home/page/spot_detail_page.dart';
import 'package:lighthouse/ui/module_home/page/treemap_page.dart';
import 'package:lighthouse/ui/module_mine/page/area_page.dart';
import 'package:lighthouse/ui/module_mine/page/login_page.dart';
import 'package:lighthouse/ui/module_mine/page/login_sms_page.dart';
import 'package:lighthouse/ui/module_mine/page/modify_nickname_page.dart';
import 'package:lighthouse/ui/module_mine/page/modify_pwd_page.dart';
import 'package:lighthouse/ui/module_mine/page/setting_page.dart';
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

var modifyPwdPageHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return ModifyPwdPage();
    });

var spotDetailPageHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      String coin_code = params['coin_code']?.first;
      return SpotDetailPage(coin_code: coin_code);
    });

var globalQuotePageHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return GlobalQuotePage();
    });

var treemapPageHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return TreemapPage();
    });

var milestonePageHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return MileStonePage();
    });