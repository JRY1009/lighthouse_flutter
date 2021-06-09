import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:library_base/item/milestone_item.dart';
import 'package:library_base/model/milestone.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/mvvm/provider_widget.dart';
import 'package:library_base/utils/toast_util.dart';
import 'package:library_base/widget/easyrefresh/first_refresh.dart';
import 'package:library_base/widget/easyrefresh/first_refresh_top.dart';
import 'package:library_base/widget/easyrefresh/loading_empty.dart';
import 'package:library_base/widget/easyrefresh/loading_empty_top.dart';
import 'package:module_home/viewmodel/milestone_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MileStoneListPage extends StatefulWidget {
  
  final bool isSupportPull;  //是否支持手动下拉刷新
  final String tag;

  MileStoneListPage({
    Key? key,
    required this.tag,
    this.isSupportPull = true
  }) : super(key: key);

  @override
  _MileStoneListPageState createState() {
    return _MileStoneListPageState();
  }
}

class _MileStoneListPageState extends State<MileStoneListPage> with BasePageMixin<MileStoneListPage>, AutomaticKeepAliveClientMixin<MileStoneListPage>, SingleTickerProviderStateMixin {

  @override
  bool get wantKeepAlive => true;

  RefreshController _easyController = RefreshController();

  late MileStoneModel _mileStoneModel;

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
    _mileStoneModel = MileStoneModel(widget.tag);
    _mileStoneModel.refresh();

    _mileStoneModel.addListener(() {
      if (_mileStoneModel.isError) {
        if (_mileStoneModel.page == 0) {
          _easyController.refreshFailed();
        } else {
          _easyController.loadFailed();
        }
        ToastUtil.error(_mileStoneModel.viewStateError!.message!);

      } else if (_mileStoneModel.isSuccess || _mileStoneModel.isEmpty) {
        if (_mileStoneModel.page == 0) {
          _easyController.refreshCompleted(resetFooterState: !_mileStoneModel.noMore);
        } else {
          if (_mileStoneModel.noMore) {
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
      return _mileStoneModel.refresh();

    } else {
      return Future<void>.delayed(const Duration(milliseconds: 100), () {
        _easyController.requestRefresh();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ProviderWidget<MileStoneModel>(
        model: _mileStoneModel,
        builder: (context, model, child) {

          Widget refreshWidget = widget.isSupportPull ? FirstRefresh() : FirstRefreshTop();
          Widget emptyWidget = widget.isSupportPull ? LoadingEmpty() : LoadingEmptyTop();

          return SmartRefresher(
              controller: _easyController,
              enablePullDown: widget.isSupportPull,
              enablePullUp: !model.noMore,
              onRefresh: widget.isSupportPull ? model.refresh : null,
              onLoading: model.noMore ? null : model.loadMore,
              child: model.isFirst ? refreshWidget : model.isEmpty ? emptyWidget : CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      MileStone mileStone = model.mileStoneList[index];
                      return MileStoneItem(
                        index: index,
                        content: mileStone.content ?? '',
                        time: mileStone.date ?? '',
                        isLast: index == (model.mileStoneList.length - 1),
                      );
                    },
                      childCount: model.mileStoneList.length,
                    ),
                  ),
                ],
              )
          );
        }
    );
  }
}
