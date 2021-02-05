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

  /// `页面不存在`
  String get notFoundPage {
    return Intl.message(
      '页面不存在',
      name: 'notFoundPage',
      desc: '',
      args: [],
    );
  }

  /// `登录`
  String get login {
    return Intl.message(
      '登录',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `欢迎登录`
  String get welcomeLogin {
    return Intl.message(
      '欢迎登录',
      name: 'welcomeLogin',
      desc: '',
      args: [],
    );
  }

  /// `密码登录`
  String get pwdLogin {
    return Intl.message(
      '密码登录',
      name: 'pwdLogin',
      desc: '',
      args: [],
    );
  }

  /// `请输入账户密码，推荐一键登录`
  String get pwdLoginTips {
    return Intl.message(
      '请输入账户密码，推荐一键登录',
      name: 'pwdLoginTips',
      desc: '',
      args: [],
    );
  }

  /// `验证码登录`
  String get smsLogin {
    return Intl.message(
      '验证码登录',
      name: 'smsLogin',
      desc: '',
      args: [],
    );
  }

  /// `验证即登录，新手机号自动注册`
  String get smsLoginTips {
    return Intl.message(
      '验证即登录，新手机号自动注册',
      name: 'smsLoginTips',
      desc: '',
      args: [],
    );
  }

  /// `欢迎注册`
  String get welcomeRegist {
    return Intl.message(
      '欢迎注册',
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

  /// `手机号`
  String get loginPhone {
    return Intl.message(
      '手机号',
      name: 'loginPhone',
      desc: '',
      args: [],
    );
  }

  /// `请输入手机号`
  String get loginPhoneHint {
    return Intl.message(
      '请输入手机号',
      name: 'loginPhoneHint',
      desc: '',
      args: [],
    );
  }

  /// `手机号不能为空!`
  String get loginPhoneError {
    return Intl.message(
      '手机号不能为空!',
      name: 'loginPhoneError',
      desc: '',
      args: [],
    );
  }

  /// `验证码`
  String get verifyCode {
    return Intl.message(
      '验证码',
      name: 'verifyCode',
      desc: '',
      args: [],
    );
  }

  /// `获取验证码`
  String get getVerifyCode {
    return Intl.message(
      '获取验证码',
      name: 'getVerifyCode',
      desc: '',
      args: [],
    );
  }

  /// `请输入验证码`
  String get verifyCodeHint {
    return Intl.message(
      '请输入验证码',
      name: 'verifyCodeHint',
      desc: '',
      args: [],
    );
  }

  /// `秒后重发`
  String get verifyRetry {
    return Intl.message(
      '秒后重发',
      name: 'verifyRetry',
      desc: '',
      args: [],
    );
  }

  /// `已发送验证码`
  String get verifySended {
    return Intl.message(
      '已发送验证码',
      name: 'verifySended',
      desc: '',
      args: [],
    );
  }

  /// `密码`
  String get password {
    return Intl.message(
      '密码',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `请输入密码`
  String get passwordHint {
    return Intl.message(
      '请输入密码',
      name: 'passwordHint',
      desc: '',
      args: [],
    );
  }

  /// `密码不能少于6位!`
  String get passwordError {
    return Intl.message(
      '密码不能少于6位!',
      name: 'passwordError',
      desc: '',
      args: [],
    );
  }

  /// `忘记密码？`
  String get forgetPassword {
    return Intl.message(
      '忘记密码？',
      name: 'forgetPassword',
      desc: '',
      args: [],
    );
  }

  /// `登录成功`
  String get loginSuccess {
    return Intl.message(
      '登录成功',
      name: 'loginSuccess',
      desc: '',
      args: [],
    );
  }

  /// `注册`
  String get register {
    return Intl.message(
      '注册',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `密码`
  String get newPassword {
    return Intl.message(
      '密码',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `重复密码`
  String get repeatPassword {
    return Intl.message(
      '重复密码',
      name: 'repeatPassword',
      desc: '',
      args: [],
    );
  }

  /// `修改密码`
  String get modifyPassword {
    return Intl.message(
      '修改密码',
      name: 'modifyPassword',
      desc: '',
      args: [],
    );
  }

  /// `密码不一致`
  String get passwordNotSame {
    return Intl.message(
      '密码不一致',
      name: 'passwordNotSame',
      desc: '',
      args: [],
    );
  }

  /// `修改成功`
  String get modifySuccess {
    return Intl.message(
      '修改成功',
      name: 'modifySuccess',
      desc: '',
      args: [],
    );
  }

  /// `确定修改`
  String get confirmNotify {
    return Intl.message(
      '确定修改',
      name: 'confirmNotify',
      desc: '',
      args: [],
    );
  }

  /// `注册成功`
  String get registerSuccess {
    return Intl.message(
      '注册成功',
      name: 'registerSuccess',
      desc: '',
      args: [],
    );
  }

  /// `设置`
  String get settings {
    return Intl.message(
      '设置',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `关闭`
  String get close {
    return Intl.message(
      '关闭',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `取消`
  String get cancel {
    return Intl.message(
      '取消',
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

  /// `登录即代表您已同意`
  String get loginPolicy {
    return Intl.message(
      '登录即代表您已同意',
      name: 'loginPolicy',
      desc: '',
      args: [],
    );
  }

  /// `《用户注册协议》`
  String get registAgreement {
    return Intl.message(
      '《用户注册协议》',
      name: 'registAgreement',
      desc: '',
      args: [],
    );
  }

  /// `《隐私政策》`
  String get privatePolicy {
    return Intl.message(
      '《隐私政策》',
      name: 'privatePolicy',
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

  /// `正在获取验证码...`
  String get verifyin {
    return Intl.message(
      '正在获取验证码...',
      name: 'verifyin',
      desc: '',
      args: [],
    );
  }

  /// `上传中...`
  String get uploading {
    return Intl.message(
      '上传中...',
      name: 'uploading',
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

  /// `清空缓存`
  String get clearCache {
    return Intl.message(
      '清空缓存',
      name: 'clearCache',
      desc: '',
      args: [],
    );
  }

  /// `缓存大小：`
  String get cacheSize {
    return Intl.message(
      '缓存大小：',
      name: 'cacheSize',
      desc: '',
      args: [],
    );
  }

  /// ` 是否清空？`
  String get clearCacheConfirm {
    return Intl.message(
      ' 是否清空？',
      name: 'clearCacheConfirm',
      desc: '',
      args: [],
    );
  }

  /// `已清空`
  String get clearCacheSuccess {
    return Intl.message(
      '已清空',
      name: 'clearCacheSuccess',
      desc: '',
      args: [],
    );
  }

  /// `分享`
  String get share {
    return Intl.message(
      '分享',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `检查更新`
  String get checkUpdate {
    return Intl.message(
      '检查更新',
      name: 'checkUpdate',
      desc: '',
      args: [],
    );
  }

  /// `保存`
  String get save {
    return Intl.message(
      '保存',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `保存成功`
  String get saveSuccess {
    return Intl.message(
      '保存成功',
      name: 'saveSuccess',
      desc: '',
      args: [],
    );
  }

  /// `保存失败`
  String get saveFailed {
    return Intl.message(
      '保存失败',
      name: 'saveFailed',
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

  /// `修改昵称`
  String get modifyNickname {
    return Intl.message(
      '修改昵称',
      name: 'modifyNickname',
      desc: '',
      args: [],
    );
  }

  /// `请输入昵称`
  String get modifyNicknameHint {
    return Intl.message(
      '请输入昵称',
      name: 'modifyNicknameHint',
      desc: '',
      args: [],
    );
  }

  /// `*1~12个字符之间，可以汉字，字母和数字组合，不支持设置空格、特殊符号`
  String get modifyNicknameTips {
    return Intl.message(
      '*1~12个字符之间，可以汉字，字母和数字组合，不支持设置空格、特殊符号',
      name: 'modifyNicknameTips',
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

  /// `BTC/ETH为实时行情数据，其余数据为15分钟延时报价；`
  String get quoteDefinition {
    return Intl.message(
      'BTC/ETH为实时行情数据，其余数据为15分钟延时报价；',
      name: 'quoteDefinition',
      desc: '',
      args: [],
    );
  }

  /// `里程碑`
  String get milestone {
    return Intl.message(
      '里程碑',
      name: 'milestone',
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

  /// `简况`
  String get briefInfo {
    return Intl.message(
      '简况',
      name: 'briefInfo',
      desc: '',
      args: [],
    );
  }

  /// `行情`
  String get quote {
    return Intl.message(
      '行情',
      name: 'quote',
      desc: '',
      args: [],
    );
  }

  /// `数据`
  String get data {
    return Intl.message(
      '数据',
      name: 'data',
      desc: '',
      args: [],
    );
  }

  /// `更多链接`
  String get moreLink {
    return Intl.message(
      '更多链接',
      name: 'moreLink',
      desc: '',
      args: [],
    );
  }

  /// `更新时间`
  String get updateTime {
    return Intl.message(
      '更新时间',
      name: 'updateTime',
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

  /// `24H额`
  String get pro24hAmount {
    return Intl.message(
      '24H额',
      name: 'pro24hAmount',
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

  /// `市值`
  String get proMarketValue {
    return Intl.message(
      '市值',
      name: 'proMarketValue',
      desc: '',
      args: [],
    );
  }

  /// `总量`
  String get proTotalVolum {
    return Intl.message(
      '总量',
      name: 'proTotalVolum',
      desc: '',
      args: [],
    );
  }

  /// `流通量`
  String get proCirculation {
    return Intl.message(
      '流通量',
      name: 'proCirculation',
      desc: '',
      args: [],
    );
  }

  /// `流通量比`
  String get proCirculationRatio {
    return Intl.message(
      '流通量比',
      name: 'proCirculationRatio',
      desc: '',
      args: [],
    );
  }

  /// `地址资产分布`
  String get proAddressAssetsDistribution {
    return Intl.message(
      '地址资产分布',
      name: 'proAddressAssetsDistribution',
      desc: '',
      args: [],
    );
  }

  /// `地址总数`
  String get proAddressTotalAmount {
    return Intl.message(
      '地址总数',
      name: 'proAddressTotalAmount',
      desc: '',
      args: [],
    );
  }

  /// `地址数量`
  String get proAddressAmount {
    return Intl.message(
      '地址数量',
      name: 'proAddressAmount',
      desc: '',
      args: [],
    );
  }

  /// `余额范围`
  String get proBalanceRange {
    return Intl.message(
      '余额范围',
      name: 'proBalanceRange',
      desc: '',
      args: [],
    );
  }

  /// `占比`
  String get proProportion {
    return Intl.message(
      '占比',
      name: 'proProportion',
      desc: '',
      args: [],
    );
  }

  /// `较昨日`
  String get proCompareYesterday {
    return Intl.message(
      '较昨日',
      name: 'proCompareYesterday',
      desc: '',
      args: [],
    );
  }

  /// `交易平台数据`
  String get proTradePlatformData {
    return Intl.message(
      '交易平台数据',
      name: 'proTradePlatformData',
      desc: '',
      args: [],
    );
  }

  /// `交易平台`
  String get proTradePlatform {
    return Intl.message(
      '交易平台',
      name: 'proTradePlatform',
      desc: '',
      args: [],
    );
  }

  /// `最新价`
  String get proLatestPrice {
    return Intl.message(
      '最新价',
      name: 'proLatestPrice',
      desc: '',
      args: [],
    );
  }

  /// `涨幅`
  String get proRate {
    return Intl.message(
      '涨幅',
      name: 'proRate',
      desc: '',
      args: [],
    );
  }

  /// `优质资产对比`
  String get proAssetsCompare {
    return Intl.message(
      '优质资产对比',
      name: 'proAssetsCompare',
      desc: '',
      args: [],
    );
  }

  /// `微信`
  String get shareWechat {
    return Intl.message(
      '微信',
      name: 'shareWechat',
      desc: '',
      args: [],
    );
  }

  /// `朋友圈`
  String get shareFriend {
    return Intl.message(
      '朋友圈',
      name: 'shareFriend',
      desc: '',
      args: [],
    );
  }

  /// `保存`
  String get shareSave {
    return Intl.message(
      '保存',
      name: 'shareSave',
      desc: '',
      args: [],
    );
  }

  /// `更多`
  String get shareMore {
    return Intl.message(
      '更多',
      name: 'shareMore',
      desc: '',
      args: [],
    );
  }

  /// `长按二维码识别下载`
  String get shareQRDownload {
    return Intl.message(
      '长按二维码识别下载',
      name: 'shareQRDownload',
      desc: '',
      args: [],
    );
  }

  /// `微信未安装`
  String get shareWxNotInstalled {
    return Intl.message(
      '微信未安装',
      name: 'shareWxNotInstalled',
      desc: '',
      args: [],
    );
  }

  /// `加载失败`
  String get vsMsgError {
    return Intl.message(
      '加载失败',
      name: 'vsMsgError',
      desc: '',
      args: [],
    );
  }

  /// `网络连接异常,请检查网络或稍后重试`
  String get vsMsgNetworkError {
    return Intl.message(
      '网络连接异常,请检查网络或稍后重试',
      name: 'vsMsgNetworkError',
      desc: '',
      args: [],
    );
  }

  /// `空空如也`
  String get vsMsgEmpty {
    return Intl.message(
      '空空如也',
      name: 'vsMsgEmpty',
      desc: '',
      args: [],
    );
  }

  /// `我的资产`
  String get myMoney {
    return Intl.message(
      '我的资产',
      name: 'myMoney',
      desc: '',
      args: [],
    );
  }

  /// `已成为灯塔塔民{param}天`
  String becomeUserDays(Object param) {
    return Intl.message(
      '已成为灯塔塔民$param天',
      name: 'becomeUserDays',
      desc: '',
      args: [param],
    );
  }

  /// `总资产`
  String get totalAssets {
    return Intl.message(
      '总资产',
      name: 'totalAssets',
      desc: '',
      args: [],
    );
  }

  /// `资产走势`
  String get assetsTrend {
    return Intl.message(
      '资产走势',
      name: 'assetsTrend',
      desc: '',
      args: [],
    );
  }

  /// `收益走势`
  String get profitTrend {
    return Intl.message(
      '收益走势',
      name: 'profitTrend',
      desc: '',
      args: [],
    );
  }

  /// `资产指标`
  String get assetsIndex {
    return Intl.message(
      '资产指标',
      name: 'assetsIndex',
      desc: '',
      args: [],
    );
  }

  /// `今日盈亏`
  String get proTodayProfit {
    return Intl.message(
      '今日盈亏',
      name: 'proTodayProfit',
      desc: '',
      args: [],
    );
  }

  /// `今日盈亏率`
  String get proTodayProfitRate {
    return Intl.message(
      '今日盈亏率',
      name: 'proTodayProfitRate',
      desc: '',
      args: [],
    );
  }

  /// `已接入交易所`
  String get proLinkedExchangeCount {
    return Intl.message(
      '已接入交易所',
      name: 'proLinkedExchangeCount',
      desc: '',
      args: [],
    );
  }

  /// `累计盈亏`
  String get proTotalProfit {
    return Intl.message(
      '累计盈亏',
      name: 'proTotalProfit',
      desc: '',
      args: [],
    );
  }

  /// `累计盈亏率`
  String get proTotalProfitRate {
    return Intl.message(
      '累计盈亏率',
      name: 'proTotalProfitRate',
      desc: '',
      args: [],
    );
  }

  /// `最大回撤`
  String get proMaxRetracement {
    return Intl.message(
      '最大回撤',
      name: 'proMaxRetracement',
      desc: '',
      args: [],
    );
  }

  /// `交易次数`
  String get proNumOfTrade {
    return Intl.message(
      '交易次数',
      name: 'proNumOfTrade',
      desc: '',
      args: [],
    );
  }

  /// `盈利次数`
  String get proNumOfGain {
    return Intl.message(
      '盈利次数',
      name: 'proNumOfGain',
      desc: '',
      args: [],
    );
  }

  /// `亏损次数`
  String get proNumOfLoss {
    return Intl.message(
      '亏损次数',
      name: 'proNumOfLoss',
      desc: '',
      args: [],
    );
  }

  /// `交易量`
  String get proTradeVolume {
    return Intl.message(
      '交易量',
      name: 'proTradeVolume',
      desc: '',
      args: [],
    );
  }

  /// `手续费`
  String get proFee {
    return Intl.message(
      '手续费',
      name: 'proFee',
      desc: '',
      args: [],
    );
  }

  /// `交易胜率`
  String get proWinRate {
    return Intl.message(
      '交易胜率',
      name: 'proWinRate',
      desc: '',
      args: [],
    );
  }

  /// `支持交易所`
  String get supportExchanges {
    return Intl.message(
      '支持交易所',
      name: 'supportExchanges',
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