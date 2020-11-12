import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lighthouse/router/routers.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  SplashPageState createState() {
    return new SplashPageState();
  }
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pop(context);
      Routers.navigateTo(context, Routers.loginPage, clearStack: true, transition: TransitionType.none);
    });
//    Future.delayed(new Duration(seconds: 1), () {
//
//    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
        ),
        body: new Stack(
//          children: <Widget>[
//            Container(
//              alignment: Alignment.center,
//              child: LocalImage('img_splash_slogan',
//                width: 81.0,
//                height: 81.0,
//              ),
//            ),
//            Container(
//              alignment: Alignment.bottomCenter,
//              margin: EdgeInsets.only(bottom: 40),
//              child: LocalImage('img_splash_foot',
//                width: 120.0,
//                height: 10.0,
//              ),
//            )
//          ],
        ));
  }
}
