

import 'package:extended_tabs/extended_tabs.dart';
import 'package:flutter/material.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/utils/log_util.dart';
import 'package:library_base/widget/nestedscroll/nested_scroll_view_inner_scroll_position_key_widget.dart' as extended;
import 'package:library_base/widget/tab/round_indicator.dart';

import 'index_list_page.dart';
import 'platform_page.dart';


class QuotePage extends StatefulWidget {

  QuotePage({
    Key? key,
  }) : super(key: key);

  @override
  _QuotePageState createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage> with BasePageMixin<QuotePage>, AutomaticKeepAliveClientMixin<QuotePage>, SingleTickerProviderStateMixin {

  @override
  bool get wantKeepAlive => true;

  late List<GlobalKey<BasePageMixin>> _keyList;
  late List<String> _tabTitles ;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    _tabTitles = [S.current.index, S.current.platform];

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
  Future<void> jump({Map<String, dynamic>? params}) async {
    LogUtil.v('_QuotePageState ==> jump $params');
    int tabIndex = params!['tab'] ?? 0;

    setState(() {
      _tabController.index = tabIndex;
    });
  }

  @override
  Future<void> refresh({slient = false}) {
    return _keyList[_tabController.index].currentState!.refresh();
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
      body: Column(
        children: <Widget>[
          Container(
            height: 44.0,
            alignment: Alignment.centerLeft,
            child: TabBar(
              controller: _tabController,
              labelColor: Colours.gray_800,
              labelStyle: TextStyles.textGray800_w700_18,
              unselectedLabelColor: Colours.gray_400,
              unselectedLabelStyle: TextStyles.textGray400_w400_14,
              indicatorSize: TabBarIndicatorSize.label,
              indicator: RoundTabIndicator(
                  borderSide: BorderSide(color: Colours.app_main, width: 3),
                  isRound: true,
                  insets: EdgeInsets.only(left: 10, right: 10)),
              isScrollable: true,
              tabs: <Tab>[
                Tab(text: _tabTitles[0]),
                Tab(text: _tabTitles[1]),
              ],
            ),
          ),

          Expanded(
              child: ExtendedTabBarView(
                controller: _tabController,
                children: <Widget>[
                  extended.NestedScrollViewInnerScrollPositionKeyWidget(Key(_tabTitles[0]), IndexListPage(key: _keyList[0])),
                  extended.NestedScrollViewInnerScrollPositionKeyWidget(Key(_tabTitles[1]), PlatformPage(key: _keyList[1])),
                ],
              )
          )
        ],
      ),
    );
  }

}
