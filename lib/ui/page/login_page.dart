import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/constant/constant.dart';
import 'package:lighthouse/generated/l10n.dart';
import 'package:lighthouse/net/dio_util.dart';
import 'package:lighthouse/net/model/account.dart';
import 'package:lighthouse/net/rt_account.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/gaps.dart';
import 'package:lighthouse/res/styles.dart';
import 'package:lighthouse/ui/widget/appbar/common_app_bar.dart';
import 'package:lighthouse/ui/widget/button/gradient_button.dart';
import 'package:lighthouse/ui/widget/common_scroll_view.dart';
import 'package:lighthouse/ui/widget/textfield/account_text_field.dart';
import 'package:lighthouse/ui/widget/textfield/pwd_text_field.dart';
import 'package:lighthouse/utils/date_util.dart';
import 'package:lighthouse/utils/encrypt_util.dart';
import 'package:lighthouse/utils/object_util.dart';
import 'package:lighthouse/utils/other_util.dart';
import 'package:lighthouse/utils/toast_util.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final FocusNode _phoneNode = FocusNode();
  final FocusNode _pwdNode = FocusNode();

  bool _loginEnabled = false;

  @override
  void initState() {
    Account account = RTAccount.instance().loadAccount();
    if (account != null) {
      var t = account.phone?.split(' ');
      _phoneController.text = t?.last;
    }
    super.initState();
  }

  void _checkInput() {
    setState(() {
      if (ObjectUtil.isEmpty(_phoneController.text) || ObjectUtil.isEmpty(_pwdController.text)) {
        _loginEnabled = false;
      } else {
        _loginEnabled = true;
      }
    });
  }

  void _login() {
    String phone = '+86 ' + _phoneController.text;
    String pwd = _pwdController.text;
    int nonce = DateUtil.getNowDateMs() * 1000;
    String pwdMd5 = EncryptUtil.encodeMd5(EncryptUtil.encodeMd5(pwd) + nonce.toString());

    Map<String, dynamic> params = {
      'phone': phone,
      'password': pwdMd5,
      'nonce': nonce,
    };
    DioUtil.getInstance().post(Constant.URL_LOGIN, params, (data, headers) {
      Account account = Account.fromJson(data['data']);
      account.token = headers.value(Constant.KEY_USER_TOKEN);
      RTAccount.instance().setActiveAccount(account);
      RTAccount.instance().saveAccount();
      ToastUtil.success(S.current.loginSuccess);
    }, (error) {
      ToastUtil.error(error[Constant.MESSAGE]);
    });
  }

  void _forgetPwd() {

  }

  void _jump2Register() {

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
          backgroundColor: Colors.white,
          appBar: CommonAppBar(
            backVisible: false,
          ),
          body: CommonScrollView(
            keyboardConfig: OtherUtil.getKeyboardActionsConfig(context, <FocusNode>[_phoneNode, _pwdNode]),
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
            children: <Widget>[
              Text(
                S.of(context).welcomeLogin,
                style: TextStyles.textBlackBold26,
              ),
              Gaps.vGap32,
              AccountTextField(
                controller: _phoneController,
                onTextChanged: _checkInput,
              ),
              Gaps.vGap16,
              PwdTextField(
                controller: _pwdController,
                onTextChanged: _checkInput,
              ),
              Gaps.vGap16,
              GradientButton(
                width: double.infinity,
                height: 48,
                text: S.of(context).login,
                colors: <Color>[   //背景渐变
                  Colours.app_main,
                  Colours.dark_app_main
                ],
                onPressed: _loginEnabled ? _login : null,
              ),
              Container(
                height: 40.0,
                alignment: Alignment.centerRight,
                child: InkWell(
                  child: Text(
                    S.of(context).forgetPassword,
                    style: TextStyles.textGray14,
                  ),
                  onTap: _forgetPwd,
                ),
              ),
            ],
            bottomButton: Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(bottom: 20.0),
                child: Text.rich(TextSpan(
                    children: [
                      TextSpan(text: S.of(context).noAccount, style: TextStyles.textGray14),
                      TextSpan(text: S.of(context).clickRegister, style: TextStyles.textMain14,
                          recognizer: new TapGestureRecognizer()..onTap = _jump2Register),
                    ]
                ))
            ),
          )
    );
  }

}
