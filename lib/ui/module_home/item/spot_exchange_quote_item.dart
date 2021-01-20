
import 'package:flutter/material.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/gaps.dart';
import 'package:lighthouse/res/styles.dart';
import 'package:lighthouse/utils/num_util.dart';


class SpotExchangeQuoteItem extends StatelessWidget {

  final int index;

  final String tradePlatform;

  final double price;

  final double cny;

  final double rate;


  const SpotExchangeQuoteItem(
      {Key key,
        this.index,
        this.tradePlatform,
        this.price,
        this.cny,
        this.rate,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    String rateStr = (rate >= 0 ? '+' : '') + NumUtil.getNumByValueDouble(rate, 2).toString() + '%';
    String priceStr = NumUtil.getNumByValueDouble(price, 2).toString();
    String cnyStr = NumUtil.getNumByValueDouble(cny, 2).toString();

    return Container(
      height: 55.0,
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 0.6, color: Colours.default_line))
      ),
      child: Row (
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 100,
            child: Row(
              children: [
                Icon(Icons.fire_extinguisher, color: Colours.text_black, size: 20),
                Gaps.hGap4,
                Text(tradePlatform,
                  style: TextStyles.textGray800_w400_12,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
          Container(
            width: 90,
            alignment: Alignment.centerRight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('\$' + priceStr,
                  style: rate >= 0 ? TextStyles.textGreen_w400_14 : TextStyles.textRed_w400_14,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Gaps.vGap3,
                Text('≈￥' + cnyStr, style: TextStyles.textGray500_w400_10,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            width: 70,
            alignment: Alignment.centerRight,
            child: Text(rateStr,
              style: rate >= 0 ? TextStyles.textGreen_w400_12 : TextStyles.textRed_w400_12,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,),
          ),
        ],
      ),
    );
  }
}
