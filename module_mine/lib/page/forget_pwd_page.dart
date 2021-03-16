import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/model/account.dart';
import 'package:library_base/global/rt_account.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/widget/button/back_button.dart';
import 'package:library_base/widget/button/gradient_button.dart';
import 'package:library_base/widget/clickbar/setting_clickbar.dart';
import 'package:library_base/widget/common_scroll_view.dart';
import 'package:library_base/widget/textfield/account_text_field.dart';
import 'package:library_base/widget/textfield/pwd_text_field.dart';
import 'package:library_base/widget/textfield/verify_text_field.dart';
import 'package:library_base/utils/encrypt_util.dart';
import 'package:library_base/utils/object_util.dart';
import 'package:library_base/utils/other_util.dart';
import 'package:library_base/utils/toast_util.dart';
import 'package:module_mine/viewmodel/modify_pwd_model.dart';
import 'package:module_mine/viewmodel/verify_model.dart';

class ForgetPwdPage extends StatefulWidget {
  @override
  _ForgetPwdPageState createState() => _ForgetPwdPageState();
}

class _ForgetPwdPageState extends State<ForgetPwdPage> with BasePageMixin<ForgetPwdPage> {

  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneNode = FocusNode();

  final TextEditingController _verifyController = TextEditingController();
  final FocusNode _verifyNode = FocusNode();

  final TextEditingController _pwdController = TextEditingController();
  final FocusNode _pwdNode = FocusNode();

  final TextEditingController _pwdRepeatController = TextEditingController();
  final FocusNode _pwdRepeatNode = FocusNode();

  ModifyPwdModel _modifyPwdModel;
  VerifyModel _verifyModel;

  String _area_code = '+86';
  bool _saveEnabled = false;

  @override
  void initState() {
    super.initState();
    initViewModel();
  }

  void initViewModel() {
    _modifyPwdModel = ModifyPwdModel();
    _verifyModel = VerifyModel();

    _modifyPwdModel.addListener(() {
      if (_modifyPwdModel.isBusy) {
        showProgress(content: '');

      } else if (_modifyPwdModel.isError) {
        closeProgress();
        ToastUtil.error(_modifyPwdModel.viewStateError.message);

      } else if (_modifyPwdModel.isSuccess) {
        closeProgress();
        ToastUtil.success(S.of(context).modifySuccess);

        Navigator.pop(context);
      }
    });

    _verifyModel.addListener(() {
      if (_verifyModel.isBusy) {

      } else if (_verifyModel.isError) {
        ToastUtil.waring(_verifyModel.viewStateError.message);

      } else if (_verifyModel.isSuccess) {
        ToastUtil.normal(S.current.verifySended);
      }
    });
  }

  void _checkInput() {
    setState(() {
      if (ObjectUtil.isEmpty(_phoneController.text) ||
          ObjectUtil.isEmpty(_verifyController.text) ||
          ObjectUtil.isEmpty(_pwdController.text) ||
          ObjectUtil.isEmpty(_pwdRepeatController.text)) {
        _saveEnabled = false;
      } else {
        _saveEnabled = true;
      }
    });
  }

  void _submit() {
    String phone = _phoneController.text;
    String verifyCode = _verifyController.text;
    String pwd = _pwdController.text;
    String pwdRepeat = _pwdRepeatController.text;
    String pwdMd5 = EncryptUtil.encodeMd5(pwd);

    if (pwd != pwdRepeat) {
      ToastUtil.error(S.of(context).passwordNotSame);
      return;
    }

    _modifyPwdModel.forgetPwd(phone, pwd, pwdRepeat, verifyCode);
  }

  Future<bool> _getVCode() {
    String phone = _phoneController.text;
    if (ObjectUtil.isEmptyString(phone)) {
      ToastUtil.normal(S.current.loginPhoneHint);
      return Future.value(false);
    }

    return _verifyModel.getVCode(phone, VerifyModel.SMS_FORGET_PWD);
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
            title: Text(S.of(context).forgetPassword, style: TextStyles.textBlack16)
        ),
        body: CommonScrollView(
          keyboardConfig: OtherUtil.getKeyboardActionsConfig(context, <FocusNode>[_verifyNode, _pwdNode, _pwdRepeatNode]),
          padding: const EdgeInsets.only(top: 8.0),
          children: <Widget>[
            AccountTextField(
              backgroundColor: Colours.white,
              focusedBorder: BorderStyles.outlineInputR0White,
              enabledBorder: BorderStyles.outlineInputR0White,
              focusNode: _phoneNode,
              controller: _phoneController,
              onTextChanged: _checkInput,
              areaCode: _area_code,
              onPrefixPressed: (){},
            ),

            VerifyTextField(
              backgroundColor: Colours.white,
              focusedBorder: BorderStyles.outlineInputR0White,
              enabledBorder: BorderStyles.outlineInputR0White,
              focusNode: _verifyNode,
              controller: _verifyController,
              onTextChanged: _checkInput,
              getVCode: _getVCode,
            ),
            Gaps.line,
            PwdTextField(
              prefixText: S.of(context).inputPassword,
              hintText: S.of(context).passwordHintTips,
              backgroundColor: Colours.white,
              focusedBorder: BorderStyles.outlineInputR0White,
              enabledBorder: BorderStyles.outlineInputR0White,
              focusNode: _pwdNode,
              controller: _pwdController,
              onTextChanged: _checkInput,
            ),
            Gaps.line,
            PwdTextField(
              prefixText: S.of(context).repeatPassword,
              hintText: S.of(context).passwordHintTips,
              backgroundColor: Colours.white,
              focusedBorder: BorderStyles.outlineInputR0White,
              enabledBorder: BorderStyles.outlineInputR0White,
              focusNode: _pwdRepeatNode,
              controller: _pwdRepeatController,
              onTextChanged: _checkInput,
            ),
            Gaps.vGap16,

            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: GradientButton(
                width: double.infinity,
                height: 48,
                text: S.of(context).confirmNotify,
                colors: <Color>[   //背景渐变
                  Colours.app_main,
                  Colours.app_main_500
                ],
                onPressed: _saveEnabled ? _submit : null,
              ),
            )

          ],
        )
    );
  }

}
