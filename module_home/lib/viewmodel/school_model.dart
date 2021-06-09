
import 'dart:async';

import 'package:library_base/mvvm/view_state.dart';
import 'package:library_base/mvvm/view_state_model.dart';
import 'package:library_base/net/apis.dart';
import 'package:library_base/net/dio_util.dart';
import 'package:library_base/utils/object_util.dart';
import 'package:module_home/model/lesson.dart';

class SchoolModel extends ViewStateModel {

  List<Lesson> lessonList = [];

  int page = 0;
  int pageSize = 20;

  bool noMore = true;

  SchoolModel() : super(viewState: ViewState.first);

  Future refresh() {
    page = 0;
    //noMore = false;
    return getLessons(page, pageSize);
  }

  Future loadMore() {
    page ++;
    return getLessons(page, pageSize);
  }

  Future getLessons(int page, int pageSize) {
    Map<String, dynamic> params = {
      'page_num': page,
      'page_size': pageSize,
    };

    return DioUtil.getInstance()!.requestNetwork(Apis.URL_GET_LESSONS, 'get', params: params,
        cancelToken: cancelToken,
        onSuccess: (dynamic data) {

          List<Lesson> list = Lesson.fromJsonList(data['records']) ?? [];
          if (page == 0) {
            lessonList.clear();
            lessonList.addAll(list);

          } else {
            lessonList.addAll(list);
          }

          //noMore = list?.length < pageSize;

          if (ObjectUtil.isEmptyList(lessonList)) {
            setEmpty();
          } else {
            setSuccess();
          }
        },
        onError: (errno, msg) {
          setError(errno!, message: msg);
        });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
