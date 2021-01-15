import 'package:flutter/material.dart';
import 'package:lighthouse/generated/l10n.dart';
import 'package:lighthouse/res/styles.dart';
import 'package:lighthouse/ui/widget/common_scroll_view.dart';
import 'package:lighthouse/ui/widget/image/local_image.dart';

class LoadingEmpty extends StatelessWidget {

  final String text;
  final String image;

  const LoadingEmpty({
    Key key,
    this.text,
    this.image
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonScrollView(children: [
      Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 50),
        child: LocalImage('img_nodata', width: 100, height: 100,),
      ),
      Container(
        alignment: Alignment.center,
        child: Text(
          text ?? S.of(context).noData,
          style: TextStyles.textGray400_w400_12,
        ),
      )
    ]);
  }
}