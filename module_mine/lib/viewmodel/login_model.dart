

import 'package:library_base/event/event.dart';
import 'package:library_base/event/user_event.dart';
import 'package:library_base/mvvm/view_state_model.dart';
import 'package:library_base/net/apis.dart';
import 'package:library_base/net/dio_util.dart';
import 'package:library_base/model/account.dart';
import 'package:library_base/global/rt_account.dart';

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

    return DioUtil.getInstance().requestNetwork(Apis.URL_LOGIN, "post", params: params,
        cancelToken: cancelToken,
        onSuccess: (data) {

          loginResult = AccountEntity.fromJson(data);
          loginResult.account_info.token = loginResult.token;

          //account.token = headers.value(Apis.KEY_USER_TOKEN);
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

    return DioUtil.getInstance().requestNetwork(Apis.URL_LOGIN, "post", params: params,
        cancelToken: cancelToken,
        onSuccess: (data) {

          loginResult = AccountEntity.fromJson(data);
          loginResult.account_info.token = loginResult.token;

          //account.token = headers.value(Apis.KEY_USER_TOKEN);
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
