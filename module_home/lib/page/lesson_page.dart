import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:library_base/constant/constant.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/widget/button/back_button.dart';
import 'package:library_base/widget/dialog/dialog_util.dart';
import 'package:library_base/widget/dialog/share_widget.dart';
import 'package:library_base/widget/image/local_image.dart';
import 'package:module_home/home_router.dart';
import 'package:module_home/model/lesson.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class LessonPage extends StatefulWidget {

  final Lesson? lesson;

  LessonPage({
    Key? key,
    this.lesson,
  }) : super(key: key);

  @override
  _LessonPageState createState() {
    return _LessonPageState();
  }
}

class _LessonPageState extends State<LessonPage> with BasePageMixin<LessonPage> {

  @override
  bool get wantKeepAlive => true;

  RefreshController _easyController = RefreshController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _easyController.dispose();
    super.dispose();
  }


  @override
  Future<void> refresh({slient = false}) async {

  }

  Future<void> _share(BuildContext context) async {

    String? package = HomeRouter.isRunModule ? null : Constant.moduleHome;

    DialogUtil.showShareDialog(context,
        children: [
          Container(
            color: Colours.normal_bg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gaps.vGap16,
                LocalImage('school_logo', package: package, width: 112, height: 104),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9F2FB),
                    borderRadius: BorderRadius.all(Radius.circular(6.0)),
                  ),
                  child: Text(widget.lesson?.title ?? '',
                    style: TextStyles.textGray800_w700_20,
                    strutStyle: StrutStyle(forceStrutHeight: true, height:1.4, leading: 0.5),
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
                  child: Text(widget.lesson?.content ?? '',
                    style: TextStyles.textGray800_w400_16,
                    strutStyle: StrutStyle(forceStrutHeight: true, height:1.2, leading: 0.5),
                  ),
                )
              ],
            )
          ),
          ShareQRFoooter(backgroundColor: Colours.normal_bg)
        ]
    );
  }

  @override
  Widget build(BuildContext context) {

    String? package = HomeRouter.isRunModule ? null : Constant.moduleHome;

    return Scaffold(
        backgroundColor: Colours.normal_bg,
        appBar: AppBar(
            leading: BackButtonEx(),
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
            backgroundColor: Colours.normal_bg,
            actions: [
              IconButton(
                icon: LocalImage('icon_share', package: Constant.baseLib, width: 20, height: 20),
                onPressed: () => _share(context),
              )
            ],
            centerTitle: true,
            title: Text(S.of(context).dengtaSchool, style: TextStyles.textBlack16)
        ),
        body: SmartRefresher(
            controller: _easyController,
            enablePullDown: false,
            enablePullUp: false,
            onRefresh: null,
            onLoading: null,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LocalImage('school_logo', package: package, width: 112, height: 104),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE9F2FB),
                            borderRadius: BorderRadius.all(Radius.circular(6.0)),
                          ),
                          child: Text(widget.lesson?.title ?? '',
                            style: TextStyles.textGray800_w600_20,
                            strutStyle: StrutStyle(forceStrutHeight: true, height:1.4, leading: 0.5),
                          ),
                        ),

                        Container(
                          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
                          child: Text(widget.lesson?.content ?? '',
                            style: TextStyles.textGray800_w400_16,
                            strutStyle: StrutStyle(forceStrutHeight: true, height:1.2, leading: 0.5),
                          ),
                        )
                      ],
                    )
                ),
              ],
            )
        )
    );

  }
}
