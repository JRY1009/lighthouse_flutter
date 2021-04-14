

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluwx/fluwx.dart';
import 'package:library_base/constant/constant.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/utils/object_util.dart';
import 'package:library_base/utils/toast_util.dart';
import 'package:library_base/widget/image/local_image.dart';
import 'package:share/share.dart';

class ShareLinkDialog extends StatelessWidget {

  final String title_share;
  final String summary_share;
  final String url_share;
  final String thumb_share;

  ShareLinkDialog({
    Key key,
    this.title_share,
    this.summary_share,
    this.url_share,
    this.thumb_share,
  }) : super(key: key);

  Future<void> _copyLink(BuildContext context) async {

    String content = '$title_share\n${summary_share ?? ''}\n$url_share';
    Clipboard.setData(ClipboardData(text: content));

    ToastUtil.success(S.of(context).copySuccess);

    Navigator.pop(context);
  }

  Future<void> _more(BuildContext context) async {

    String content = '$title_share\n${summary_share ?? ''}\n$url_share';
    Share.share(content);

    Navigator.pop(context);
  }

  Future<void> _shareWechat(BuildContext context, WeChatScene scene) async {
    bool result = await isWeChatInstalled;
    if (!result) {
      ToastUtil.waring(S.of(context).shareWxNotInstalled);
      return;
    }

    shareToWeChat(WeChatShareWebPageModel(url_share,
        title: title_share,
        description: ObjectUtil.isEmpty(summary_share) ? null : summary_share,
        thumbnail: ObjectUtil.isEmpty(thumb_share) ? WeChatImage.asset('assets/images/logo_white.png?package=library_base', suffix: '.png') : WeChatImage.network(thumb_share),
        scene: scene)
    );

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
      onTap: () => _copyLink(context),
      child: Container(
        child: Column(
          children: [
            LocalImage('icon_share_save', package: Constant.baseLib, width: 48, height: 48),
            Gaps.vGap4,
            Text(S.of(context).shareCopyLink,
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
