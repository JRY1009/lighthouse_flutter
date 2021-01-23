

import 'dart:async';

import 'package:lighthouse/mvvm/view_state.dart';
import 'package:lighthouse/mvvm/view_state_model.dart';
import 'package:lighthouse/net/constant.dart';
import 'package:lighthouse/net/dio_util.dart';
import 'package:lighthouse/net/model/news.dart';
import 'package:lighthouse/utils/object_util.dart';

class NewsModel extends ViewStateModel {

  List<News> newsList = [];

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
      'page_num': page,
      'page_size': pageSize,
    };

    return DioUtil.getInstance().requestNetwork(Constant.URL_GET_MILESTONES, 'get', params: params,
        cancelToken: cancelToken,
        onSuccess: (data) {

          List<News> list = News.fromJsonList(data['records']) ?? [];
          if (page == 0) {
            newsList.clear();
            newsList.addAll(list);

          } else {
            newsList.addAll(list);
          }

          noMore = list?.length < pageSize;

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

  @override
  void dispose() {
    super.dispose();
  }
}
