import 'package:flutter/material.dart';
import 'package:library_base/constant/constant.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/widget/image/local_image.dart';

class RoundCheckBox extends StatefulWidget {
  var value = false;

  Function(bool)? onChanged;

  RoundCheckBox({Key? key, required this.value, this.onChanged})
      : super(key: key);

  @override
  _RoundCheckBoxState createState() => _RoundCheckBoxState();
}

class _RoundCheckBoxState extends State<RoundCheckBox> {
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
          height: 36,
            color: Colours.white,
            padding: const EdgeInsets.all(10.0),
            child: widget.value
                ? LocalImage('check_on', package: Constant.baseLib, width: 16, height: 16)
                : LocalImage('check_off', package: Constant.baseLib, width: 16, height: 16)
        )
    );
  }
}