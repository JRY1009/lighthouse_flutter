

import 'package:library_base/event/event.dart';
import 'package:library_base/event/user_event.dart';
import 'package:library_base/mvvm/view_state_model.dart';
import 'package:library_base/net/apis.dart';
import 'package:library_base/net/dio_util.dart';
import 'package:library_base/model/account.dart';
import 'package:library_base/global/rt_account.dart';

class BindModel extends ViewStateModel {

  BindModel();

  Future bindWechat(code) {

    Account? account = RTAccount.instance()!.getActiveAccount();

    Map<String, dynamic> params = {
      'id': account?.account_id,
      'code': code,
    };

    setBusy();

    return DioUtil.getInstance()!.requestNetwork(Apis.URL_BIND_WECHAT, "post", data: params,
        cancelToken: cancelToken,
        onSuccess: (dynamic data) {

          Account account = RTAccount.instance()!.getActiveAccount()!;
          account.wechat_account!.binded = true;

          Event.eventBus.fire(UserEvent(account, UserEventState.userme));
          setSuccess();
        },
        onError: (errno, msg) {
          setError(errno!, message: msg);
        });
  }

  Future unbindWechat() {

    Map<String, dynamic> params = {
    };

    setBusy();

    return DioUtil.getInstance()!.requestNetwork(Apis.URL_UNBIND_WECHAT, "post", data: params,
        cancelToken: cancelToken,
        onSuccess: (dynamic data) {

          Account account = RTAccount.instance()!.getActiveAccount()!;
          account.wechat_account!.binded = false;

          Event.eventBus.fire(UserEvent(account, UserEventState.userme));
          setSuccess();
        },
        onError: (errno, msg) {
          setError(errno!, message: msg);
        });
  }
}
