
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:lighthouse/event/event.dart';
import 'package:lighthouse/event/user_event.dart';
import 'package:lighthouse/mvvm/view_state_model.dart';
import 'package:lighthouse/net/constant.dart';
import 'package:lighthouse/net/dio_util.dart';
import 'package:lighthouse/net/model/account.dart';
import 'package:lighthouse/net/rt_account.dart';

class SettingModel extends ViewStateModel {

  StreamSubscription userSubscription;

  SettingModel();

  void listenEvent() {
    userSubscription?.cancel();

    userSubscription = Event.eventBus.on<UserEvent>().listen((event) {
      notifyListeners();
    });
  }

  Future uploadHeadIcon(String path) async {

    final String name = path.substring(path.lastIndexOf('/') + 1);
    final FormData formData = FormData.fromMap(<String, dynamic>{
      'ico': await MultipartFile.fromFile(path, filename: name)
    });

    setBusy();

    return DioUtil.getInstance().requestNetwork(Constant.URL_UPLOAD_HEAD_ICON, "post", data: formData,
        cancelToken: cancelToken,
        onSuccess: (data) {

          Account account = RTAccount.instance().getActiveAccount();
          account?.head_ico = data;
          RTAccount.instance().setActiveAccount(account);
          RTAccount.instance().saveAccount();

          setSuccess();
        },
        onError: (errno, msg) {
          setError(errno, message: msg);
        });
  }

  @override
  void dispose() {
    userSubscription?.cancel();
    super.dispose();
  }
}
