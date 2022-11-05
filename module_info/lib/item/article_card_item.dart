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
class ArticleCardItem extends StatelessWidget {

  final int? index;
  final Article aritcle;

  const ArticleCardItem(
      {Key? key,
        required this.aritcle,
        this.index
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.all(0),
      ),
      onPressed: () {
        Parameters params = Parameters()
          ..putString('title', '')
          ..putString('url', aritcle.url_app ?? '')
          ..putString('title_share', aritcle.title ?? '')
          ..putString('summary_share', aritcle.summary ?? '')
          ..putString('url_share', aritcle.url ?? '')
          ..putString('thumb_share', aritcle.snapshot_url ?? '');

        Routers.navigateTo(context, Routers.articlePage, parameters: params);
      },
      child: Container(
        width: double.infinity,
        child: Container(
            padding: EdgeInsets.fromLTRB(18, 18, 17, 12),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 0.6, color: Colours.default_line))
            ),
            child: Column(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(aritcle.title ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        strutStyle: StrutStyle(forceStrutHeight: true, height:1.4, leading: 0.5),
                        style: TextStyles.textGray800_w600_17
                    )
                ),
                Gaps.vGap5,
                IntrinsicHeight(
                  child: Row(
                    children: [
                      ObjectUtil.isEmpty(aritcle.snapshot_url) ? Gaps.empty :
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: RoundImage(aritcle.snapshot_url ?? '',
                          width: 84,
                          height: 84,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                      Expanded(
                        child: Container(
                            alignment: Alignment.topLeft,
                            child: Text(aritcle.summary ?? '',
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                strutStyle: StrutStyle(forceStrutHeight: true, height:1.2, leading: 0.5),
                                style: TextStyles.textGray500_w400_14
                            )),
                      ),
                    ],
                  ),
                ),

                Gaps.vGap8,
                Container(
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(aritcle.publisher ?? '', style: TextStyles.textGray400_w400_12),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        alignment: Alignment.centerRight,
                        child: Text(TimeCountUtil.formatStr(aritcle.publish_time ?? '') ?? '',
                          style: TextStyles.textGray400_w400_12,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
