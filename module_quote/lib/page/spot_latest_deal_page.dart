
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
import 'package:module_quote/item/latest_deal_item.dart';
import 'package:module_quote/model/latest_deal.dart';
import 'package:module_quote/viewmodel/spot_deal_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SpotLatestDealPage extends StatefulWidget {

  const SpotLatestDealPage({
    Key? key,
  }): super(key: key);


  @override
  _SpotLatestDealPageState createState() => _SpotLatestDealPageState();
}

class _SpotLatestDealPageState extends State<SpotLatestDealPage> with BasePageMixin<SpotLatestDealPage>, AutomaticKeepAliveClientMixin<SpotLatestDealPage>, SingleTickerProviderStateMixin{

  @override
  bool get wantKeepAlive => true;

  RefreshController _easyController = RefreshController();

  late SpotDealModel _spotDealModel;

  @override
  void initState() {
    super.initState();

    _spotDealModel = SpotDealModel();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
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
    _spotDealModel.getLatestDeal();
    _spotDealModel.listenEvent();

    _spotDealModel.addListener(() {
      if (_spotDealModel.isError) {
        _easyController.refreshFailed();
        ToastUtil.error(_spotDealModel.viewStateError!.message!);

      } else if (_spotDealModel.isSuccess || _spotDealModel.isEmpty) {
        _easyController.refreshCompleted(resetFooterState: false);
      }
    });
  }

  @override
  Future<void> refresh({slient = false}) {
    return _spotDealModel.getLatestDeal();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ProviderWidget<SpotDealModel>(
        model: _spotDealModel,
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
                        return LatestDealItem(
                          latestDeal: _spotDealModel.dealList[i],
                        );
                      },
                        childCount: min(20, _spotDealModel.dealList.length),
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
              flex: 1,
              child: Text(S.of(context).proTime,
                style: TextStyles.textGray400_w400_12,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(S.of(context).proWay,
                style: TextStyles.textGray400_w400_12,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(S.of(context).proPrice,
                style: TextStyles.textGray400_w400_12,
                maxLines: 1,
                overflow: TextOverflow.ellipsis
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerRight,
              child: Text(S.of(context).proAmount,
                style: TextStyles.textGray400_w400_12,
                maxLines: 1,
                overflow: TextOverflow.ellipsis
              ),
            ),
          ),
        ],
      ),
    );
  }

}
