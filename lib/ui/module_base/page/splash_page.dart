import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/router/routers.dart';
import 'package:lighthouse/ui/module_base/viewmodel/splash_model.dart';
import 'package:library_base/widget/image/local_image.dart';
import 'package:library_base/utils/image_util.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  SplashPageState createState() {
    return new SplashPageState();
  }
}

class SplashPageState extends State<SplashPage> {

  SplashModel _splashModel;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initViewModel();
    });
//    Future.delayed(new Duration(seconds: 1), () {
//
//    });
  }

  void initViewModel() {
    _splashModel = SplashModel();
    _splashModel.addListener(() {
      if (_splashModel.isError) {
        Navigator.pop(context);
        Routers.navigateTo(context, Routers.loginSmsPage, clearStack: true, transition: TransitionType.none);

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
