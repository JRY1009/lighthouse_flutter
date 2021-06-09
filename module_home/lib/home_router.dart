
import 'package:flutter/material.dart';
import 'package:library_base/router/i_router.dart';
import 'package:library_base/router/page_builder.dart';
import 'package:library_base/router/routers.dart';
import 'package:module_home/model/lesson.dart';
import 'package:module_home/page/community_page.dart';
import 'package:module_home/page/home_page.dart';
import 'package:module_home/page/lesson_page.dart';
import 'package:module_home/page/milestone_page.dart';
import 'package:module_home/page/school_page.dart';

class HomeRouter implements IRouter{

  static bool isRunModule = false;

  @override
  List<PageBuilder> getPageBuilders() {
    return [
      PageBuilder(Routers.homePage, (params) {
        Key? key = params?.getObj('key');
        return HomePage(key: key);
      }),

      PageBuilder(Routers.milestonePage, (params) {
        int initialIndex = params?.getInt('initialIndex') ?? 0;
        return MileStonePage(initialIndex: initialIndex);
      }),

      PageBuilder(Routers.schoolPage, (_) => SchoolPage()),
      PageBuilder(Routers.communityPage, (_) => CommunityPage()),


      PageBuilder(Routers.lessonPage, (params) {
        Lesson? lesson = params?.getObj('lesson');
        return LessonPage(lesson: lesson);
      }),
    ];
  }

}