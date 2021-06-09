import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/model/account.dart';
import 'package:library_base/global/rt_account.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/router/routers.dart';
import 'package:library_base/widget/button/gradient_button.dart';
import 'package:library_base/widget/common_scroll_view.dart';
import 'package:library_base/widget/textfield/pwd_text_field.dart';
import 'package:library_base/utils/encrypt_util.dart';
import 'package:library_base/utils/object_util.dart';
import 'package:library_base/utils/other_util.dart';
import 'package:library_base/utils/toast_util.dart';
import 'package:module_mine/viewmodel/modify_pwd_model.dart';
import 'package:module_mine/mine_router.dart';

class SetPwdPage extends StatefulWidget {
  @override
  _SetPwdPageState createState() => _SetPwdPageState();
}

class _SetPwdPageState extends State<SetPwdPage> with BasePageMixin<SetPwdPage> {

  final TextEditingController _pwdController = TextEditingController();
  final FocusNode _pwdNode = FocusNode();

  final TextEditingController _pwdRepeatController = TextEditingController();
  final FocusNode _pwdRepeatNode = FocusNode();

  late ModifyPwdModel _modifyPwdModel;

  bool _saveEnabled = false;

  @override
  void initState() {
    super.initState();
    initViewModel();
  }

  void initViewModel() {
    _modifyPwdModel = ModifyPwdModel();

    _modifyPwdModel.addListener(() {
      if (_modifyPwdModel.isBusy) {
        showProgress(content: '');

      } else if (_modifyPwdModel.isError) {
        closeProgress();
        ToastUtil.error(_modifyPwdModel.viewStateError!.message!);

      } else if (_modifyPwdModel.isSuccess) {
        closeProgress();
        ToastUtil.success(S.of(context).setSuccess);

        Navigator.pop(context);
        Routers.navigateTo(context, MineRouter.isRunModule ? Routers.minePage : Routers.mainPage, clearStack: true);
      }
    });

  }

  void _checkInput() {
    setState(() {
      if (ObjectUtil.isEmpty(_pwdController.text) || ObjectUtil.isEmpty(_pwdRepeatController.text)) {
        _saveEnabled = false;
      } else {
        _saveEnabled = true;
      }
    });
  }

  void _skip() {
    Navigator.pop(context);
    Routers.navigateTo(context, MineRouter.isRunModule ? Routers.minePage : Routers.mainPage, clearStack: true);
  }

  void _submit() {
    String pwd = _pwdController.text;
    String pwdRepeat = _pwdRepeatController.text;
    String pwdMd5 = EncryptUtil.encodeMd5(pwd);

    if (pwd != pwdRepeat) {
      ToastUtil.error(S.of(context).passwordNotSame);
      return;
    }

    _modifyPwdModel.setPwd(pwd, pwdRepeat);
  }

  @override
  Widget build(BuildContext context) {

    Account? account = RTAccount.instance()!.getActiveAccount();
    
    return Scaffold(
        backgroundColor: Colours.white,
        appBar: AppBar(
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Colours.white,
          automaticallyImplyLeading: false,
        ),
        body: CommonScrollView(
          keyboardConfig: OtherUtil.getKeyboardActionsConfig(context, <FocusNode>[_pwdNode, _pwdRepeatNode]),
          padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 20.0),
          children: <Widget>[
            Gaps.vGap32,
            Container(
                padding: EdgeInsets.only(top: 10),
                alignment: Alignment.topLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                        height: 22,
                        padding: EdgeInsets.only(bottom: 1),
                        alignment: Alignment.centerLeft,
                        child: Text(S.of(context).setPassword,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.textGray800_w400_17)
                    ),

                    Container(
                        height: 22,
                        alignment: Alignment.centerLeft,
                        child: Text(S.of(context).setPasswordTips,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.textGray400_w400_12)
                    ),

                  ],
                )
            ),

            Gaps.vGap32,
            PwdTextField(
              prefixText: S.of(context).inputPassword,
              hintText: S.of(context).passwordHintTips,
              hintStyle: TextStyles.textGray400_w400_12,
              backgroundColor: Colours.white,
              focusNode: _pwdNode,
              controller: _pwdController,
              onTextChanged: _checkInput,
            ),
            PwdTextField(
              prefixText: S.of(context).repeatPassword,
              hintText: S.of(context).passwordHintTips,
              hintStyle: TextStyles.textGray400_w400_12,
              backgroundColor: Colours.white,
              focusNode: _pwdRepeatNode,
              controller: _pwdRepeatController,
              onTextChanged: _checkInput,
            ),

            Gaps.vGap32,
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
            ),
            Gaps.vGap16,
            Container(
              height: 40.0,
              alignment: Alignment.center,
              child: InkWell(
                child: Text(
                  S.of(context).skip,
                  style: TextStyles.textGray500_w400_15,
                ),
                onTap: _skip,
              ),
            ),
          ],
        )
    );
  }

}
