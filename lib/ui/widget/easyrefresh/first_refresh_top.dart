import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lighthouse/generated/l10n.dart';
import 'package:lighthouse/res/styles.dart';
import 'package:lighthouse/ui/widget/common_scroll_view.dart';

class FirstRefreshTop extends StatelessWidget {

  final double top;
  const FirstRefreshTop({
    Key key,
    this.top = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonScrollView(children: [
      Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: top),
        width: 60.0,
        height: 60.0,
        child: SpinKitCircle(
          color: Theme.of(context).primaryColor,
          size: 30.0,
        ),
      ),
      Container(
        child: Text(S.of(context).loading, style: TextStyles.textGray400_w400_14),
      )

    ]);
  }
}