
import 'package:flutter/material.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';


class GlobalQuoteRoundItem extends StatelessWidget {

  final int index;

  final String name;

  final double posX;

  final double posY;

  final double rate;


  const GlobalQuoteRoundItem(
      {Key key,
        this.index,
        this.name,
        this.posX,
        this.posY,
        this.rate,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: posX,
      top: posY,
      child: Container(
        height: 50.0,
        width: 50.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0),   //圆角
            color: rate >= 0 ? Colours.text_red : Colours.text_green
        ),
        child: Column (
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                height: 14,
                alignment: Alignment.center,
                child: Text(name ?? '',
                  style: TextStyles.textWhite11,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
            ),
            Container(
              height: 10,
              alignment: Alignment.center,
              child: Text((rate >= 0 ? '+' : '') + rate.toString() + '%', style: TextStyles.textWhite9,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
