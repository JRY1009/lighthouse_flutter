
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:library_base/constant/constant.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/utils/date_util.dart';
import 'package:library_base/utils/image_util.dart';
import 'package:library_base/utils/object_util.dart';
import 'package:library_base/utils/time_count_util.dart';
import 'package:library_base/widget/dash_line.dart';
import 'package:library_base/widget/dialog/dialog_util.dart';
import 'package:library_base/widget/dialog/share_widget.dart';
import 'package:library_base/widget/image/local_image.dart';
import 'package:library_base/widget/text/text_expand.dart';
import 'package:module_info/model/news.dart';

class NewsItem extends StatefulWidget {

  final int index;
  final News news;
  final bool isLast;

  NewsItem({Key key,
    this.index,
    this.news,
    this.isLast = false,
  })
      : super(key: key);

  @override
  _NewsItemState createState() => _NewsItemState();
}

class _NewsItemState extends State<NewsItem> {

  TextExpandController controller = TextExpandController();

  Future<void> _share(BuildContext context) async {

    DialogUtil.showShareDialog(context,
        children: [
        Container(
          color: Colours.white,
          child: Column(
            children: [
              ShareNewsHeader(),
              Container(
                child: Stack(
                  children: [
                    Container(
                      height: 165.6,
                      decoration: BoxDecoration(
                        color: Colours.white,
                        image: DecorationImage(
                          image: AssetImage(ImageUtil.getImgPath('bg_home2'), package: Constant.baseLib),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(minHeight: 165.6),
                      padding: EdgeInsets.fromLTRB(16, 20, 18, 20),
                      child: Column(
                        children: [
                          ObjectUtil.isEmpty(widget.news?.title) ? Gaps.empty :
                          Container(
                              margin: EdgeInsets.only(top: 20),
                              alignment: Alignment.centerLeft,
                              child: Text(widget.news?.title ?? '',
                                  strutStyle: StrutStyle(forceStrutHeight: true, height:1.4, leading: 0.5),
                                  style: TextStyles.textGray800_w700_20
                              )
                          ),
                          Container(
                            height: 20,
                            margin: EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                LocalImage('icon_time', width: 12, height: 12, package: Constant.baseLib),
                                Gaps.hGap5,
                                Text(TimeCountUtil.formatDateStr(widget.news?.publish_time, format: DateFormat.NORMAL) ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyles.textGray500_w400_12
                                )
                              ],
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 10),
                              alignment: Alignment.centerLeft,
                              child: Text(widget.news?.summary ?? '',
                                  strutStyle: StrutStyle(forceStrutHeight: true, height:1.2, leading: 0.5),
                                  style: TextStyles.textGray800_w400_15
                              )
                          ),

//                      Container(
//                        height: 20,
//                        alignment: Alignment.centerLeft,
//                        margin: EdgeInsets.only(top: 10),
//                        child: Text(S.of(context).origin + (widget.news?.publisher ?? ''),
//                            maxLines: 1,
//                            overflow: TextOverflow.ellipsis,
//                            style: TextStyles.textGray300_w400_12
//                        ),
//                      ),
                        ],
                      ),
                    ),
                  ],
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
    return Container(
      width: double.infinity,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: double.infinity,
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      width: 0.6,
                      height: 26,
                      child: widget.index == 0 ? null : DashLine(strokeWidth: 0.6, color: Colours.gray_200, gap: 3),
                    ),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                        color: Colours.app_main,
                      ),
                    ),
                    Expanded(
                      child: DashLine(strokeWidth: 0.6, color: Colours.gray_200, gap: 3),
                    ),
                  ]
              ),
            ),

            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 20, 18, widget.isLast ? 10 : 0),
                child: Column(
                  children: [
                    Container(
                      height: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(TimeCountUtil.formatDateStr(widget.news?.publish_time, format: DateFormat.HOUR_MINUTE) ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyles.textGray500_w400_12
                          ),
                          Text(/*news?.publisher ??*/ '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyles.textGray500_w400_12
                          )
                        ],
                      ),
                    ),

                    ObjectUtil.isEmpty(widget.news?.title) ? Gaps.empty :
                    GestureDetector(
                      onTap: () {
                        controller.trigger = !controller.trigger;
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(widget.news?.title ?? '',
                            strutStyle: StrutStyle(forceStrutHeight: true, height:1.4, leading: 0.5),
                            style: TextStyles.textGray800_w700_17
                        )
                      ),
                    ),

                    Container(
                        margin: EdgeInsets.only(top: 10),
                        alignment: Alignment.centerLeft,
                        child: TextExpand(
                            controller: controller,
                            text: widget.news?.summary ?? '',
                            expandText: '',
                            minLines: 4,
                            isEnableTextClick: true,
                            textStyle: TextStyles.textGray500_w400_15,
                            strutStyle: StrutStyle(forceStrutHeight: true, height:1.2, leading: 0.5)
                        ),
                    ),

                    Container(
                      alignment: Alignment.centerRight,
                      child: InkWell(
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
                      ),
                    )

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
