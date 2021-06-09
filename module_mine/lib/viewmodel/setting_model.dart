
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:library_base/event/event.dart';
import 'package:library_base/event/user_event.dart';
import 'package:library_base/mvvm/view_state_model.dart';
import 'package:library_base/net/apis.dart';
import 'package:library_base/net/dio_util.dart';
import 'package:library_base/model/account.dart';
import 'package:library_base/global/rt_account.dart';

class SettingModel extends ViewStateModel {

  StreamSubscription? userSubscription;

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

    return DioUtil.getInstance()!.requestNetwork(Apis.URL_UPLOAD_HEAD_ICON, "post", data: formData,
        cancelToken: cancelToken,
        onSuccess: (dynamic data) {

          Account account = RTAccount.instance()!.getActiveAccount()!;
          account.head_ico = data;
          RTAccount.instance()!.setActiveAccount(account);
          RTAccount.instance()!.saveAccount();

          setSuccess();
          Event.eventBus.fire(UserEvent(account, UserEventState.userme));
        },
        onError: (errno, msg) {
          setError(errno!, message: msg);
        });
  }

  @override
  void dispose() {
    userSubscription?.cancel();
    super.dispose();
  }
}
