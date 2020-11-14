
import 'package:flutter/material.dart';
import 'package:lighthouse/generated/l10n.dart';
import 'package:lighthouse/net/model/account.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/gaps.dart';
import 'package:lighthouse/res/styles.dart';
import 'package:lighthouse/ui/widget/appbar/home_flexible_tabview.dart';
import 'package:lighthouse/ui/widget/tab/bubble_indicator.dart';
import 'package:lighthouse/ui/widget/tab/quotation_tab.dart';
import 'package:lighthouse/utils/image_util.dart';
import 'package:lighthouse/utils/screen_util.dart';

class HomePinnedAppBar extends StatefulWidget {

  final double appBarOpacity;
  final double height;

  const HomePinnedAppBar({
    Key key,
    @required this.appBarOpacity,
    @required this.height,
  }): super(key: key);


  @override
  _HomePinnedAppBarState createState() => _HomePinnedAppBarState();
}

class _HomePinnedAppBarState extends State<HomePinnedAppBar> {

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

    return Opacity(
      opacity: widget.appBarOpacity,
      child: Container(
        padding: EdgeInsets.only(top: ScreenUtil.getStatusBarH(context) + 10),
        height: widget.height,
        decoration: BoxDecoration(
          color: Colours.white,
          boxShadow: BoxShadows.normalBoxShadow,
        ),
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 24),
                        alignment: Alignment.centerLeft,
                        child: Text('BTC/USD', style: TextStyles.textGray800_w400_15,
                        )),
                    Gaps.vGap5,
                    Container(
                        margin: EdgeInsets.only(left: 24),
                        alignment: Alignment.centerLeft,
                        child: Text('12321.92  1.21%', style: TextStyles.textGray400_w400_12,
                        )),
                  ],)
            ),
            Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        child: Text('ETH/USD', style: TextStyles.textGray800_w400_15,)
                    ),
                    Gaps.vGap5,
                    Container(
                        alignment: Alignment.centerLeft,
                        child: Text('12321.92  1.21%', style: TextStyles.textGray400_w400_12,)
                    ),
                  ],)
            ),
          ],
        ),
      ),
    );
  }
}
