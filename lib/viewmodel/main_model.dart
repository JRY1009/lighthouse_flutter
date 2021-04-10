
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:library_base/event/event.dart';
import 'package:library_base/event/main_jump_event.dart';
import 'package:library_base/event/user_event.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/router/routers.dart';
import 'package:library_base/utils/channel_util.dart';
import 'package:library_base/utils/device_util.dart';

class MainModel extends ValueNotifier<int> {

  BuildContext context;
  PageController pageController;
  List<GlobalKey<BasePageMixin>> keyList;

  StreamSubscription userSubscription;
  StreamSubscription mainJumpSubscription;

  MainModel() : super(0);

  void listenEvent(BuildContext context, PageController pageController, List<GlobalKey<BasePageMixin>> keyList) {
    this.context = context;
    this.pageController = pageController;
    this.keyList = keyList;

    userSubscription?.cancel();
    mainJumpSubscription?.cancel();

    userSubscription = Event.eventBus.on<UserEvent>().listen((event) {

      if (event.state == UserEventState.logout) {
        Routers.navigateTo(this.context, Routers.loginPage);
      }
    });

    mainJumpSubscription = Event.eventBus.on<MainJumpEvent>().listen((event) {

      if (event.page.value >= 0) {
        this.pageController.jumpToPage(event.page.value);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          this.keyList[event.page.value].currentState?.jump(params: event.params);
        });
      }
    });
  }

  Future<void> initBugly() async {
    if (!DeviceUtil.isMobile) {
      return Future.value(0);
    }

    String channel = await ChannelUtil.getChannel();

    FlutterBugly.init(
        androidAppId: '9e87287cfa',
        iOSAppId: 'ad8a0b5092',
        enableHotfix: true,
        channel: DeviceUtil.isAndroid ? channel : 'ios',
        customUpgrade: false
    );
  }

  @override
  void dispose() {
    userSubscription?.cancel();
    mainJumpSubscription?.cancel();
    super.dispose();
  }
}