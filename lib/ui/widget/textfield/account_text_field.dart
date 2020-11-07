import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lighthouse/generated/l10n.dart';
import 'package:lighthouse/res/gaps.dart';
import 'package:lighthouse/res/styles.dart';
import 'package:lighthouse/ui/widget/auto_image.dart';

//登陆注册界面edittext输入框
class AccountTextField extends StatefulWidget {

  final Function() onTextChanged;
  final TextEditingController controller;

  AccountTextField({
    Key key,
    @required this.controller,
    this.onTextChanged,
  }) : super(key: key);

  @override
  _AccountTextFieldState createState() => _AccountTextFieldState();
}

class _AccountTextFieldState extends State<AccountTextField> {

  bool _isEmptyText() {
    return widget.controller.text == null || widget.controller.text.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 48.0,
        child: TextField(
          controller: widget.controller,
          style: TextStyles.textBlack14,
          keyboardType: TextInputType.numberWithOptions(),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))] ,
          maxLines: 1,
          maxLength: 11,
          decoration: InputDecoration(
            counterText: "",
            hintText: S.of(context).loginPhoneHint,
            contentPadding: EdgeInsets.only(left: 20, right: 10),
            hintStyle: TextStyles.textGray14,
            focusedBorder: BorderStyles.outlineInputR50Main,
            enabledBorder: BorderStyles.outlineInputR50Gray,
            prefixIcon: Container(
              padding: EdgeInsets.all(14.0),
              child: LocalImage('ic_phone', width: 20.0, height: 20.0),
            ),
            suffixIcon: !_isEmptyText() ? IconButton(
              iconSize: 14.0,
              icon: LocalImage('ic_close_black', width: 14.0, height: 14.0),
              onPressed: () {
                setState(() {
                  widget.controller.text = "";
                  widget.onTextChanged();
                });
              },
            ) : Gaps.empty,
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
