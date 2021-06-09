import 'package:flutter/material.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';

class MoneyIndexBar extends StatelessWidget {

  final String days;
  const MoneyIndexBar({
    Key? key,
    this.days = '123',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 250,
        color: Colours.white,
        margin: EdgeInsets.symmetric(vertical: 8),
        child:
        Column(
            children: <Widget>[
              Container(
                  height: 50.0,
                  alignment: Alignment.centerLeft,
                  color: Colours.white,
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 13,
                        margin: const EdgeInsets.only(right: 4),
                        color: Colours.app_main,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(S.of(context).assetsIndex,
                          style: TextStyles.textGray500_w400_14,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  )
              ),

              Container(
                height: 60,
                child: Row (
                  children: [
                    Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                                alignment: Alignment.center,
                                child: Text(S.of(context).proTotalProfit,
                                  style: TextStyles.textGray500_w400_12,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                            ),
                            Gaps.vGap5,
                            Container(
                                alignment: Alignment.center,
                                child: Text('+122.23',
                                  style: TextStyles.textGray800_w400_16,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                            ),
                          ],
                        )
                    ),
                    Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                                alignment: Alignment.center,
                                child: Text(S.of(context).proTotalProfitRate,
                                  style: TextStyles.textGray500_w400_12,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                            ),
                            Gaps.vGap5,
                            Container(
                                alignment: Alignment.center,
                                child: Text('12.12%',
                                  style: TextStyles.textGray800_w400_16,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                            ),
                          ],
                        )
                    ),
                    Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                                alignment: Alignment.center,
                                child: Text(S.of(context).proMaxRetracement,
                                  style: TextStyles.textGray500_w400_12,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                            ),
                            Gaps.vGap5,
                            Container(
                                alignment: Alignment.center,
                                child: Text('3',
                                  style: TextStyles.textGray800_w400_16,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                            ),
                          ],
                        )
                    ),
                  ],
                ),
              ),
              Container(
                height: 60,
                child: Row (
                  children: [
                    Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                                alignment: Alignment.center,
                                child: Text(S.of(context).proNumOfTrade,
                                  style: TextStyles.textGray500_w400_12,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                            ),
                            Gaps.vGap5,
                            Container(
                                alignment: Alignment.center,
                                child: Text('+122.23',
                                  style: TextStyles.textGray800_w400_16,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                            ),
                          ],
                        )
                    ),
                    Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                                alignment: Alignment.center,
                                child: Text(S.of(context).proNumOfGain,
                                  style: TextStyles.textGray500_w400_12,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                            ),
                            Gaps.vGap5,
                            Container(
                                alignment: Alignment.center,
                                child: Text('12.12%',
                                  style: TextStyles.textGray800_w400_16,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                            ),
                          ],
                        )
                    ),
                    Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                                alignment: Alignment.center,
                                child: Text(S.of(context).proNumOfLoss,
                                  style: TextStyles.textGray500_w400_12,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                            ),
                            Gaps.vGap5,
                            Container(
                                alignment: Alignment.center,
                                child: Text('3',
                                  style: TextStyles.textGray800_w400_16,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                            ),
                          ],
                        )
                    ),
                  ],
                ),
              ),
              Container(
                height: 60,
                child: Row (
                  children: [
                    Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                                alignment: Alignment.center,
                                child: Text(S.of(context).proTradeVolume,
                                  style: TextStyles.textGray500_w400_12,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                            ),
                            Gaps.vGap5,
                            Container(
                                alignment: Alignment.center,
                                child: Text('+122.23',
                                  style: TextStyles.textGray800_w400_16,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                            ),
                          ],
                        )
                    ),
                    Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                                alignment: Alignment.center,
                                child: Text(S.of(context).proFee,
                                  style: TextStyles.textGray500_w400_12,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                            ),
                            Gaps.vGap5,
                            Container(
                                alignment: Alignment.center,
                                child: Text('12.12%',
                                  style: TextStyles.textGray800_w400_16,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                            ),
                          ],
                        )
                    ),
                    Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                                alignment: Alignment.center,
                                child: Text(S.of(context).proWinRate,
                                  style: TextStyles.textGray500_w400_12,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                            ),
                            Gaps.vGap5,
                            Container(
                                alignment: Alignment.center,
                                child: Text('3',
                                  style: TextStyles.textGray800_w400_16,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                            ),
                          ],
                        )
                    ),
                  ],
                ),
              ),
            ]
        )
    );
  }
}