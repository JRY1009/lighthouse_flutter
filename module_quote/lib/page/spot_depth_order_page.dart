
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/mvvm/provider_widget.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/utils/toast_util.dart';
import 'package:library_base/widget/common_scroll_view.dart';
import 'package:library_base/widget/easyrefresh/first_refresh_top.dart';
import 'package:library_base/widget/easyrefresh/loading_empty_top.dart';
import 'package:module_quote/item/depth_order_item.dart';
import 'package:module_quote/viewmodel/spot_depth_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SpotDepthOrderPage extends StatefulWidget {

  const SpotDepthOrderPage({
    Key key,
  }): super(key: key);


  @override
  _SpotDepthOrderPageState createState() => _SpotDepthOrderPageState();
}

class _SpotDepthOrderPageState extends State<SpotDepthOrderPage> with BasePageMixin<SpotDepthOrderPage>, AutomaticKeepAliveClientMixin<SpotDepthOrderPage>, SingleTickerProviderStateMixin{

  @override
  bool get wantKeepAlive => true;

  RefreshController _easyController = RefreshController();

  SpotDepthModel _spotDepthModel;

  @override
  void initState() {
    super.initState();

    _spotDepthModel = SpotDepthModel();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        initViewModel();
      }
    });
  }

  @override
  void dispose() {
    _easyController.dispose();
    super.dispose();
  }

  void initViewModel() {
    _spotDepthModel.getDepth('', isChart: false);
    _spotDepthModel.listenEvent();

    _spotDepthModel.addListener(() {
      if (_spotDepthModel.isError) {
        _easyController.refreshFailed();
        ToastUtil.error(_spotDepthModel.viewStateError.message);

      } else if (_spotDepthModel.isSuccess || _spotDepthModel.isEmpty) {
        _easyController.refreshCompleted(resetFooterState: false);
      }
    });
  }

  @override
  Future<void> refresh({slient = false}) {
    return _spotDepthModel.getDepth('', isChart: false);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ProviderWidget<SpotDepthModel>(
        model: _spotDepthModel,
        builder: (context, model, child) {

          Widget refreshWidget = FirstRefreshTop();
          Widget emptyWidget = LoadingEmptyTop();

          return ScrollConfiguration(
            behavior: OverScrollBehavior(),
            child: SmartRefresher(
                physics: const ClampingScrollPhysics(),
                controller: _easyController,
                enablePullDown: false,
                enablePullUp: false,
                onRefresh: null,
                onLoading: null,
                child: model.isFirst ? refreshWidget : (model.isEmpty || model.isError) ? emptyWidget : CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: _buildHeader()
                    ),

                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, i) {
                        return DepthOrderItem(
                          bid: i < _spotDepthModel?.bidsList?.length ? _spotDepthModel?.bidsList[i] : null,
                          ask: i < _spotDepthModel?.asksList?.length ? _spotDepthModel?.asksList[i] : null,
                          bidAmountMax: _spotDepthModel?.bidAmountMax,
                          askAmountMax: _spotDepthModel?.askAmountMax,
                        );
                      },
                        childCount: min(20, _spotDepthModel?.bidsList?.length),
                      ),
                    ),
                  ],
                )
            ),
          );

        }
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 40.0,
      width: double.infinity,
      margin: const EdgeInsets.only(left: 9, right: 9),
      child: Row (
        children: [
          Expanded(
            child: Container(
                alignment: Alignment.centerLeft,
                child: Text(S.of(context).proBid, style: TextStyles.textGray500_w400_12,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis
                )
            ),
          ),
          Gaps.hGap5,
          Expanded(
            child: Container(
                alignment: Alignment.centerLeft,
                child: Text(S.of(context).proAsk, style: TextStyles.textGray500_w400_12,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis
                )
            ),
          ),
        ],
      ),
    );
  }

}
