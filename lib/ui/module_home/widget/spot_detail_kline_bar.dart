
import 'package:flutter/material.dart';
import 'package:lighthouse/net/constant.dart';
import 'package:lighthouse/net/dio_util.dart';
import 'package:lighthouse/net/model/quote.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/styles.dart';
import 'package:lighthouse/ui/module_base/widget/chart/line_chart.dart';
import 'package:lighthouse/ui/module_base/widget/tab/kline_tab.dart';

class SpotDetailKLineBar extends StatefulWidget {

  final String coin_code;
  final VoidCallback onPressed;

  const SpotDetailKLineBar({
    Key key,
    this.coin_code,
    this.onPressed,
  }): super(key: key);


  @override
  _SpotDetailKLineBarState createState() => _SpotDetailKLineBarState();
}

class _SpotDetailKLineBarState extends State<SpotDetailKLineBar> with AutomaticKeepAliveClientMixin<SpotDetailKLineBar>, SingleTickerProviderStateMixin{

  @override
  bool get wantKeepAlive => true;

  List<String> _rangeList;
  Map<String, List<Quote>> _quoteMap = {};

  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 6, vsync: this);

    _rangeList = ['24h', '1w', '1m', '6m', '1y', 'all'];

    _requestData(widget.coin_code, 0);
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  Future<void> _requestData(String coin_code, int index) {
    Map<String, dynamic> params = {
      'coin_code': coin_code,
      'time_range': _rangeList[index],
    };

    return DioUtil.getInstance().get(Constant.URL_GET_QUOTE, params: params,
        successCallBack: (data, headers) {
          if (data == null || data['data'] == null) {
            return;
          }

          List<Quote> quoteList = Quote.fromJsonList(data['data']) ?? [];
          _quoteMap[_rangeList[index]] = quoteList;

          setState(() {});
        },
        errorCallBack: (error) {
          _quoteMap[_rangeList[index]] = [];
          setState(() {});
        });
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
      child: Column(
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
                if (_quoteMap[_rangeList[_tabController.index]] != null) {
                  setState(() {

                  });
                } else {
                  _requestData(widget.coin_code, index);
                }
              },
            ),
          ),

          Expanded(
            child: Container(
              height: 170,
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: SimpleLineChart(
                  quoteList: _quoteMap[_rangeList[_tabController.index]],
                  timeFormat: _tabController.index == 0 ? ChartTimeFormat.HOUR_MINUTE : ChartTimeFormat.MONTH_DAY),
            ),
          )
        ],
      ),
    );
  }
}
