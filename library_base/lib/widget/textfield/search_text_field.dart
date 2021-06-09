import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';

class SearchTextField extends StatefulWidget {

  final FocusNode? focusNode;
  final Function()? onTextChanged;
  final TextEditingController controller;

  SearchTextField({
    Key? key,
    required this.controller,
    this.focusNode,
    this.onTextChanged,
  }) : super(key: key);

  @override
  _SearchTextFieldState createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {

  bool _isEmptyText() {
    return widget.controller.text == null || widget.controller.text.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 42.0,
        child: TextField(
          focusNode: widget.focusNode,
          controller: widget.controller,
          style: TextStyles.textBlack14,
          keyboardType: TextInputType.text,
          maxLines: 1,
          maxLength: 20,
          decoration: InputDecoration(
            counterText: "",
            hintText: S.of(context).search,
            contentPadding: EdgeInsets.only(left: 10, right: 10),
            hintStyle: TextStyles.textGray400_w400_14,
            focusedBorder: BorderStyles.outlineInputR50Main,
            enabledBorder: BorderStyles.outlineInputR50Gray,
            prefixIcon: Container(
              padding: EdgeInsets.all(10.0),
              child: Icon(Icons.search, color: Colours.text_black, size: 22),
            ),
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
