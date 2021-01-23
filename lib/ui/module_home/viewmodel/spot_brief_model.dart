

import 'dart:async';

import 'package:lighthouse/mvvm/view_state.dart';
import 'package:lighthouse/mvvm/view_state_model.dart';
import 'package:lighthouse/net/constant.dart';
import 'package:lighthouse/net/dio_util.dart';
import 'package:lighthouse/net/model/friend_link.dart';
import 'package:lighthouse/net/model/milestone.dart';
import 'package:lighthouse/net/model/spot_brief.dart';

class SpotBriefModel extends ViewStateModel {

  List<SpotBrief> briefList = [];
  List<FriendLink> friendLinkList = [];
  List<MileStone> milestoneList = [];

  SpotBriefModel() : super(viewState: ViewState.first);

  Future getBrief(String chain) {
    Map<String, dynamic> params = {
      'chain': chain,
    };

    return DioUtil.getInstance().requestNetwork(Constant.URL_GET_CHAIN_DETAIL, 'get', params: params,
        cancelToken: cancelToken,
        onSuccess: (data) {

          briefList = SpotBrief.fromJsonList(data['chain_detail']) ?? [];
          friendLinkList = FriendLink.fromJsonList(data['friend_link']) ?? [];
          milestoneList = FriendLink.fromJsonList(data['milestone']) ?? [];

          setSuccess();
        },
        onError: (errno, msg) {
          setError(errno, message: msg);
        });
  }

}
