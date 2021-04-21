
import 'dart:async';

import 'package:library_base/mvvm/view_state.dart';
import 'package:library_base/mvvm/view_state_model.dart';
import 'package:library_base/net/apis.dart';
import 'package:library_base/net/dio_util.dart';
import 'package:library_base/utils/object_util.dart';
import 'package:module_home/model/leave_message.dart';

class LeaveMessageModel extends ViewStateModel {

  List<LeaveMessage> messageList = [];

  int page = 0;
  int pageSize = 8;

  bool noMore = true;

  LeaveMessageModel() : super(viewState: ViewState.first);

  Future refresh() {
    page = 0;
    //noMore = false;
    return getMessages(page, pageSize);
  }

  Future loadMore() {
    page ++;
    return getMessages(page, pageSize);
  }

  Future getMessages(int page, int pageSize) {
    Map<String, dynamic> params = {
      'start': page * pageSize,
      'count': pageSize,
    };

    return DioUtil.getInstance().requestArticle(Apis.URL_GET_ARTICLES + '1/articles', 'get', params: params,
        cancelToken: cancelToken,
        onSuccess: (data) {

          List<LeaveMessage> list = LeaveMessage.fromJsonList(data) ?? [];
          if (page == 0) {
            messageList.clear();
            messageList.addAll(list);

          } else {
            messageList.addAll(list);
          }

          //noMore = list?.length < pageSize;

          if (ObjectUtil.isEmptyList(messageList)) {
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
