import 'package:flutter/material.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';

class MoneySupportExchangeBar extends StatelessWidget {

  final String days;
  const MoneySupportExchangeBar({
    Key key,
    this.days = '123',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 105,
        color: Colours.white,
        margin: EdgeInsets.only(top: 8, bottom: 16),
        child:
        Column(
            children: <Widget>[
              Container(
                  height: 50.0,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 45,
                        height: 0.6,
                        child: Divider(color: Colours.default_line, height: 0.6),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(S.of(context).supportExchanges,
                          style: TextStyles.textGray500_w400_14,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      SizedBox(
                        width: 45,
                        height: 0.6,
                        child: Divider(color: Colours.default_line, height: 0.6),
                      ),
                    ],
                  )
              ),
              Container(
                  height: 50.0,
                  alignment: Alignment.topCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.shopping_basket, color: Colours.gray_800, size: 26),
                      Gaps.hGap8,
                      Icon(Icons.shopping_basket, color: Colours.gray_800, size: 26),
                      Gaps.hGap8,
                      Icon(Icons.shopping_basket, color: Colours.gray_800, size: 26),
                      Gaps.hGap8,
                      Icon(Icons.shopping_basket, color: Colours.gray_800, size: 26),
                      Gaps.hGap8,
                      Icon(Icons.shopping_basket, color: Colours.gray_800, size: 26),
                      Gaps.hGap8,
                      Icon(Icons.shopping_basket, color: Colours.gray_800, size: 26),
                    ],
                  )
              ),
            ]
        )
    );
  }
}