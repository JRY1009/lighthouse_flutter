import 'package:flutter/material.dart';
import 'package:library_base/constant/constant.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/widget/image/local_image.dart';

class BackButtonEx extends StatelessWidget {

  const BackButtonEx({
    Key? key,
    this.icon,
    this.onPressed
  }) : super(key: key);

  final Widget? icon;

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    return IconButton(
      icon: icon ?? LocalImage('icon_back', package: Constant.baseLib, width: 20, height: 20),
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      onPressed: () {
        if (onPressed != null) {
          onPressed!();
        } else {
          Navigator.maybePop(context);
        }
      },
    );
  }
}