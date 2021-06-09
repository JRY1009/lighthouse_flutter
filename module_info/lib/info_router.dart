
import 'package:flutter/material.dart';
import 'package:library_base/router/i_router.dart';
import 'package:library_base/router/page_builder.dart';
import 'package:library_base/router/routers.dart';
import 'package:module_info/page/article_list_page.dart';
import 'package:module_info/page/article_recommend_page.dart';
import 'package:module_info/page/info_page.dart';
import 'package:module_info/page/news_list_page.dart';
import 'package:module_info/page/article_page.dart';
import 'package:module_info/page/article_request_page.dart';

class InfoRouter implements IRouter{

  static bool isRunModule = false;

  @override
  List<PageBuilder> getPageBuilders() {
    return [
      PageBuilder(Routers.infoPage, (params) {
        Key? key = params?.getObj('key');
        return InfoPage(key: key);
      }),

      PageBuilder(Routers.articleRecommendPage, (params) {
        Key? key = params?.getObj('key');
        return ArticleRecommendPage(key: key);
      }),

      PageBuilder(Routers.articleListPage, (params) {
        Key? key = params?.getObj('key');
        bool isSupportPull = params?.getBool('isSupportPull') ?? true;
        bool isSingleCard = params?.getBool('isSingleCard') ?? false;
        return ArticleListPage(key: key, isSupportPull: isSupportPull, isSingleCard: isSingleCard);
      }),

      PageBuilder(Routers.newsListPage, (params) {
        Key? key = params?.getObj('key');
        bool isSupportPull = params?.getBool('isSupportPull') ?? true;
        return NewsListPage(key: key, isSupportPull: isSupportPull);
      }),

      PageBuilder(Routers.articlePage, (params) {
        String? title = params?.getString('title');
        String? url = params?.getString('url');
        String? title_share = params?.getString('title_share');
        String? summary_share = params?.getString('summary_share');
        String? url_share = params?.getString('url_share');
        String? thumb_share = params?.getString('thumb_share');
        bool show_share = params?.getBool('show_share') ?? true;
        return ArticlePage(url, title, title_share: title_share, summary_share: summary_share, url_share: url_share, thumb_share: thumb_share, show_share: show_share);
      }),

      PageBuilder(Routers.articleRequestPage, (params) {
        num article_id = params?.getInt('article_id') ?? 0;
        return ArticleRequestPage(article_id);
      }),

    ];
  }
}