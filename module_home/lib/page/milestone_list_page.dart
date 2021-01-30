import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/mvvm/provider_widget.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/widget/easyrefresh/common_footer.dart';
import 'package:library_base/widget/easyrefresh/first_refresh.dart';
import 'package:library_base/widget/easyrefresh/loading_empty.dart';
import 'package:library_base/utils/toast_util.dart';
import 'package:module_home/item/milestone_item.dart';
import 'package:module_home/model/milestone.dart';
import 'package:module_home/viewmodel/milestone_model.dart';


class MileStoneListPage extends StatefulWidget {
  
  final bool isSupportPull;  //是否支持手动下拉刷新
  final String tag;

  MileStoneListPage({
    Key key,
    @required this.tag,
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

  EasyRefreshController _easyController = EasyRefreshController();

  MileStoneModel _mileStoneModel;

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
          _easyController.finishRefresh(success: false);
        } else {
          _easyController.finishLoad(success: false, noMore: _mileStoneModel.noMore);
        }
        ToastUtil.error(_mileStoneModel.viewStateError.message);

      } else if (_mileStoneModel.isSuccess || _mileStoneModel.isEmpty) {
        if (_mileStoneModel.page == 0) {
          _easyController.finishRefresh(success: true);
        } else {
          _easyController.finishLoad(success: true, noMore: _mileStoneModel.noMore);
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
        _easyController.callRefresh();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ProviderWidget<MileStoneModel>(
        model: _mileStoneModel,
        builder: (context, model, child) {
          return model.isFirst ? FirstRefresh() : EasyRefresh(
            header: widget.isSupportPull ? MaterialHeader(valueColor: AlwaysStoppedAnimation<Color>(Colours.app_main)) : null,
            footer:  CommonFooter(enableInfiniteLoad: !model.noMore),
            controller: _easyController,
            topBouncing: false,
            emptyWidget: (model.isEmpty || model.isError) ? LoadingEmpty() : null,
            child: ListView.builder(
              padding: EdgeInsets.all(0.0),
              itemBuilder: (context, index) {
                MileStone mileStone = model.mileStoneList[index];
                return MileStoneItem(
                  index: index,
                  content: mileStone?.content,
                  time: mileStone?.date,
                  isLast: index == (model.mileStoneList.length - 1),
                );
              },
              itemCount: model.mileStoneList.length,
            ),

            onRefresh: widget.isSupportPull ? model.refresh : null,
            onLoad: model.noMore ? null : model.loadMore,
          );
        }
    );
  }
}
