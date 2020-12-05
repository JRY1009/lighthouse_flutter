
import 'package:flutter/material.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/gaps.dart';
import 'package:lighthouse/res/styles.dart';


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
              alignment: Alignment.centerLeft,
              child: Text(name ?? '',
                style: TextStyles.textBlack13,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
          ),
          Container(
            margin: EdgeInsets.only(top: 9),
            alignment: Alignment.centerLeft,
            child: Text(price.toString(), style: rate >= 0 ? TextStyles.textRed_w400_14 : TextStyles.textGreen_w400_14,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,),
          ),
          Expanded(child: Container()),
          Container(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text((change >= 0 ? '+' : '') + change.toString(), style: rate >= 0 ? TextStyles.textRed_w400_10 : TextStyles.textGreen_w400_10,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Gaps.hGap10,
                Expanded(
                  child: Text((rate >= 0 ? '+' : '') + rate.toString() + '%', style: rate >= 0 ? TextStyles.textRed_w400_10 : TextStyles.textGreen_w400_10,
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
