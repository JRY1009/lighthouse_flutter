
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/net/apis.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/widget/common_scroll_view.dart';
import 'package:library_base/widget/image/local_image.dart';
import 'package:library_base/widget/shot_view.dart';
import 'package:library_base/utils/object_util.dart';
import 'package:library_base/utils/toast_util.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';

class ShareDialog extends StatelessWidget {

  final List<Widget> children;

  ShotController _shotController = new ShotController();

  ShareDialog({
    Key key,
    this.children,
  }) : super(key: key);

  Future<void> _save(BuildContext context) async {
    PermissionStatus status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
      return;
    }

    Uint8List pngBytes = await _shotController.makeImageUint8List();
    final result = await ImageGallerySaver.saveImage(pngBytes);

    if(ObjectUtil.isEmpty(result)){
      ToastUtil.error(S.of(context).saveFailed);
    }else{
      ToastUtil.success(S.of(context).saveSuccess + result['filePath'].replaceAll("file://", ""));
    }

    Navigator.pop(context);
  }

  Future<void> _more(BuildContext context) async {
    if (children == null) {
      Share.share(Apis.URL_OFFICIAL_WEBSITE);

      Navigator.pop(context);

    } else {

      PermissionStatus status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
        return;
      }

      Uint8List pngBytes = await _shotController.makeImageUint8List();
      final result = await ImageGallerySaver.saveImage(pngBytes);

      if(ObjectUtil.isNotEmpty(result)){
        File saveFile = new File(result['filePath'].replaceAll("file://", ""));

        Share.shareFiles([
          saveFile.path
        ]);
      }

      Navigator.pop(context);
    }
  }

  Future<void> _shareWechat(BuildContext context, WeChatScene scene) async {
    bool result = await isWeChatInstalled;
    if (!result) {
      ToastUtil.waring(S.of(context).shareWxNotInstalled);
      return;
    }

    if (children == null) {
      shareToWeChat(WeChatShareWebPageModel(Apis.URL_OFFICIAL_WEBSITE, scene: scene));

      Navigator.pop(context);

    } else {
      
      Uint8List pngBytes = await _shotController.makeImageUint8List();

      shareToWeChat(WeChatShareImageModel(WeChatImage.binary(pngBytes), scene: scene));

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {

    Widget shareWechat = InkWell(
      onTap: () => _shareWechat(context, WeChatScene.SESSION),
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
    );

    Widget shareFriend = InkWell(
      onTap: () => _shareWechat(context, WeChatScene.TIMELINE),
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
    );

    Widget shareSave = InkWell(
      onTap: () => _save(context),
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
    );

    Widget shareMore = InkWell(
      onTap: () => _more(context),
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
    );

    Widget bottom = Container(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        decoration: BoxDecoration(
          color: Colours.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
        ),
        child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: children == null ? [
                shareWechat,
                shareFriend,
                shareMore
              ] : [
                shareWechat,
                shareFriend,
                shareSave,
                shareMore
              ],
            )
        )
    );

    return children == null ? bottom : CommonScrollView(
      padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
      shotController: _shotController,
      children: children,
      bottomButton: bottom,
    );
  }
}
