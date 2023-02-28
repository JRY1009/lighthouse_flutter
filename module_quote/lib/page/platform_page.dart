

import 'package:extended_tabs/extended_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/utils/log_util.dart';
import 'package:library_base/widget/image/round_image.dart';
import 'package:library_base/widget/nestedscroll/nested_scroll_view_inner_scroll_position_key_widget.dart' as extended;
import 'package:library_base/widget/tab/bubble_indicator.dart';

import 'platform_list_page.dart';



class PlatformPage extends StatefulWidget {

  PlatformPage({
    Key? key,
  }) : super(key: key);

  @override
  _PlatformPageState createState() => _PlatformPageState();
}

class _PlatformPageState extends State<PlatformPage> with BasePageMixin<PlatformPage>, AutomaticKeepAliveClientMixin<PlatformPage>, SingleTickerProviderStateMixin {

  @override
  bool get wantKeepAlive => true;

  late List<GlobalKey<BasePageMixin>> _keyList;
  late List<String> _tabTitles ;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);

    _tabTitles = ['OKEX', 'Huobi', 'Binance'];

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
  Future<void> jump({Map<String, dynamic>? params}) async {
    LogUtil.v('_PlatformPageState ==> jump $params');
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
        systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
        backgroundColor: Colours.white,
        automaticallyImplyLeading: false,
        toolbarHeight: 10,
      ),
      body: Column(

        children: <Widget>[
          Container(
            height: 44.0,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            child: Theme(
              data: ThemeData(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: TabBar(
                controller: _tabController,
                labelPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 6),
                labelColor: Colours.gray_800,
                labelStyle: TextStyles.textGray800_w400_13,
                unselectedLabelColor: Colours.gray_800,
                unselectedLabelStyle: TextStyles.textGray800_w400_13,
                indicatorSize: TabBarIndicatorSize.label,
                indicator: BubbleTabIndicator(
                  insets: const EdgeInsets.only(left: 0, right: 12),
                  indicatorHeight: 30.0,
                  indicatorRadius: 4,
                  indicatorColor: Colours.gray_50,
                  tabBarIndicatorSize: TabBarIndicatorSize.tab,
                ),
                isScrollable: true,
                tabs: <Tab>[
                  Tab(child: Row(
                    children: [
                      Gaps.hGap8,
                      RoundImage('https://szwj-beacon.oss-cn-beijing.aliyuncs.com/backstage/coin_ico/20210421/c55936d515204c1b9eee64e2ddcbba5ficon-exchange-OKex.png',
                        width: 16,
                        height: 16,
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                      ),
                      Gaps.hGap3,
                      Text(_tabTitles[0]),
                      Gaps.hGap18,
                      SizedBox(width: 1, height: 16.0, child: VerticalDivider(width: 1, color: Colours.gray_400)),
                    ],
                  )),
                  Tab(child: Row(
                    children: [
                      Gaps.hGap8,
                      RoundImage('https://szwj-beacon.oss-cn-beijing.aliyuncs.com/backstage/coin_ico/20210421/9a81f06c4f6447eda18417a209cf3702icon-exchange-huobi.png',
                        width: 16,
                        height: 16,
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                      ),
                      Gaps.hGap3,
                      Text(_tabTitles[1]),
                      Gaps.hGap18,
                      SizedBox(width: 1, height: 16.0, child: VerticalDivider(width: 1, color: Colours.gray_400)),
                    ],
                  )),
                  Tab(child: Row(
                    children: [
                      Gaps.hGap8,
                      RoundImage('https://szwj-beacon.oss-cn-beijing.aliyuncs.com/backstage/coin_ico/20210421/d673adfc7fc0432db082e7a0f7835909icon-exchange-bian.png',
                        width: 16,
                        height: 16,
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                      ),
                      Gaps.hGap3,
                      Text(_tabTitles[2]),
                      Gaps.hGap18,
                    ],
                  )),
                ],
              ),
            ),
          ),

          Expanded(
            child: ExtendedTabBarView(
              controller: _tabController,
              children: <Widget>[
                extended.NestedScrollViewInnerScrollPositionKeyWidget(Key(_tabTitles[0]), PlatformListPage(key: _keyList[0])),
                extended.NestedScrollViewInnerScrollPositionKeyWidget(Key(_tabTitles[1]), PlatformListPage(key: _keyList[1])),
                extended.NestedScrollViewInnerScrollPositionKeyWidget(Key(_tabTitles[2]), PlatformListPage(key: _keyList[2])),
              ],
            )
          )
        ],
      ),
    );
  }

}
