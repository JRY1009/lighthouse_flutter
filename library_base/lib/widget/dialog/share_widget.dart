
import 'package:flutter/material.dart';
import 'package:library_base/constant/constant.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/widget/image/local_image.dart';
import 'package:library_base/utils/image_util.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ShareQRHeader extends StatelessWidget {

  ShareQRHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 72,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colours.white,
        //borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LocalImage('logo', width: 48, height: 48),
          Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(S.of(context).appName + '·' + S.of(context).slogan,
                      style: TextStyles.textGray800_w400_14,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Gaps.vGap3,
                    Text(S.of(context).shareQRDownload,
                      style: TextStyles.textGray400_w400_12,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              )
          ),
          QrImage(
            data: "https://www.baidu.com",
            version: QrVersions.auto,
            padding: EdgeInsets.all(0),
            size: 44.0,
          ),
        ],
      ),
    );
  }
}

class ShareQRFoooter extends StatelessWidget {

  ShareQRFoooter({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 72,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colours.white,
        //borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(S.of(context).appName + '·' + S.of(context).slogan,
                      style: TextStyles.textGray400_w400_12,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Gaps.vGap5,
                    Text(S.of(context).shareQRDownload,
                      style: TextStyles.textGray400_w400_12,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              )
          ),
          QrImage(
            data: "https://www.baidu.com",
            version: QrVersions.auto,
            padding: EdgeInsets.all(0),
            size: 44.0,
          ),
        ],
      ),
    );
  }
}


class ShareNewsHeader extends StatelessWidget {

  ShareNewsHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 92,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colours.gray_100,
        image: DecorationImage(
          image: AssetImage(ImageUtil.getImgPath('bg_share_news'), package: Constant.baseLib),
          fit: BoxFit.fill,
        ),
        //borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          LocalImage('logo', width: 48, height: 48, package: Constant.baseLib),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(S.of(context).appName,
                  style: TextStyles.textGray800_w400_16,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Gaps.vGap5,
                Text(S.of(context).info + '·' + S.of(context).x724,
                  style: TextStyles.textGray400_w400_12,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}