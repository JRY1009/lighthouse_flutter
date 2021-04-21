import 'package:flutter/material.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/router/parameters.dart';
import 'package:library_base/router/routers.dart';
import 'package:library_base/utils/object_util.dart';
import 'package:library_base/utils/time_count_util.dart';
import 'package:library_base/widget/image/round_image.dart';
import 'package:module_info/model/article.dart';

/// 资讯列表详情
class ArticleItem extends StatelessWidget {

  final int index;
  final Article aritcle;

  const ArticleItem(
      {Key key,
        this.index,
        this.aritcle
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        Parameters params = Parameters()
          ..putString('title', '')
          ..putString('url', aritcle.url_app ?? '')
          ..putString('title_share', aritcle.title ?? '')
          ..putString('summary_share', aritcle.summary ?? '')
          ..putString('url_share', aritcle.url ?? '')
          ..putString('thumb_share', aritcle.snapshot_url ?? '');

        Routers.navigateTo(context, Routers.inappWebviewPage, parameters: params);
      },
      padding: EdgeInsets.all(0.0),
      child: Container(
        width: double.infinity,
        child: Container(
            padding: EdgeInsets.fromLTRB(18, 18, 17, 18),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 0.6, color: Colours.default_line))
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(top: 4),
                          alignment: Alignment.centerLeft,
                          child: Text(aritcle?.title ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              strutStyle: StrutStyle(forceStrutHeight: true, height:1, leading: 0.5),
                              style: TextStyles.textGray800_w600_17
                          )
                      ),
                      Gaps.vGap12,
                      Container(
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(aritcle?.publisher, style: TextStyles.textGray400_w400_12),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              alignment: Alignment.centerRight,
                              child: Text(TimeCountUtil.formatStr(aritcle?.publish_time) ?? '',
                                style: TextStyles.textGray400_w400_12,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ),
                ObjectUtil.isEmpty(aritcle?.snapshot_url) ? Gaps.empty :
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: RoundImage(aritcle?.snapshot_url ?? '',
                    width: 105,
                    height: 80,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              ],
            ),

            ),
      ),
    );
  }
}
