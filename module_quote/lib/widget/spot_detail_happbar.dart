
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:library_base/constant/constant.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/model/quote_coin.dart';
import 'package:library_base/mvvm/provider_widget.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/utils/num_util.dart';
import 'package:library_base/widget/image/local_image.dart';
import 'package:library_base/widget/text/number_slide_animation.dart';
import 'package:module_quote/viewmodel/spot_detail_model.dart';
import 'package:provider/provider.dart';

class SpotDetailHAppbar extends StatefulWidget {

  final QuoteCoin quoteCoin;
  final NumberSlideController numberSlideController;
  final bool showShadow;

  const SpotDetailHAppbar({
    Key key,
    this.quoteCoin,
    this.numberSlideController,
    this.showShadow = true,
  }): super(key: key);


  @override
  _SpotDetailHAppbarState createState() => _SpotDetailHAppbarState();
}

class _SpotDetailHAppbarState extends State<SpotDetailHAppbar>{

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

    num rate = widget.quoteCoin != null ? widget.quoteCoin.change_percent : 0;
    num price = widget.quoteCoin != null ? widget.quoteCoin.quote : 0;
    num priceCny = NumUtil.multiply(price, 6.5);
    num change_amount = widget.quoteCoin != null ? widget.quoteCoin.change_amount : 0;

    String coin_code = widget?.quoteCoin?.coin_code ?? '';
    String coin_name = widget?.quoteCoin?.coin_name ?? '';
    String pair = widget?.quoteCoin?.pair ?? '';
    String rateStr = (rate >= 0 ? '+' : '') + NumUtil.getNumByValueDouble(rate, 2).toString() + '%';
    String priceStr = NumUtil.formatNum(price, point: 2);
    String priceCnyStr = NumUtil.formatNum(priceCny, point: 2);
    String changeAmountStr = (change_amount >= 0 ? '+' : '') + NumUtil.formatNum(change_amount, point: 2);

    return Container(
        height: 31,
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colours.white,
          boxShadow: !widget.showShadow ? null : BoxShadows.normalBoxShadow,
            border: Border(bottom: BorderSide(width: 0.6, color: Colours.default_line))
        ),
        child: Row(
          children: [
            Container(
                alignment: Alignment.centerLeft,
                height: 20,
                child: Row(
                    children: [
                      Container(
                          margin: EdgeInsets.only(right: 10),
                          alignment: Alignment.centerLeft,
                          height: 20,
                          child: Text(pair,
                            style: TextStyles.textGray800_w600_16,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                      ),
                    ]
                )
            ),

            Container(
                margin: EdgeInsets.only(right: 10),
                alignment: Alignment.centerLeft,
                height: 20,
                child: Text.rich(TextSpan(
                    children: [
                      TextSpan(text: '\$', style: rate >= 0 ? TextStyles.textGreen_w400_9 : TextStyles.textRed_w400_9),
                      //TextSpan(text: priceStr, style: rate >= 0 ? TextStyles.textGreen_w400_22 : TextStyles.textRed_w400_22),
                      WidgetSpan(
                        child: NumberSlide(
                            controller: widget.numberSlideController,
                            initialNumber: priceStr,
                            textStyle: rate >= 0 ? TextStyles.textGreen_w400_16 : TextStyles.textRed_w400_16
                        ),
                      ),
                      TextSpan(text: ' ', style: TextStyle(fontSize: 11)),
                      WidgetSpan(
                          child: rate >= 0 ?
                          LocalImage('arrow_up', package: Constant.baseLib, width: 10, height: 10) :
                          LocalImage('arrow_down', package: Constant.baseLib, width: 10, height: 10)
                      )
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
                  String changeAmountStr = (change_amount >= 0 ? '+' : '') + NumUtil.formatNum(change_amount, point: 2);

                  return Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Container(
                            height: 14,
                            alignment: Alignment.centerLeft,
                            child: Text(rateStr,
                              style: rate >= 0 ? TextStyles.textGreen_w400_9 : TextStyles.textRed_w400_9,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                        ),
                        Gaps.hGap12,
                        Container(
                            alignment: Alignment.centerLeft,
                            height: 14,
                            child: Text(changeAmountStr,
                              style: change_amount >= 0 ? TextStyles.textGreen_w400_9 : TextStyles.textRed_w400_9,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                        ),
                        Gaps.hGap12,
                        Container(
                            height: 14,
                            alignment: Alignment.centerLeft,
                            child: Text('≈￥' + priceCnyStr,
                              style: TextStyles.textGray800_w400_9,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                        ),
                      ],
                    ),
                  );
                }),

            Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                          padding: EdgeInsets.all(8),
                          child: LocalImage('icon_zoom_out', package: Constant.moduleQuote, width: 12, height: 12)
                      )
                  ),
                )
            )
          ],
        )
    );
  }
}
