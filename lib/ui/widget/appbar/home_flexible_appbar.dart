
import 'package:flutter/material.dart';
import 'package:lighthouse/generated/l10n.dart';
import 'package:lighthouse/net/model/account.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/gaps.dart';
import 'package:lighthouse/res/styles.dart';
import 'package:lighthouse/ui/widget/appbar/home_flexible_tabview.dart';
import 'package:lighthouse/ui/widget/tab/bubble_indicator.dart';
import 'package:lighthouse/ui/widget/tab/quotation_tab.dart';
import 'package:lighthouse/utils/image_util.dart';

class HomeFlexibleAppBar extends StatefulWidget {

  final Account account;
  final VoidCallback onPressed;

  const HomeFlexibleAppBar({
    Key key,
    this.account,
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
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      child: TabBar(
                        controller: _tabController,
                        labelColor: Colours.gray_800,
                        unselectedLabelColor: Colours.gray_400,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: new BubbleTabIndicator(
                          insets: const EdgeInsets.symmetric(horizontal: 0),
                          indicatorHeight: 55.0,
                          indicatorRadius: 10,
                          indicatorColor: Colours.white,
                          tabBarIndicatorSize: TabBarIndicatorSize.tab,
                        ),
                        isScrollable: false,
                        tabs: <QuotationTab>[
                          QuotationTab(title: 'BTC/USD', subTitle: '12321.92  1.21%',),
                          QuotationTab(title: 'ETH/USD', subTitle: '12321.92  1.21%',),
                        ],
                      ),
                    ),

                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: <Widget>[
                          HomeFlexibleTabView(),
                          HomeFlexibleTabView()
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
