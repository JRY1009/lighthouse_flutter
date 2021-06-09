

import 'dart:async';

import 'package:library_base/mvvm/view_state.dart';
import 'package:library_base/mvvm/view_state_model.dart';
import 'package:library_base/net/apis.dart';
import 'package:library_base/net/dio_util.dart';
import 'package:library_base/model/friend_link.dart';
import 'package:library_base/model/milestone.dart';
import 'package:module_quote/model/index_brief.dart';

class IndexBriefModel extends ViewStateModel {

  List<IndexBrief> briefList = [];
  List<FriendLink> friendLinkList = [];
  List<MileStone> milestoneList = [];

  IndexBriefModel() : super(viewState: ViewState.first);

  Future getBrief(String chain) {
    Map<String, dynamic> params = {
      'chain': chain,
    };

    return DioUtil.getInstance()!.requestNetwork(Apis.URL_GET_CHAIN_DETAIL, 'get', params: params,
        cancelToken: cancelToken,
        onSuccess: (dynamic data) {

          briefList = IndexBrief.fromJsonList(data['chain_detail']) ?? [];
          friendLinkList = FriendLink.fromJsonList(data['friend_link']) ?? [];
          milestoneList = MileStone.fromJsonList(data['milestone']) ?? [];

          setSuccess();
        },
        onError: (errno, msg) {
          setError(errno!, message: msg);
        });
  }

}
