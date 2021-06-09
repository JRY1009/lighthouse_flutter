
import 'package:flutter/material.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/styles.dart';


class AssetsDistributionItem extends StatelessWidget {

  final bool isLast;

  final Color? color;

  final String? balanceRange;

  final String? addressAmount;

  final String? proportion;

  final String? compareYesterday;

  const AssetsDistributionItem(
      {Key? key,
        this.isLast = false,
        this.color,
        this.balanceRange,
        this.addressAmount,
        this.proportion,
        this.compareYesterday
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35.0,
      width: double.infinity,
      decoration: isLast ? null : BoxDecoration(
          border: Border(bottom: BorderSide(width: 0.6, color: Colours.default_line))
      ),
      child: Row (
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 4,
            height: 8,
            margin: const EdgeInsets.only(right: 3),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
          ),
          Expanded(
              child: Text(balanceRange ?? '',
                style: TextStyles.textGray800_w400_12,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
          ),
          Container(
            width: 90,
            alignment: Alignment.centerRight,
            child: Text(addressAmount ?? '', style: TextStyles.textGray800_w400_12,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,),
          ),
          Container(
            width: 70,
            alignment: Alignment.centerRight,
            child: Text(proportion ?? '', style: TextStyles.textGray800_w400_12,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,),
          ),
          Container(
            width: 70,
            alignment: Alignment.centerRight,
            child: Text(compareYesterday ?? '', style: TextStyles.textGray800_w400_12,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,),
          ),
        ],
      ),
    );
  }
}
