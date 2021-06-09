import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/widget/common_scroll_view.dart';

class FirstRefreshTop extends StatelessWidget {

  final double top;
  const FirstRefreshTop({
    Key? key,
    this.top = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonScrollView(

        physics: NeverScrollableScrollPhysics(),
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
            alignment: Alignment.center,
            child: Text(S.of(context).loading, style: TextStyles.textGray400_w400_14),
          )

        ]);
  }
}