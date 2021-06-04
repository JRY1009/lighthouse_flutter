
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/mvvm/provider_widget.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/utils/screen_util.dart';
import 'package:library_base/widget/easyrefresh/first_refresh.dart';
import 'package:library_base/widget/tab/kline_tab.dart';
import 'package:module_quote/viewmodel/index_detail_model.dart';
import 'package:module_quote/viewmodel/index_timeline_model.dart';
import 'package:module_quote/widget/kline_chart.dart';
import 'package:provider/provider.dart';

class IndexTimelineBar extends StatefulWidget {

  final String coinCode;
  final VoidCallback onPressed;

  const IndexTimelineBar({
    Key key,
    this.coinCode,
    this.onPressed,
  }): super(key: key);


  @override
  _IndexTimelineBarState createState() => _IndexTimelineBarState();
}

class _IndexTimelineBarState extends State<IndexTimelineBar> with AutomaticKeepAliveClientMixin<IndexTimelineBar>, SingleTickerProviderStateMixin{

  @override
  bool get wantKeepAlive => true;

  IndexTimelineModel _indexTimelineModel;

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
    _indexTimelineModel = IndexTimelineModel();
    _indexTimelineModel.listenEvent();
    _indexTimelineModel.getQuote(widget.coinCode, 1);
  }

  @override
  Future<void> refresh({slient = false}) {
    return _indexTimelineModel.getQuote(widget.coinCode, _tabController.index);
  }

  @override
  Widget build(BuildContext context) {

    double height = max(235, ScreenUtil.instance().screenHeight * 0.5);

    return Container(
        height: height,
        color: Colours.white,
        margin: EdgeInsets.only(bottom: 9),
        child: ProviderWidget<IndexTimelineModel>(
            model: _indexTimelineModel,
            builder: (context, model, child) {
              return  Column(
                children: [

                  Expanded(
                      child: Container(
                          height: height - 55,
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: model.isBusy ? FirstRefresh() : KLineChart(
                            height: height - 55,
                            gridRows: 5,
                            quoteList: model.getQuoteList(_tabController.index),
                            onLongPressChanged: (entity) {
                              IndexDetailModel indexDetailModel = Provider.of<IndexDetailModel>(context, listen: false);
                              indexDetailModel?.handleKLineLongPress(entity);
                            },
                          )
                      )
                  ),

                  Container(
                    height: 24,
                    margin: EdgeInsets.fromLTRB(4, 0, 4, 12),
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

                ],
              );
            }
        )

    );
  }
}
