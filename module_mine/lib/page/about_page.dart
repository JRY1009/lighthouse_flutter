import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:library_base/constant/constant.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/router/parameters.dart';
import 'package:library_base/router/routers.dart';
import 'package:library_base/widget/button/back_button.dart';
import 'package:library_base/widget/common_scroll_view.dart';
import 'package:library_base/widget/image/local_image.dart';
import 'package:package_info/package_info.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> with BasePageMixin<AboutPage> {

  String _version;

  @override
  void initState() {
    super.initState();

    PackageInfo.fromPlatform().then((value) {
      setState(() {
        _version = value?.version;
      });
    });

  }

  void _jump2Register() {
    Parameters params = Parameters()
      ..putString('title', 'xxx')
      ..putString('url', 'https://www.baidu.com');

    Routers.navigateTo(context, Routers.webviewPage, parameters: params);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colours.gray_100,
        appBar: AppBar(
            leading: BackButtonEx(),
            elevation: 0,
            brightness: Brightness.light,
            backgroundColor: Colours.white,
            centerTitle: true,
            title: Text(S.of(context).about + S.of(context).appName, style: TextStyles.textBlack16)
        ),
        body: Column(
          children: <Widget>[
            Expanded(flex: 3, child: Container()),
            Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  LocalImage('logo', width: 60, height: 60, package: Constant.baseLib),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(S.of(context).appName,
                          style: TextStyles.textGray800_w400_16,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Gaps.vGap8,
                        Text(S.of(context).slogan,
                          style: TextStyles.textGray400_w400_12,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  )
                ],
              )
            ),
            Gaps.vGap32,
            Container(
              height: 40.0,
              alignment: Alignment.center,
              child: InkWell(
                child: Text(
                  'V$_version',
                  style: TextStyles.textGray500_w400_15,
                ),
              ),
            ),
            Expanded(flex: 5, child: Container()),
            Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(bottom: 20.0),
                child: Text.rich(TextSpan(
                    children: [
                      TextSpan(text: S.of(context).registAgreement, style: TextStyles.textMain14,
                          recognizer: new TapGestureRecognizer()..onTap = _jump2Register),
                      TextSpan(text: '、', style: TextStyles.textGray400_w400_14),
                      TextSpan(text: S.of(context).privatePolicy, style: TextStyles.textMain14,
                          recognizer: new TapGestureRecognizer()..onTap = _jump2Register),
                    ]
                ))
            ),
          ],
        )
    );
  }

}
