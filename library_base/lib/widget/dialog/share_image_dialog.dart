
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:library_base/constant/constant.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/utils/device_util.dart';
import 'package:library_base/utils/object_util.dart';
import 'package:library_base/utils/path_util.dart';
import 'package:library_base/utils/toast_util.dart';
import 'package:library_base/widget/dialog/loading_center_dialog.dart';
import 'package:library_base/widget/image/local_image.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';

class ShareImageDialog extends StatelessWidget {

  final String imgUrl;

  ShareImageDialog({
    Key key,
    this.imgUrl,
  }) : super(key: key);

  bool _isShowDialog = false;

  void showProgress(BuildContext context, {String content, bool showContent = true}) {
    /// 避免重复弹出
    if (!_isShowDialog) {
      _isShowDialog = true;
      try {
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          barrierColor: const Color(0x00FFFFFF), // 默认dialog背景色为半透明黑色，这里修改为透明（1.20添加属性）
          builder:(_) {
            return WillPopScope(
              onWillPop: () async {
                // 拦截到返回键，证明dialog被手动关闭
                _isShowDialog = false;
                return Future.value(true);
              },
              child: LoadingCenterDialog(
                  content: S.of(context).saving
              ),
            );
          },
        );
      } catch(e) {
        /// 异常原因主要是页面没有build完成就调用Progress。
        print(e);
      }
    }
  }
  void closeProgress(BuildContext context) {
    if (_isShowDialog) {
      _isShowDialog = false;

      FocusManager.instance.primaryFocus?.unfocus();
      Navigator.pop(context);
    }
  }

  Future<void> _save(BuildContext context) async {
    PermissionStatus status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
      return;
    }

    showProgress(context);
    var response = await Dio().get(imgUrl, options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));

    closeProgress(context);

    if (ObjectUtil.isEmpty(result)){
      ToastUtil.error(S.of(context).saveFailed);
    } else{
      String suffix = result['filePath'] != null ? result['filePath']?.replaceAll("file://", "") : '';
      ToastUtil.success(S.of(context).saveSuccess + suffix);
    }

    Navigator.pop(context);
  }

  Future<void> _more(BuildContext context) async {
      PermissionStatus status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
        return;
      }

      showProgress(context);
      var response = await Dio().get(imgUrl, options: Options(responseType: ResponseType.bytes));
      Uint8List pngBytes = Uint8List.fromList(response.data);

      if (DeviceUtil.isAndroid) {

        final result = await ImageGallerySaver.saveImage(pngBytes);

        closeProgress(context);

        if(ObjectUtil.isNotEmpty(result)){
          File saveFile = new File(result['filePath']?.replaceAll("file://", ""));
          Share.shareFiles([
            saveFile.path
          ]);
        }

      } else if (DeviceUtil.isIOS) {
        String docPath = await PathUtils.getDocumentsDirPath();
        bool isDirExist = await Directory(docPath).exists();
        if (!isDirExist) Directory(docPath).create();

        File saveFile = await File(docPath + "/${DateTime.now().toIso8601String()}.jpg").writeAsBytes(pngBytes);

        closeProgress(context);

        Share.shareFiles([
          saveFile.path
        ]);
      }

      Navigator.pop(context);
  }

  Future<void> _shareWechat(BuildContext context, WeChatScene scene) async {
    bool result = await isWeChatInstalled;
    if (!result) {
      ToastUtil.waring(S.of(context).shareWxNotInstalled);
      return;
    }

    shareToWeChat(WeChatShareImageModel(WeChatImage.network(imgUrl), scene: scene));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    Widget shareWechat = InkWell(
      onTap: () => _shareWechat(context, WeChatScene.SESSION),
      child: Container(
        child: Column(
          children: [
            LocalImage('icon_share_wechat', package: Constant.baseLib, width: 48, height: 48),
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
            LocalImage('icon_share_friend', package: Constant.baseLib, width: 48, height: 48),
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
            LocalImage('icon_share_save', package: Constant.baseLib, width: 48, height: 48),
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
            LocalImage('icon_share_more', package: Constant.baseLib, width: 48, height: 48),
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
        decoration: BoxDecoration(
          color: Colours.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 10),
              child:
              IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      shareWechat,
                      shareFriend,
                      shareSave,
                      shareMore
                    ],
                  )
              ),
            ),
            TextButton(
                onPressed: () => Navigator.pop(context),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colours.white),
                  padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0)))),
                ),
                child: Container(
                    alignment: Alignment.center,
                    height: 56.0,
                    width: double.infinity,
                    child: Text(S.of(context).cancel,
                      style: TextStyles.textGray800_w400_16,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                )
            ),
          ],
        )
    );

    return bottom;
  }
}
