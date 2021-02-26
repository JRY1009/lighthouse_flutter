
import 'package:flutter/material.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/mvvm/provider_widget.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/widget/easyrefresh/first_refresh_top.dart';
import 'package:library_base/widget/tab/kline_tab.dart';
import 'package:module_home/viewmodel/spot_detail_model.dart';
import 'package:module_home/viewmodel/spot_kline_model.dart';
import 'package:module_home/widget/kline_chart.dart';
import 'package:provider/provider.dart';

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
    _tabController = TabController(initialIndex:1, length: 6, vsync: this);
    initViewModel();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void initViewModel() {
    _kLineModel = SpotKLineModel();
    _kLineModel.listenEvent();
    _kLineModel.getQuote(widget.coinCode, 1);
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
                    margin: EdgeInsets.fromLTRB(4, 12, 4, 0),
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
                        KLineTab(text: S.of(context).kline1h, select: _tabController.index == 0),
                        KLineTab(text: S.of(context).kline24h, select: _tabController.index == 1),
                        KLineTab(text: S.of(context).kline1week, select: _tabController.index == 2),
                        KLineTab(text: S.of(context).kline1month, select: _tabController.index == 3),
                        KLineTab(text: S.of(context).kline1year, select: _tabController.index == 4),
                        KLineTab(text: S.of(context).klineAll, select: _tabController.index == 5),
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
                      height: 180,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: model.isBusy ? FirstRefreshTop() : KLineChart(
                        quoteList: model.getQuoteList(_tabController.index),
                        onLongPressChanged: (entity) {
                          SpotDetailModel spotDetailModel = Provider.of<SpotDetailModel>(context, listen: false);
                          spotDetailModel?.handleKLineLongPress(entity);
                        },
                      )
                    )
                  )
                ],
              );
            }
        )

    );
  }
}
