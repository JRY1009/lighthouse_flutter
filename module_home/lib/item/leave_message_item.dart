import 'package:flutter/material.dart';
import 'package:library_base/constant/constant.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/router/parameters.dart';
import 'package:library_base/router/routers.dart';
import 'package:library_base/utils/image_util.dart';
import 'package:library_base/widget/dialog/dialog_util.dart';
import 'package:library_base/widget/dialog/share_widget.dart';
import 'package:library_base/widget/image/circle_image.dart';
import 'package:library_base/widget/image/local_image.dart';
import 'package:module_home/model/leave_message.dart';

/// 资讯列表详情
class LeaveMessageItem extends StatelessWidget {

  final LeaveMessage lvMessage;
  final EdgeInsetsGeometry margin;
  final bool share;

  const LeaveMessageItem(
      {Key key,
        this.lvMessage,
        this.margin,
        this.share = false
      })
      : super(key: key);

  Future<void> _share(BuildContext context) async {

    DialogUtil.showShareDialog(context,
        children: [
          Container(
            color: Colours.white,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                  child: Container(
                    width: double.infinity,
                    height: 232,
                    margin: margin,
                    child: AspectRatio(
                      aspectRatio: 1.5,
                      child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 15),
                          decoration: BoxDecoration(
                            color: Colours.white,
                            borderRadius: BorderRadius.all(Radius.circular(16.0)),
                            boxShadow: BoxShadows.normalBoxShadow,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    IntrinsicHeight(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            child: CircleImage(
                                              lvMessage?.snapshot_url ?? '',
                                              radius: 18,
                                              borderWidth: 0.5,
                                              borderColor: Colours.white,
                                              placeholderImage: DecorationImage(
                                                image: AssetImage(ImageUtil.getImgPath('icon_default_head'), package: Constant.baseLib),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          Gaps.hGap10,
                                          Expanded(child: Text(lvMessage?.title ?? '',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyles.textGray800_w400_14)
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                        width: double.infinity,
                                        margin: EdgeInsets.only(top: 10),
                                        alignment: Alignment.centerLeft,
                                        child: Text(lvMessage?.summary ?? '',
                                            maxLines: 5,
                                            overflow: TextOverflow.ellipsis,
                                            strutStyle: StrutStyle(forceStrutHeight: true, height:1.0, leading: 0.5),
                                            style: TextStyles.textGray500_w400_14
                                        )
                                    ),
                                  ],
                                ),
                              ),

                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(lvMessage?.publisher, style: TextStyles.textGray300_w400_12),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                      ),
                    ),
                  ),
                ),
                ShareQRFoooter()
              ],
            ),
          )
        ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!share) {
          Routers.navigateTo(context, Routers.communityPage);
        }
      },
      child: Container(
        width: double.infinity,
        margin: margin,
        child: AspectRatio(
          aspectRatio: 1.5,
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Colours.white,
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                boxShadow: BoxShadows.normalBoxShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        IntrinsicHeight(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                child: CircleImage(
                                  lvMessage?.snapshot_url ?? '',
                                  radius: 18,
                                  borderWidth: 0.5,
                                  borderColor: Colours.white,
                                  placeholderImage: DecorationImage(
                                    image: AssetImage(ImageUtil.getImgPath('icon_default_head'), package: Constant.baseLib),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Gaps.hGap10,
                              Expanded(child: Text(lvMessage?.title ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyles.textGray800_w400_14)
                              )
                            ],
                          ),
                        ),
                        Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(top: 10),
                            alignment: Alignment.centerLeft,
                            child: Text(lvMessage?.summary ?? '',
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                                strutStyle: StrutStyle(forceStrutHeight: true, height:1.0, leading: 0.5),
                                style: TextStyles.textGray500_w400_14
                            )
                        ),

                      ],
                    ),
                  ),

                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(lvMessage?.publisher, style: TextStyles.textGray300_w400_12),
                        ),
                        share ?
                        InkWell(
                          onTap: () => _share(context),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  child: LocalImage('icon_share', package: Constant.baseLib, width: 15, height: 15),
                                ),
                                Gaps.hGap4,
                                Container(
                                  padding: EdgeInsets.only(top: 1),
                                  child: Text(S.of(context).share,
                                      style: TextStyles.textGray350_w400_14
                                  ),
                                )
                              ],
                            ),
                          ),
                        ) : Gaps.empty
                      ],
                    ),
                  ),
                ],
              )
          ),
        ),
      ),
    );
  }
}
