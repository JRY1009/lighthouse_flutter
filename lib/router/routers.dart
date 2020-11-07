import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/router/router_handler.dart';

///使用fluro进行路由管理
class Routers {
  static FluroRouter router;

  static String webviewPage = '/webviewPage';
  static String loginPage = '/loginPage';

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
}
