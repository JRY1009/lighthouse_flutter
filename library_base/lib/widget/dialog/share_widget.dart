
import 'package:flutter/material.dart';
import 'package:library_base/constant/constant.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/net/apis.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/widget/image/local_image.dart';
import 'package:library_base/utils/image_util.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ShareQRHeader extends StatelessWidget {

  ShareQRHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 72,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colours.white,
        //borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LocalImage('logo', width: 44, height: 44, package: Constant.baseLib),
          Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(S.of(context).appName + '·' + S.of(context).slogan,
                      style: TextStyles.textGray800_w600_14,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Gaps.vGap6,
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
            data: Apis.URL_OFFICIAL_WEBSITE,
            version: QrVersions.auto,
            padding: EdgeInsets.all(0),
            size: 50.0,
          ),
        ],
      ),
    );
  }
}

class ShareQRFoooter extends StatelessWidget {

  final Color? backgroundColor;

  ShareQRFoooter({
    Key? key,
    this.backgroundColor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 100,
      color: backgroundColor ?? Colours.white,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          LocalImage('logo', width: 44, height: 44, package: Constant.baseLib),
          Expanded(
              child: Container(
                height: 44,
                margin: EdgeInsets.only(left: 8),
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      alignment: Alignment.centerLeft,
                      child: Text(S.of(context).appName + '·' + S.of(context).slogan,
                        style: TextStyles.textGray800_w600_14,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      height: 20,
                      alignment: Alignment.centerLeft,
                      child: Text(S.of(context).shareQRDownload,
                        style: TextStyles.textGray400_w400_12,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              )
          ),
          QrImage(
            data: Apis.URL_OFFICIAL_WEBSITE,
            version: QrVersions.auto,
            padding: EdgeInsets.all(0),
            size: 64.0,
          ),
        ],
      ),
    );
  }
}


class ShareNewsHeader extends StatelessWidget {

  ShareNewsHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 104,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 21, vertical: 10),
      decoration: BoxDecoration(
        color: Colours.gray_100,
        image: DecorationImage(
          image: AssetImage(ImageUtil.getImgPath('bg_home'), package: Constant.baseLib),
          fit: BoxFit.fill,
        ),
        //borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 26,
                  alignment: Alignment.bottomLeft,
                  child: Text.rich(TextSpan(
                      children: [
                        TextSpan(text: S.of(context).appName, style: TextStyles.textWhite20_w700),
                        TextSpan(text: ' · ' + S.of(context).x724, style: TextStyles.textWhite20),
                      ]
                  )),
                ),
                Container(
                  height: 26,
                  padding: EdgeInsets.only(left: 2),
                  alignment: Alignment.center,
                  child: Text(Apis.URL_DISPLAY_WEBSITE,
                    style: TextStyles.textWhite12,
                  ),
                )

              ],
            ),
          )
        ],
      ),
    );
  }
}