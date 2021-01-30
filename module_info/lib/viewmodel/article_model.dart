

import 'dart:async';

import 'package:library_base/mvvm/view_state.dart';
import 'package:library_base/mvvm/view_state_model.dart';
import 'package:library_base/net/apis.dart';
import 'package:library_base/net/dio_util.dart';
import 'package:library_base/utils/object_util.dart';
import 'package:module_info/model/article.dart';

class ArticleModel extends ViewStateModel {

  List<Article> articleList = [];

  final String tag;
  int page = 0;
  int pageSize = 20;

  bool noMore = false;

  ArticleModel(this.tag) : super(viewState: ViewState.first);

  Future refresh() {
    page = 0;
    noMore = false;
    return getArticles(page, pageSize);
  }

  Future loadMore() {
    page ++;
    return getArticles(page, pageSize);
  }

  Future getArticles(int page, int pageSize) {
    Map<String, dynamic> params = {
      'tag': tag,
      'page_num': page,
      'page_size': pageSize,
    };

    return DioUtil.getInstance().requestNetwork(Apis.URL_GET_MILESTONES, 'get', params: params,
        cancelToken: cancelToken,
        onSuccess: (data) {

          List<Article> newsList = Article.fromJsonList(data['records']) ?? [];
          if (page == 0) {
            articleList.clear();
            articleList.addAll(newsList);

          } else {
            articleList.addAll(newsList);
          }

          noMore = newsList?.length < pageSize;

          if (ObjectUtil.isEmptyList(articleList)) {
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
