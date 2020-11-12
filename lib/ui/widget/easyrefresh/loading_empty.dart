import 'package:flutter/material.dart';
import 'package:lighthouse/generated/l10n.dart';
import 'package:lighthouse/res/styles.dart';
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
    return Container(
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: SizedBox(),
            flex: 2,
          ),
          SizedBox(
            width: 100.0,
            height: 100.0,
            child: LocalImage(image ?? 'img_nodata'),
          ),
          Text(
            text ?? S.of(context).noData,
            style: TextStyles.textGray14,
          ),
          Expanded(
            child: SizedBox(),
            flex: 3,
          ),
        ],
      ),
    );
  }
}