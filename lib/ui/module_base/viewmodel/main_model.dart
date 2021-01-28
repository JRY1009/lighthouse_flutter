
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:flutter_xupdate/flutter_xupdate.dart';
import 'package:library_base/event/event.dart';
import 'package:library_base/event/main_jump_event.dart';
import 'package:library_base/event/user_event.dart';
import 'package:lighthouse/router/routers.dart';
import 'package:library_base/utils/device_util.dart';

class MainModel extends ValueNotifier<int> {

  BuildContext context;
  PageController pageController;

  StreamSubscription userSubscription;
  StreamSubscription mainJumpSubscription;

  MainModel() : super(0);

  void listenEvent(BuildContext context, PageController pageController) {
    this.context = context;
    this.pageController = pageController;

    userSubscription?.cancel();
    mainJumpSubscription?.cancel();

    userSubscription = Event.eventBus.on<UserEvent>().listen((event) {

      if (event.state == UserEventState.logout) {
        Routers.navigateTo(this.context, Routers.loginPage);
      }
    });

    mainJumpSubscription = Event.eventBus.on<MainJumpEvent>().listen((event) {

      if (event.page.value >= 0) {
        pageController.jumpToPage(event.page.value);
      }
    });
  }

  void initBugly() {
    FlutterBugly.init(androidAppId: '9e87287cfa', iOSAppId: 'ad8a0b5092');

    if (DeviceUtil.isAndroid) {
      FlutterBugly.onCheckUpgrade.listen((_upgradeInfo) {

        FlutterXUpdate.updateByInfo(
          updateEntity: UpdateEntity(
              hasUpdate: true,
              isIgnorable: false,
              isForce: _upgradeInfo.upgradeType == 2,
              versionCode: _upgradeInfo.versionCode,
              versionName: _upgradeInfo.versionName,
              updateContent: _upgradeInfo.newFeature,
              downloadUrl: _upgradeInfo.apkUrl,
              apkSize: (_upgradeInfo.fileSize / 1024).toInt(),
              apkMd5: _upgradeInfo.apkMd5
          ),
          themeColor: '#FF2872FC',
        );
      });
    }
  }

  @override
  void dispose() {
    userSubscription?.cancel();
    mainJumpSubscription?.cancel();
    super.dispose();
  }
}