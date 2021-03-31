
import 'package:flutter/material.dart';
import 'package:library_base/mvvm/provider_widget.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/utils/num_util.dart';
import 'package:library_base/widget/text/number_slide_animation.dart';
import 'package:module_home/model/quote_coin.dart';
import 'package:module_home/viewmodel/spot_detail_model.dart';
import 'package:provider/provider.dart';

class SpotDetailAppbar extends StatefulWidget {

  final QuoteCoin quoteCoin;
  final NumberSlideController numberSlideController;
  final bool showShadow;

  const SpotDetailAppbar({
    Key key,
    this.quoteCoin,
    this.numberSlideController,
    this.showShadow = true,
  }): super(key: key);


  @override
  _SpotDetailAppbarState createState() => _SpotDetailAppbarState();
}

class _SpotDetailAppbarState extends State<SpotDetailAppbar>{

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

    SpotDetailModel spotDetailModel = Provider.of<SpotDetailModel>(context);

    double rate = widget.quoteCoin != null ? widget.quoteCoin.change_percent : 0;
    double price = widget.quoteCoin != null ? widget.quoteCoin.quote : 0;
    double priceCny = NumUtil.multiply(price, 6.5);
    double change_amount = widget.quoteCoin != null ? widget.quoteCoin.change_amount : 0;
    double amount_24h = widget.quoteCoin != null ? widget.quoteCoin.amount_24h : 0;
    double vol_24h = widget.quoteCoin != null ? widget.quoteCoin.vol_24h : 0;

    String coin_code = widget.quoteCoin != null ? widget.quoteCoin.coin_code : '';
    String rateStr = (rate >= 0 ? '+' : '') + NumUtil.getNumByValueDouble(rate, 2).toString() + '%';
    String priceStr = NumUtil.formatNum(price, point: 2);
    String priceCnyStr = NumUtil.formatNum(priceCny, point: 2);
    String changeAmountStr = (rate >= 0 ? '+' : '') + NumUtil.formatNum(change_amount, point: 2);
    String amount24Str = NumUtil.getBigVolumFormat(amount_24h, fractionDigits: 2).toString();
    String vol24Str = NumUtil.getBigVolumFormat(vol_24h, fractionDigits: 2).toString();

    return Container(
      height: 64,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colours.white,
        boxShadow: !widget.showShadow ? null : BoxShadows.normalBoxShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: EdgeInsets.only(top: 5, right: 10),
              alignment: Alignment.centerLeft,
              height: 27,
              child: Text.rich(TextSpan(
                  children: [
                    TextSpan(text: '\$', style: rate >= 0 ? TextStyles.textGreen_w400_12 : TextStyles.textRed_w400_12),
                    //TextSpan(text: priceStr, style: rate >= 0 ? TextStyles.textGreen_w400_22 : TextStyles.textRed_w400_22),
                    WidgetSpan(
                        child: NumberSlide(
                          controller: widget.numberSlideController,
                          initialNumber: priceStr,
                          textStyle: rate >= 0 ? TextStyles.textGreen_w400_22 : TextStyles.textRed_w400_22
                        ),
                    )
//                        WidgetSpan(
//                            child: Icon(rate >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
//                                color: rate >= 0 ? Colours.text_green : Colours.text_red,
//                                size: 14)
//                        )
                  ]
              ))
          ),

          ProviderWidget<SpotHeaderModel>(
              model: spotDetailModel.spotHeaderModel,
              builder: (context, model, child) {

                double rate = spotDetailModel.quoteCoin != null ? spotDetailModel.quoteCoin.change_percent : 0;
                double price = spotDetailModel.quoteCoin != null ? spotDetailModel.quoteCoin.quote : 0;
                double priceCny = NumUtil.multiply(price, 6.5);
                double change_amount = spotDetailModel.quoteCoin != null ? spotDetailModel.quoteCoin.change_amount : 0;

                String rateStr = (rate >= 0 ? '+' : '') + NumUtil.getNumByValueDouble(rate, 2).toString() + '%';
                String priceCnyStr = NumUtil.formatNum(priceCny, point: 2);
                String changeAmountStr = (rate >= 0 ? '+' : '') + NumUtil.formatNum(change_amount, point: 2);

                return Container(
                  margin: EdgeInsets.only(top: 6),
                  child: Row(
                    children: [
                      Container(
                          height: 15,
                          alignment: Alignment.centerLeft,
                          child: Text(rateStr,
                            style: rate >= 0 ? TextStyles.textGreen_w400_12 : TextStyles.textRed_w400_12,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                      ),
                      Gaps.hGap12,
                      Container(
                          alignment: Alignment.centerLeft,
                          height: 15,
                          child: Text(changeAmountStr,
                            style: rate >= 0 ? TextStyles.textGreen_w400_12 : TextStyles.textRed_w400_12,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                      ),
                      Gaps.hGap12,
                      Container(
                          height: 15,
                          alignment: Alignment.centerLeft,
                          child: Text('≈￥' + priceCnyStr,
                            style: TextStyles.textGray500_w400_12,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                      ),
                    ],
                  ),
                );
              })

        ],
      ),
    );
  }
}

class SpotDetailShareBar extends StatelessWidget {

  final QuoteCoin quoteCoin;
  final NumberSlideController numberSlideController;
  final bool showShadow;

  const SpotDetailShareBar({
    Key key,
    this.quoteCoin,
    this.numberSlideController,
    this.showShadow = true,
  }): super(key: key);


  @override
  Widget build(BuildContext context) {

    double rate = quoteCoin != null ? quoteCoin.change_percent : 0;
    double price = quoteCoin != null ? quoteCoin.quote : 0;
    double priceCny = NumUtil.multiply(price, 6.5);
    double change_amount = quoteCoin != null ? quoteCoin.change_amount : 0;

    String rateStr = (rate >= 0 ? '+' : '') + NumUtil.getNumByValueDouble(rate, 2).toString() + '%';
    String priceStr = NumUtil.formatNum(price, point: 2);
    String priceCnyStr = NumUtil.formatNum(priceCny, point: 2);
    String changeAmountStr = (rate >= 0 ? '+' : '') + NumUtil.formatNum(change_amount, point: 2);

    return Container(
      height: 64,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colours.white,
        boxShadow: !showShadow ? null : BoxShadows.normalBoxShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: EdgeInsets.only(top: 5, right: 10),
              alignment: Alignment.centerLeft,
              height: 27,
              child: Text.rich(TextSpan(
                  children: [
                    TextSpan(text: '\$', style: rate >= 0 ? TextStyles.textGreen_w400_12 : TextStyles.textRed_w400_12),
                    TextSpan(text: priceStr, style: rate >= 0 ? TextStyles.textGreen_w400_22 : TextStyles.textRed_w400_22),
                  ]
              ))
          ),

          Container(
            margin: EdgeInsets.only(top: 6),
            child: Row(
              children: [
                Container(
                    height: 15,
                    alignment: Alignment.centerLeft,
                    child: Text(rateStr,
                      style: rate >= 0 ? TextStyles.textGreen_w400_12 : TextStyles.textRed_w400_12,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                ),
                Gaps.hGap12,
                Container(
                    alignment: Alignment.centerLeft,
                    height: 15,
                    child: Text(changeAmountStr,
                      style: rate >= 0 ? TextStyles.textGreen_w400_12 : TextStyles.textRed_w400_12,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                ),
                Gaps.hGap12,
                Container(
                    height: 15,
                    alignment: Alignment.centerLeft,
                    child: Text('≈￥' + priceCnyStr,
                      style: TextStyles.textGray500_w400_12,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}