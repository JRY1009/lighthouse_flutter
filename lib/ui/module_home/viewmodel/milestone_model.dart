

import 'dart:async';

import 'package:lighthouse/mvvm/view_state.dart';
import 'package:lighthouse/mvvm/view_state_model.dart';
import 'package:lighthouse/net/constant.dart';
import 'package:lighthouse/net/dio_util.dart';
import 'package:lighthouse/net/model/milestone.dart';
import 'package:lighthouse/utils/object_util.dart';

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

    return DioUtil.getInstance().requestNetwork(Constant.URL_GET_MILESTONES, 'get', params: params,
        cancelToken: cancelToken,
        onSuccess: (data) {

          List<MileStone> newsList = MileStone.fromJsonList(data['records']) ?? [];
          if (page == 0) {
            mileStoneList.clear();
            mileStoneList.addAll(newsList);

          } else {
            mileStoneList.addAll(newsList);
          }

          noMore = newsList?.length < pageSize;

          if (ObjectUtil.isEmptyList(mileStoneList)) {
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
