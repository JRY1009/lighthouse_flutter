
import 'package:flutter/material.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/utils/num_util.dart';
import 'package:library_base/widget/image/round_image.dart';

import 'package:module_quote/model/quote_index_platform.dart';


class IndexPlatformItem extends StatelessWidget {

  final int? index;

  final QuoteIndexPlatform quoteIndexPlatform;


  const IndexPlatformItem(
      {Key? key,
        required this.quoteIndexPlatform,
        this.index,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    String rateStr = (quoteIndexPlatform.change_percent! >= 0 ? '+' : '') + NumUtil.getNumByValueDouble(quoteIndexPlatform.change_percent!.toDouble(), 2).toString() + '%';

    String priceStr = NumUtil.formatNum(quoteIndexPlatform.quote, point: 2);
    String cnyStr = NumUtil.formatNum(quoteIndexPlatform.cny, point: 2);

    return InkWell(
      onTap: () {

      },
      child: Container(
        height: 65.0,
        width: double.infinity,
//      decoration: BoxDecoration(
//          border: Border(bottom: BorderSide(width: 0.6, color: Colours.default_line))
//      ),
        child: Row (
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 100,
              child: Row(
                children: [
                  RoundImage(quoteIndexPlatform.ico ?? '',
                    width: 18,
                    height: 18,
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                  ),
                  Gaps.hGap8,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(quoteIndexPlatform.name ?? '',
                        style: TextStyles.textGray800_w600_15,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Gaps.vGap5,
                      Text(quoteIndexPlatform.pair ?? '',
                        style: TextStyles.textGray500_w400_11,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
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
                  Text('\$' + priceStr,
                    style: TextStyles.textGray800_w700_15,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Gaps.vGap6,
                  Text('≈￥' + cnyStr, style: TextStyles.textGray500_w400_11,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              width: 70,
              alignment: Alignment.centerRight,
              child: Text(rateStr,
                  style: quoteIndexPlatform.change_percent! >= 0 ? TextStyles.textGreen_w400_14 : TextStyles.textRed_w400_14,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}
