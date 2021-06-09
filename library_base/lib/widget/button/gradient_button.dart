import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/styles.dart';

class GradientButton extends StatefulWidget {

  final List<Color> colors;
  final String? text;
  final TextStyle textStyle;
  final double? width;
  final double? height;
  final Function()? onPressed;

  GradientButton({
    Key? key,
    required this.colors,
    this.text,
    this.textStyle = TextStyles.textWhite16,
    this.width,
    this.height,
    this.onPressed,
  }) : super(key: key);

  @override
  _GradientButtonState createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),   //圆角
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: widget.colors,
        ),
      ),
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50.0))),
        disabledColor: Color(0xff93b8fd),
        child: Text(
          widget.text ?? '',
          style: widget.textStyle,
        ),
        onPressed: widget.onPressed,
      ),
    );
  }
}
