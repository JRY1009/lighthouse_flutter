// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `区块灯塔`
  String get appName {
    return Intl.message(
      '区块灯塔',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `照亮数字世界之海`
  String get slogan {
    return Intl.message(
      '照亮数字世界之海',
      name: 'slogan',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Login`
  String get welcomeLogin {
    return Intl.message(
      'Welcome Login',
      name: 'welcomeLogin',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Regist`
  String get welcomeRegist {
    return Intl.message(
      'Welcome Regist',
      name: 'welcomeRegist',
      desc: '',
      args: [],
    );
  }

  /// `退出登录`
  String get logout {
    return Intl.message(
      '退出登录',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `确定要退出当前账号吗？`
  String get logoutConfirm {
    return Intl.message(
      '确定要退出当前账号吗？',
      name: 'logoutConfirm',
      desc: '',
      args: [],
    );
  }

  /// `立即登录`
  String get loginNow {
    return Intl.message(
      '立即登录',
      name: 'loginNow',
      desc: '',
      args: [],
    );
  }

  /// `登录后可同步数据`
  String get loginGuide {
    return Intl.message(
      '登录后可同步数据',
      name: 'loginGuide',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get loginPhone {
    return Intl.message(
      'Phone Number',
      name: 'loginPhone',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your phone number`
  String get loginPhoneHint {
    return Intl.message(
      'Please enter your phone number',
      name: 'loginPhoneHint',
      desc: '',
      args: [],
    );
  }

  /// `Phone number cannot be empty!`
  String get loginPhoneError {
    return Intl.message(
      'Phone number cannot be empty!',
      name: 'loginPhoneError',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your password`
  String get passwordHint {
    return Intl.message(
      'Please enter your password',
      name: 'passwordHint',
      desc: '',
      args: [],
    );
  }

  /// `Password cannot be less than 6 digits!`
  String get passwordError {
    return Intl.message(
      'Password cannot be less than 6 digits!',
      name: 'passwordError',
      desc: '',
      args: [],
    );
  }

  /// `Forget Password?`
  String get forgetPassword {
    return Intl.message(
      'Forget Password?',
      name: 'forgetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Login Success`
  String get loginSuccess {
    return Intl.message(
      'Login Success',
      name: 'loginSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Repeat Password`
  String get repeatPassword {
    return Intl.message(
      'Repeat Password',
      name: 'repeatPassword',
      desc: '',
      args: [],
    );
  }

  /// `Register Success`
  String get registerSuccess {
    return Intl.message(
      'Register Success',
      name: 'registerSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `确定`
  String get confirm {
    return Intl.message(
      '确定',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `没有账号？`
  String get noAccount {
    return Intl.message(
      '没有账号？',
      name: 'noAccount',
      desc: '',
      args: [],
    );
  }

  /// `点此注册`
  String get clickRegister {
    return Intl.message(
      '点此注册',
      name: 'clickRegister',
      desc: '',
      args: [],
    );
  }

  /// `再次点击退出应用`
  String get doubleTapExit {
    return Intl.message(
      '再次点击退出应用',
      name: 'doubleTapExit',
      desc: '',
      args: [],
    );
  }

  /// `首页`
  String get home {
    return Intl.message(
      '首页',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `资讯`
  String get info {
    return Intl.message(
      '资讯',
      name: 'info',
      desc: '',
      args: [],
    );
  }

  /// `财富`
  String get money {
    return Intl.message(
      '财富',
      name: 'money',
      desc: '',
      args: [],
    );
  }

  /// `我的`
  String get mine {
    return Intl.message(
      '我的',
      name: 'mine',
      desc: '',
      args: [],
    );
  }

  /// `7x24`
  String get x724 {
    return Intl.message(
      '7x24',
      name: 'x724',
      desc: '',
      args: [],
    );
  }

  /// `文章`
  String get article {
    return Intl.message(
      '文章',
      name: 'article',
      desc: '',
      args: [],
    );
  }

  /// `正在加载...`
  String get loading {
    return Intl.message(
      '正在加载...',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `登录中...`
  String get logingin {
    return Intl.message(
      '登录中...',
      name: 'logingin',
      desc: '',
      args: [],
    );
  }

  /// `国家/地区`
  String get countryArea {
    return Intl.message(
      '国家/地区',
      name: 'countryArea',
      desc: '',
      args: [],
    );
  }

  /// `搜索`
  String get search {
    return Intl.message(
      '搜索',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `暂无数据`
  String get noData {
    return Intl.message(
      '暂无数据',
      name: 'noData',
      desc: '',
      args: [],
    );
  }

  /// `没有更多数据`
  String get noMoreData {
    return Intl.message(
      '没有更多数据',
      name: 'noMoreData',
      desc: '',
      args: [],
    );
  }

  /// `账户与安全`
  String get accountSecurity {
    return Intl.message(
      '账户与安全',
      name: 'accountSecurity',
      desc: '',
      args: [],
    );
  }

  /// `我的头像`
  String get myAvatar {
    return Intl.message(
      '我的头像',
      name: 'myAvatar',
      desc: '',
      args: [],
    );
  }

  /// `拍照`
  String get camera {
    return Intl.message(
      '拍照',
      name: 'camera',
      desc: '',
      args: [],
    );
  }

  /// `相册`
  String get gallery {
    return Intl.message(
      '相册',
      name: 'gallery',
      desc: '',
      args: [],
    );
  }

  /// `看大图`
  String get viewFullSize {
    return Intl.message(
      '看大图',
      name: 'viewFullSize',
      desc: '',
      args: [],
    );
  }

  /// `查看详细信息`
  String get viewDetail {
    return Intl.message(
      '查看详细信息',
      name: 'viewDetail',
      desc: '',
      args: [],
    );
  }

  /// `全部`
  String get all {
    return Intl.message(
      '全部',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `全球行情`
  String get globalQuote {
    return Intl.message(
      '全球行情',
      name: 'globalQuote',
      desc: '',
      args: [],
    );
  }

  /// `热力图`
  String get treemap {
    return Intl.message(
      '热力图',
      name: 'treemap',
      desc: '',
      args: [],
    );
  }

  /// `区块链里程碑`
  String get blockMileStone {
    return Intl.message(
      '区块链里程碑',
      name: 'blockMileStone',
      desc: '',
      args: [],
    );
  }

  /// `最新资讯`
  String get latestInfo {
    return Intl.message(
      '最新资讯',
      name: 'latestInfo',
      desc: '',
      args: [],
    );
  }

  /// `市场总值`
  String get proTotalMarketValue {
    return Intl.message(
      '市场总值',
      name: 'proTotalMarketValue',
      desc: '',
      args: [],
    );
  }

  /// `24H量`
  String get pro24hVolume {
    return Intl.message(
      '24H量',
      name: 'pro24hVolume',
      desc: '',
      args: [],
    );
  }

  /// `全网算力（EH/S）`
  String get proComputePower {
    return Intl.message(
      '全网算力（EH/S）',
      name: 'proComputePower',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}