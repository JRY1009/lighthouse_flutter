
import 'package:flutter/material.dart';
import 'package:lighthouse/mvvm/provider_widget.dart';
import 'package:lighthouse/net/constant.dart';
import 'package:lighthouse/net/dio_util.dart';
import 'package:lighthouse/net/model/quote.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/styles.dart';
import 'package:lighthouse/ui/module_base/widget/chart/line_chart.dart';
import 'package:lighthouse/ui/module_base/widget/easyrefresh/first_refresh_top.dart';
import 'package:lighthouse/ui/module_base/widget/tab/kline_tab.dart';
import 'package:lighthouse/ui/module_home/viewmodel/spot_kline_model.dart';

class SpotDetailKLineBar extends StatefulWidget {

  final String coinCode;
  final VoidCallback onPressed;

  const SpotDetailKLineBar({
    Key key,
    this.coinCode,
    this.onPressed,
  }): super(key: key);


  @override
  _SpotDetailKLineBarState createState() => _SpotDetailKLineBarState();
}

class _SpotDetailKLineBarState extends State<SpotDetailKLineBar> with AutomaticKeepAliveClientMixin<SpotDetailKLineBar>, SingleTickerProviderStateMixin{

  @override
  bool get wantKeepAlive => true;

  SpotKLineModel _kLineModel;

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    initViewModel();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void initViewModel() {
    _kLineModel = SpotKLineModel();
    _kLineModel.getQuote(widget.coinCode, 0);
  }

  @override
  Future<void> refresh({slient = false}) {
    return _kLineModel.getQuote(widget.coinCode, _tabController.index);
  }

  @override
  Widget build(BuildContext context) {

    return Container(
        height: 235,
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: Colours.white,
          borderRadius: BorderRadius.all(Radius.circular(14.0)),
          boxShadow: BoxShadows.normalBoxShadow,
        ),
        child: ProviderWidget<SpotKLineModel>(
            model: _kLineModel,
            builder: (context, model, child) {
              return  Column(
                children: [
                  Container(
                    height: 24,
                    margin: EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                    child: TabBar(
                      controller: _tabController,
                      labelPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
                      labelColor: Colours.white,
                      unselectedLabelColor: Colours.gray_500,
                      labelStyle: TextStyle(fontSize: 13, color: Colours.white),
                      unselectedLabelStyle: TextStyle(fontSize: 13, color: Colours.gray_500),
                      indicatorSize: TabBarIndicatorSize.label,
                      indicator: const BoxDecoration(),
//              indicator: new BubbleTabIndicator(
//                insets: const EdgeInsets.symmetric(horizontal: 0),
//                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
//                indicatorHeight: 24.0,
//                indicatorRadius: 10,
//                indicatorColor: Colours.app_main,
//                tabBarIndicatorSize: TabBarIndicatorSize.tab,
//              ),
                      isScrollable: false,
                      tabs: <KLineTab>[
                        KLineTab(text: '24H', select: _tabController.index == 0),
                        KLineTab(text: '1周', select: _tabController.index == 1),
                        KLineTab(text: '1月', select: _tabController.index == 2),
                        KLineTab(text: '6月', select: _tabController.index == 3),
                        KLineTab(text: '1年', select: _tabController.index == 4),
                        KLineTab(text: '全部', select: _tabController.index == 5),
                      ],
                      onTap: (index) {
                        if (model.getQuoteList(_tabController.index) != null) {
                          model.notifyListeners();
                        } else {
                          model.getQuote(widget.coinCode, index);
                        }
                      },
                    ),
                  ),

                  Expanded(
                    child: Container(
                      height: 170,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: model.isBusy ? FirstRefreshTop() : SimpleLineChart(
                          quoteList: model.getQuoteList(_tabController.index),
                          timeFormat: _tabController.index == 0 ? ChartTimeFormat.HOUR_MINUTE : ChartTimeFormat.MONTH_DAY),
                    ),
                  )
                ],
              );
            }
        )

    );
  }
}
