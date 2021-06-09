import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';

class NormalTextField extends StatefulWidget {

  final String? hint;
  final FocusNode? focusNode;
  final Function()? onTextChanged;
  final TextEditingController controller;

  NormalTextField({
    Key? key,
    required this.controller,
    this.focusNode,
    this.hint,
    this.onTextChanged,
  }) : super(key: key);

  @override
  _NormalTextFieldState createState() => _NormalTextFieldState();
}

class _NormalTextFieldState extends State<NormalTextField> {

  bool _isEmptyText() {
    return widget.controller.text == null || widget.controller.text.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 52.0,
        color: Colours.white,
        child: TextField(
          focusNode: widget.focusNode,
          controller: widget.controller,
          style: TextStyles.textBlack14,
          keyboardType: TextInputType.text,
          maxLines: 1,
          maxLength: 12,
          decoration: InputDecoration(
            counterText: "",
            hintText: widget.hint,
            contentPadding: EdgeInsets.only(left: 16, right: 10, top: 18, bottom: 18),
            hintStyle: TextStyles.textGray400_w400_14,
            focusedBorder: BorderStyles.outlineInputR0White,
            enabledBorder: BorderStyles.outlineInputR0White,
            suffixIcon: !_isEmptyText() ? IconButton(
              iconSize: 20.0,
              icon: Icon(Icons.close, color: Colours.text_black, size: 20),
              onPressed: () {
                setState(() {
                  widget.controller.text = "";
                  if (widget.onTextChanged != null) {
                    widget.onTextChanged!();
                  }
                });
              },
            ) : Gaps.empty,
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
