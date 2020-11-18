
import 'package:flutter/material.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/gaps.dart';
import 'package:lighthouse/res/styles.dart';


class SpotTradePlatformDataItem extends StatelessWidget {

  final int index;

  final String tradePlatform;

  final String price;

  final String rate;


  const SpotTradePlatformDataItem(
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
      height: 55.0,
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 0.6, color: Colours.default_line))
      ),
      child: Row (
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              children: [
                Icon(Icons.fire_extinguisher, color: Colours.text_black, size: 20),
                Gaps.hGap4,
                Text('Huobi',
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
                Text('\$12345.33', style: TextStyles.textGray800_w400_14,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Gaps.vGap3,
                Text('≈￥82345.33', style: TextStyles.textGray500_w400_10,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            width: 70,
            alignment: Alignment.centerRight,
            child: Text('+10.12%', style: TextStyles.textGray800_w400_12,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,),
          ),
        ],
      ),
    );
  }
}
