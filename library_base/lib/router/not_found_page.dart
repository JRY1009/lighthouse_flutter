import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/styles.dart';

class NotFoundPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("404",
                    style: TextStyle(
                        color: Colours.gray_500,
                        fontSize: 35,
                        fontWeight: FontWeight.w800)),
                Container(
                  margin: EdgeInsets.only(top: 16),
                  child: Text(S.of(context).notFoundPage, style: TextStyles.textGray500_w400_14),
                )
              ],
            ),
          ),
        ));
  }
}
