import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lighthouse/generated/l10n.dart';
import 'package:lighthouse/net/constant.dart';
import 'package:lighthouse/provider/locale_provider.dart';
import 'package:lighthouse/provider/store.dart';
import 'package:lighthouse/provider/theme_provider.dart';
import 'package:lighthouse/router/app_analysis.dart';
import 'package:lighthouse/router/routers.dart';
import 'package:lighthouse/ui/page/splash_page.dart';
import 'package:lighthouse/utils/device_util.dart';
import 'package:lighthouse/utils/log_util.dart';
import 'package:lighthouse/utils/sp_util.dart';
import 'package:lighthouse/utils/toast_util.dart';
import 'package:provider/provider.dart';
import 'package:umeng_analytics_plugin/umeng_analytics_plugin.dart';

//默认App的启动
class DefaultApp {
  //运行app
  static Future<void> run() async {
    WidgetsFlutterBinding.ensureInitialized();

    await UmengAnalyticsPlugin.init(
      androidKey: '5fa62c2745b2b751a925bf49',
      iosKey: '5fa62c921c520d3073a2536f',
    );

    await SPUtil.init();

    runApp(Store.init(MyApp()));

    initApp();
  }

  //程序初始化操作
  static void initApp() {

    FlutterBugly.init(androidAppId: '9e87287cfa', iOSAppId: 'ad8a0b5092');

    LogUtil.init(isDebug: Constant.isTestEnvironment);

    if (DeviceUtil.isAndroid) {
      // 透明状态栏
      const SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }

  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  final Widget home;
  final ThemeData theme;

  MyApp({
    this.home,
    this.theme
  });

  @override
  Widget build(BuildContext context) {
    Routers.init();

    return Consumer2<ThemeProvider, LocaleProvider>(
        builder: (context, themeProvider, localeModel, _) {
      return ToastUtil.init(MaterialApp(
        title: 'LightHouse',
        theme: theme ?? themeProvider.getThemeData(),
        darkTheme: themeProvider.getThemeData(isDarkMode: true),
        themeMode: themeProvider.getThemeMode(),
        home: home ?? SplashPage(),
        onGenerateRoute: Routers.router.generator,
        navigatorObservers: [AppAnalysis()],
        locale: localeModel.getLocale(),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: S.delegate.supportedLocales,
        localeResolutionCallback:
            (Locale _locale, Iterable<Locale> supportedLocales) {
          if (localeModel.getLocale() != null) {
            //如果已经选定语言，则不跟随系统
            return localeModel.getLocale();
          } else {
            //跟随系统
            if (S.delegate.isSupported(_locale)) {
              return _locale;
            }
            return supportedLocales.first;
          }
        },
      ));
    });
  }
}
