
import 'package:library_base/router/i_router.dart';
import 'package:library_base/router/page_builder.dart';
import 'package:library_base/router/routers.dart';
import 'package:lighthouse/ui/module_base/page/main_page.dart';
import 'package:lighthouse/ui/module_base/page/web_view_page.dart';
import 'package:lighthouse/ui/module_home/page/global_quote_page.dart';
import 'package:lighthouse/ui/module_home/page/milestone_page.dart';
import 'package:lighthouse/ui/module_home/page/spot_detail_page.dart';
import 'package:lighthouse/ui/module_home/page/treemap_page.dart';

class MainRouter implements IRouter{

  @override
  List<PageBuilder> getPageBuilders() {
    return [
      PageBuilder(Routers.webviewPage, (params) {
        String title = params?.getString('title');
        String url = params?.getString('url');
        return WebViewPage(url, title);
      }),

      PageBuilder(Routers.mainPage, (_) => MainPage()),
      PageBuilder(Routers.spotDetailPage, (params) {
        String coinCode = params?.getString('coinCode');
        return SpotDetailPage(coinCode: coinCode);
      }),

      PageBuilder(Routers.globalQuotePage, (_) => GlobalQuotePage()),
      PageBuilder(Routers.treemapPage, (_) => TreemapPage()),
      PageBuilder(Routers.milestonePage, (_) => MileStonePage()),
    ];
  }

}