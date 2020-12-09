import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/styles.dart';
import 'package:lighthouse/ui/widget/image/round_image.dart';

/// 资讯列表详情
class ArticleCardItem extends StatelessWidget {

  final int index;
  final String newsUrl;
  final String imageUrl;
  final String title;
  final String author;
  final String time;

  const ArticleCardItem(
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
    return Container(
      margin: index == 0 ? EdgeInsets.fromLTRB(12, 9, 12, 6) : EdgeInsets.symmetric(horizontal: 12 , vertical: 6),
      decoration: BoxDecoration(
        color: Colours.white,
        borderRadius: BorderRadius.all(Radius.circular(14.0)),
        boxShadow: BoxShadows.normalBoxShadow,
      ),
      child: FlatButton(
        onPressed: () {},
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
      )
    );
  }
}
