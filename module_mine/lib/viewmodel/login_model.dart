

import 'package:library_base/event/event.dart';
import 'package:library_base/event/user_event.dart';
import 'package:library_base/mvvm/view_state_model.dart';
import 'package:library_base/net/apis.dart';
import 'package:library_base/net/dio_util.dart';
import 'package:library_base/model/account.dart';
import 'package:library_base/global/rt_account.dart';
import 'package:library_base/utils/object_util.dart';

class LoginModel extends ViewStateModel {

  AccountEntity? loginResult;

  LoginModel();

  Future login(phone, password, nonce) {

    Map<String, dynamic> params = {
      'phone': phone,
      'password': password,
      'nonce': nonce
    };

    setBusy();

    return DioUtil.getInstance()!.requestNetwork(Apis.URL_LOGIN, "post", data: params,
        cancelToken: cancelToken,
        onSuccess: (dynamic data) {

          loginResult = AccountEntity.fromJson(data);
          loginResult!.account_info!.token = loginResult!.token;

          //account.token = headers.value(Apis.KEY_USER_TOKEN);
          RTAccount.instance()!.setActiveAccount(loginResult!.account_info);
          RTAccount.instance()!.saveAccount();

          setSuccess();
          Event.eventBus.fire(UserEvent(loginResult!.account_info, UserEventState.login));
        },
        onError: (errno, msg) {
          loginResult = null;
          setError(errno!, message: msg);
        });

  }

  Future loginSms(phone, verifyCode) {

    Map<String, dynamic> params = {
      'phone': phone,
      'verification_code': verifyCode,
    };

    setBusy();

    return DioUtil.getInstance()!.requestNetwork(Apis.URL_LOGIN, "post", data: params,
        cancelToken: cancelToken,
        onSuccess: (dynamic data) {

          loginResult = AccountEntity.fromJson(data);
          loginResult!.account_info!.token = loginResult!.token;

          //account.token = headers.value(Apis.KEY_USER_TOKEN);
          RTAccount.instance()!.setActiveAccount(loginResult!.account_info);
          RTAccount.instance()!.saveAccount();

          setSuccess();
          Event.eventBus.fire(UserEvent(loginResult!.account_info, UserEventState.login));
        },
        onError: (errno, msg) {
          loginResult = null;
          setError(errno!, message: msg);
        });
  }

  Future loginWechat(code) {

    Map<String, dynamic> params = {
      'code': code,
    };

    setBusy();

    return DioUtil.getInstance()!.requestNetwork(Apis.URL_WECHAT_LOGIN, "post", data: params,
        cancelToken: cancelToken,
        onSuccess: (dynamic data) {

          loginResult = AccountEntity.fromJson(data);
          loginResult!.account_info!.token = loginResult!.token;

          //account.token = headers.value(Apis.KEY_USER_TOKEN);
          RTAccount.instance()!.setActiveAccount(loginResult!.account_info);

          if (!ObjectUtil.isEmpty(loginResult!.account_info?.phone)) {
            RTAccount.instance()!.saveAccount();
            Event.eventBus.fire(UserEvent(loginResult!.account_info, UserEventState.login));
          }

          setSuccess();
        },
        onError: (errno, msg) {
          loginResult = null;
          setError(errno!, message: msg);
        });
  }

  Future bindPhone(id, phone, verifyCode) {

    Map<String, dynamic> params = {
      'id': id,
      'phone': phone,
      'verification_code': verifyCode,
    };

    setBusy();

    return DioUtil.getInstance()!.requestNetwork(Apis.URL_BIND_PHONE, "post", data: params,
        cancelToken: cancelToken,
        onSuccess: (dynamic data) {

          loginResult = AccountEntity.fromJson(data);
          loginResult!.account_info!.token = loginResult!.token;

          RTAccount.instance()!.setActiveAccount(loginResult!.account_info);
          RTAccount.instance()!.saveAccount();

          Event.eventBus.fire(UserEvent(loginResult!.account_info, UserEventState.login));

          setSuccess();
        },
        onError: (errno, msg) {
          loginResult = null;
          setError(errno!, message: msg);
        });
  }
}
