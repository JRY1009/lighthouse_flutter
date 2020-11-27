import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lighthouse/generated/l10n.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/gaps.dart';
import 'package:lighthouse/res/styles.dart';
import 'package:lighthouse/ui/widget/DashLine.dart';
import 'package:lighthouse/ui/widget/dialog/dialog_util.dart';
import 'package:lighthouse/ui/widget/dialog/share_widget.dart';
import 'package:lighthouse/ui/widget/image/local_image.dart';

class NewsItem extends StatelessWidget {

  final int index;
  final String newsUrl;
  final String imageUrl;
  final String title;
  final String author;
  final String time;
  final bool isLast;

  const NewsItem(
      {Key key,
        this.index,
        this.newsUrl,
        this.imageUrl,
        this.title,
        this.author,
        this.isLast = false,
        this.time
      })
      : super(key: key);

  Future<void> _share(BuildContext context) async {

    DialogUtil.showShareDialog(context,
        children: [
          ShareNewsHeader(),
          Container(
            color: Colours.white,
            padding: EdgeInsets.fromLTRB(16, 20, 18, isLast ? 20 : 6),
            child: Column(
              children: [
                Container(
                    margin: EdgeInsets.only(top: 10),
                    alignment: Alignment.centerLeft,
                    child: Text((title ?? '') + '外媒：中国季节性矿工迁移致BTC算力下降哥哥哥',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        strutStyle: StrutStyle(forceStrutHeight: true, height:1, leading: 0.5),
                        style: TextStyles.textGray800_w400_16
                    )
                ),
                Container(
                  height: 20,
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text((time ?? '11:11'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.textMain12
                      ),
                      Text(author ?? '',
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
                    child: Text((title ?? '') + '外媒：中国季节性矿工迁移致BTC算力下降外媒：中国季节性矿工迁移致BTC算力下降外媒：中国季节性矿工迁移致BTC算力下降外媒：中国季节性矿工迁移致BTC算力下降外媒：中国季节性矿工迁移致BTC算力下降外媒：中国季节性矿工迁移致BTC算力下降',
                        strutStyle: StrutStyle(forceStrutHeight: true, height:1, leading: 0.5),
                        style: TextStyles.textGray800_w400_14
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
      onTap: () {},
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
                            Text((time ?? '11:11'),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyles.textMain12
                            ),
                            Text(author ?? '',
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
                        child: Text((title ?? '') + '外媒：中国季节性矿工迁移致BTC算力下降哥哥哥',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            strutStyle: StrutStyle(forceStrutHeight: true, height:1, leading: 0.5),
                            style: TextStyles.textGray800_w400_16
                        )
                      ),

                      Container(
                          margin: EdgeInsets.only(top: 10),
                          alignment: Alignment.centerLeft,
                          child: Text((title ?? '') + '外媒：中国季节性矿工迁移致BTC算力下降外媒：中国季节性矿工迁移致BTC算力下降外媒：中国季节性矿工迁移致BTC算力下降外媒：中国季节性矿工迁移致BTC算力下降外媒：中国季节性矿工迁移致BTC算力下降外媒：中国季节性矿工迁移致BTC算力下降',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              strutStyle: StrutStyle(forceStrutHeight: true, height:1, leading: 0.5),
                              style: TextStyles.textGray800_w400_14
                          )
                      ),

                      InkWell(
                        onTap: () => _share(context),
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          height: 20,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(S.of(context).share,
                                  style: TextStyles.textGray500_w400_12
                              ),
                              Gaps.hGap4,
                              Container(
                                margin: EdgeInsets.only(top: 2),
                                child: LocalImage('icon_share', width: 12, height: 12),
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
