
import 'package:flutter/material.dart';
import 'package:library_base/router/i_router.dart';
import 'package:library_base/router/page_builder.dart';
import 'package:library_base/router/routers.dart';
import 'package:module_money/page/money_page.dart';

class MoneyRouter implements IRouter{

  static bool isRunModule = false;

  @override
  List<PageBuilder> getPageBuilders() {
    return [
      PageBuilder(Routers.moneyPage, (params) {
        Key key = params?.getObj('key');
        return MoneyPage(key: key);
      }),

    ];
  }

}