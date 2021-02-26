
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
    String package = HomeRouter.isRunModule ? null : Constant.moduleHome;

    double btcRate = homeModel.btcUsdPair != null ? homeModel.btcUsdPair.change_percent : 0;
    double btcPrice = homeModel.btcUsdPair != null ? homeModel.btcUsdPair.quote : 0;
    String btcRateStr = (btcRate >= 0 ? '+' : '') + NumUtil.getNumByValueDouble(btcRate, 2).toString() + '%';
    String btcPriceStr = '\$' + NumUtil.formatNum(btcPrice, point: 2);

    double ethRate = homeModel.ethUsdPair != null ? homeModel.ethUsdPair.change_percent : 0;
    double ethPrice = homeModel.ethUsdPair != null ? homeModel.ethUsdPair.quote : 0;
    String ethRateStr = (ethRate >= 0 ? '+' : '') + NumUtil.getNumByValueDouble(ethRate, 2).toString() + '%';
    String ethPriceStr = '\$' + NumUtil.formatNum(ethPrice, point: 2);

    bool isVertical = ScreenUtil.getScreenW(context) < ScreenUtil.getScreenH(context);

    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colours.transparent,
            image: DecorationImage(
              image: AssetImage(ImageUtil.getImgPath('bg_home'), package: package),
              fit: BoxFit.fill,
            ),
          ),
          child: isVertical ? AspectRatio (
            aspectRatio: 1.45,
          ) : null,
        ),
        Container(  //占满
          padding: EdgeInsets.symmetric(horizontal: 12),
          color: Colours.transparent,
          child: Column(
            children: [
              Gaps.vGap50,
              Container(
                height: 30,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 10),
                child: Text(S.of(context).appName, style: TextStyles.textWhite24,),
              ),
              Gaps.vGap5,
              Container(
                height: 20,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 10),
                child: Text(S.of(context).slogan, style: TextStyles.textWhite15,),
              ),
              Gaps.vGap15,

              Container(
                height: 335,
                decoration: BoxDecoration(
                  color: Colours.white,
                  borderRadius: BorderRadius.all(Radius.circular(14.0)),
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
                            title: homeModel.btcUsdPair?.pair,
                            subTitle: btcPriceStr + '  ' + btcRateStr,
                            subStyle: btcRate >= 0 ? TextStyles.textGreen_w400_12 : TextStyles.textRed_w400_12,
                          ),
                          QuotationTab(
                            title: homeModel.ethUsdPair?.pair,
                            subTitle: ethPriceStr + '  ' + ethRateStr,
                            subStyle: ethRate >= 0 ? TextStyles.textGreen_w400_12 : TextStyles.textRed_w400_12,
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
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
