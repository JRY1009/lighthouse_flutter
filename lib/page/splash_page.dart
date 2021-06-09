import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:library_base/router/routers.dart';
import 'package:library_base/utils/device_util.dart';
import 'package:library_base/utils/object_util.dart';
import 'package:library_base/utils/sp_util.dart';
import 'package:lighthouse/viewmodel/splash_model.dart';
import 'package:package_info/package_info.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  SplashPageState createState() {
    return new SplashPageState();
  }
}

class SplashPageState extends State<SplashPage> {

  late SplashModel _splashModel;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      initViewModel();
    });
//    Future.delayed(new Duration(seconds: 1), () {
//
//    });
  }

  void initViewModel() {
    _splashModel = SplashModel();
    _splashModel.addListener(() async {
      if (_splashModel.isError) {

        if (DeviceUtil.isMobile) {

          String old_version = SPUtil.getString(SPUtil.key_old_version, defValue: '');

          PackageInfo packageInfo = await PackageInfo.fromPlatform();
          String cur_version = packageInfo.version;

          if (old_version == cur_version) {
            Navigator.pop(context);
            Routers.navigateTo(context, Routers.mainPage, clearStack: true, transition: TransitionType.none);
          } else {

            await SPUtil.putString(SPUtil.key_old_version, cur_version);

            Navigator.pop(context);
            Routers.navigateTo(context, Routers.loginSmsPage, clearStack: true, transition: TransitionType.none);
          }

        } else {
          Navigator.pop(context);
          Routers.navigateTo(context, Routers.mainPage, clearStack: true, transition: TransitionType.none);
        }

      } else if (_splashModel.isSuccess) {
        Navigator.pop(context);
        Routers.navigateTo(context, Routers.mainPage, clearStack: true, transition: TransitionType.none);
      }
    });

    _splashModel.autoLogin();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Color(0xFFF2F8FF),
        body: Column(
         children: <Widget>[
//           Expanded(child: Container()),
//           Container(
//             alignment: Alignment.center,
//             child: LocalImage('launch_image',
//               width: 176.0,
//               height: 200.0,
//             ),
//           ),
//           SizedBox(height: 200),
//           Container(
//             alignment: Alignment.bottomCenter,
//             decoration: BoxDecoration(
//               color: Colours.transparent,
//               image: DecorationImage(
//                 image: AssetImage(ImageUtil.getImgPath('launch_foot')),
//                 fit: BoxFit.fill,
//               ),
//             ),
//             child: AspectRatio (
//               aspectRatio: 1.63,
//             ),
//           ),
         ],
        ));
  }
}
