

import 'package:flutter/material.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/widget/tab/round_indicator.dart';
import 'package:library_base/utils/log_util.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart' as extended;
import 'package:module_info/page/article_list_page.dart';
import 'package:module_info/page/news_list_page.dart';



class InfoPage extends StatefulWidget {

  InfoPage({
    Key key,
  }) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> with BasePageMixin<InfoPage>, AutomaticKeepAliveClientMixin<InfoPage>, SingleTickerProviderStateMixin {

  @override
  bool get wantKeepAlive => true;

  List<GlobalKey<BasePageMixin>> _keyList;
  List<String> _tabTitles ;

  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    _tabTitles = [S.current.x724, S.current.article];

    _keyList = [
      GlobalKey<BasePageMixin>(debugLabel: _tabTitles[0]),
      GlobalKey<BasePageMixin>(debugLabel: _tabTitles[1]),
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Future<void> jump({Map<String, dynamic> params}) {
    LogUtil.v('_InfoPageState ==> jump $params');
    int tabIndex = params['tab'] ?? 0;
    setState(() {
      _tabController.index = tabIndex;
    });
  }

  @override
  Future<void> refresh({slient = false}) {
    return _keyList[_tabController.index]?.currentState.refresh();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colours.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colours.white,
        automaticallyImplyLeading: false,
        toolbarHeight: 10,
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                width: 200.0,
                height: 44.0,
                child: TabBar(
                  controller: _tabController,
                  labelColor: Colours.app_main,
                  labelStyle: TextStyles.textMain16,
                  unselectedLabelColor: Colours.gray_400,
                  unselectedLabelStyle: TextStyles.textGray400_w400_16,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicator: RoundTabIndicator(
                      borderSide: BorderSide(color: Colours.app_main, width: 3),
                      isRound: true,
                      insets: EdgeInsets.only(left: 5, right: 5)),
                  isScrollable: false,
                  tabs: <Tab>[
                    Tab(text: _tabTitles[0]),
                    Tab(text: _tabTitles[1]),
                  ],
                ),
              ),

              Gaps.line,
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    extended.NestedScrollViewInnerScrollPositionKeyWidget(Key(_tabTitles[0]), NewsListPage(key: _keyList[0], isSupportPull: true)),
                    extended.NestedScrollViewInnerScrollPositionKeyWidget(Key(_tabTitles[1]), ArticleListPage(key: _keyList[1], isSupportPull: true)),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

}
