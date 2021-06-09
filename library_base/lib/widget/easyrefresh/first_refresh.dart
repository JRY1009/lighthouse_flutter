import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/styles.dart';

class FirstRefresh extends StatelessWidget {

  const FirstRefresh({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: SizedBox(),
            flex: 2,
          ),
          SizedBox(
            width: 60.0,
            height: 60.0,
            child: SpinKitCircle(
              color: Theme.of(context).primaryColor,
              size: 30.0,
            ),
          ),
          Text(S.of(context).loading,
              style: TextStyle(
                  color: Colours.gray_400,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  height: 1.0,
                  decoration: TextDecoration.none
          )),
          Expanded(
            child: SizedBox(),
            flex: 3,
          ),
        ],
      ),);
  }
}