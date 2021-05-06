import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import 'package:module_home/item/leave_message_item.dart';
import 'package:module_home/model/leave_message.dart';
import 'package:module_home/viewmodel/leave_message_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CommunityPage extends StatefulWidget {

  CommunityPage({
    Key key,
  }) : super(key: key);

  @override
  _CommunityPageState createState() {
    return _CommunityPageState();
  }
}

class _CommunityPageState extends State<CommunityPage> with BasePageMixin<CommunityPage> {

  @override
  bool get wantKeepAlive => true;

  RefreshController _easyController = RefreshController();

  LeaveMessageModel _leaveMessageModel;

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
    _leaveMessageModel = LeaveMessageModel();
    _leaveMessageModel.refresh();

    _leaveMessageModel.addListener(() {
      if (_leaveMessageModel.isError) {
        if (_leaveMessageModel.page == 1) {
          _easyController.refreshFailed();
        } else {
          _easyController.loadFailed();
        }
        ToastUtil.error(_leaveMessageModel.viewStateError.message);

      } else if (_leaveMessageModel.isSuccess || _leaveMessageModel.isEmpty) {
        if (_leaveMessageModel.page == 1) {
          _easyController.refreshCompleted(resetFooterState: !_leaveMessageModel.noMore);
        } else {
          if (_leaveMessageModel.noMore) {
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
      return _leaveMessageModel.refresh();

    } else {
      return Future<void>.delayed(const Duration(milliseconds: 100), () {
        _easyController.requestRefresh();
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colours.white,
        appBar: AppBar(
            leading: BackButtonEx(),
            elevation: 0,
            brightness: Brightness.light,
            backgroundColor: Colours.white,
            centerTitle: true,
            title: Text(S.of(context).dtCommunity, style: TextStyles.textBlack16)
        ),
        body: ProviderWidget<LeaveMessageModel>(
            model: _leaveMessageModel,
            builder: (context, model, child) {

              Widget refreshWidget = FirstRefresh();
              Widget emptyWidget = LoadingEmpty();

              return SmartRefresher(
                  controller: _easyController,
                  enablePullDown: true,
                  enablePullUp: !model.noMore,
                  onRefresh: model.refresh,
                  onLoading: model.noMore ? null : model.loadMore,
                  child: model.isFirst ? refreshWidget : model.isEmpty ? emptyWidget : CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          LeaveMessage lvMessage = model.messageList[index];
                          return LeaveMessageItem(
                            height: 232,
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                            maxLines: 5,
                            lvMessage: lvMessage,
                            share: true,
                          );
                        },
                          childCount: model.messageList.length,
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
