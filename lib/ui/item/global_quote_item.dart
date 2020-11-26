
import 'package:flutter/material.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/gaps.dart';
import 'package:lighthouse/res/styles.dart';


class GlobalQuoteItem extends StatelessWidget {

  final int index;

  final String tradePlatform;

  final String price;

  final String rate;


  const GlobalQuoteItem(
      {Key key,
        this.index,
        this.tradePlatform,
        this.price,
        this.rate,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 107.0,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 13),
      decoration: BoxDecoration(
          border: Border.all(color: Colours.gray_200, width: 1.0),
          borderRadius: BorderRadius.circular(8.0),   //圆角
      ),
      child: Column (
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text('BTC/USDT',
              style: TextStyles.textBlack13,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          ),
          Container(
            margin: EdgeInsets.only(top: 9),
            alignment: Alignment.centerLeft,
            child: Text('\$12332.12', style: TextStyles.textRed_w400_14,
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
                Text('+123.33', style: TextStyles.textRed_w400_10,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Gaps.hGap10,
                Text('+10.01%', style: TextStyles.textRed_w400_10,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
