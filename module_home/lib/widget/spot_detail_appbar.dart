
import 'package:flutter/material.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/utils/num_util.dart';
import 'package:module_home/model/quote_coin.dart';

class SpotDetailAppbar extends StatefulWidget {

  final QuoteCoin quoteCoin;
  final bool showShadow;
  final VoidCallback onPressed;

  const SpotDetailAppbar({
    Key key,
    this.quoteCoin,
    this.showShadow = true,
    this.onPressed,
  }): super(key: key);


  @override
  _SpotDetailAppbarState createState() => _SpotDetailAppbarState();
}

class _SpotDetailAppbarState extends State<SpotDetailAppbar> with AutomaticKeepAliveClientMixin<SpotDetailAppbar>, SingleTickerProviderStateMixin{

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
  Widget build(BuildContext context) {

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
      child: Row (
        children: [
          Column(
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
//                        WidgetSpan(
//                            child: Icon(rate >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
//                                color: rate >= 0 ? Colours.text_green : Colours.text_red,
//                                size: 14)
//                        )
                      ]
                  ))
              ),
              Container(
                  margin: EdgeInsets.only(top: 2),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.only(top: 10),
                  height: 15,
                  alignment: Alignment.centerLeft,
                  child: Text(rateStr,
                    style: rate >= 0 ? TextStyles.textGreen_w400_12 : TextStyles.textRed_w400_12,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
              ),
              Container(
                  margin: EdgeInsets.only(top: 6),
                  alignment: Alignment.centerLeft,
                  height: 15,
                  child: Text(changeAmountStr,
                    style: rate >= 0 ? TextStyles.textGreen_w400_12 : TextStyles.textRed_w400_12,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
              ),
            ],
          ),

          Expanded(
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.only(top: 10),
                    alignment: Alignment.centerRight,
                    height: 15,
                    child: Text(S.of(context).pro24hAmount,
                      style: TextStyles.textGray400_w400_12,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                ),
                Container(
                    margin: EdgeInsets.only(top: 6),
                    alignment: Alignment.centerRight,
                    height: 15,
                    child: Text(S.of(context).pro24hVolume,
                      style: TextStyles.textGray400_w400_12,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 5),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                      margin: EdgeInsets.only(top: 10),
                      alignment: Alignment.centerLeft,
                      height: 15,
                      child: Text('\$' + amount24Str,
                        style: TextStyles.textGray800_w400_12,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 6),
                      alignment: Alignment.centerLeft,
                      height: 15,
                      child: Text(vol24Str + coin_code,
                        style: TextStyles.textGray800_w400_12,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                  ),
                ],
              ),
            ),
          ),


        ],
      ),
    );
  }
}
