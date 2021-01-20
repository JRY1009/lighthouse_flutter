
import 'package:flutter/material.dart';
import 'package:lighthouse/generated/l10n.dart';
import 'package:lighthouse/net/model/quote_basic.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/gaps.dart';
import 'package:lighthouse/res/styles.dart';
import 'package:lighthouse/ui/module_base/widget/tab/bubble_indicator.dart';
import 'package:lighthouse/ui/module_base/widget/tab/quotation_tab.dart';
import 'package:lighthouse/ui/module_home/widget/home_flexible_tabview.dart';
import 'package:lighthouse/utils/image_util.dart';
import 'package:lighthouse/utils/num_util.dart';

class HomeFlexibleAppBar extends StatefulWidget {

  final Map<String, QuoteBasic> quoteBasicMap;
  final VoidCallback onPressed;

  const HomeFlexibleAppBar({
    Key key,
    this.quoteBasicMap,
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

    double btcRate = widget.quoteBasicMap['bitcoin'] != null ? widget.quoteBasicMap['bitcoin'].change_percent : 0;
    double btcPrice = widget.quoteBasicMap['bitcoin'] != null ? widget.quoteBasicMap['bitcoin'].quote : 0;
    String btcRateStr = (btcRate >= 0 ? '+' : '') + NumUtil.getNumByValueDouble(btcRate, 2).toString() + '%';
    String btcPriceStr = NumUtil.getNumByValueDouble(btcPrice, 2).toString();

    double ethRate = widget.quoteBasicMap['ethereum'] != null ? widget.quoteBasicMap['ethereum'].change_percent : 0;
    double ethPrice = widget.quoteBasicMap['ethereum'] != null ? widget.quoteBasicMap['ethereum'].quote : 0;
    String ethRateStr = (ethRate >= 0 ? '+' : '') + NumUtil.getNumByValueDouble(ethRate, 2).toString() + '%';
    String ethPriceStr = NumUtil.getNumByValueDouble(ethPrice, 2).toString();

    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colours.transparent,
            image: DecorationImage(
              image: AssetImage(ImageUtil.getImgPath('bg_home')),
              fit: BoxFit.fill,
            ),
          ),
          child: AspectRatio (
            aspectRatio: 1.45,
          ),
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
                height: 361,
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
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                            title: widget.quoteBasicMap['bitcoin']?.pair,
                            subTitle: btcPriceStr + '  ' + btcRateStr,
                            subStyle: btcRate >= 0 ? TextStyles.textGreen_w400_12 : TextStyles.textRed_w400_12,
                          ),
                          QuotationTab(
                            title: widget.quoteBasicMap['ethereum']?.pair,
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
                          HomeFlexibleTabView(quoteBasic: widget.quoteBasicMap['bitcoin']),
                          HomeFlexibleTabView(quoteBasic: widget.quoteBasicMap['ethereum'])
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
