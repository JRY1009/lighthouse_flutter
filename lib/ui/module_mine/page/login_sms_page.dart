import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/model/account.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/global/rt_account.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:lighthouse/router/routers.dart';
import 'package:library_base/widget/button/gradient_button.dart';
import 'package:library_base/widget/common_scroll_view.dart';
import 'package:library_base/widget/image/local_image.dart';
import 'package:library_base/widget/textfield/account_text_field.dart';
import 'package:library_base/widget/textfield/verify_text_field.dart';
import 'package:lighthouse/ui/module_mine/viewmodel/login_model.dart';
import 'package:lighthouse/ui/module_mine/viewmodel/verify_model.dart';
import 'package:library_base/utils/date_util.dart';
import 'package:library_base/utils/object_util.dart';
import 'package:library_base/utils/other_util.dart';
import 'package:library_base/utils/toast_util.dart';

class LoginSmsPage extends StatefulWidget {
  @override
  _LoginSmsPageState createState() => _LoginSmsPageState();
}

class _LoginSmsPageState extends State<LoginSmsPage> with BasePageMixin<LoginSmsPage> {

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _verifyController = TextEditingController();
  final FocusNode _phoneNode = FocusNode();
  final FocusNode _verifyNode = FocusNode();

  LoginModel _loginModel;
  VerifyModel _verifyModel;

  String _area_code;
  bool _loginEnabled = false;

  @override
  void initState() {
    super.initState();

    initView();
    initViewModel();

    _checkInput();
  }

  void initView() {
    Account account = RTAccount.instance().loadAccount();
    if (account != null) {
      // var t = account.phone?.split(' ');
      // _area_code = t?.first;
      // _phoneController.text = t?.last;
      _area_code = '+86';
      _phoneController.text = account.phone;
    } else {
      _area_code = '+86';
    }
  }

  void initViewModel() {
    _loginModel = LoginModel();
    _verifyModel = VerifyModel();

    _loginModel.addListener(() {
      if (_loginModel.isBusy) {
        showProgress(content: S.current.logingin);

      } else if (_loginModel.isError) {
        closeProgress();
        ToastUtil.error(_loginModel.viewStateError.message);

      } else if (_loginModel.isSuccess) {
        closeProgress();

        Navigator.pop(context);
        Routers.navigateTo(context, Routers.mainPage, clearStack: true);
      }
    });

    _verifyModel.addListener(() {
      if (_verifyModel.isBusy) {
        showProgress(content: S.current.verifyin);

      } else if (_verifyModel.isError) {
        closeProgress();
        ToastUtil.error(_verifyModel.viewStateError.message);

      } else if (_verifyModel.isSuccess) {
        closeProgress();
        ToastUtil.normal(S.current.verifySended);
      }
    });
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
    //String phone = _area_code + ' ' + _phoneController.text;
    String phone = _phoneController.text;
    String verify = _verifyController.text;
    int nonce = DateUtil.getNowDateMs() * 1000;

    _loginModel.loginSms(phone, verify);
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

  Future<bool> _getVCode() async {
    String phone = _phoneController.text;
    if (ObjectUtil.isEmptyString(phone)) {
      ToastUtil.normal(S.current.loginPhoneHint);
      return Future.value(false);
    }

    return _verifyModel.getVCode(phone, VerifyModel.SMS_LOGIN);
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
            Gaps.vGap32,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: LocalImage('logo', width: 60, height: 60),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                      padding: EdgeInsets.only(left: 15, top: 10),
                      alignment: Alignment.topLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                              height: 22,
                              padding: EdgeInsets.only(bottom: 1),
                              alignment: Alignment.centerLeft,
                              child: Text(S.of(context).smsLogin,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyles.textGray800_w400_17)
                          ),

                          Container(
                              height: 22,
                              alignment: Alignment.centerLeft,
                              child: Text(S.of(context).smsLoginTips,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyles.textGray400_w400_12)
                          ),

                        ],
                      )),
                ),
              ],
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
            Gaps.vGap46,
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
            Gaps.vGap16,
            Container(
              height: 40.0,
              alignment: Alignment.center,
              child: InkWell(
                child: Text(
                  S.of(context).pwdLogin,
                  style: TextStyles.textGray500_w400_15,
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
                    TextSpan(text: S.of(context).loginPolicy, style: TextStyles.textGray400_w400_14),
                    TextSpan(text: S.of(context).registAgreement, style: TextStyles.textMain14,
                        recognizer: new TapGestureRecognizer()..onTap = _jump2Register),
                    TextSpan(text: '、', style: TextStyles.textGray400_w400_14),
                    TextSpan(text: S.of(context).privatePolicy, style: TextStyles.textMain14,
                        recognizer: new TapGestureRecognizer()..onTap = _jump2Register),
                  ]
              ))
          ),
        )
    );
  }

}
