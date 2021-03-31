import 'package:flutter/material.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/router/parameters.dart';
import 'package:library_base/router/routers.dart';
import 'package:library_base/utils/time_count_util.dart';
import 'package:library_base/widget/image/round_image.dart';
import 'package:module_info/model/article.dart';

/// 资讯列表详情
class ArticleCardItem extends StatelessWidget {

  final int index;
  final Article aritcle;

  const ArticleCardItem(
      {Key key,
        this.index,
        this.aritcle,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: index == 0 ? EdgeInsets.fromLTRB(12, 9, 12, 6) : EdgeInsets.symmetric(horizontal: 12 , vertical: 6),
      decoration: BoxDecoration(
        color: Colours.white,
        borderRadius: BorderRadius.all(Radius.circular(14.0)),
        boxShadow: BoxShadows.normalBoxShadow,
      ),
      child: FlatButton(
        onPressed: () {
          Parameters params = Parameters()
            ..putString('title', aritcle.title ?? '')
            ..putString('url', aritcle.url_app ?? '')
            ..putString('url_share', aritcle.url ?? '')
            ..putString('thumb_share', aritcle.snapshot_url ?? '');

          Routers.navigateTo(context, Routers.inappWebviewPage, parameters: params);
        },
        padding: EdgeInsets.all(0.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14.0))),
        child: Container(
          height: 100.0,
          width: double.infinity,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                    padding: EdgeInsets.fromLTRB(17, 18, 10, 17),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: Text(aritcle?.title ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                strutStyle: StrutStyle(forceStrutHeight: true, height:1, leading: 0.5),
                                style: TextStyles.textGray800_w400_15
                            ),
                          ),
                        ),
                        Container(
                          child: Row(
                            children: [
                              Icon(Icons.web, color: Colours.app_main, size: 16),
                              Container(
                                margin: EdgeInsets.only(left: 5),
                                alignment: Alignment.centerLeft,
                                child: Text(aritcle?.author, style: TextStyles.textGray400_w400_12),
                              ),
                              Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(right: 5),
                                    alignment: Alignment.centerRight,
                                    child: Text(TimeCountUtil.formatStr(aritcle?.publish_time) ?? '',
                                      style: TextStyles.textGray500_w400_12,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
              Container(
                margin: EdgeInsets.only(right: 18),
                child: RoundImage(aritcle?.snapshot_url ?? '',
                  width: 88,
                  height: 66,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
