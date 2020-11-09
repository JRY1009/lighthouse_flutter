import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lighthouse/generated/l10n.dart';
import 'package:lighthouse/res/styles.dart';

class FirstRefresh extends StatelessWidget {

  const FirstRefresh({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 60.0,
            height: 60.0,
            child: SpinKitCircle(
              color: Theme.of(context).primaryColor,
              size: 30.0,
            ),
          ),
          Container(
            child: Text(S.of(context).loading, style: TextStyles.textGray14),
          )
        ],
      ),);
  }
}