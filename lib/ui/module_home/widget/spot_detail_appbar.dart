
import 'package:flutter/material.dart';
import 'package:lighthouse/generated/l10n.dart';
import 'package:lighthouse/net/model/quote_basic.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/styles.dart';
import 'package:lighthouse/utils/num_util.dart';

class SpotDetailAppbar extends StatefulWidget {

  final QuoteBasic quoteBasic;
  final bool showShadow;
  final VoidCallback onPressed;

  const SpotDetailAppbar({
    Key key,
    this.quoteBasic,
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

    double rate = widget.quoteBasic != null ? widget.quoteBasic.change_percent : 0;
    double price = widget.quoteBasic != null ? widget.quoteBasic.quote : 0;
    double priceCny = NumUtil.multiply(price, 6.5);
    double change_amount = widget.quoteBasic != null ? widget.quoteBasic.change_amount : 0;
    double amount_24h = widget.quoteBasic != null ? widget.quoteBasic.amount_24h : 0;
    double vol_24h = widget.quoteBasic != null ? widget.quoteBasic.vol_24h : 0;

    String coin_code = widget.quoteBasic != null ? widget.quoteBasic.coin_code : '';
    String rateStr = (rate >= 0 ? '+' : '') + NumUtil.getNumByValueDouble(rate, 2).toString() + '%';
    String priceStr = NumUtil.getNumByValueDouble(price, 2).toString();
    String priceCnyStr = NumUtil.getNumByValueDouble(priceCny, 2).toString();
    String changeAmountStr = (rate >= 0 ? '+' : '') + NumUtil.getNumByValueDouble(change_amount, 2).toString();
    String amount24Str = NumUtil.getBigVolumFormat(amount_24h, fractionDigits: 2).toString();
    String vol24Str = NumUtil.getBigVolumFormat(vol_24h, fractionDigits: 2).toString();

    return Container(
      height: 64,
      padding: EdgeInsets.symmetric(horizontal: 12),
      margin: EdgeInsets.only(bottom: 9),
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
                  child: Text.rich(TextSpan(
                      children: [
                        TextSpan(text: '\$', style: rate >= 0 ? TextStyles.textGreen_w400_12 : TextStyles.textRed_w400_12),
                        TextSpan(text: priceStr, style: rate >= 0 ? TextStyles.textGreen_w400_22 : TextStyles.textRed_w400_22),
                        WidgetSpan(
                          child: Icon(rate >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                              color: rate >= 0 ? Colours.text_green : Colours.text_red,
                              size: 14)
                        )
                      ]
                  ))
              ),
              Container(
                  margin: EdgeInsets.only(top: 5),
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
                  alignment: Alignment.centerLeft,
                  child: Text(rateStr,
                    style: rate >= 0 ? TextStyles.textGreen_w400_12 : TextStyles.textRed_w400_12,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
              ),
              Container(
                  margin: EdgeInsets.only(top: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(changeAmountStr,
                    style: rate >= 0 ? TextStyles.textGreen_w400_12 : TextStyles.textRed_w400_12,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
              ),
            ],
          ),
          Expanded(
            child: Container(),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  alignment: Alignment.centerRight,
                  height: 20,
                  child: Text(S.of(context).pro24hAmount,
                    style: TextStyles.textGray400_w400_12,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
              ),
              Container(
                  margin: EdgeInsets.only(top: 8),
                  alignment: Alignment.centerRight,
                  height: 20,
                  child: Text(S.of(context).pro24hVolume,
                    style: TextStyles.textGray400_w400_12,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
              ),
            ],
          ),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    alignment: Alignment.centerLeft,
                    height: 20,
                    child: Text('\$' + amount24Str,
                      style: TextStyles.textGray800_w400_12,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                ),
                Container(
                    margin: EdgeInsets.only(top: 8),
                    alignment: Alignment.centerLeft,
                    height: 20,
                    child: Text(vol24Str + coin_code,
                      style: TextStyles.textGray800_w400_12,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
