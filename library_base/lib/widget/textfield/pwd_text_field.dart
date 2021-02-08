import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/res/gaps.dart';

//登陆注册界面edittext输入框
class PwdTextField extends StatefulWidget {

  final FocusNode focusNode;
  final Function() onTextChanged;
  final TextEditingController controller;

  final String prefixText;
  final Color backgroundColor;
  final InputBorder focusedBorder;
  final InputBorder enabledBorder;

  PwdTextField({
    Key key,
    @required this.controller,
    this.focusNode,
    this.onTextChanged,
    this.prefixText,
    this.backgroundColor,
    this.focusedBorder,
    this.enabledBorder
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

  bool _isEmptyText() {
    return widget.controller.text == null || widget.controller.text.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 48.0,
        color: widget.backgroundColor ?? Colours.transparent,
        child: TextField(
          focusNode: widget.focusNode,
          controller: widget.controller,
          style: TextStyles.textBlack14,
          obscureText: !_isShowPassWord,
          keyboardType: TextInputType.visiblePassword,
          inputFormatters: [FilteringTextInputFormatter.deny(RegExp('[\u4e00-\u9fa5]'))], //不包含汉字
          maxLines: 1,
          maxLength: 20,
          decoration: InputDecoration(
              counterText: "",
              hintText: S.of(context).passwordHint,
              contentPadding: EdgeInsets.only(top: 16, bottom: 16),
              hintStyle: TextStyles.textGray400_w400_14,
              focusedBorder: widget.focusedBorder ?? BorderStyles.underlineInputMain,
              enabledBorder: widget.enabledBorder ?? BorderStyles.underlineInputGray,
              prefixIcon: Container(
                  child: FlatButton(
                    padding: EdgeInsets.all(10.0),
                    minWidth: 80,
                    onPressed: null,
                    child: Container(
                        constraints: BoxConstraints(maxWidth: 60),
                      alignment: Alignment.centerLeft,
                      child:Text(widget.prefixText ?? S.of(context).password, style: TextStyles.textBlack14)
                    ),
                  )),
              suffixIcon: Container(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    !_isEmptyText() ? IconButton(
                      iconSize: 20.0,
                      constraints: BoxConstraints(
                        minWidth: 36,
                        minHeight: 48,
                      ),
                      icon: Icon(Icons.close, color: Colours.gray_400, size: 20),
                      onPressed: () {
                        setState(() {
                          widget.controller.text = "";
                          widget.onTextChanged();
                        });
                      },
                    ) : Gaps.empty,
                    IconButton(
                      iconSize: 20.0,
                      constraints: BoxConstraints(
                        minWidth: 48,
                        minHeight: 48,
                      ),
                      icon: Icon(_isShowPassWord ? Icons.visibility_off : Icons.visibility, color: Colours.gray_400, size: 20),
                      onPressed: _showPassWord,
                    )
                  ],
                )
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
