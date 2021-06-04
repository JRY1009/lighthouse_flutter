import 'package:flutter/material.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/widget/easyrefresh/skeleton_list.dart';

class SkeletonQuoteItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65.0,
      padding: const EdgeInsets.only(left: 15, right: 15),
      width: double.infinity,
      child: Row (
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 100,
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonContainer(width: 70, height: 15),
                    Gaps.vGap4,
                    SkeletonContainer(width: 50, height: 11),
                  ],
                )
              ],
            ),
          ),
          Container(
            width: 110,
            alignment: Alignment.centerRight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonContainer(width: 70, height: 15),
                Gaps.vGap4,
                SkeletonContainer(width: 50, height: 11),
              ],
            ),
          ),
          Container(
            width: 100,
            alignment: Alignment.centerRight,
            child: SkeletonContainer(width: 80, height: 32),
          ),
        ],
      ),
    );
  }
}