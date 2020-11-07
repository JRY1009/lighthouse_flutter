import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lighthouse/router/routers.dart';
import 'package:lighthouse/ui/widget/auto_image.dart';

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
    
    Future.delayed(new Duration(seconds: 1), () {

      Navigator.pop(context);
      Routers.navigateTo(context, Routers.loginPage, clearStack: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.white,
        body: new Column(
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: LocalImage('img_splash_slogan',
                  width: 126.0,
                  height: 119.0,
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.only(bottom: 40),
              child: LocalImage('img_splash_foot',
                width: 120.0,
                height: 10.0,
              ),
            )
          ],
        ));
  }
}
