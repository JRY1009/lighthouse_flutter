
import 'package:flutter/material.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/widget/dialog/avatar_select_dialog.dart';
import 'package:library_base/widget/dialog/cupertino_alert_dialog.dart';
import 'package:library_base/widget/dialog/share_dialog.dart';
import 'package:library_base/widget/dialog/share_link_dialog.dart';
import 'package:library_base/utils/object_util.dart';

class DialogUtil {

  static void showCupertinoAlertDialog(BuildContext context,
      {String title, String content, String cancel, String confirm, Function cancelPressed, Function confirmPressed}) {

    List<Widget> actions = [];
    if (ObjectUtil.isNotEmpty(cancel)) {
      actions.add(CupertinoDialogAction(
          child: Text(cancel, style: TextStyle(fontSize: 17, color: Colours.gray_500)),
          onPressed: cancelPressed
      ));
    }

    if (ObjectUtil.isNotEmpty(confirm)) {
      actions.add(CupertinoDialogAction(
          child: Text(confirm, style: TextStyle(fontSize: 17, color: Colours.app_main)),
          onPressed: confirmPressed
      ));
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
              title: ObjectUtil.isEmpty(title) ? null : Text(title, style: TextStyle(fontSize: 17, color: Colours.gray_800)),
              content: ObjectUtil.isEmpty(content) ? null : Container(
                margin: EdgeInsets.only(top: 10, bottom: 5),
                child: Text(content, style: TextStyle(fontSize: 13, color: Colours.gray_800)),
              ),
              actions: actions
          );
        });
  }

  static void showAvatarSelectDialog(BuildContext context,
      {bool crop, ValueChanged<String> selectCallback, Function viewCallback}) {

    showModalBottomSheet(
        context: context,
        backgroundColor: Colours.transparent,
        builder: (context) {
          return AvatarSelectDialog(
              crop: crop,
              selectCallback: selectCallback,
              viewCallback: viewCallback,
          );
        });
  }

  static void showShareDialog(BuildContext context, {List<Widget> children}) {

    showModalBottomSheet(
        context: context,
        isScrollControlled: children != null,
        backgroundColor: Colours.transparent,
        builder: (context) {
          return ShareDialog(
            children: children,
          );
        });
  }

  static void showShareLinkDialog(BuildContext context, {String title_share,
    String summary_share,
    String url_share,
    String thumb_share,}) {

    showModalBottomSheet(
        context: context,
        isScrollControlled: false,
        backgroundColor: Colours.transparent,
        builder: (context) {
          return ShareLinkDialog(
            title_share: title_share,
            summary_share: summary_share,
            url_share: url_share,
            thumb_share: thumb_share,
          );
        });
  }
}