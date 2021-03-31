import 'dart:math';

import 'package:flutter/material.dart';
import 'package:library_base/constant/constant.dart';
import 'package:library_base/event/event.dart';
import 'package:library_base/event/main_jump_event.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/mvvm/provider_widget.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/router/routers.dart';
import 'package:library_base/utils/image_util.dart';
import 'package:module_home/home_router.dart';
import 'package:module_home/item/milestone_item.dart';
import 'package:module_home/model/milestone.dart';
import 'package:module_home/viewmodel/milestone_model.dart';

class HomeMileStoneBar extends StatefulWidget {
  final VoidCallback onPressed;

  const HomeMileStoneBar({
    Key key,
    this.onPressed,
  }) : super(key: key);

  @override
  _HomeMileStoneBarState createState() => _HomeMileStoneBarState();
}

class _HomeMileStoneBarState extends State<HomeMileStoneBar>
    with BasePageMixin<HomeMileStoneBar> {
  MileStoneModel _mileStoneModel;

  @override
  void initState() {
    super.initState();
    initViewModel();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initViewModel() {
    _mileStoneModel = MileStoneModel('all');
    _mileStoneModel.getMileStones(0, 3);
  }

  @override
  Future<void> refresh({slient = false}) {
    return _mileStoneModel.getMileStones(0, 3);
  }

  @override
  Widget build(BuildContext context) {

    String package = HomeRouter.isRunModule ? null : Constant.moduleHome;

    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () => Routers.navigateTo(context, Routers.milestonePage),
          child: Container(
            height: 82,
            margin: EdgeInsets.fromLTRB(12, 8, 12, 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),   //圆角
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFFABD5FF),
                  Color(0xFFEFF8FF),
                ],
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),   //圆角
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFFF2F5FF),
                    Color(0xFFBFD9FD),
                  ],
                ),
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(right: 0, top: 0,
                    child: Container(
                      width: 159,
                      height: 82,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
                        image: DecorationImage(
                          image: AssetImage(ImageUtil.getImgPath('bg_school'), package: package),
                        ),
                      ),
                    ),
                  ),
                  Positioned(left: 25, top: 24,
                    child: Container(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                height: 20,
                                alignment: Alignment.centerLeft,
                                child: Text(S.of(context).dengtaSchool,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyles.textGray800_w400_15)
                            ),
                            Gaps.vGap4,
                            Container(
                                height: 16,
                                child: Text(S.of(context).learnMore,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Color(0xFF6984BA), fontWeight: FontWeight.w400, fontSize: 13, height: 1.0
                                    ))
                            ),

                          ],
                        )
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => Event.eventBus.fire(MainJumpEvent(MainJumpPage.info, params: {"tab": 1})),
          child: Container(
            margin: EdgeInsets.only(left: 12, right: 12, top: 40, bottom: 9),
            height: 24,
            child: Row(
              children: [
                Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        S.of(context).latestInfo,
                        style: TextStyles.textGray800_w400_18,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )),
                Container(
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      children: [
                        Text(S.of(context).all, style: TextStyles.textGray400_w400_12),
                        Gaps.hGap3,
                        Icon(Icons.keyboard_arrow_right, color: Colours.gray_400, size: 16),
                      ],
                    )
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
