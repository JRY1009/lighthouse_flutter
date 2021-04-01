import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:library_base/constant/constant.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/router/parameters.dart';
import 'package:library_base/router/routers.dart';
import 'package:library_base/utils/date_util.dart';
import 'package:library_base/utils/time_count_util.dart';
import 'package:library_base/widget/dash_line.dart';
import 'package:library_base/widget/dialog/dialog_util.dart';
import 'package:library_base/widget/dialog/share_widget.dart';
import 'package:library_base/widget/image/local_image.dart';
import 'package:module_info/model/news.dart';

class NewsItem extends StatelessWidget {

  final int index;
  final News news;
  final bool isLast;

  const NewsItem(
      {Key key,
        this.index,
        this.news,
        this.isLast = false,
      })
      : super(key: key);

  Future<void> _share(BuildContext context) async {

    DialogUtil.showShareDialog(context,
        children: [
          ShareNewsHeader(),
          Container(
            color: Colours.white,
            padding: EdgeInsets.fromLTRB(16, 20, 18, 20),
            child: Column(
              children: [
                Container(
                    margin: EdgeInsets.only(top: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(news?.title ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        strutStyle: StrutStyle(forceStrutHeight: true, height:1, leading: 0.5),
                        style: TextStyles.textGray800_w400_20
                    )
                ),
                Container(
                  height: 20,
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(TimeCountUtil.formatDateStr(news?.publish_time, format: DateFormat.NORMAL) ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.textGray500_w400_12
                      ),
                      Text(news?.publisher ?? '',
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
                    child: Text(news?.summary ?? '',
                        strutStyle: StrutStyle(forceStrutHeight: true, height:1, leading: 0.5),
                        style: TextStyles.textGray800_w400_15
                    )
                ),

              ],
            ),
          ),
          ShareQRFoooter()
        ]
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Parameters params = Parameters()
          ..putString('title', S.of(context).infoDetail)
          ..putString('url', news.url_app ?? '')
          ..putString('title_share', news.title ?? '')
          ..putString('summary_share', news.summary ?? '')
          ..putString('url_share', news.url ?? '')
          ..putString('thumb_share', news.snapshot_url ?? '');

        Routers.navigateTo(context, Routers.inappWebviewPage, parameters: params);
      },
      child: Container(
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
                        child: index == 0 ? null : DashLine(strokeWidth: 0.6, color: Colours.gray_200, gap: 3),
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
                  padding: EdgeInsets.fromLTRB(0, 20, 18, isLast ? 20 : 6),
                  child: Column(
                    children: [
                      Container(
                        height: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(TimeCountUtil.formatDateStr(news?.publish_time, format: DateFormat.HOUR_MINUTE) ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyles.textGray500_w400_12
                            ),
                            Text(news?.publisher ?? '',
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
                        child: Text(news?.title ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            strutStyle: StrutStyle(forceStrutHeight: true, height:1, leading: 0.5),
                            style: TextStyles.textGray800_w400_17
                        )
                      ),

                      Container(
                          margin: EdgeInsets.only(top: 10),
                          alignment: Alignment.centerLeft,
                          child: Text(news?.summary ?? '',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              strutStyle: StrutStyle(forceStrutHeight: true, height:1, leading: 0.5),
                              style: TextStyles.textGray800_w400_15
                          )
                      ),

                      InkWell(
                        onTap: () => _share(context),
                        child: Container(
                          height: 20,
                          margin: EdgeInsets.only(top: 10),
                          alignment: Alignment.centerRight,
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
                        )
                      )
                      
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
