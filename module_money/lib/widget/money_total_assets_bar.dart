import 'package:flutter/material.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:module_money/widget/money_unit_select_dialog.dart';

class MoneyTotalAssetsBar extends StatelessWidget {

  final ValueChanged<String>? selectCallback;

  const MoneyTotalAssetsBar({
    Key? key,
    this.selectCallback,
  }) : super(key: key);

  void _unitSelect(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colours.transparent,
        builder: (context) {
          return MoneyUnitSelectDialog(
            selectCallback: selectCallback,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 236,
      padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colours.app_main,
        borderRadius: BorderRadius.all(Radius.circular(14.0)),
      ),
      child: Column(
        children: [
          Container(
            height: 25,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 3),
            child: Text(S.of(context).totalAssets, style: TextStyles.textWhite15),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 40,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 3),
                  child: Text('22112.32', style: TextStyles.textWhite24),
                ),
                Gaps.hGap10,
                Container(
                  width: 60,
                  height: 26,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colours.white, width: 1.0),
                    borderRadius: BorderRadius.circular(4.0),   //圆角
                  ),
                  child: FlatButton(
                    onPressed: () => _unitSelect(context),
                    padding: EdgeInsets.all(0.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.0))),
                    color: Colours.transparent,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: 10),
                        Text('CNY', style: TextStyles.textWhite12),
                        Icon(Icons.arrow_drop_down_outlined, color: Colours.white, size: 20),
                      ]
                    )
                  ),
                ),
              ],
            ),
          ),

          Container(
            height: 23,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 3),
            child: Text('≈22112.32 BTC', style: TextStyles.textWhite80_14),
          ),
          Container(
            height: 75,
            child: Row (
              children: [
                Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Text(S.of(context).proTodayProfit + '（\$）',
                              style: TextStyles.textWhite80_12,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                        ),
                        Gaps.vGap5,
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Text('+122.23',
                              style: TextStyles.textWhite20,
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
                            alignment: Alignment.centerLeft,
                            child: Text(S.of(context).proTodayProfitRate,
                              style: TextStyles.textWhite80_12,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                        ),
                        Gaps.vGap5,
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Text('12.12%',
                              style: TextStyles.textWhite20,
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
                            alignment: Alignment.centerLeft,
                            child: Text(S.of(context).proLinkedExchangeCount,
                              style: TextStyles.textWhite80_12,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                        ),
                        Gaps.vGap5,
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Text('3',
                              style: TextStyles.textWhite20,
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
          Gaps.line,
          Gaps.vGap12,
          InkWell(
            onTap: () => {},
            child: Container(
              height: 30,
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        scrollDirection:Axis.horizontal,
                        padding: EdgeInsets.all(0.0),
                        itemBuilder: (context, index) {
                          return Icon(Icons.event_available, color: Colours.white, size: 26);
                        },
                        itemCount: 10
                      )
                  ),
                  Gaps.hGap5,
                  Container(
                    alignment: Alignment.centerRight,
                    child: Text(S.of(context).viewDetail,
                      style: TextStyles.textWhite12,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_right, color: Colours.white, size: 20),
                ],
              ),
            ),
          )

        ],
      ),
    );
  }
}