import 'package:dio/dio.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/event/event.dart';
import 'package:lighthouse/event/user_event.dart';
import 'package:lighthouse/generated/l10n.dart';
import 'package:lighthouse/net/constant.dart';
import 'package:lighthouse/net/dio_util.dart';
import 'package:lighthouse/net/model/account.dart';
import 'package:lighthouse/net/rt_account.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/gaps.dart';
import 'package:lighthouse/res/styles.dart';
import 'package:lighthouse/router/routers.dart';
import 'package:lighthouse/ui/page/base_page.dart';
import 'package:lighthouse/ui/widget/button/gradient_button.dart';
import 'package:lighthouse/ui/widget/common_scroll_view.dart';
import 'package:lighthouse/ui/widget/textfield/account_text_field.dart';
import 'package:lighthouse/ui/widget/textfield/pwd_text_field.dart';
import 'package:lighthouse/ui/widget/textfield/verify_text_field.dart';
import 'package:lighthouse/utils/date_util.dart';
import 'package:lighthouse/utils/encrypt_util.dart';
import 'package:lighthouse/utils/object_util.dart';
import 'package:lighthouse/utils/other_util.dart';
import 'package:lighthouse/utils/toast_util.dart';

class LoginSmsPage extends StatefulWidget {
  @override
  _LoginSmsPageState createState() => _LoginSmsPageState();
}

class _LoginSmsPageState extends State<LoginSmsPage> with BasePageMixin<LoginSmsPage> {

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _verifyController = TextEditingController();
  final FocusNode _phoneNode = FocusNode();
  final FocusNode _verifyNode = FocusNode();

  String _area_code;
  bool _loginEnabled = false;

  @override
  void initState() {
    Account account = RTAccount.instance().loadAccount();
    if (account != null) {
      var t = account.phone?.split(' ');
      _area_code = t?.first;
      _phoneController.text = t?.last;
    } else {
      _area_code = '+86';
    }
    super.initState();
  }

  void _checkInput() {
    setState(() {
      if (ObjectUtil.isEmpty(_phoneController.text) || ObjectUtil.isEmpty(_verifyController.text)) {
        _loginEnabled = false;
      } else {
        _loginEnabled = true;
      }
    });
  }

  void _login() {
    String phone = _area_code + ' ' + _phoneController.text;
    String pwd = _verifyController.text;
    int nonce = DateUtil.getNowDateMs() * 1000;
    String pwdMd5 = EncryptUtil.encodeMd5(EncryptUtil.encodeMd5(pwd) + nonce.toString());

    Map<String, dynamic> params = {
      'phone': phone,
      'password': pwdMd5,
      'nonce': nonce,
    };

    showProgress(content: S.current.logingin);
    DioUtil.getInstance().post(Constant.URL_LOGIN, params: params,
        successCallBack: (data, headers) {
          closeProgress();
          Account account = Account.fromJson(data['data']);
          account.token = headers.value(Constant.KEY_USER_TOKEN);
          RTAccount.instance().setActiveAccount(account);
          RTAccount.instance().saveAccount();
          ToastUtil.success(S.current.loginSuccess);

          Navigator.pop(context);
          Routers.navigateTo(context, Routers.mainPage, clearStack: true);

          Event.eventBus.fire(UserEvent(account, UserEventState.login));

        },
        errorCallBack: (error) {
          closeProgress();
          ToastUtil.error(error[Constant.MESSAGE]);
        });
  }

  void _selectArea() {

    Map<String, dynamic> params = {
      'areaCode': _area_code,
    };

    Routers.navigateToResult(context, Routers.areaPage, params, (result) {
      setState(() {
        _area_code = result;
      });
    }, transition: TransitionType.materialFullScreenDialog);
  }

  void _pwdLogin() {

    Routers.navigateTo(context, Routers.loginPage, clearStack: true);
  }

  void _jump2Register() {
    Map<String, dynamic> params = {
      'title': 'xxx',
      'url': 'https://www.baidu.com',
    };

    Routers.navigateTo(context, Routers.webviewPage, params: params);
  }

  Future<bool> _getVCode() {
    ToastUtil.normal('获取验证码 click');
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colours.white,
        appBar: AppBar(
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Colours.white,
          automaticallyImplyLeading: false,
        ),
        body: CommonScrollView(
          keyboardConfig: OtherUtil.getKeyboardActionsConfig(context, <FocusNode>[_phoneNode, _verifyNode]),
          padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 20.0),
          children: <Widget>[
            Text(
              S.of(context).smsLogin,
              style: TextStyles.textBlackBold26,
            ),
            Gaps.vGap32,
            AccountTextField(
              focusNode: _phoneNode,
              controller: _phoneController,
              onTextChanged: _checkInput,
              areaCode: _area_code,
              onPrefixPressed: _selectArea,
            ),
            Gaps.vGap16,
            VerifyTextField(
              focusNode: _verifyNode,
              controller: _verifyController,
              onTextChanged: _checkInput,
              getVCode: _getVCode,
            ),
            Gaps.vGap16,
            GradientButton(
              width: double.infinity,
              height: 48,
              text: S.of(context).login,
              colors: <Color>[   //背景渐变
                Colours.app_main,
                Colours.app_main_500
              ],
              onPressed: _loginEnabled ? _login : null,
            ),
            Container(
              height: 40.0,
              alignment: Alignment.centerRight,
              child: InkWell(
                child: Text(
                  S.of(context).pwdLogin,
                  style: TextStyles.textGray400_w400_14,
                ),
                onTap: _pwdLogin,
              ),
            ),
          ],
          bottomButton: Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.only(bottom: 20.0),
              child: Text.rich(TextSpan(
                  children: [
                    TextSpan(text: S.of(context).noAccount, style: TextStyles.textGray400_w400_14),
                    TextSpan(text: S.of(context).clickRegister, style: TextStyles.textMain14,
                        recognizer: new TapGestureRecognizer()..onTap = _jump2Register),
                  ]
              ))
          ),
        )
    );
  }

}