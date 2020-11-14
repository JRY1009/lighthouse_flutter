
import 'package:flutter/material.dart';
import 'package:lighthouse/generated/l10n.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/gaps.dart';
import 'package:lighthouse/res/styles.dart';
import 'package:lighthouse/ui/widget/image/local_image.dart';
import 'package:lighthouse/utils/image_util.dart';
import 'package:lighthouse/utils/toast_util.dart';

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

    return Container(
      padding: EdgeInsets.fromLTRB(12, 9, 12, 9),
      child: Row (
        children: [
          Expanded(
              flex: 1,
              child: InkWell(
                  onTap: () => ToastUtil.normal('点我'),
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
                          child: LocalImage('icon_home_global_quote', width: 55, height: 54,),
                        ),
                        Positioned(right: 0, top: 0,
                          child: Container(
                            width: 65,
                            height: 59,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topRight: Radius.circular(14)),
                              image: DecorationImage(
                                image: AssetImage(ImageUtil.getImgPath('icon_home_global_quote_rt')),
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
                                image: AssetImage(ImageUtil.getImgPath('icon_home_global_quote_rb')),
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
                  onTap: () => ToastUtil.normal('点我2'),
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
                          child: LocalImage('icon_home_treemap', width: 60, height: 57),
                        ),
                        Positioned(right: 0, top: 0,
                          child: Container(
                            width: 52,
                            height: 62,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topRight: Radius.circular(14)),
                              image: DecorationImage(
                                image: AssetImage(ImageUtil.getImgPath('icon_home_treemap_rt')),
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
                                image: AssetImage(ImageUtil.getImgPath('icon_home_treemap_rb')),
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
