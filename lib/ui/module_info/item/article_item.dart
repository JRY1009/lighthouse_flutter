import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/widget/image/round_image.dart';

/// 资讯列表详情
class ArticleItem extends StatelessWidget {

  final int index;
  final String newsUrl;
  final String imageUrl;
  final String title;
  final String author;
  final String time;

  const ArticleItem(
      {Key key,
        this.index,
        this.newsUrl = '',
        this.imageUrl = '',
        this.title = '',
        this.author = '',
        this.time
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {},
      padding: EdgeInsets.all(0.0),
      child: Container(
        height: 100.0,
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 0.6, color: Colours.default_line))
        ),
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
                          child: Text(title + '的快乐撒娇的刻录机萨克来得及奥斯卡了佳度了佳度科拉了佳度科拉了佳度科拉科拉屎佳度科拉屎觉得',
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
                              child: Text(author, style: TextStyles.textGray400_w400_12),
                            ),
                            Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(right: 5),
                                  alignment: Alignment.centerRight,
                                  child: Text(time??'11-11 11:11',
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
              child: RoundImage(imageUrl ?? '',
                width: 88,
                height: 66,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
