

import 'package:lighthouse/event/event.dart';
import 'package:lighthouse/event/user_event.dart';
import 'package:lighthouse/mvvm/view_state_model.dart';
import 'package:lighthouse/net/constant.dart';
import 'package:lighthouse/net/dio_util.dart';
import 'package:lighthouse/net/model/account.dart';
import 'package:lighthouse/net/rt_account.dart';

class LoginModel extends ViewStateModel {

  AccountEntity loginResult;

  LoginModel();

  Future login(phone, password, nonce) {

    Map<String, dynamic> params = {
      'phone': phone,
      'password': password,
      'nonce': nonce
    };

    setBusy();

    return DioUtil.getInstance().requestNetwork(Constant.URL_LOGIN, "post", params: params,
        cancelToken: cancelToken,
        onSuccess: (data) {

          loginResult = AccountEntity.fromJson(data);
          loginResult.account_info.token = loginResult.token;

          //account.token = headers.value(Constant.KEY_USER_TOKEN);
          RTAccount.instance().setActiveAccount(loginResult.account_info);
          RTAccount.instance().saveAccount();

          setSuccess();
          Event.eventBus.fire(UserEvent(loginResult.account_info, UserEventState.login));
        },
        onError: (errno, msg) {
          loginResult = null;
          setError(errno, message: msg);
        });

  }

  Future loginSms(phone, verifyCode) {

    Map<String, dynamic> params = {
      'phone': phone,
      'verification_code': verifyCode,
    };

    setBusy();

    return DioUtil.getInstance().requestNetwork(Constant.URL_LOGIN, "post", params: params,
        cancelToken: cancelToken,
        onSuccess: (data) {

          loginResult = AccountEntity.fromJson(data);
          loginResult.account_info.token = loginResult.token;

          //account.token = headers.value(Constant.KEY_USER_TOKEN);
          RTAccount.instance().setActiveAccount(loginResult.account_info);
          RTAccount.instance().saveAccount();

          setSuccess();
          Event.eventBus.fire(UserEvent(loginResult.account_info, UserEventState.login));
        },
        onError: (errno, msg) {
          loginResult = null;
          setError(errno, message: msg);
        });
  }
}
