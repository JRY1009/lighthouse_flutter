import 'package:flutter/material.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';

class MoneyAppbar extends StatelessWidget {

  final String days;
  const MoneyAppbar({
    Key? key,
    this.days = '123',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(  //占满
            height: 90,
            padding: EdgeInsets.symmetric(horizontal: 12),
            color: Colours.transparent,
            child: Column(
                children: [
                  Gaps.vGap24,
                  Container(
                    height: 30,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 10),
                    child: Text(S.of(context).myMoney, style: TextStyles.textGray800_w400_24),
                  ),
                  Gaps.vGap5,
                  Container(
                    height: 20,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 10),
                    child: Text(S.of(context).becomeUserDays(days), style: TextStyles.textGray800_w400_15),
                  ),
                ]
            )
        ),

        Positioned(
          top: 24,
          right: 5,
          child: IconButton(
            onPressed: (){},
            padding: EdgeInsets.only(right: 10, top: 0, left: 10, bottom: 20),
            icon: Icon(Icons.settings_outlined, color: Colours.gray_350, size: 24),
          ),
        ),

      ],
    );
  }
}