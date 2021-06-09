

import 'package:flutter/material.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/widget/tab/trend_tab.dart';
import 'package:module_money/widget/trend_line_bar.dart';


class MoneyAssetsTrendBar extends StatefulWidget {

  MoneyAssetsTrendBar({
    Key? key,
  }) : super(key: key);

  @override
  _MoneyAssetsTrendBarState createState() => _MoneyAssetsTrendBarState();
}

class _MoneyAssetsTrendBarState extends State<MoneyAssetsTrendBar> with BasePageMixin<MoneyAssetsTrendBar>, SingleTickerProviderStateMixin {

  late List<GlobalKey<BasePageMixin>> _keyList;

  TabController? _tabController;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    _keyList = [
      GlobalKey<BasePageMixin>(debugLabel: 'tab0'),
      GlobalKey<BasePageMixin>(debugLabel: 'tab1'),
    ];
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Future<void> refresh({slient = false}) {
    return _keyList[_tabController!.index].currentState!.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 221,
        color: Colours.white,
        margin: EdgeInsets.symmetric(vertical: 8),
        child:
          Column(
            children: <Widget>[
              Container(
                height: 50.0,
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 13,
                      margin: const EdgeInsets.only(right: 4),
                      color: Colours.app_main,
                    ),
                    TabBar(
                      controller: _tabController,
                      labelPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 5.0),
                      labelColor: Colours.white,
                      unselectedLabelColor: Colours.gray_500,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicator: const BoxDecoration(),
                      isScrollable: true,
                      tabs: <TrendTab>[
                        TrendTab(text: S.of(context).assetsTrend, select:_tabController!.index  == 0, padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2)),
                        TrendTab(text: S.of(context).profitTrend, select:_tabController!.index  == 1, padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2)),
                      ],
                      onTap: (index) {
                        _pageController.animateToPage(index,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.fastOutSlowIn);
                      },
                    ),

                    Expanded(
                        flex: 1,
                        child: Container()
                    ),
                    InkWell(
                      onTap: () => {},
                      child: Container(
                        padding: EdgeInsets.only(right: 10),
                        child: Row(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerRight,
                              child: Text(S.of(context).viewDetail,
                                style: TextStyles.textGray500_w400_12,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(Icons.keyboard_arrow_right, color: Colours.gray_500, size: 20),
                          ],
                        ),
                      ),
                    )

                  ],
                )
              ),

              Expanded(
                  child: Container(
                    child: PageView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: _pageController,
                      onPageChanged: (int index) => setState((){ _tabController!.index = index; }),
                      children: <Widget>[
                        TrendLineBar(),
                        TrendLineBar()
                      ],
                    ),
                  )
              )
            ],
          )
    );
  }

}
