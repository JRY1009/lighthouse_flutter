import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:library_base/constant/app_config.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/net/apis.dart';
import 'package:library_base/router/routers.dart';
import 'package:library_base/utils/device_util.dart';
import 'package:library_base/utils/log_util.dart';
import 'package:library_base/utils/sp_util.dart';
import 'package:library_base/utils/toast_util.dart';
import 'package:library_base/utils/refresh_util.dart';
import 'package:module_info/info_router.dart';
import 'package:module_info/page/info_page.dart';

void main() => runApp(MyApp());

class DefaultApp {
  //运行app
  static Future<void> run() async {

    WidgetsFlutterBinding.ensureInitialized();

    await SPUtil.init();

    runApp(MyApp());

    initApp();
  }

  //程序初始化操作
  static void initApp() {

    LogUtil.init(isDebug: AppConfig.isTestEnvironment);
    if (DeviceUtil.isAndroid) {
      // 透明状态栏
      const SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
      );
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    Routers.init([InfoRouter()]);

    InfoRouter.isRunModule = true;

    Widget child = MaterialApp(
      title: 'module_info',
      home: InfoPage(),
      onGenerateRoute: Routers.router!.generator,
      locale: Locale('zh', 'CN'),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: S.delegate.supportedLocales,
    );

    return ToastUtil.init(RefreshUtil.init(child));
  }
}
