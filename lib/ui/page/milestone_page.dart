

import 'package:flutter/material.dart';
import 'package:lighthouse/generated/l10n.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/styles.dart';
import 'package:lighthouse/ui/page/base_page.dart';
import 'package:lighthouse/ui/page2nd/milestone_list_page.dart';
import 'package:lighthouse/ui/widget/button/back_button.dart';
import 'package:lighthouse/ui/widget/tab/kline_tab.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart' as extended;


class MileStonePage extends StatefulWidget {

  MileStonePage({
    Key key,
  }) : super(key: key);

  @override
  _MileStonePageState createState() => _MileStonePageState();
}

class _MileStonePageState extends State<MileStonePage> with BasePageMixin<MileStonePage>, SingleTickerProviderStateMixin {

  List<GlobalKey<BasePageMixin>> _keyList;
  List<String> _tabTitles ;

  TabController _tabController;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 5, vsync: this);

    _tabTitles = [S.current.all, 'BTC', 'ETH', 'USDT', 'DECP'];

    _keyList = [
      GlobalKey<BasePageMixin>(debugLabel: _tabTitles[0]),
      GlobalKey<BasePageMixin>(debugLabel: _tabTitles[1]),
      GlobalKey<BasePageMixin>(debugLabel: _tabTitles[2]),
      GlobalKey<BasePageMixin>(debugLabel: _tabTitles[3]),
      GlobalKey<BasePageMixin>(debugLabel: _tabTitles[4]),
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  Future<void> refresh({slient = false}) {
    return _keyList[_tabController.index]?.currentState.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.app_main,
      appBar: AppBar(
          leading: BackButtonEx(icon: Icon(Icons.arrow_back_ios, color: Colours.white, size: 25)),
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Colours.app_main,
          centerTitle: true,
          title: Text(S.of(context).milestone, style: TextStyles.textWhite18)
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                height: 50.0,
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Colours.white,
                  borderRadius: BorderRadius.vertical(top:  Radius.circular(14.0)),
                ),
                child: TabBar(
                  controller: _tabController,
                  labelPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
                  labelColor: Colours.white,
                  unselectedLabelColor: Colours.gray_500,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicator: const BoxDecoration(),
                  isScrollable: true,
                  tabs: <KLineTab>[
                    KLineTab(text: _tabTitles[0], select:_tabController.index  == 0, padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2)),
                    KLineTab(text: _tabTitles[1], select:_tabController.index  == 1, padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2)),
                    KLineTab(text: _tabTitles[2], select:_tabController.index  == 2, padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2)),
                    KLineTab(text: _tabTitles[3], select:_tabController.index  == 3, padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2)),
                    KLineTab(text: _tabTitles[4], select:_tabController.index  == 4, padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2)),
                  ],
                  onTap: (index) {
                    _pageController.animateToPage(index,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.fastOutSlowIn,);
                  },
                ),
              ),

              Expanded(
                child: Container(
                  color: Colours.white,
                  child: PageView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int index) => setState((){ _tabController.index = index; }),
                    children: <Widget>[
                      extended.NestedScrollViewInnerScrollPositionKeyWidget(Key(_tabTitles[0]), MileStoneListPage(key: _keyList[0], isSupportPull: true)),
                      extended.NestedScrollViewInnerScrollPositionKeyWidget(Key(_tabTitles[1]), MileStoneListPage(key: _keyList[1], isSupportPull: true)),
                      extended.NestedScrollViewInnerScrollPositionKeyWidget(Key(_tabTitles[2]), MileStoneListPage(key: _keyList[2], isSupportPull: true)),
                      extended.NestedScrollViewInnerScrollPositionKeyWidget(Key(_tabTitles[3]), MileStoneListPage(key: _keyList[3], isSupportPull: true)),
                      extended.NestedScrollViewInnerScrollPositionKeyWidget(Key(_tabTitles[4]), MileStoneListPage(key: _keyList[4], isSupportPull: true)),
                    ],
                  ),
                )
              )
            ],
          )
        ],
      ),

    );
  }

}
