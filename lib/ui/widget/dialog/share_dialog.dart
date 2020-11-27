import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lighthouse/generated/l10n.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/gaps.dart';
import 'package:lighthouse/res/styles.dart';
import 'package:lighthouse/ui/widget/image/local_image.dart';
import 'package:lighthouse/utils/object_util.dart';
import 'package:lighthouse/utils/toast_util.dart';

class ShareDialog extends StatelessWidget {

  final bool crop;
  final ValueChanged<String> selectCallback;
  final Function viewCallback;

  ShareDialog({
    Key key,
    this.crop = false,
    this.selectCallback,
    this.viewCallback
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        decoration: BoxDecoration(
          color: Colours.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
        ),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                onTap: () => ToastUtil.normal('click 1'),
                child: Container(
                  child: Column(
                    children: [
                      LocalImage('icon_share_wechat', width: 48, height: 48),
                      Gaps.vGap4,
                      Text(S.of(context).shareWechat,
                        style: TextStyles.textGray800_w400_12,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )

                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => ToastUtil.normal('click 2'),
                child: Container(
                  child: Column(
                    children: [
                      LocalImage('icon_share_friend', width: 48, height: 48),
                      Gaps.vGap4,
                      Text(S.of(context).shareFriend,
                        style: TextStyles.textGray800_w400_12,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )

                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => ToastUtil.normal('click 3'),
                child: Container(
                  child: Column(
                    children: [
                      LocalImage('icon_share_save', width: 48, height: 48),
                      Gaps.vGap4,
                      Text(S.of(context).shareSave,
                        style: TextStyles.textGray800_w400_12,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )

                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => ToastUtil.normal('click 4'),
                child: Container(
                  child: Column(
                    children: [
                      LocalImage('icon_share_more', width: 48, height: 48),
                      Gaps.vGap4,
                      Text(S.of(context).shareMore,
                        style: TextStyles.textGray800_w400_12,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )

                    ],
                  ),
                ),
              ),
            ],
          )
        )
    );
  }
}
