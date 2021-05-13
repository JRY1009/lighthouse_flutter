import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluwx/fluwx.dart';
import 'package:library_base/constant/app_config.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/global/locale_provider.dart';
import 'package:library_base/global/theme_provider.dart';
import 'package:library_base/mvvm/provider_widget.dart';
import 'package:library_base/router/app_analysis.dart';
import 'package:library_base/router/parameters.dart';
import 'package:library_base/router/routers.dart';
import 'package:library_base/utils/channel_util.dart';
import 'package:library_base/utils/device_util.dart';
import 'package:library_base/utils/log_util.dart';
import 'package:library_base/utils/object_util.dart';
import 'package:library_base/utils/refresh_util.dart';
import 'package:library_base/utils/sp_util.dart';
import 'package:library_base/utils/toast_util.dart';
import 'package:lighthouse/main_router.dart';
import 'package:lighthouse/page/splash_page.dart';
import 'package:module_home/home_router.dart';
import 'package:module_info/info_router.dart';
import 'package:module_mine/mine_router.dart';
import 'package:module_money/money_router.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:umeng_analytics_plugin/umeng_analytics_plugin.dart';
import 'package:uni_links/uni_links.dart';

//默认App的启动
class DefaultApp {
  static Future<Widget> getApp() async {
    WidgetsFlutterBinding.ensureInitialized();

    await initApp();

    return MyApp();
  }

  //运行app
  static Future<void> run() async {
    WidgetsFlutterBinding.ensureInitialized();

    await initApp();

    runApp(MyApp());
  }

  //程序初始化操作
  static Future<void> initApp() async {

    LogUtil.init(isDebug: AppConfig.isTestEnvironment);
    //JPushUtil.initPlatformState();

    if (DeviceUtil.isAndroid) {
      // 透明状态栏
      const SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
      );
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }

    if (DeviceUtil.isMobile) {

      String channel = await ChannelUtil.getChannel();

      await UmengAnalyticsPlugin.init(
          androidKey: '607552ba5844f15425d14f03',
          iosKey: '6075530a5844f15425d151b2',
          channel: channel
      );

      await registerWxApi(
          appId: "wxfdba5c8a01643f82",
          doOnAndroid: true,
          doOnIOS: true,
          universalLink: "https://www.idengta.com/app/lighthouse/");
    }

    await SPUtil.init();
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();

    Routers.init([
      MainRouter(),
      HomeRouter(),
      InfoRouter(),
      MoneyRouter(),
      MineRouter()
    ]);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return ProviderWidget2(
        model1: ThemeProvider(),
        model2: LocaleProvider(SPUtil.getString(SPUtil.key_locale)),
        builder: (context, themeProvider, localeModel, _) {

          Widget child = MaterialApp(
            title: 'LightHouse',
            home: SplashPage(),
            theme:  themeProvider.getThemeData(),
            darkTheme: themeProvider.getThemeData(isDarkMode: true),
            themeMode: themeProvider.getThemeMode(),
            onGenerateRoute: Routers.router.generator,
            navigatorObservers: [AppAnalysis()],
            locale: localeModel.getLocale(),
            localizationsDelegates: const [
              S.delegate,
              RefreshLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate
            ],
            supportedLocales: S.delegate.supportedLocales,
            localeResolutionCallback: (Locale _locale, Iterable<Locale> supportedLocales) {
              if (localeModel.getLocale() != null) {  //如果已经选定语言，则不跟随系统
                return localeModel.getLocale();

              } else {  //跟随系统
                if (S.delegate.isSupported(_locale)) {
                  return _locale;
                }
                return supportedLocales.first;
              }
            },
            builder: (context, widget) {
              return MediaQuery(
                //设置文字大小不随系统设置改变
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: widget,
              );
            },
          );

          return ToastUtil.init(RefreshUtil.init(child));
        }
    );
  }
}
