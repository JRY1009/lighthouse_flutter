
import 'package:flutter/material.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/router/routers.dart';

class KlineSelectMenu extends StatefulWidget {

  const KlineSelectMenu({
    Key? key,
    required this.data,
    this.sortIndex,
    required this.height,
    required this.onSelected,
    required this.onCancel,
    this.crossAxisCount = 4
  }): super(key: key);

  final int crossAxisCount;
  final List<String> data;
  final int? sortIndex;
  final double height;
  final Function(int, String) onSelected;
  final Function() onCancel;

  @override
  _KlineSelectMenuState createState() => _KlineSelectMenuState();
}

class _KlineSelectMenuState extends State<KlineSelectMenu> with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  late Animation<double> _animation;

  bool cancel = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..forward();

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInCubic,
      reverseCurve: Curves.easeOutCubic,
    );
    _animation.addStatusListener(_statusListener);
  }

  void _statusListener(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      /// 菜单动画停止，关闭菜单。
      Routers.goBack(context);
    }
  }

  @override
  void dispose() {
    if (cancel) {
      widget.onCancel();
    }
    _animation.removeStatusListener(_statusListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = Colours.white;

    final Widget listView = GridView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        childAspectRatio: 3.0,
      ),
      itemCount: widget.data.length,
      itemBuilder: (_, index) {
        return _buildItem(index, backgroundColor);
      },
    );

    return FadeTransition(
      opacity: _animation,
      child: Container(
        color: const Color(0x00000000),
        height: widget.height,
        child: Column(
          children: [
            Container(
                color: Colours.white,
                child: listView
            ),
            Container(
              height: 8.0,
              decoration: BoxDecoration(
                color: Colours.white,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(14.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colours.normal_border_shadow,
                    offset: Offset(0.0, 10.0),
                    blurRadius: 10.0,
                    spreadRadius: 0.0,
                  ),
                ],
              ),
            )
          ],
        )
      ),
    );
  }

  Widget _buildItem(int index, Color backgroundColor) {
    return Material(
      color: backgroundColor,
      child: InkWell(
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(left: 5.0, right: 5.0, top: 3.0, bottom: 3.0),
          decoration: BoxDecoration(
            color: Colours.gray_150,
            border: Border.all(color: index == widget.sortIndex ? Colours.app_main_500 : Colours.gray_150, width: 1.0),
            borderRadius: BorderRadius.circular(5.0),   //圆角
          ),
          child: Text(
            widget.data[index],
            style: index == widget.sortIndex ? TextStyles.textMain500_11 : TextStyles.textGray500_w400_11,
          ),
        ),
        onTap: () {
          cancel = false;
          widget.onSelected(index, widget.data[index]);
          _controller.reverse();
        },
      ),
    );
  }
}
