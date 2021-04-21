
import 'package:flutter/material.dart';
import 'package:library_base/constant/constant.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/utils/image_util.dart';
import 'package:library_base/utils/num_util.dart';
import 'package:library_base/utils/screen_util.dart';
import 'package:library_base/widget/tab/bubble_indicator.dart';
import 'package:library_base/widget/tab/quotation_tab.dart';
import 'package:module_home/home_router.dart';
import 'package:module_home/viewmodel/home_model.dart';
import 'package:module_home/widget/home_flexible_tabview.dart';
import 'package:provider/provider.dart';


class HomeFlexibleAppBar extends StatefulWidget {

  final VoidCallback onPressed;

  const HomeFlexibleAppBar({
    Key key,
    this.onPressed,
  }): super(key: key);


  @override
  _HomeFlexibleAppBarState createState() => _HomeFlexibleAppBarState();
}

class _HomeFlexibleAppBarState extends State<HomeFlexibleAppBar> with SingleTickerProviderStateMixin{

  TabController _tabController;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    HomeModel homeModel = Provider.of<HomeModel>(context);

    String btcIco = homeModel?.btcUsdPair?.icon ?? '';
    String btcIcoUnSelect = homeModel?.btcUsdPair?.icon_grey ?? '';
    num btcRate = homeModel?.btcUsdPair?.change_percent ?? 0;
    num btcPrice = homeModel?.btcUsdPair?.quote ?? 0;
    String btcRateStr = (btcRate >= 0 ? '+' : '') + NumUtil.getNumByValueDouble(btcRate.toDouble(), 2).toString() + '%';
    String btcPriceStr = NumUtil.formatNum(btcPrice, point: 2);

    String ethIco = homeModel?.ethUsdPair?.icon ?? '';
    String ethIcoUnSelect = homeModel?.ethUsdPair?.icon_grey ?? '';
    num ethRate = homeModel?.ethUsdPair?.change_percent ?? 0;
    num ethPrice = homeModel?.ethUsdPair?.quote ?? 0;
    String ethRateStr = (ethRate >= 0 ? '+' : '') + NumUtil.getNumByValueDouble(ethRate.toDouble(), 2).toString() + '%';
    String ethPriceStr = NumUtil.formatNum(ethPrice, point: 2);

    bool isVertical = ScreenUtil.getScreenW(context) < ScreenUtil.getScreenH(context);

    return Stack(
      children: <Widget>[
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colours.transparent,
            image: DecorationImage(
              image: AssetImage(ImageUtil.getImgPath('bg_home'), package: Constant.baseLib),
              fit: BoxFit.fill,
            ),
          ),
//          child: isVertical ? AspectRatio (
//            aspectRatio: 3.125,
//          ) : null,
        ),
        Container(
          height: 190,
          margin: EdgeInsets.only(top: 120),
          decoration: BoxDecoration(
            color: Colours.transparent,
            image: DecorationImage(
              image: AssetImage(ImageUtil.getImgPath('bg_home2'), package: Constant.baseLib),
              fit: BoxFit.fill,
            ),
          ),
        ),
        Container(  //占满
          padding: EdgeInsets.symmetric(horizontal: 12),
          color: Colours.transparent,
          child: Column(
            children: [
              Gaps.vGap60,
              Container(
                height: 30,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 10),
                child: Text(S.of(context).appName, style: TextStyles.textWhite24,),
              ),
              Container(
                height: 24,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 10),
                child: Text(S.of(context).slogan, style: TextStyles.textWhite14,),
              ),
              Gaps.vGap20,

              Container(
                height: 350,
                decoration: BoxDecoration(
                  color: Colours.white,
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  boxShadow: BoxShadows.normalBoxShadow,
                ),
                child: Column(
                  children: [
                    Container(
                      height: 59,
                      decoration: BoxDecoration(
                        color: Colours.bubble_bg,
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      margin: EdgeInsets.fromLTRB(12, 12, 12, 0),
                      child: TabBar(
                        controller: _tabController,
                        labelColor: Colours.gray_800,
                        unselectedLabelColor: Colours.gray_400,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: new BubbleTabIndicator(
                          insets: const EdgeInsets.symmetric(horizontal: 2),
                          indicatorHeight: 55.0,
                          indicatorRadius: 10,
                          indicatorColor: Colours.white,
                          tabBarIndicatorSize: TabBarIndicatorSize.tab,
                        ),
                        isScrollable: false,
                        tabs: <QuotationTab>[
                          QuotationTab(
                            select:_tabController.index  == 0,
                            icon: btcIco,
                            iconUnselect: btcIcoUnSelect,
                            title: homeModel.btcUsdPair?.coin_code,
                            priceStr: btcPriceStr,
                            rateStr: btcRateStr,
                            rate: btcRate,
                          ),
                          QuotationTab(
                            select:_tabController.index  == 1,
                            icon: ethIco,
                            iconUnselect: ethIcoUnSelect,
                            title: homeModel.ethUsdPair?.coin_code,
                            priceStr: ethPriceStr,
                            rateStr: ethRateStr,
                            rate: ethRate,
                          ),
                        ],
                        onTap: (index) {
                          _pageController.animateToPage(index,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.fastOutSlowIn,);
                        },
                      ),
                    ),

                    Expanded(
                      child: PageView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: _pageController,
                        onPageChanged: (int index) => setState((){ _tabController.index = index; }),
                        children: <Widget>[
                          HomeFlexibleTabView(quotePair: homeModel.btcUsdPair),
                          HomeFlexibleTabView(quotePair: homeModel.ethUsdPair)
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
