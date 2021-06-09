import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/styles.dart';

//登陆注册界面验证码edittext输入框
class VerifyTextField extends StatefulWidget {

  final FocusNode? focusNode;
  final Function()? onTextChanged;
  final TextEditingController? controller;
  final Future<bool> Function() getVCode;

  final Color? backgroundColor;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;

  VerifyTextField({
    Key? key,
    required this.controller,
    required this.getVCode,
    this.focusNode,
    this.onTextChanged,
    this.backgroundColor,
    this.focusedBorder,
    this.enabledBorder
  }) : super(key: key);

  @override
  _VerifyTextFieldState createState() => _VerifyTextFieldState();
}

class _VerifyTextFieldState extends State<VerifyTextField> {

  bool _clickable = true;
  /// 倒计时秒数
  final int _second = 60;
  /// 当前秒数
  int? _currentSecond;
  StreamSubscription? _subscription;

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future _getVCode() async {
    final bool isSuccess = await widget.getVCode();
    if (isSuccess != null && isSuccess) {
      setState(() {
        _currentSecond = _second;
        _clickable = false;
      });
      _subscription = Stream.periodic(const Duration(seconds: 1), (int i) => i).take(_second).listen((int i) {
        setState(() {
          _currentSecond = _second - i - 1;
          _clickable = _currentSecond! < 1;
        });
      });
    }
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
          keyboardType: TextInputType.numberWithOptions(),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))] ,
          maxLines: 1,
          maxLength: 6,
          decoration: InputDecoration(
              counterText: "",
              hintText: S.of(context).verifyCodeHint,
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
                      child: Text(S.of(context).verifyCode, style: TextStyles.textBlack14)
                    ),
                  )),
              suffixIcon:  Container(
                  child: FlatButton(
                    padding: EdgeInsets.all(5.0),
                    minWidth: 90,
                    onPressed: _clickable ? _getVCode : null,
                    textColor: Colours.app_main,
                    color: Colors.transparent,
                    disabledTextColor: Colours.gray_400,
                    child: Container(
                        constraints: BoxConstraints(maxWidth: 80),
                        alignment: Alignment.center,
                        child: Text(_clickable ? S.of(context).getVerifyCode : '$_currentSecond' + S.of(context).verifyRetry, style: const TextStyle(fontSize: 14))
                    ),
                  )
              ),
          ),
          onChanged: (text) {
            setState(() {
              if (widget.onTextChanged != null) {
                widget.onTextChanged!();
              }
            });
          },
        )
    );
  }
}
