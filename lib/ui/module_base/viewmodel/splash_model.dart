

import 'package:lighthouse/event/event.dart';
import 'package:lighthouse/event/user_event.dart';
import 'package:lighthouse/mvvm/view_state_model.dart';
import 'package:lighthouse/net/constant.dart';
import 'package:lighthouse/net/dio_util.dart';
import 'package:lighthouse/net/model/account.dart';
import 'package:lighthouse/net/rt_account.dart';
import 'package:lighthouse/utils/object_util.dart';

class SplashModel extends ViewStateModel {

  Account loginResult;

  SplashModel();

  Future autoLogin() {

    Account account = RTAccount.instance().loadAccount();
    if (account == null) {
      setError(Constant.ERRNO_UNKNOWN, message: Constant.ERRNO_UNKNOWN_MESSAGE);
      return Future.value();
    }

    if (ObjectUtil.isEmpty(account.token)) {
      setError(Constant.ERRNO_UNKNOWN, message: Constant.ERRNO_UNKNOWN_MESSAGE);
      return Future.value();
    }

    RTAccount.instance().setActiveAccount(account);

    return DioUtil.getInstance().requestNetwork(Constant.URL_GET_ACCOUNT_INFO, "get", params: {},
        cancelToken: cancelToken,
        onSuccess: (data) {

          loginResult = Account.fromJson(data);
          loginResult.token = account.token;

          //account.token = headers.value(Constant.KEY_USER_TOKEN);
          RTAccount.instance().setActiveAccount(loginResult);
          RTAccount.instance().saveAccount();

          setSuccess();
          Event.eventBus.fire(UserEvent(loginResult, UserEventState.login));
        },
        onError: (errno, msg) {
          loginResult = null;
          setError(errno, message: msg);
        });

  }

}
