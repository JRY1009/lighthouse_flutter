
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/gaps.dart';
import 'package:lighthouse/ui/widget/auto_image.dart';
import 'package:lighthouse/utils/object_util.dart';

/// 自定义AppBar
class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {

  const CommonAppBar({
    Key key,
    this.backgroundColor,
    this.title,
    this.titleAlignment = Alignment.center,
    this.actionText,
    this.backImage = 'ic_back',
    this.backVisible = true,
    this.onPressed
  }): super(key: key);

  final Color backgroundColor;
  final String title;
  final Alignment titleAlignment;
  final String backImage;
  final bool backVisible;
  final String actionText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {

    Color _backgroundColor = backgroundColor ?? Colors.white;
    final SystemUiOverlayStyle _overlayStyle = ThemeData.estimateBrightnessForColor(_backgroundColor) == Brightness.dark
        ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;

    final Widget backWidget = backVisible ? IconButton(
      padding: EdgeInsets.all(12.0),
      icon: LocalImage(backImage),
      onPressed: () {
        FocusManager.instance.primaryFocus?.unfocus();
        Navigator.maybePop(context);
      },
    ) : Gaps.empty;

    final Widget actionWidget = ObjectUtil.isNotEmpty(actionText) ? Positioned(
      right: 0.0,
      child: FlatButton(
        child: Text(actionText),
        textColor: Colours.text_black,
        highlightColor: Colors.transparent,
        onPressed: onPressed,
      ),
    ) : Gaps.empty;

    final Widget titleWidget = Semantics(
      namesRoute: true,
      header: true,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 48.0),
        alignment: titleAlignment,
        child: Text(ObjectUtil.isEmpty(title) ? "" : title, style: TextStyle(fontSize: 18.0),
        ),
      ),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _overlayStyle,
      child: Material(
        color: _backgroundColor,
        child: SafeArea(
          child: Stack(
            alignment: Alignment.centerLeft,
            children: <Widget>[
              titleWidget,
              backWidget,
              actionWidget,
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(48.0);
}
