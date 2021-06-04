
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/utils/date_util.dart';
import 'package:library_base/utils/num_util.dart';
import 'package:module_quote/model/latest_deal.dart';


class LatestDealItem extends StatelessWidget {


  final LatestDeal latestDeal;

  const LatestDealItem(
      {Key key,
        this.latestDeal,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    Random rng = Random();
    bool way = rng.nextBool();

    String priceStr = NumUtil.formatNum(latestDeal?.quote, point: 2);
    String amountStr = NumUtil.formatNum(latestDeal?.change_amount, point: 2);
    String timeStr = DateUtil.getDateStrByDateTime(DateTime.now(), format: DateFormat.HOUR_MINUTE_SECOND);

    return Container(
      height: 22.0,
      width: double.infinity,
      margin: const EdgeInsets.only(left: 9, right: 9),
      child: Row (
        children: [
          Expanded(
              flex: 1,
              child: Text(timeStr,
                style: TextStyles.textGray400_w400_12,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(way ? S.of(context).proBid : S.of(context).proAsk,
                style: way ? TextStyles.textGreen_w400_12 : TextStyles.textRed_w400_12,
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(priceStr, style: TextStyles.textGray400_w400_12,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerRight,
              child: Text(amountStr, style: TextStyles.textGray400_w400_12,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,),
            ),
          ),
        ],
      ),
    );
  }
}
