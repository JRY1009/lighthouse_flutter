
import 'package:flutter/material.dart';
import 'package:library_base/constant/constant.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/model/account.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/widget/image/circle_image.dart';
import 'package:library_base/utils/image_util.dart';

class MineAppBar extends StatefulWidget {

  final Account? account;
  final VoidCallback? onPressed;
  final VoidCallback? onActionPressed;
  final VoidCallback? onAvatarPressed;

  const MineAppBar({
    Key? key,
    this.account,
    this.onPressed,
    this.onActionPressed,
    this.onAvatarPressed
  }): super(key: key);


  @override
  _MineAppBarState createState() => _MineAppBarState();
}

class _MineAppBarState extends State<MineAppBar> {


  @override
  Widget build(BuildContext context) {

    String title = widget.account != null ? widget.account!.nick_name! : S.of(context).loginNow;
    String? subTitle = widget.account != null ? widget.account!.phoneSecret : S.of(context).loginGuide;

    return InkWell(
        onTap: () {
          if (widget.onPressed != null) {
            widget.onPressed!();
          }
        },
        child: Container(
            height: 150,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImageUtil.getImgPath('bg_mine'), package: Constant.baseLib),
                fit: BoxFit.fill,
              ),
            ),
            child: Stack(
              children: <Widget>[
//                Positioned(
//                  right: 5,
//                  top: 40,
//                  child: IconButton(
//                    onPressed: widget.onActionPressed,
//                    padding: EdgeInsets.only(right: 10, top: 0, left: 10, bottom: 20),
//                    icon: LocalImage('icon_notify', package: Constant.baseLib, width: 20, height: 20),
//                  ),
//                ),
                Padding(
                  padding: EdgeInsets.only(top: 60),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(left: 28),
                          child: InkWell(
                            onTap: widget.onAvatarPressed,
                            child: CircleImage(
                                widget.account?.head_ico ?? '',
                                radius: 32,
                                borderWidth: 3,
                                borderColor: Colours.white,
                                boxShadow: BoxShadows.normalBoxShadow,
                                placeholderImage: DecorationImage(
                                  image: AssetImage(ImageUtil.getImgPath('icon_default_head'), package: Constant.baseLib),
                                  fit: BoxFit.fill,
                                ),
                            ),
                          )
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                            padding: EdgeInsets.only(left: 15, top: 10),
                            alignment: Alignment.topLeft,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.only(bottom: 6),
                                    alignment: Alignment.centerLeft,
                                    child: Text(title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyles.textGray800_w700_17)
                                ),

                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(subTitle ?? '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyles.textGray400_w400_14)
                                ),

                              ],
                            )),
                      ),

                      IconButton(
                        padding: EdgeInsets.only(top: 10, right: 10),
                        icon: Icon(Icons.keyboard_arrow_right, color: Colours.gray_200, size: 25),
                        onPressed: (){
                          if (widget.onPressed != null) {
                            widget.onPressed!();
                          }
                        },
                      ),

                    ],
                  ),
                ),

              ],
            )
        )
    );
  }
}
