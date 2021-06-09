import 'package:flutter/material.dart';
import 'package:library_base/constant/constant.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/widget/image/local_image.dart';

class CheckTextButton extends StatefulWidget {

  bool value = false;

  String? text;

  Function(bool)? onChanged;

  CheckTextButton({Key? key,
    required this.value,
    this.text,
    this.onChanged
  }) : super(key: key);

  @override
  _RoundCheckBoxState createState() => _RoundCheckBoxState();
}

class _RoundCheckBoxState extends State<CheckTextButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          widget.value = !widget.value;
          if (widget.onChanged != null) {
            widget.onChanged!(widget.value);
          }
        },
        child: Container(
            height: 30,
            color: Colours.white,
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 9),
            child: widget.value
                ? Text(widget.text ?? '', style: TextStyles.textMain500_11)
                : Text(widget.text ?? '', style: TextStyles.textGray400_w400_11)
        )
    );
  }
}