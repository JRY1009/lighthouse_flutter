import 'package:flutter/material.dart';
import 'package:library_base/res/colors.dart';

class BackButtonEx extends StatelessWidget {

  const BackButtonEx({
    Key key,
    this.icon,
    this.onPressed
  }) : super(key: key);

  final Widget icon;

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    return IconButton(
      icon: icon ?? Icon(Icons.arrow_back_ios, color: Colours.gray_400, size: 25),
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      onPressed: () {
        if (onPressed != null) {
          onPressed();
        } else {
          Navigator.maybePop(context);
        }
      },
    );
  }
}