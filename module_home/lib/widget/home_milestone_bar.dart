
import 'package:flutter/material.dart';
import 'package:library_base/constant/constant.dart';
import 'package:library_base/event/event.dart';
import 'package:library_base/event/main_jump_event.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/router/routers.dart';
import 'package:library_base/utils/image_util.dart';
import 'package:module_home/home_router.dart';

class HomeMileStoneBar extends StatefulWidget {
  final VoidCallback onPressed;

  const HomeMileStoneBar({
    Key key,
    this.onPressed,
  }) : super(key: key);

  @override
  _HomeMileStoneBarState createState() => _HomeMileStoneBarState();
}

class _HomeMileStoneBarState extends State<HomeMileStoneBar> with BasePageMixin<HomeMileStoneBar> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    String package = HomeRouter.isRunModule ? null : Constant.moduleHome;

    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () => Routers.navigateTo(context, Routers.schoolPage),
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
                                    style: TextStyle(color: const Color(0xFF354C77), fontSize: 15, fontWeight: FontWeight.w600, height: 1.0))
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
      ],
    );
  }
}
