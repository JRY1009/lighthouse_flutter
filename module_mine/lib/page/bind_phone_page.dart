import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:library_base/constant/constant.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/global/rt_account.dart';
import 'package:library_base/model/account.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/router/parameters.dart';
import 'package:library_base/router/routers.dart';
import 'package:library_base/utils/date_util.dart';
import 'package:library_base/utils/object_util.dart';
import 'package:library_base/utils/other_util.dart';
import 'package:library_base/utils/sp_util.dart';
import 'package:library_base/utils/toast_util.dart';
import 'package:library_base/widget/button/gradient_button.dart';
import 'package:library_base/widget/common_scroll_view.dart';
import 'package:library_base/widget/image/local_image.dart';
import 'package:library_base/widget/textfield/account_text_field.dart';
import 'package:library_base/widget/textfield/verify_text_field.dart';
import 'package:module_mine/mine_router.dart';
import 'package:module_mine/viewmodel/login_model.dart';
import 'package:module_mine/viewmodel/verify_model.dart';

class BindPhonePage extends StatefulWidget {
  @override
  _BindPhonePageState createState() => _BindPhonePageState();
}

class _BindPhonePageState extends State<BindPhonePage> with BasePageMixin<BindPhonePage> {

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _verifyController = TextEditingController();
  final FocusNode _phoneNode = FocusNode();
  final FocusNode _verifyNode = FocusNode();

  LoginModel _loginModel;
  VerifyModel _verifyModel;

  String _area_code;
  bool _loginEnabled = false;
  bool _agreeChecked = false;

  @override
  void initState() {
    super.initState();

    initView();
    initViewModel();

    _checkInput();
  }

  @override
  void dispose() {
    super.dispose();

    Account account = RTAccount.instance().getActiveAccount();
    if (account != null && ObjectUtil.isEmpty(account?.phone)) {
      RTAccount.instance().setActiveAccount(null);
    }
  }

  void initView() {
    _area_code = '+86';
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

        ToastUtil.success(S.current.bindSuccess);

        Routers.navigateTo(context, MineRouter.isRunModule ? Routers.minePage : Routers.mainPage, clearStack: true);
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
      if (ObjectUtil.isEmpty(_phoneController.text) || ObjectUtil.isEmpty(_verifyController.text)) {
        _loginEnabled = false;
      } else {
        _loginEnabled = true;
      }
    });
  }

  void _bind() {
    Account account = RTAccount.instance().getActiveAccount();
    if (account != null) {
      String phone = _phoneController.text;
      String verify = _verifyController.text;

      _loginModel.bindPhone(account?.account_id, phone, verify);
    }

  }

  void _selectArea() {
    Parameters params = Parameters()
      ..putString('areaCode', _area_code);

    Routers.navigateToResult(context, Routers.areaPage, params, (result) {
      setState(() {
        _area_code = result;
      });
    }, transition: TransitionType.materialFullScreenDialog);
  }

  Future<bool> _getVCode() async {
    String phone = _phoneController.text;
    if (ObjectUtil.isEmptyString(phone)) {
      ToastUtil.normal(S.current.loginPhoneHint);
      return Future.value(false);
    }

    return _verifyModel.getVCode(phone, VerifyModel.SMS_BIND_PHONE);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        resizeToAvoidBottomInset:false,
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: LocalImage('logo', package: Constant.baseLib, width: 60, height: 60),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                        height: 22,
                        padding: EdgeInsets.only(left: 15),
                        alignment: Alignment.centerLeft,
                        child: Text(S.of(context).bindPhone,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.textGray800_w600_20)
                    ),
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
              Gaps.vGap24,
              GradientButton(
                width: double.infinity,
                height: 48,
                text: S.of(context).bind,
                colors: <Color>[   //背景渐变
                  Colours.app_main,
                  Colours.app_main_500
                ],
                onPressed: _loginEnabled ? _bind : null,
              ),
            ],

        )
    );
  }

}
