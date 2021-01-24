

import 'package:lighthouse/event/event.dart';
import 'package:lighthouse/event/user_event.dart';
import 'package:lighthouse/mvvm/view_state_model.dart';
import 'package:lighthouse/net/constant.dart';
import 'package:lighthouse/net/dio_util.dart';
import 'package:lighthouse/net/model/account.dart';
import 'package:lighthouse/net/rt_account.dart';

class ModifyNicknameModel extends ViewStateModel {

  ModifyNicknameModel();

  Future modifyNickname(String nickname) async {

    Map<String, dynamic> params = {
      'nick_name': nickname,
    };

    setBusy();
    return DioUtil.getInstance().requestNetwork(Constant.URL_UPDATE_NICK_NAME, "post", params: params,
        cancelToken: cancelToken,
        onSuccess: (data) {

          Account account = RTAccount.instance().getActiveAccount();
          account?.nick_name = nickname;
          RTAccount.instance().setActiveAccount(account);
          RTAccount.instance().saveAccount();

          setSuccess();

          Event.eventBus.fire(UserEvent(account, UserEventState.userme));
        },
        onError: (error, msg) {
          setError(error, message: msg);
        });
  }
}
