
import 'package:flutter/material.dart';
import 'package:library_base/model/quote_coin.dart';
import 'package:library_base/router/i_router.dart';
import 'package:library_base/router/page_builder.dart';
import 'package:library_base/router/routers.dart';

import 'page/global_quote_page.dart';
import 'page/index_detail_page.dart';
import 'page/quote_page.dart';
import 'page/spot_depth_order_page.dart';
import 'page/spot_detail_hpage.dart';
import 'page/spot_detail_page.dart';
import 'page/spot_latest_deal_page.dart';
import 'page/treemap_page.dart';

class QuoteRouter implements IRouter{

  static bool isRunModule = false;

  @override
  List<PageBuilder> getPageBuilders() {
    return [
      PageBuilder(Routers.quotePage, (params) {
        Key key = params?.getObj('key');
        return QuotePage(key: key);
      }),

      PageBuilder(Routers.indexDetailPage, (params) {
        String coinCode = params?.getString('coinCode');
        return IndexDetailPage(coinCode: coinCode);
      }),

      PageBuilder(Routers.spotDetailPage, (params) {
        String coinCode = params?.getString('coinCode');
        return SpotDetailPage(coinCode: coinCode);
      }),

      PageBuilder(Routers.spotDetailHPage, (params) {
        String coinCode = params?.getString('coinCode');
        QuoteCoin quoteCoin = params?.getObj('quoteCoin');
        return SpotDetailHPage(coinCode: coinCode, quoteCoin: quoteCoin);
      }),

      PageBuilder(Routers.spotDepthOrderPage, (params) {
        Key key = params?.getObj('key');
        return SpotDepthOrderPage(key: key);
      }),

      PageBuilder(Routers.spotLatestDealPage, (params) {
        Key key = params?.getObj('key');
        return SpotLatestDealPage(key: key);
      }),

      PageBuilder(Routers.globalQuotePage, (_) => GlobalQuotePage()),
      PageBuilder(Routers.treemapPage, (_) => TreemapPage()),
    ];
  }

}