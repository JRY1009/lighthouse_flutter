import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/res/colors.dart';

/// 资讯列表详情
class NewsItem extends StatelessWidget {

  final String newsUrl;
  final String imageUrl;
  final String title;
  final String author;
  final String time;

  const NewsItem(
      {Key key,
        this.newsUrl = '',
        this.imageUrl = '',
        this.title = '',
        this.author = '',
        this.time
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
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
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: Text(title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.black, fontSize: 15)
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(top: 2.0),
                        child: Text('$author  $time',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                    ],
                  )),
            ),
            Container(
              padding: EdgeInsets.all(10),
              color: Colors.white,
              child: CachedNetworkImage(
                imageUrl: imageUrl ?? '',
                fit: BoxFit.fill,
                imageBuilder: (context, imageProvider) => Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    border: Border.all(color: Colours.toast_warn, width: 2, style: BorderStyle.solid),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                ),
              ),

            ),
          ],
        ),
      ),
    );
  }
}
