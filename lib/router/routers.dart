import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/router/router_handler.dart';
import 'package:lighthouse/utils/log_util.dart';

///使用fluro进行路由管理
class Routers {
  static FluroRouter router;

  static String webviewPage = '/webviewPage';
  static String loginPage = '/loginPage';
  static String loginSmsPage = '/loginSmsPage';
  static String areaPage = '/areaPage';
  static String mainPage = '/mainPage';
  static String settingPage = '/settingPage';
  static String spotDetailPage = '/spotDetailPage';
  static String milestonePage = '/milestonePage';

  static void init() {
    router = FluroRouter();
    configureRoutes(router);
  }

  ///路由配置
  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print("route is not find !");
      return null;
    });

    router.define(webviewPage, handler: webviewPageHandler);
    router.define(loginPage, handler: loginPageHandler);
    router.define(loginSmsPage, handler: loginSmsPageHandler);
    router.define(areaPage, handler: areaPageHandler);
    router.define(mainPage, handler: mainPageHandler);
    router.define(settingPage, handler: settingPageHandler);
    router.define(spotDetailPage, handler: spotDetailPageHandler);
    router.define(milestonePage, handler: milestonePageHandler);
  }

  // 对参数进行encode，解决参数中有特殊字符，影响fluro路由匹配(https://www.jianshu.com/p/e575787d173c)
  static Future navigateTo(BuildContext context, String path,
      {Map<String, dynamic> params,
        bool clearStack = false,
        TransitionType transition = TransitionType.cupertino}) {
    String query = "";
    if (params != null) {
      int index = 0;
      for (var key in params.keys) {
        var value = Uri.encodeComponent(params[key]);
        if (index == 0) {
          query = "?";
        } else {
          query = query + "\&";
        }
        query += "$key=$value";
        index++;
      }
    }

    path = path + query;
    return router.navigateTo(context, path,
        clearStack: clearStack, transition: transition);
  }

  static void navigateToResult(BuildContext context, String path, Map<String, dynamic> params, Function(Object) function,
      {bool clearStack = false, TransitionType transition = TransitionType.cupertino}) {
    unfocus();
    navigateTo(context, path, params: params, clearStack: clearStack, transition: transition).then((Object result) {
      // 页面返回result为null
      if (result == null) {
        return;
      }
      function(result);
    }).catchError((dynamic error) {
      LogUtil.e('$error');
    });
  }

  /// 返回
  static void goBack(BuildContext context) {
    unfocus();
    Navigator.pop(context);
  }

  /// 带参数返回
  static void goBackWithParams(BuildContext context, Object result) {
    unfocus();
    Navigator.pop<Object>(context, result);
  }

  static void unfocus() {
    // 使用下面的方式，会触发不必要的build。
    // FocusScope.of(context).unfocus();
    // https://github.com/flutter/flutter/issues/47128#issuecomment-627551073
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
