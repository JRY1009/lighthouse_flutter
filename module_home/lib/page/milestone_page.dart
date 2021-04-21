

import 'package:flutter/material.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/widget/button/back_button.dart';
import 'package:library_base/widget/image/local_image.dart';
import 'package:library_base/widget/tab/kline_tab.dart';
import 'package:library_base/widget/nestedscroll/nested_scroll_view_inner_scroll_position_key_widget.dart' as extended;
import 'package:module_home/page/milestone_list_page.dart';


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

    _tabController = TabController(length: 3, vsync: this);

    _tabTitles = [S.current.all, 'BTC', 'ETH'];

    _keyList = [
      GlobalKey<BasePageMixin>(debugLabel: _tabTitles[0]),
      GlobalKey<BasePageMixin>(debugLabel: _tabTitles[1]),
      GlobalKey<BasePageMixin>(debugLabel: _tabTitles[2]),
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
      backgroundColor: Color(0xFFF5FAFE),
      appBar: AppBar(
          leading: BackButtonEx(),
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Color(0xFFF5FAFE),
          centerTitle: true,
          title: Text(S.of(context).dengtaSchool, style: TextStyles.textBlack16)
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 16, top: 18.0, bottom: 5),
                  child: Text(S.of(context).blockMileStone, style: TextStyles.textGray800_w600_18)
              ),
              Container(
                height: 50.0,
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                alignment: Alignment.centerLeft,
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
                  child: PageView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int index) => setState((){ _tabController.index = index; }),
                    children: <Widget>[
                      extended.NestedScrollViewInnerScrollPositionKeyWidget(Key(_tabTitles[0]), MileStoneListPage(key: _keyList[0], tag: 'all', isSupportPull: true)),
                      extended.NestedScrollViewInnerScrollPositionKeyWidget(Key(_tabTitles[1]), MileStoneListPage(key: _keyList[1], tag: 'bitcoin', isSupportPull: true)),
                      extended.NestedScrollViewInnerScrollPositionKeyWidget(Key(_tabTitles[2]), MileStoneListPage(key: _keyList[2], tag: 'ethereum', isSupportPull: true)),
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
