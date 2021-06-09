import 'package:flutter/material.dart';
import 'package:library_base/res/colors.dart';

enum SortButtonState {
  NORMAL,
  ASCEND, //升序
  DESCEND,  //降序
}

class SortButton extends StatelessWidget {

  final SortButtonState state;

  const SortButton({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 20,
      alignment: Alignment.center,
      child: Stack(
        children: <Widget>[
          Positioned(
              top: 2,
              bottom: 4,
              child: Icon(Icons.arrow_drop_up, color: state == SortButtonState.ASCEND ? Colours.dark_app_main : Colours.gray_300, size: 14)
          ),
          Positioned(
              top: 6,
              bottom: 0,
              child: Icon(Icons.arrow_drop_down, color: state == SortButtonState.DESCEND ? Colours.dark_app_main : Colours.gray_300, size: 14)
          ),
        ],
      ),
    );
  }
}