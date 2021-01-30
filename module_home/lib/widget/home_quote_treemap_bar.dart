
import 'package:flutter/material.dart';
import 'package:library_base/constant/constant.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/router/routers.dart';
import 'package:library_base/widget/image/local_image.dart';
import 'package:library_base/utils/image_util.dart';
import 'package:module_home/home_router.dart';

class HomeQuoteTreemapBar extends StatefulWidget {

  final double appBarOpacity;
  final double height;

  const HomeQuoteTreemapBar({
    Key key,
    @required this.appBarOpacity,
    @required this.height,
  }): super(key: key);


  @override
  _HomeQuoteTreemapBarState createState() => _HomeQuoteTreemapBarState();
}

class _HomeQuoteTreemapBarState extends State<HomeQuoteTreemapBar> {

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

    return Container(
      padding: EdgeInsets.fromLTRB(12, 9, 12, 9),
      child: Row (
        children: [
          Expanded(
              flex: 1,
              child: InkWell(
                  onTap: () => Routers.navigateTo(context, Routers.globalQuotePage),
                  child: Container(
                    height: 82,
                    decoration: BoxDecoration(
                      color: Colours.white,
                      borderRadius: BorderRadius.all(Radius.circular(14.0)),
                      boxShadow: BoxShadows.normalBoxShadow,
                    ),
                    child: Stack(
                      children: <Widget>[
                        Positioned(left: 0, top: 2,
                          child: LocalImage('icon_home_global_quote', width: 55, height: 54, package: package),
                        ),
                        Positioned(right: 0, top: 0,
                          child: Container(
                            width: 65,
                            height: 59,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topRight: Radius.circular(14)),
                              image: DecorationImage(
                                image: AssetImage(ImageUtil.getImgPath('icon_home_global_quote_rt'), package: package),
                              ),
                            ),
                          ),
                        ),
                        Positioned(right: 0, bottom: 0,
                          child: Container(
                            width: 38,
                            height: 41,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(14)),
                              image: DecorationImage(
                                image: AssetImage(ImageUtil.getImgPath('icon_home_global_quote_rb'), package: package),
                              ),
                            ),
                          ),
                        ),
                        Positioned(left: 14, top: 50,
                          child: Text(S.of(context).globalQuote, style: TextStyles.textGray800_w400_16,),
                        ),
                      ],
                    ),
                  )
              )
          ),
          Gaps.hGap12,
          Expanded(
              flex: 1,
              child: InkWell(
                  onTap: () => Routers.navigateTo(context, Routers.treemapPage),
                  child: Container(
                    height: 82,
                    decoration: BoxDecoration(
                      color: Colours.white,
                      borderRadius: BorderRadius.all(Radius.circular(14.0)),
                      boxShadow: BoxShadows.normalBoxShadow,
                    ),
                    child: Stack(
                      children: <Widget>[
                        Positioned(left: 0, top: 2,
                          child: LocalImage('icon_home_treemap', width: 60, height: 57, package: package),
                        ),
                        Positioned(right: 0, top: 0,
                          child: Container(
                            width: 52,
                            height: 62,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topRight: Radius.circular(14)),
                              image: DecorationImage(
                                image: AssetImage(ImageUtil.getImgPath('icon_home_treemap_rt'), package: package),
                              ),
                            ),
                          ),
                        ),
                        Positioned(right: 20, bottom: 0,
                          child: Container(
                            width: 60,
                            height: 41,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(14)),
                              image: DecorationImage(
                                image: AssetImage(ImageUtil.getImgPath('icon_home_treemap_rb'), package: package),
                              ),
                            ),
                          ),
                        ),
                        Positioned(left: 14, top: 50,
                          child: Text(S.of(context).treemap, style: TextStyles.textGray800_w400_16,),
                        )
                      ],
                    ),
                  )
              )
          ),
        ],
      ),
    );
  }
}
