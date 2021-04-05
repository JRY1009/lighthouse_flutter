

import 'dart:async';

import 'package:library_base/mvvm/view_state.dart';
import 'package:library_base/mvvm/view_state_model.dart';
import 'package:library_base/net/apis.dart';
import 'package:library_base/net/dio_util.dart';
import 'package:library_base/utils/date_util.dart';
import 'package:library_base/utils/object_util.dart';
import 'package:module_info/model/news.dart';

class NewsModel extends ViewStateModel {

  List<News> newsList = [];
  List<List<News>> dateNewsList = [];

  final String tag;
  int page = 0;
  int pageSize = 20;

  bool noMore = false;

  NewsModel(this.tag) : super(viewState: ViewState.first);

  Future refresh() {
    page = 0;
    noMore = false;

    return getNews(page, pageSize);
  }

  Future loadMore() {
    page ++;
    return getNews(page, pageSize);
  }

  Future getNews(int page, int pageSize) {
    Map<String, dynamic> params = {
      'tag': tag,
      'start': page * pageSize,
      'count': pageSize,
    };

    return DioUtil.getInstance().requestArticle(Apis.URL_GET_ARTICLES + '1/articles', 'get', params: params,
        cancelToken: cancelToken,
        onSuccess: (data) {

          List<News> list = News.fromJsonList(data) ?? [];
          if (page == 0) {
            newsList.clear();
            newsList.addAll(list);

          } else {
            newsList.addAll(list);
          }

          noMore = list?.length < pageSize;

          generateList();

          if (ObjectUtil.isEmptyList(newsList)) {
            setEmpty();
          } else {
            setSuccess();
          }
        },
        onError: (errno, msg) {
          setError(errno, message: msg);
        });
  }

  void generateList() {
    newsList = newsList.toSet().toList();
    newsList.sort((a, b) {
      DateTime aD = DateUtil.getDateTime(a.publish_time);
      DateTime bD = DateUtil.getDateTime(b.publish_time);
      return bD.compareTo(aD);
    });

    int length = newsList.length;
    if (length > 0) {


      dateNewsList.clear();
      dateNewsList.add([]);
      DateTime groupDt = DateUtil.getDateTime(newsList.first?.publish_time);

      for (int i=0; i<length; i++) {
        DateTime dt = DateUtil.getDateTime(newsList[i].publish_time);
        if (DateUtil.dayIsEqual(dt, groupDt)) {
          dateNewsList.last.add(newsList[i]);

        } else {
          groupDt = dt;
          dateNewsList.add([]);
          dateNewsList.last.add(newsList[i]);
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
