

import 'package:library_base/mvvm/view_state_model.dart';
import 'package:library_base/net/apis.dart';
import 'package:library_base/net/dio_util.dart';
import 'package:library_base/model/account.dart';

class ModifyPwdModel extends ViewStateModel {

  ModifyPwdModel();

  Future modifyPwd(src_password, new_password, confirmpassword) {

    Map<String, dynamic> params = {
      'src_password': src_password,
      'new_password': new_password,
      'confirm_password': confirmpassword,
    };

    setBusy();

    return DioUtil.getInstance()!.requestNetwork(Apis.URL_UPDATE_PASSWORD, "post", data: params,
        cancelToken: cancelToken,
        onSuccess: (data) {
          setSuccess();
        },
        onError: (errno, msg) {
          setError(errno!, message: msg);
        });
  }

  Future resetPwd(newPassword, confirmpassword, verifyCode) {

    Map<String, dynamic> params = {
      'new_password': newPassword,
      'confirm_password': confirmpassword,
      'verification_code': verifyCode,
    };

    setBusy();

    return DioUtil.getInstance()!.requestNetwork(Apis.URL_RESET_PASSWORD, "post", data: params,
        cancelToken: cancelToken,
        onSuccess: (data) {
          setSuccess();
        },
        onError: (errno, msg) {
          setError(errno!, message: msg);
        });
  }

  Future forgetPwd(phone, newPassword, confirmpassword, verifyCode) {

    Map<String, dynamic> params = {
      'phone': phone,
      'new_password': newPassword,
      'confirm_password': confirmpassword,
      'verification_code': verifyCode,
    };

    setBusy();

    return DioUtil.getInstance()!.requestNetwork(Apis.URL_FORGET_PASSWORD, "post", data: params,
        cancelToken: cancelToken,
        onSuccess: (data) {
          setSuccess();
        },
        onError: (errno, msg) {
          setError(errno!, message: msg);
        });
  }

  Future setPwd(password, confirmpassword) {

    Map<String, dynamic> params = {
      'password': password,
      'confirm_password': confirmpassword,
    };

    setBusy();

    return DioUtil.getInstance()!.requestNetwork(Apis.URL_SET_PASSWORD, "post", data: params,
        cancelToken: cancelToken,
        onSuccess: (data) {
          setSuccess();
        },
        onError: (errno, msg) {
          setError(errno!, message: msg);
        });
  }
}
