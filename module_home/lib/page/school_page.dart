import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:library_base/constant/constant.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/mvvm/provider_widget.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/utils/toast_util.dart';
import 'package:library_base/widget/button/back_button.dart';
import 'package:library_base/widget/easyrefresh/first_refresh.dart';
import 'package:library_base/widget/easyrefresh/loading_empty.dart';
import 'package:library_base/widget/image/local_image.dart';
import 'package:module_home/home_router.dart';
import 'package:module_home/item/lesson_item.dart';
import 'package:module_home/model/lesson.dart';
import 'package:module_home/viewmodel/school_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SchoolPage extends StatefulWidget {

  SchoolPage({
    Key? key,
  }) : super(key: key);

  @override
  _SchoolPageState createState() {
    return _SchoolPageState();
  }
}

class _SchoolPageState extends State<SchoolPage> with BasePageMixin<SchoolPage> {

  @override
  bool get wantKeepAlive => true;

  RefreshController _easyController = RefreshController();

  late SchoolModel _schoolModel;

  @override
  void initState() {
    super.initState();

    initViewModel();
  }

  @override
  void dispose() {
    _easyController.dispose();
    super.dispose();
  }

  void initViewModel() {
    _schoolModel = SchoolModel();
    _schoolModel.refresh();

    _schoolModel.addListener(() {
      if (_schoolModel.isError) {
        if (_schoolModel.page == 0) {
          _easyController.refreshFailed();
        } else {
          _easyController.loadFailed();
        }
        ToastUtil.error(_schoolModel.viewStateError!.message!);

      } else if (_schoolModel.isSuccess || _schoolModel.isEmpty) {
        if (_schoolModel.page == 0) {
          _easyController.refreshCompleted(resetFooterState: !_schoolModel.noMore);
        } else {
          if (_schoolModel.noMore) {
            _easyController.loadNoData();
          } else {
            _easyController.loadComplete();
          }
        }
      }
    });
  }

  @override
  Future<void> refresh({slient = false}) {
    if (slient) {
      return _schoolModel.refresh();

    } else {
      return Future<void>.delayed(const Duration(milliseconds: 100), () {
        _easyController.requestRefresh();
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    String? package = HomeRouter.isRunModule ? null : Constant.moduleHome;

    return Scaffold(
      backgroundColor: Colours.normal_bg,
      appBar: AppBar(
          leading: BackButtonEx(),
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Colours.normal_bg,
          centerTitle: true,
          title: Text(S.of(context).dengtaSchool, style: TextStyles.textBlack16)
      ),
      body: ProviderWidget<SchoolModel>(
          model: _schoolModel,
          builder: (context, model, child) {

            Widget refreshWidget = FirstRefresh();
            Widget emptyWidget = LoadingEmpty();

            return SmartRefresher(
                controller: _easyController,
                enablePullDown: false,
                enablePullUp: !model.noMore,
                onRefresh: null,
                onLoading: model.noMore ? null : model.loadMore,
                child: model.isFirst ? refreshWidget : model.isEmpty ? emptyWidget : CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LocalImage('school_logo', package: package, width: 112, height: 104),
                          Container(
                            padding: const EdgeInsets.only(left: 24, bottom: 15),
                            child: Text(S.of(context).schoolWelcome,
                              style: TextStyles.textGray800_w400_16,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      )
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        if (index == model.lessonList.length) {
                          return LessonItem(
                            lesson: Lesson(title: S.of(context).blockMileStone),
                            isLast: true,
                          );
                        } else {
                          Lesson lesson = model.lessonList[index];
                          return LessonItem(
                            lesson: lesson,
                            isLast: false,
                          );
                        }
                      },
                        childCount: model.lessonList.length + 1,
                      ),
                    ),
                    SliverToBoxAdapter(
                        child: Gaps.vGap12
                    ),
                  ],

                )
            );
          }
      )
    );

  }
}
