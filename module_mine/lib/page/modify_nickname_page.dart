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
import 'package:library_base/widget/common_scroll_view.dart';
import 'package:library_base/widget/textfield/normal_text_field.dart';
import 'package:library_base/utils/object_util.dart';
import 'package:library_base/utils/other_util.dart';
import 'package:library_base/utils/toast_util.dart';
import 'package:module_mine/viewmodel/modify_nickname_model.dart';

class ModifyNicknamePage extends StatefulWidget {
  @override
  _ModifyNicknamePageState createState() => _ModifyNicknamePageState();
}

class _ModifyNicknamePageState extends State<ModifyNicknamePage> with BasePageMixin<ModifyNicknamePage> {

  final TextEditingController _textController = TextEditingController();
  final FocusNode _textNode = FocusNode();

  bool _saveEnabled = false;

  ModifyNicknameModel _nicknameModel;

  @override
  void initState() {
    super.initState();
    initView();
    initViewModel();
  }

  void initView() {

    Account account = RTAccount.instance().getActiveAccount();
    _textController.text = account?.nick_name;

    _checkInput();
  }

  void initViewModel() {
    _nicknameModel = ModifyNicknameModel();
    _nicknameModel.addListener(() {
      if (_nicknameModel.isBusy) {
        showProgress(content: '');

      } else if (_nicknameModel.isError) {
        closeProgress();
        ToastUtil.error(_nicknameModel.viewStateError.message);

      } else if (_nicknameModel.isSuccess) {
        closeProgress();

        ToastUtil.success(S.of(context).modifySuccess);
        Navigator.pop(context);
      }
    });
  }

  void _checkInput() {
    setState(() {
      if (ObjectUtil.isEmpty(_textController.text.trim())) {
        _saveEnabled = false;
      } else {
        _saveEnabled = true;
      }
    });
  }

  void _submit() {
    String nickname = _textController.text.trim();
    _nicknameModel.modifyNickname(nickname);
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
            actions: <Widget>[
              FlatButton(
                  padding: EdgeInsets.all(0),
                  minWidth: 70,
                  disabledTextColor: Colours.gray_500,
                  textColor: Colours.app_main,
                  child: Text(S.of(context).save, style: TextStyle(fontSize: 14)),
                  onPressed: _saveEnabled ? _submit : null)
            ],
            centerTitle: true,
            title: Text(S.of(context).modifyNickname, style: TextStyles.textBlack16)
        ),
        body: CommonScrollView(
          keyboardConfig: OtherUtil.getKeyboardActionsConfig(context, <FocusNode>[_textNode]),
          padding: const EdgeInsets.only(top: 8.0),
          children: <Widget>[
            NormalTextField(
              focusNode: _textNode,
              controller: _textController,
              hint: S.of(context).modifyNicknameHint,
              onTextChanged: _checkInput,
            ),
            Gaps.vGap12,
            Container(
              height: 40.0,
              padding: EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              child: Text(
                S.of(context).modifyNicknameTips,
                style: TextStyles.textGray400_w400_14,
              ),
            ),
          ],
        )
    );
  }

}
