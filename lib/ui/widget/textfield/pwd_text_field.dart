import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lighthouse/generated/l10n.dart';
import 'package:lighthouse/res/gaps.dart';
import 'package:lighthouse/res/styles.dart';
import 'package:lighthouse/ui/widget/auto_image.dart';

//登陆注册界面edittext输入框
class PwdTextField extends StatefulWidget {

  final Function() onTextChanged;
  final TextEditingController controller;

  PwdTextField({
    Key key,
    @required this.controller,
    this.onTextChanged,
  }) : super(key: key);

  @override
  _AccountTextFieldState createState() => _AccountTextFieldState();
}

class _AccountTextFieldState extends State<PwdTextField> {

  bool _isShowPassWord = false;

  void _showPassWord() {
    setState(() {
      _isShowPassWord = !_isShowPassWord;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 48.0,
        child: TextField(
          controller: widget.controller,
          style: TextStyles.textBlack14,
          obscureText: !_isShowPassWord,
          keyboardType: TextInputType.visiblePassword,
          inputFormatters: [FilteringTextInputFormatter.deny(RegExp('[\u4e00-\u9fa5]'))], //不包含汉字
          maxLines: 1,
          maxLength: 16,
          decoration: InputDecoration(
            counterText: "",
            hintText: S.of(context).passwordHint,
            contentPadding: EdgeInsets.only(left: 20, right: 10),
            hintStyle: TextStyles.textGray14,
            focusedBorder: BorderStyles.outlineInputR50Main,
            enabledBorder: BorderStyles.outlineInputR50Gray,
            prefixIcon: Container(
              padding: EdgeInsets.all(14.0),
              child: LocalImage('ic_password', width: 20.0, height: 20.0),
            ),
            suffixIcon: IconButton(
              iconSize: 20.0,
              icon: LocalImage(_isShowPassWord ? 'ic_eye_close' : 'ic_eye_open', width: 20.0, height: 20.0),
              onPressed: _showPassWord,
            )
          ),
          onChanged: (text) {
            setState(() {
              widget.onTextChanged();
            });
          },
        )
    );
  }
}
