
import 'package:flutter/material.dart';
import 'package:library_base/router/i_router.dart';
import 'package:library_base/router/page_builder.dart';
import 'package:library_base/router/routers.dart';
import 'package:module_home/model/lesson.dart';
import 'package:module_home/page/community_page.dart';
import 'package:module_home/page/global_quote_page.dart';
import 'package:module_home/page/home_page.dart';
import 'package:module_home/page/lesson_page.dart';
import 'package:module_home/page/milestone_page.dart';
import 'package:module_home/page/school_page.dart';
import 'package:module_home/page/spot_detail_page.dart';
import 'package:module_home/page/treemap_page.dart';

class HomeRouter implements IRouter{

  static bool isRunModule = false;

  @override
  List<PageBuilder> getPageBuilders() {
    return [
      PageBuilder(Routers.homePage, (params) {
        Key key = params?.getObj('key');
        return HomePage(key: key);
      }),

      PageBuilder(Routers.spotDetailPage, (params) {
        String coinCode = params?.getString('coinCode');
        return SpotDetailPage(coinCode: coinCode);
      }),

      PageBuilder(Routers.globalQuotePage, (_) => GlobalQuotePage()),
      PageBuilder(Routers.treemapPage, (_) => TreemapPage()),
      PageBuilder(Routers.milestonePage, (_) => MileStonePage()),
      PageBuilder(Routers.schoolPage, (_) => SchoolPage()),
      PageBuilder(Routers.communityPage, (_) => CommunityPage()),


      PageBuilder(Routers.lessonPage, (params) {
        Lesson lesson = params?.getObj('lesson');
        return LessonPage(lesson: lesson);
      }),
    ];
  }

}