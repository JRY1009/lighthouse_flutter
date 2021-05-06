
import 'package:flutter/material.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/utils/device_util.dart';
import 'package:library_base/utils/num_util.dart';
import 'package:library_base/utils/screen_util.dart';
import 'package:library_base/widget/image/round_image.dart';
import 'package:module_home/viewmodel/home_model.dart';
import 'package:provider/provider.dart';

class HomePinnedAppBar extends StatefulWidget {

  final double appBarOpacity;
  final double height;

  const HomePinnedAppBar({
    Key key,
    @required this.appBarOpacity,
    @required this.height,
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
    HomeModel homeModel = Provider.of<HomeModel>(context);

    num btcRate = homeModel.btcUsdPair != null ? homeModel.btcUsdPair.change_percent : 0;
    num btcPrice = homeModel.btcUsdPair != null ? homeModel.btcUsdPair.quote : 0;
    String btcRateStr = (btcRate >= 0 ? '+' : '') + NumUtil.getNumByValueDouble(btcRate.toDouble(), 2).toString() + '%';
    String btcPriceStr = NumUtil.formatNum(btcPrice, point: 2);

    num ethRate = homeModel.ethUsdPair != null ? homeModel.ethUsdPair.change_percent : 0;
    num ethPrice = homeModel.ethUsdPair != null ? homeModel.ethUsdPair.quote : 0;
    String ethRateStr = (ethRate >= 0 ? '+' : '') + NumUtil.getNumByValueDouble(ethRate.toDouble(), 2).toString() + '%';
    String ethPriceStr = NumUtil.formatNum(ethPrice, point: 2);

    return Opacity(
      opacity: widget.appBarOpacity,
      child: Container(
        padding: EdgeInsets.only(top: ScreenUtil.getStatusBarH(context) + (DeviceUtil.isIOS ? 0 : 10)),
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
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            Container(
                                width: 18,
                                height: 18,
                                child:  RoundImage(homeModel?.btcUsdPair?.icon ?? '',
                                  width: 18,
                                  height: 18,
                                  borderRadius: BorderRadius.all(Radius.circular(18)),
                                  fadeInDuration: const Duration(milliseconds: 10),
                                )
                            ),
                            Gaps.hGap5,
                            Text(homeModel?.btcUsdPair?.coin_code ?? '', style: TextStyles.textGray800_w700_15)
                          ],
                        ),
                    ),
                    Gaps.vGap6,
                    Container(
                      margin: EdgeInsets.only(left: 24),
                      child: Row(
                        children: [
                          Text.rich(TextSpan(
                              children: [
                                TextSpan(text: '\$', style: btcRate >= 0 ? TextStyles.textGreen_w600_10 : TextStyles.textRed_w600_10),
                                TextSpan(text: btcPriceStr, style: btcRate >= 0 ? TextStyles.textGreen_w600_14 : TextStyles.textRed_w600_14),
                              ]
                          )),
                          Gaps.hGap8,
                          Container(
                            height: 18,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: btcRate >= 0 ? Color(0x1a22C29B) : Color(0x1aEC3944),
                              borderRadius: BorderRadius.all(Radius.circular(2.0)),
                            ),
                            child: Text(btcRateStr,
                              style: btcRate >= 0 ? TextStyles.textGreen_w400_10 : TextStyles.textRed_w400_10,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                    )
                  ],)
            ),
            Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            Container(
                              width: 18,
                              height: 18,
                              child:  RoundImage(homeModel?.ethUsdPair?.icon ?? '',
                                width: 18,
                                height: 18,
                                borderRadius: BorderRadius.all(Radius.circular(18)),
                                fadeInDuration: const Duration(milliseconds: 10),
                              )
                            ),
                            Gaps.hGap5,
                            Text(homeModel?.ethUsdPair?.coin_code ?? '', style: TextStyles.textGray800_w700_15)
                          ],
                        ),
                    ),
                    Gaps.vGap6,
                    Row(
                      children: [
                        Text.rich(TextSpan(
                            children: [
                              TextSpan(text: '\$', style: ethRate >= 0 ? TextStyles.textGreen_w600_10 : TextStyles.textRed_w600_10),
                              TextSpan(text: ethPriceStr, style: ethRate >= 0 ? TextStyles.textGreen_w600_14 : TextStyles.textRed_w600_14),
                            ]
                        )),
                        Gaps.hGap8,
                        Container(
                          height: 18,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: ethRate >= 0 ? Color(0x1a22C29B) : Color(0x1aEC3944),
                            borderRadius: BorderRadius.all(Radius.circular(2.0)),
                          ),
                          child: Text(ethRateStr,
                            style: ethRate >= 0 ? TextStyles.textGreen_w400_10 : TextStyles.textRed_w400_10,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    )
                  ],)
            ),
          ],
        ),
      ),
    );
  }
}
