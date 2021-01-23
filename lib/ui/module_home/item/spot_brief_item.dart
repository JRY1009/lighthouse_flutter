
import 'package:flutter/material.dart';
import 'package:lighthouse/generated/l10n.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/styles.dart';
import 'package:lighthouse/ui/module_base/widget/dialog/dialog_util.dart';


class SpotBriefItem extends StatelessWidget {

  final int index;

  final String title;

  final String subTitle;

  final String detailInfo;

  final int type;

  const SpotBriefItem(
      {Key key,
        this.index,
        this.title,
        this.subTitle,
        this.detailInfo,
        this.type,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return type == 2 ? Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: 15, right: 16),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(top: 18),
              child: Text(title,
                style: TextStyles.textGray800_w400_15,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.symmetric(vertical: 15),
              child: Text(subTitle ?? '',
                style: TextStyles.textGray400_w400_14,
                strutStyle: StrutStyle(forceStrutHeight: true, height:1, leading: 0.5),
              ),
            )
          ],
        )
    ) : Container(
        height: 40.0,
        width: double.infinity,
        padding: EdgeInsets.only(left: 15, right: 16),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 5),
              child: Text(title,
                style: TextStyles.textGray400_w400_14,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            type == 3 ? InkWell(
              onTap: () => DialogUtil.showCupertinoAlertDialog(context,
                  title: title,
                  content: subTitle,
                  confirm: S.of(context).confirm,
                  confirmPressed: () => Navigator.of(context).pop()
              ),
              child: Icon(Icons.info_outline, color: Colours.gray_400, size: 20),
            ) : Container(),
            Expanded(child: Container(
              padding: EdgeInsets.only(right: 5),
              alignment: Alignment.centerRight,
              child: Text(subTitle ?? '',
                style: TextStyles.textGray800_w400_14,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ))

          ],
        )
    );
  }
}
