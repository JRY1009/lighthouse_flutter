import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:library_base/res/colors.dart';

const double _kTabHeight = 46.0;
const double _kTextAndIconTabHeight = 72.0;

class TrendTab extends StatelessWidget {
  /// Creates a material design [TabBar] tab.
  ///
  /// At least one of [text], [icon], and [child] must be non-null. The [text]
  /// and [child] arguments must not be used at the same time. The
  /// [iconMargin] is only useful when [icon] and either one of [text] or
  /// [child] is non-null.
  const TrendTab({
    Key? key,
    required this.select,
    this.text,
    this.icon,
    this.padding,
    this.iconMargin = const EdgeInsets.only(bottom: 10.0),
    this.child,
  }) : assert(text != null || child != null || icon != null),
        assert(text == null || child == null),
        super(key: key);

  final EdgeInsetsGeometry? padding;

  final bool select;
  /// The text to display as the tab's label.
  ///
  /// Must not be used in combination with [child].
  final String? text;

  /// The widget to be used as the tab's label.
  ///
  /// Usually a [Text] widget, possibly wrapped in a [Semantics] widget.
  ///
  /// Must not be used in combination with [text].
  final Widget? child;

  /// An icon to display as the tab's label.
  final Widget? icon;

  /// The margin added around the tab's icon.
  ///
  /// Only useful when used in combination with [icon], and either one of
  /// [text] or [child] is non-null.
  final EdgeInsetsGeometry iconMargin;

  Widget _buildLabelText() {
    return child ?? Container(
      height: 24.0,
      padding: padding,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: select ? Colours.gray_100 : Colours.transparent,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Text(text ?? '', softWrap: false, overflow: TextOverflow.fade,
          style: select ? TextStyle(fontSize: 13, color: Colours.app_main) : TextStyle(fontSize: 13, color: Colours.gray_500)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));

    double height;
    Widget label;
    if (icon == null) {
      height = _kTabHeight;
      label = _buildLabelText();
    } else if (text == null && child == null) {
      height = _kTabHeight;
      label = icon!;
    } else {
      height = _kTextAndIconTabHeight;
      label = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            child: icon,
            margin: iconMargin,
          ),
          _buildLabelText(),
        ],
      );
    }

    return SizedBox(
      height: height,
      child: Center(
        child: label,
        widthFactor: 1.0,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('text', text, defaultValue: null));
    properties.add(DiagnosticsProperty<Widget>('icon', icon, defaultValue: null));
  }
}