
import 'package:flutter/material.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/utils/num_util.dart';
import 'package:library_base/widget/percent/linear_percent_indicator.dart';
import 'package:library_kchart/entity/depth_entity.dart';


class DepthOrderItem extends StatelessWidget {

  final DepthEntity bid;

  final DepthEntity ask;

  final num bidAmountMax;

  final num askAmountMax;

  const DepthOrderItem(
      {Key key,
        this.bid,
        this.ask,
        this.bidAmountMax,
        this.askAmountMax
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    String bidAmountStr = NumUtil.formatNum(bid?.amount, point: 4);
    String bidPriceStr = NumUtil.formatNum(bid?.price, point: 2);

    String askAmountStr = NumUtil.formatNum(ask?.amount, point: 4);
    String askPriceStr = NumUtil.formatNum(ask?.price, point: 2);

    double bidPercent = NumUtil.divide(bid?.amount, bidAmountMax);
    double askPercent = NumUtil.divide(ask?.amount, askAmountMax);

    return Container(
      height: 22.0,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 6),
      child: Row (
        children: [
          Expanded(
              child: Stack(
                children: [
                  Container(
                    child: LinearPercentIndicator(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      lineHeight: 22.0,
                      percent: bidPercent,
                      linearStrokeCap: LinearStrokeCap.butt,
                      progressColor: Colours.trans_green,
                      backgroundColor: Colours.white,
                      isRTL: true,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 3),
                        alignment: Alignment.centerLeft,
                        child: Text(bidAmountStr,
                          style: TextStyles.textGray400_w400_10,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 3),
                        alignment: Alignment.centerRight,
                        child: Text(bidPriceStr,
                          style: TextStyles.textGreen_w400_10,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              )
          ),
          Gaps.hGap5,
          Expanded(child: Stack(
            children: [
              Container(
                child: LinearPercentIndicator(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  lineHeight: 22.0,
                  percent: askPercent,
                  linearStrokeCap: LinearStrokeCap.butt,
                  progressColor: Colours.trans_red,
                  backgroundColor: Colours.white,
                  isRTL: false,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 3),
                    alignment: Alignment.centerLeft,
                    child: Text(askPriceStr,
                      style: TextStyles.textRed_w400_10,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 3),
                    alignment: Alignment.centerRight,
                    child: Text(askAmountStr,
                      style: TextStyles.textGray400_w400_10,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          )),
        ],
      ),
    );
  }
}
