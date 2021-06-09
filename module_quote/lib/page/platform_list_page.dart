
import 'package:flutter/material.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/mvvm/provider_widget.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/utils/num_util.dart';
import 'package:library_base/utils/toast_util.dart';
import 'package:library_base/widget/button/sort_button.dart';
import 'package:library_base/widget/common_scroll_view.dart';
import 'package:library_base/widget/easyrefresh/loading_empty.dart';
import 'package:library_base/widget/easyrefresh/skeleton_list.dart';
import 'package:module_quote/item/quote_platform_item.dart';
import 'package:module_quote/item/skeleton_quote_item.dart';
import 'package:module_quote/model/quote_platform.dart';
import 'package:module_quote/viewmodel/quote_platform_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PlatformListPage extends StatefulWidget {

  const PlatformListPage({
    Key? key,
  }): super(key: key);


  @override
  _PlatformListPageState createState() => _PlatformListPageState();
}

class _PlatformListPageState extends State<PlatformListPage> with BasePageMixin<PlatformListPage>, AutomaticKeepAliveClientMixin<PlatformListPage>, SingleTickerProviderStateMixin{

  @override
  bool get wantKeepAlive => true;

  RefreshController _easyController = RefreshController();

  late QuotePlatformModel _platformModel;

  @override
  void initState() {
    super.initState();

    _platformModel = QuotePlatformModel();
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
    _platformModel.getPlatformQuote('bitcoin');
    _platformModel.listenEvent();

    _platformModel.addListener(() {
      if (_platformModel.isError) {
        _easyController.refreshFailed();
        ToastUtil.error(_platformModel.viewStateError!.message!);

      } else if (_platformModel.isSuccess || _platformModel.isEmpty) {
        _easyController.refreshCompleted(resetFooterState: false);
      }
    });
  }

  @override
  Future<void> refresh({slient = false}) {
    return _platformModel.getPlatformQuote('bitcoin');
  }


  //state 0 priceClicked，1 rateClicked
  void _changeSortState(int state) {
    _platformModel.changeSortState(state);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ProviderWidget<QuotePlatformModel>(
        model: _platformModel,
        builder: (context, model, child) {

          List<QuotePlatformPair> sortedList = _platformModel.getSortedList();

          Widget refreshWidget = SkeletonList(
            builder: (ctx, index) => SkeletonQuoteItem(),
          );

          Widget emptyWidget = LoadingEmpty();

          return ScrollConfiguration(
            behavior: OverScrollBehavior(),
            child: SmartRefresher(
                controller: _easyController,
                enablePullDown: true,
                enablePullUp: false,
                onRefresh: refresh,
                onLoading: null,
                child: model.isFirst ? refreshWidget : (model.isEmpty || model.isError) ? emptyWidget : CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        width: double.infinity,
                        color: Colours.white,
                        height: 46.0,
                        child: _buildHeader(),
                      ),
                    ),

                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, i) {
                        return QuotePlatformItem(
                            index: i,
                            quotePlatformPair: sortedList[i]
                        );
                      },
                        childCount: sortedList.length,
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

    double rate = _platformModel.platformBasic?.change_percent ?? 0;
    double price = _platformModel.platformBasic?.quote ?? 0;
    double cny = _platformModel.platformBasic?.cny ?? 0;
    double change_amount = _platformModel.platformBasic?.change_amount ?? 0;

    String groupStr = _platformModel.platformBasic?.data_src ?? '';
    String rateStr = (rate >= 0 ? '+' : '') + NumUtil.getNumByValueDouble(rate, 2).toString() + '%';

    String priceStr = NumUtil.formatNum(price, point: 2);
    String cnyStr = NumUtil.formatNum(cny, point: 2);
    String changeAmountStr = (rate >= 0 ? '+' : '') + NumUtil.formatNum(change_amount, point: 2);

    return Column(
      children: [
        Container(
          height: 46.0,
          width: double.infinity,
          margin: const EdgeInsets.only(left: 15, right: 15),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(width: 0.6, color: Colours.default_line))
          ),
          child: Row (
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: 100,
                  child: Text(S.of(context).proTradePlatform, style: TextStyles.textGray500_w400_12,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,)
              ),
              GestureDetector(
                  onTap: () =>_changeSortState(0),
                  child: Container(
                    width: 110,
                    alignment: Alignment.centerRight,
                    child: Text.rich(TextSpan(
                        children: [
                          TextSpan(text: S.of(context).proLatestPrice, style: TextStyles.textGray500_w400_12),
                          WidgetSpan(
                              child: SortButton(
                                  state: _platformModel.sortState == PlatformSortState.PRICE_ASCEND ? SortButtonState.ASCEND :
                                  _platformModel.sortState == PlatformSortState.PRICE_DESCEND ? SortButtonState.DESCEND : SortButtonState.NORMAL
                              )
                          )
                        ]
                    )),
                  )
              ),
              GestureDetector(
                  onTap: () =>_changeSortState(1),
                  child: Container(
                    width: 70,
                    alignment: Alignment.centerRight,
                    child: Text.rich(TextSpan(
                        children: [
                          TextSpan(text: S.of(context).proRate, style: TextStyles.textGray500_w400_12),
                          WidgetSpan(
                              child: SortButton(
                                  state: _platformModel.sortState == PlatformSortState.RATE_ASCEND ? SortButtonState.ASCEND :
                                  _platformModel.sortState == PlatformSortState.RATE_DESCEND ? SortButtonState.DESCEND : SortButtonState.NORMAL
                              )
                          )
                        ]
                    )),
                  )
              )
            ],
          ),
        ),

      ],
    );
  }

}
