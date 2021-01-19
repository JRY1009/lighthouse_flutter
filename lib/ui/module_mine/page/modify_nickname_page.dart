import 'package:flutter/cupertino.dart';
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
import 'package:lighthouse/ui/page/base_page.dart';
import 'package:lighthouse/ui/widget/button/back_button.dart';
import 'package:lighthouse/ui/widget/common_scroll_view.dart';
import 'package:lighthouse/ui/widget/textfield/normal_text_field.dart';
import 'package:lighthouse/utils/object_util.dart';
import 'package:lighthouse/utils/other_util.dart';
import 'package:lighthouse/utils/toast_util.dart';

class ModifyNicknamePage extends StatefulWidget {
  @override
  _ModifyNicknamePageState createState() => _ModifyNicknamePageState();
}

class _ModifyNicknamePageState extends State<ModifyNicknamePage> with BasePageMixin<ModifyNicknamePage> {

  final TextEditingController _textController = TextEditingController();
  final FocusNode _textNode = FocusNode();

  bool _saveEnabled = false;

  @override
  void initState() {
    Account account = RTAccount.instance().getActiveAccount();
    _textController.text = account?.nick_name;

    _checkInput();

    super.initState();
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

    Map<String, dynamic> params = {
      'nickname': nickname,
    };

    showProgress(showContent: false);
    DioUtil.getInstance().post(Constant.URL_SUB_PERSON_DATA, params: params,
        successCallBack: (data, headers) {
          closeProgress();
          Account account = RTAccount.instance().getActiveAccount();
          account?.nick_name = nickname;
          RTAccount.instance().setActiveAccount(account);

          ToastUtil.success(S.current.saveSuccess);

          Navigator.pop(context);
          Event.eventBus.fire(UserEvent(account, UserEventState.userme));

        },
        errorCallBack: (error) {
          closeProgress();
          ToastUtil.error(error[Constant.MESSAGE]);
        });
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
