import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/generated/l10n.dart';
import 'package:lighthouse/mvvm/base_page.dart';
import 'package:lighthouse/net/constant.dart';
import 'package:lighthouse/net/dio_util.dart';
import 'package:lighthouse/net/model/account.dart';
import 'package:lighthouse/net/rt_account.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/gaps.dart';
import 'package:lighthouse/res/styles.dart';
import 'package:lighthouse/ui/module_base/widget/button/back_button.dart';
import 'package:lighthouse/ui/module_base/widget/button/gradient_button.dart';
import 'package:lighthouse/ui/module_base/widget/clickbar/setting_clickbar.dart';
import 'package:lighthouse/ui/module_base/widget/common_scroll_view.dart';
import 'package:lighthouse/ui/module_base/widget/textfield/pwd_text_field.dart';
import 'package:lighthouse/ui/module_base/widget/textfield/verify_text_field.dart';
import 'package:lighthouse/utils/object_util.dart';
import 'package:lighthouse/utils/other_util.dart';
import 'package:lighthouse/utils/toast_util.dart';

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

  bool _saveEnabled = false;

  @override
  void initState() {
    super.initState();
  }

  void _checkInput() {
    setState(() {
      if (ObjectUtil.isEmpty(_verifyController.text) || ObjectUtil.isEmpty(_pwdController.text) || ObjectUtil.isEmpty(_pwdRepeatController.text)) {
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

    if (pwd != pwdRepeat) {
      ToastUtil.error(S.of(context).passwordNotSame);
      return;
    }

    Map<String, dynamic> params = {
      'xxx': verifyCode,
    };

    showProgress(showContent: false);
    DioUtil.getInstance().post(Constant.URL_SUB_PERSON_DATA, params: params,
        successCallBack: (data, headers) {
          closeProgress();

          ToastUtil.success(S.current.modifySuccess);

          Navigator.pop(context);

        },
        errorCallBack: (error) {
          closeProgress();
          ToastUtil.error(error[Constant.MESSAGE]);
        });
  }

  Future<bool> _getVCode() {
    ToastUtil.normal('获取验证码 click');
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {

    Account account = RTAccount.instance().getActiveAccount();
    
    return Scaffold(
        backgroundColor: Colours.gray_100,
        appBar: AppBar(
            leading: BackButtonEx(),
            elevation: 0,
            brightness: Brightness.light,
            backgroundColor: Colours.white,
            centerTitle: true,
        title: Text(S.of(context).modifyPassword, style: TextStyles.textBlack16)
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
              prefixText: S.of(context).newPassword,
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
