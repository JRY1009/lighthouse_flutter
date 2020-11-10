import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
        height: 80.0,
        width: double.infinity,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: Text(title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.black, fontSize: 15)
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 2.0),
                        child: Text('$author  $time',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                    ],
                  )),
            ),
            Container(
              padding: EdgeInsets.only(left: 5, right: 10),
              width: 100.0,
              child: AspectRatio(
                aspectRatio: 1.2,
                child: CachedNetworkImage(
                    fit: BoxFit.fill,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[200],
                    ),
                    imageUrl: imageUrl ?? ''),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
