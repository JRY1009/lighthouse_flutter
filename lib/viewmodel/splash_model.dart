

import 'package:library_base/event/event.dart';
import 'package:library_base/event/user_event.dart';
import 'package:library_base/mvvm/view_state_model.dart';
import 'package:library_base/net/apis.dart';
import 'package:library_base/net/dio_util.dart';
import 'package:library_base/model/account.dart';
import 'package:library_base/global/rt_account.dart';
import 'package:library_base/utils/object_util.dart';

class SplashModel extends ViewStateModel {

  Account? loginResult;

  SplashModel();

  Future autoLogin() {

    Account? account = RTAccount.instance()!.loadAccount();
    if (account == null) {
      setError(Apis.ERRNO_UNKNOWN, message: Apis.ERRNO_UNKNOWN_MESSAGE);
      return Future.value();
    }

    if (ObjectUtil.isEmpty(account.token)) {
      setError(Apis.ERRNO_UNKNOWN, message: Apis.ERRNO_UNKNOWN_MESSAGE);
      return Future.value();
    }

    RTAccount.instance()!.setActiveAccount(account);

    return DioUtil.getInstance()!.requestNetwork(Apis.URL_GET_ACCOUNT_INFO, "get", params: {},
        cancelToken: cancelToken,
        onSuccess: (dynamic data) {

          loginResult = Account.fromJson(data);
          loginResult!.token = account.token;

          //account.token = headers.value(Apis.KEY_USER_TOKEN);
          RTAccount.instance()!.setActiveAccount(loginResult);
          RTAccount.instance()!.saveAccount();

          setSuccess();
          Event.eventBus.fire(UserEvent(loginResult, UserEventState.login));
        },
        onError: (errno, msg) {
          loginResult = null;
          setError(errno!, message: msg);
        });

  }

}
