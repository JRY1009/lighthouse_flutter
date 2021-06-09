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
import 'package:library_base/widget/textfield/pwd_text_field.dart';
import 'package:library_base/widget/textfield/verify_text_field.dart';
import 'package:library_base/utils/encrypt_util.dart';
import 'package:library_base/utils/object_util.dart';
import 'package:library_base/utils/other_util.dart';
import 'package:library_base/utils/toast_util.dart';
import 'package:module_mine/viewmodel/modify_pwd_model.dart';
import 'package:module_mine/viewmodel/verify_model.dart';

class ModifyPwdPage extends StatefulWidget {
  @override
  _ModifyPwdPageState createState() => _ModifyPwdPageState();
}

class _ModifyPwdPageState extends State<ModifyPwdPage> with BasePageMixin<ModifyPwdPage> {

  final TextEditingController _verifyController = TextEditingController();
  final FocusNode _verifyNode = FocusNode();

  final TextEditingController _pwdController = TextEditingController();
  final FocusNode _pwdNode = FocusNode();

  final TextEditingController _pwdRepeatController = TextEditingController();
  final FocusNode _pwdRepeatNode = FocusNode();

  late ModifyPwdModel _modifyPwdModel;
  late VerifyModel _verifyModel;

  bool _saveEnabled = false;
  bool _had_password = false;

  @override
  void initState() {
    super.initState();
    Account? account = RTAccount.instance()!.getActiveAccount();
    _had_password = account?.had_password ?? false;
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
        ToastUtil.error(_modifyPwdModel.viewStateError!.message!);

      } else if (_modifyPwdModel.isSuccess) {
        closeProgress();
        ToastUtil.success(S.of(context).modifySuccess);

        Navigator.pop(context);
      }
    });

    _verifyModel.addListener(() {
      if (_verifyModel.isBusy) {
        showProgress(content: S.current.verifyin);

      } else if (_verifyModel.isError) {
        closeProgress();
        ToastUtil.waring(_verifyModel.viewStateError!.message!);

      } else if (_verifyModel.isSuccess) {
        closeProgress();
        ToastUtil.normal(S.current.verifySended);
      }
    });
  }

  void _checkInput() {
    setState(() {
      String unconfirmed = _verifyController.text;
      if (ObjectUtil.isEmpty(unconfirmed) || ObjectUtil.isEmpty(_pwdController.text) || ObjectUtil.isEmpty(_pwdRepeatController.text)) {
        _saveEnabled = false;
      } else {
        _saveEnabled = true;
      }
    });
  }

  void _submit() {
    String verifyCode = _verifyController.text;
    String pwd = _pwdController.text;
    String pwdRepeat = _pwdRepeatController.text;
    String pwdMd5 = EncryptUtil.encodeMd5(pwd);

    if (pwd != pwdRepeat) {
      ToastUtil.error(S.of(context).passwordNotSame);
      return;
    }

    _modifyPwdModel.resetPwd(pwd, pwdRepeat, verifyCode);
  }

  Future<bool> _getVCode() {
    Account? account = RTAccount.instance()!.getActiveAccount();
    if (account == null) {
      ToastUtil.normal(S.current.loginGuide);
      return Future.value(false);
    }

    String? phone = account.phone;
    if (ObjectUtil.isEmptyString(phone)) {
      ToastUtil.normal(S.current.loginPhoneError);
      return Future.value(false);
    }

    return _verifyModel.getVCode(phone!, VerifyModel.SMS_FORGET_PWD);
  }

  @override
  Widget build(BuildContext context) {

    Account? account = RTAccount.instance()!.getActiveAccount();
    
    return Scaffold(
        backgroundColor: Colours.gray_100,
        appBar: AppBar(
            leading: BackButtonEx(),
            elevation: 0,
            brightness: Brightness.light,
            backgroundColor: Colours.white,
            centerTitle: true,
            title: Text(_had_password ? S.of(context).modifyPassword : S.of(context).setPwd, style: TextStyles.textBlack16)
        ),
        body: CommonScrollView(
          keyboardConfig: OtherUtil.getKeyboardActionsConfig(context, <FocusNode>[_verifyNode, _pwdNode, _pwdRepeatNode]),
          padding: const EdgeInsets.only(top: 8.0),
          children: <Widget>[
            SettingClickBar(
              padding: EdgeInsets.symmetric(horizontal: 10),
              title: S.of(context).loginPhone,
              subTitle: account?.phoneSecret,
              titleStyle: TextStyles.textGray800_w400_14,
              iconSpace: false,
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
                text: S.of(context).confirm,
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
