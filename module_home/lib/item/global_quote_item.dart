
import 'package:flutter/material.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/utils/num_util.dart';


class GlobalQuoteItem extends StatelessWidget {

  final int index;

  final String name;

  final double price;

  final double change;

  final double rate;


  const GlobalQuoteItem(
      {Key key,
        this.index,
        this.name,
        this.price,
        this.change,
        this.rate,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    String rateStr = (rate >= 0 ? '+' : '') + NumUtil.getNumByValueDouble(rate, 2).toString() + '%';

    String priceStr = NumUtil.formatNum(price, point: 2);
    String changeStr = NumUtil.formatNum(change, point: 2);

    return Container(
      height: 107.0,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(12, 13, 0, 13),
      decoration: BoxDecoration(
        border: Border.all(color: Colours.gray_200, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),   //圆角
      ),
      child: Column (
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              height: 16,
              alignment: Alignment.centerLeft,
              child: Text(name ?? '',
                style: TextStyles.textGray800_w700_13,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
          ),
          Container(
            height: 17,
            margin: EdgeInsets.only(top: 7),
            alignment: Alignment.centerLeft,
            child: Text(priceStr, style: rate >= 0 ? TextStyles.textGreen_w600_14 : TextStyles.textRed_w600_14,
              maxLines: 1,
              overflow: TextOverflow.ellipsis
            ),
          ),
          Expanded(child: Container()),
          Container(
            height: 30,
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text((change >= 0 ? '+' : '') + changeStr, style: rate >= 0 ? TextStyles.textGreen_w400_10 : TextStyles.textRed_w400_10,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Gaps.vGap5,
                Expanded(
                  child: Text(rateStr, style: rate >= 0 ? TextStyles.textGreen_w400_10 : TextStyles.textRed_w400_10,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
