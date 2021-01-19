
import 'package:flutter/material.dart';
import 'package:lighthouse/net/model/quote_basic.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/gaps.dart';
import 'package:lighthouse/res/styles.dart';
import 'package:lighthouse/utils/num_util.dart';
import 'package:lighthouse/utils/screen_util.dart';

class HomePinnedAppBar extends StatefulWidget {

  final double appBarOpacity;
  final double height;
  final Map<String, QuoteBasic> quoteBasicMap;

  const HomePinnedAppBar({
    Key key,
    @required this.appBarOpacity,
    @required this.height,
    this.quoteBasicMap
  }): super(key: key);


  @override
  _HomePinnedAppBarState createState() => _HomePinnedAppBarState();
}

class _HomePinnedAppBarState extends State<HomePinnedAppBar> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
    String ethRateStr = (btcRate >= 0 ? '+' : '') + NumUtil.getNumByValueDouble(ethRate, 2).toString() + '%';
    String ethPriceStr = NumUtil.getNumByValueDouble(ethPrice, 2).toString();

    return Opacity(
      opacity: widget.appBarOpacity,
      child: Container(
        padding: EdgeInsets.only(top: ScreenUtil.getStatusBarH(context) + 10),
        height: widget.height,
        decoration: BoxDecoration(
          color: Colours.white,
          boxShadow: BoxShadows.normalBoxShadow,
        ),
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 24),
                        alignment: Alignment.centerLeft,
                        child: Text(widget.quoteBasicMap['bitcoin'] != null ? widget.quoteBasicMap['bitcoin'].pair : '', style: TextStyles.textGray800_w400_15,
                        )),
                    Gaps.vGap5,
                    Container(
                        margin: EdgeInsets.only(left: 24),
                        alignment: Alignment.centerLeft,
                        child: Text(btcPriceStr + '  ' + btcRateStr,
                          style: btcRate >= 0 ? TextStyles.textGreen_w400_12 : TextStyles.textRed_w400_12,
                        )
                    ),
                  ],)
            ),
            Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        child: Text(widget.quoteBasicMap['ethereum'] != null ? widget.quoteBasicMap['ethereum'].pair : '', style: TextStyles.textGray800_w400_15,)
                    ),
                    Gaps.vGap5,
                    Container(
                        alignment: Alignment.centerLeft,
                        child: Text(ethPriceStr + '  ' + ethRateStr,
                          style: ethRate >= 0 ? TextStyles.textGreen_w400_12 : TextStyles.textRed_w400_12,
                        )
                    ),
                  ],)
            ),
          ],
        ),
      ),
    );
  }
}
