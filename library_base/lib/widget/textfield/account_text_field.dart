import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';

//登陆注册界面edittext输入框
class AccountTextField extends StatefulWidget {

  final FocusNode focusNode;
  final Function() onTextChanged;
  final Function() onPrefixPressed;
  final String areaCode;
  final TextEditingController controller;

  AccountTextField({
    Key key,
    @required this.controller,
    this.onTextChanged,
    this.focusNode,
    this.areaCode,
    this.onPrefixPressed,
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
          focusNode: widget.focusNode,
          controller: widget.controller,
          style: TextStyles.textBlack14,
          keyboardType: TextInputType.numberWithOptions(),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))] ,
          maxLines: 1,
          maxLength: 11,
          decoration: InputDecoration(
            counterText: "",
            hintText: S.of(context).loginPhoneHint,
            contentPadding: EdgeInsets.only(top: 16, bottom: 16),
            hintStyle: TextStyles.textGray400_w400_14,
            focusedBorder: BorderStyles.underlineInputMain,
            enabledBorder: BorderStyles.underlineInputGray,
            prefixIcon: InkWell(
                onTap: () {
                  widget.focusNode.unfocus();
                  widget.focusNode.canRequestFocus = false;
                  Future.delayed(Duration(milliseconds: 100), () {
                    widget.focusNode.canRequestFocus = true;
                  });
                  widget.onPrefixPressed();
                },
                child: Container(
                    padding: EdgeInsets.all(10.0),
                    constraints: BoxConstraints(minWidth: 80),
                    child:Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 2),
                            child: Text(widget.areaCode, style: TextStyles.textBlack14),
                          ),
                          Icon(Icons.arrow_drop_down, color: Colours.text_black, size: 18),
                        ]
                    )

                )),
            suffixIcon: !_isEmptyText() ? IconButton(
              iconSize: 20.0,
              icon: Icon(Icons.close, color: Colours.text_black, size: 20),
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
