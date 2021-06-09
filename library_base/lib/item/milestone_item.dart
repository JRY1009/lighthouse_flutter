import 'package:flutter/material.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/utils/date_util.dart';

class MileStoneItem extends StatelessWidget {

  final int index;
  final String content;
  final String time;
  final bool isLast;

  const MileStoneItem(
      {Key? key,
        required this.index,
        required this.content,
        required this.time,
        this.isLast = false,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                width: 80,
                padding: EdgeInsets.fromLTRB(20, 22, 0, 20),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(DateUtil.getDateStrByTimeStr(time, format: DateFormat.YEAR_ONLY) ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.textGray400_w400_12
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(top: 3.0),
                      child: Text(DateUtil.getDateStrByTimeStr(time, format: DateFormat.MONTH_DAY, dateSeparate: '/') ?? '',
                          style: TextStyles.textGray800_w700_15
                      ),
                    ),
                  ],
                )
            ),
            Container(
              height: double.infinity,
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SizedBox(
                      width: 0.6,
                      height: 26,
                      child: index == 0 ? null : VerticalDivider(width: 0.6, color: Colours.gray_200),
                    ),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                        color: Colours.gray_200,
                      ),
                    ),
                    Expanded(
                      child: VerticalDivider(width: 0.6, color: Colours.gray_200),
                    ),
                  ]
              ),

            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 20, 18, isLast ? 20 : 6),
                child: Text((content),
                    strutStyle: StrutStyle(forceStrutHeight: true, height:1.2, leading: 0.5),
                    style: TextStyles.textGray800_w400_15
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
