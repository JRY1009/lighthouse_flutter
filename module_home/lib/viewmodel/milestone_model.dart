

import 'dart:async';

import 'package:library_base/mvvm/view_state.dart';
import 'package:library_base/mvvm/view_state_model.dart';
import 'package:library_base/net/apis.dart';
import 'package:library_base/net/dio_util.dart';
import 'package:library_base/utils/object_util.dart';
import 'package:library_base/model/milestone.dart';

class MileStoneModel extends ViewStateModel {

  List<MileStone> mileStoneList = [];

  final String tag;
  int page = 0;
  int pageSize = 20;

  bool noMore = false;

  MileStoneModel(this.tag) : super(viewState: ViewState.first);

  Future refresh() {
    page = 0;
    noMore = false;
    return getMileStones(page, pageSize);
  }

  Future loadMore() {
    page ++;
    return getMileStones(page, pageSize);
  }

  Future getMileStones(int page, int pageSize) {
    Map<String, dynamic> params = {
      'tag': tag,
      'page_num': page,
      'page_size': pageSize,
    };

    return DioUtil.getInstance()!.requestNetwork(Apis.URL_GET_MILESTONES, 'get', params: params,
        cancelToken: cancelToken,
        onSuccess: (dynamic data) {

          List<MileStone> newsList = MileStone.fromJsonList(data['records']) ?? [];
          if (page == 0) {
            mileStoneList.clear();
            mileStoneList.addAll(newsList);

          } else {
            mileStoneList.addAll(newsList);
          }

          noMore = newsList.length < pageSize;

          if (ObjectUtil.isEmptyList(mileStoneList)) {
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
