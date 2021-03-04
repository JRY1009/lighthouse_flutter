import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:library_base/constant/constant.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/utils/log_util.dart';
import 'package:library_base/utils/toast_util.dart';
import 'package:library_base/widget/image/local_image.dart';

class ThirdLoginBar extends StatefulWidget {

  final Function(fluwx.WeChatAuthResponse) onWeChatAuthResponse;

  ThirdLoginBar({
    Key key,
    this.onWeChatAuthResponse
  }) : super(key: key);

  @override
  _ThirdLoginBarState createState() => _ThirdLoginBarState();
}

class _ThirdLoginBarState extends State<ThirdLoginBar> {

  @override
  void initState() {
    super.initState();
    fluwx.weChatResponseEventHandler.distinct((a, b) => a == b).listen((res) {
      if (res is fluwx.WeChatAuthResponse) {
        var _result = "state :${res.state} \n code:${res.code}";
        LogUtil.v("WeChatAuthResponse：$_result");

        if (widget.onWeChatAuthResponse != null) {
          widget.onWeChatAuthResponse(res);
        }
      }
    });
  }

  Future<void> _loginWechat(BuildContext context) async {
    bool result = await fluwx.isWeChatInstalled;
    if (!result) {
      ToastUtil.waring(S.of(context).shareWxNotInstalled);
      return;
    }

    fluwx.sendWeChatAuth(scope: "snsapi_userinfo", state: "lighthouse_flutter").then((data) {
      LogUtil.v("sendWeChatAuth：" + data.toString());

    }).catchError((e) {
      LogUtil.e('sendWeChatAuth error: $e');
    });
  }

  @override
  Widget build(BuildContext context) {

    Widget shareWechat = InkWell(
      onTap: () => _loginWechat(context),
      child: Container(
        child: Column(
          children: [
            LocalImage('icon_share_wechat', package: Constant.baseLib, width: 52, height: 52),
          ],
        ),
      ),
    );

    return Container(
        height: 105,
        color: Colours.white,
        margin: EdgeInsets.only(top: 8, bottom: 16),
        child:
        Column(
            children: <Widget>[
              Container(
                  height: 50.0,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 45,
                        height: 0.6,
                        child: Divider(color: Colours.gray_200, height: 0.6),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(S.of(context).thirdLogin,
                          style: TextStyles.textGray500_w400_13,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      SizedBox(
                        width: 45,
                        height: 0.6,
                        child: Divider(color: Colours.gray_200, height: 0.6),
                      ),
                    ],
                  )
              ),
              Container(
                  alignment: Alignment.topCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      shareWechat,
                    ],
                  )
              ),
            ]
        )
    );
  }
}