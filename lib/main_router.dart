
import 'package:library_base/router/i_router.dart';
import 'package:library_base/router/page_builder.dart';
import 'package:library_base/router/routers.dart';
import 'package:lighthouse/ui/module_base/page/main_page.dart';
import 'package:lighthouse/ui/module_base/page/web_view_page.dart';

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
    ];
  }

}