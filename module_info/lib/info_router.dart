
import 'package:flutter/material.dart';
import 'package:library_base/router/i_router.dart';
import 'package:library_base/router/page_builder.dart';
import 'package:library_base/router/routers.dart';
import 'package:module_info/page/article_list_page.dart';
import 'package:module_info/page/info_page.dart';
import 'package:module_info/page/news_list_page.dart';

class InfoRouter implements IRouter{

  static bool isRunModule = false;

  @override
  List<PageBuilder> getPageBuilders() {
    return [
      PageBuilder(Routers.infoPage, (params) {
        Key key = params?.getObj('key');
        return InfoPage(key: key);
      }),

      PageBuilder(Routers.articleListPage, (params) {
        Key key = params?.getObj('key');
        String tag = params?.getString('tag') ?? '';
        bool isSupportPull = params?.getBool('isSupportPull');
        bool isSingleCard = params?.getBool('isSingleCard');
        return ArticleListPage(key: key, tag: tag, isSupportPull: isSupportPull, isSingleCard: isSingleCard);
      }),

      PageBuilder(Routers.newsListPage, (params) {
        Key key = params?.getObj('key');
        String tag = params?.getString('tag') ?? '';
        bool isSupportPull = params?.getBool('isSupportPull');
        return NewsListPage(key: key, tag: tag, isSupportPull: isSupportPull);
      }),
    ];
  }
}