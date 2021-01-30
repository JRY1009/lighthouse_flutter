import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_xupdate/flutter_xupdate.dart';
import 'package:fluwx/fluwx.dart';
import 'package:library_base/constant/constant.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/global/locale_provider.dart';
import 'package:library_base/global/theme_provider.dart';
import 'package:library_base/mvvm/provider_widget.dart';
import 'package:library_base/net/apis.dart';
import 'package:library_base/router/app_analysis.dart';
import 'package:library_base/router/routers.dart';
import 'package:library_base/utils/device_util.dart';
import 'package:library_base/utils/jpush_util.dart';
import 'package:library_base/utils/log_util.dart';
import 'package:library_base/utils/sp_util.dart';
import 'package:library_base/utils/toast_util.dart';
import 'package:lighthouse/main_router.dart';
import 'package:lighthouse/ui/module_base/page/splash_page.dart';
import 'package:module_info/info_router.dart';
import 'package:module_mine/mine_router.dart';
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

    await registerWxApi(
        appId: "wxfdba5c8a01643f82",
        doOnAndroid: true,
        doOnIOS: true,
        universalLink: "https://your.univerallink.com/link/");

    await SPUtil.init();

    runApp(MyApp());

    initApp();
  }

  //程序初始化操作
  static void initApp() {

    LogUtil.init(isDebug: Apis.isTestEnvironment);
    JPushUtil.initPlatformState();

    if (DeviceUtil.isAndroid) {
      // 透明状态栏
      const SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
      );
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);

      FlutterXUpdate.init(
        ///是否输出日志
          debug: !Constant.isReleaseMode,
          ///是否使用post请求
          isPost: false,
          ///post请求是否是上传json
          isPostJson: false,
          ///是否开启自动模式
          isWifiOnly: false,
          ///是否开启自动模式
          isAutoMode: false,
          ///需要设置的公共参数
          supportSilentInstall: false,
          ///在下载过程中，如果点击了取消的话，是否弹出切换下载方式的重试提示弹窗
          enableRetry: false
      );
    }
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    Routers.init([
      MainRouter(),
      InfoRouter(),
      MineRouter()
    ]);

    return ProviderWidget2(
        model1: ThemeProvider(),
        model2: LocaleProvider(SPUtil.getString(SPUtil.key_locale)),
        builder: (context, themeProvider, localeModel, _) {
          return ToastUtil.init(MaterialApp(
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
          )
          );
        }
    );
  }
}
