
import 'package:flutter/widgets.dart';
import 'package:library_base/constant/constant.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/utils/image_util.dart';
import 'package:library_base/widget/image/round_image.dart';

class QuotationTab extends StatefulWidget {

  const QuotationTab({
    this.select = false,
    this.icon,
    this.iconUnselect,
    this.title,
    this.rate,
    this.priceStr,
    this.rateStr
  });

  final num? rate;
  final bool select;
  final String? icon;
  final String? iconUnselect;
  final String? title;
  final String? priceStr;
  final String? rateStr;

  @override
  _QuotationTabState createState() => _QuotationTabState();
}

class _QuotationTabState extends State<QuotationTab> {

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Gaps.vGap3,
          Row(
            children: [
              Container(
                width: 18,
                height: 18,
                child:  widget.select ? RoundImage(widget.icon ?? '',
                  width: 18,
                  height: 18,
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                  fadeInDuration: const Duration(milliseconds: 10),
                ) : RoundImage(widget.iconUnselect ?? '',
                  width: 18,
                  height: 18,
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                  fadeInDuration: const Duration(milliseconds: 10),
                ),
              ),
              Gaps.hGap5,
              Text(widget.title ?? '',
                style: widget.select ? TextStyles.textGray500_w700_15 : TextStyles.textGray400_w400_15,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          Gaps.vGap5,
          Row(
            children: [
              Text.rich(TextSpan(
                  children: [
                    TextSpan(text: '\$', style: widget.select ? (widget.rate! >= 0 ? TextStyles.textGreen_w600_10 : TextStyles.textRed_w600_10) : TextStyles.textGray400_w400_10),
                    TextSpan(text: widget.priceStr ?? '', style: widget.select ? (widget.rate! >= 0 ? TextStyles.textGreen_w600_14 : TextStyles.textRed_w600_14) : TextStyles.textGray400_w400_14),
                  ]
              )),
              Gaps.hGap8,
              Container(
                height: 18,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: widget.select ? (widget.rate! >= 0 ? Color(0x1a22C29B) : Color(0x1aEC3944)) : Colours.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                ),
                child: Text(widget.rateStr ?? '',
                  style: widget.select ? (widget.rate! >= 0 ? TextStyles.textGreen_w400_10 : TextStyles.textRed_w400_10) : TextStyles.textGray400_w400_11,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              )

            ],
          )
        ],
      ),
    );
  }
}
