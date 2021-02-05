

import 'package:flutter/material.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/utils/toast_util.dart';
import 'package:library_base/widget/common_scroll_view.dart';
import 'package:module_money/widget/money_appbar.dart';
import 'package:module_money/widget/money_assets_trend_bar.dart';
import 'package:module_money/widget/money_support_exchange_bar.dart';
import 'package:module_money/widget/money_total_assets_bar.dart';
import 'package:module_money/widget/money_index_bar.dart';



class MoneyPage extends StatefulWidget {

  MoneyPage({
    Key key,
  }) : super(key: key);

  @override
  _MoneyPageState createState() => _MoneyPageState();
}

class _MoneyPageState extends State<MoneyPage> with BasePageMixin<MoneyPage>, AutomaticKeepAliveClientMixin<MoneyPage>, SingleTickerProviderStateMixin {

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Future<void> refresh({slient = false}) {
    return Future.value();
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: Colours.white,
        body: RefreshIndicator(
            onRefresh: refresh,
            child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colours.white, Color(0xffE7EFFC)],
                  ),
                ),
                child: CommonScrollView(
                  physics: ClampingScrollPhysics(),
                  children: <Widget>[
                    AppBar(
                      elevation: 0,
                      brightness: Brightness.light,
                      backgroundColor: Colours.transparent,
                      automaticallyImplyLeading: false,
                      toolbarHeight: 0,
                    ),
                    MoneyAppbar(),
                    MoneyTotalAssetsBar(
                        selectCallback: (select) {
                          ToastUtil.normal(select);
                        }),
                    MoneyAssetsTrendBar(),
                    MoneyIndexBar(),
                    MoneySupportExchangeBar()
                  ],
                )
            )
        )



    );
  }

}
