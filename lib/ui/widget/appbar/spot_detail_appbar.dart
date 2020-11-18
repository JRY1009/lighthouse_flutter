
import 'package:flutter/material.dart';
import 'package:lighthouse/generated/l10n.dart';
import 'package:lighthouse/net/model/account.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/gaps.dart';
import 'package:lighthouse/res/styles.dart';
import 'package:lighthouse/router/routers.dart';
import 'package:lighthouse/ui/widget/chart/line_chart.dart';
import 'package:lighthouse/ui/widget/tab/bubble_indicator.dart';
import 'package:lighthouse/ui/widget/tab/quotation_tab.dart';
import 'package:lighthouse/utils/image_util.dart';

class SpotDetailAppbar extends StatefulWidget {

  final Account account;
  final VoidCallback onPressed;

  const SpotDetailAppbar({
    Key key,
    this.account,
    this.onPressed,
  }): super(key: key);


  @override
  _SpotDetailAppbarState createState() => _SpotDetailAppbarState();
}

class _SpotDetailAppbarState extends State<SpotDetailAppbar> with AutomaticKeepAliveClientMixin<SpotDetailAppbar>, SingleTickerProviderStateMixin{

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 64,
      padding: EdgeInsets.symmetric(horizontal: 12),
      margin: EdgeInsets.only(bottom: 9),
      decoration: BoxDecoration(
        color: Colours.white,
        boxShadow: BoxShadows.normalBoxShadow,
      ),
      child: Row (

        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.only(top: 5, right: 10),
                  alignment: Alignment.centerLeft,
                  child: Text.rich(TextSpan(
                      children: [
                        TextSpan(text: '\$', style: TextStyles.textRed_w400_12),
                        TextSpan(text: '12222.12', style: TextStyles.textRed_w400_22),
                        WidgetSpan(child: Icon(Icons.arrow_downward, color: Colours.text_red, size: 14),)
                      ]
                  ))
              ),
              Container(
                  margin: EdgeInsets.only(top: 5),
                  alignment: Alignment.centerLeft,
                  child: Text('≈￥82333.4',
                    style: TextStyles.textGray500_w400_12,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.only(top: 10),
                  alignment: Alignment.centerLeft,
                  child: Text('+11.11%',
                    style: TextStyles.textRed_w400_12,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
              ),
              Container(
                  margin: EdgeInsets.only(top: 10),
                  alignment: Alignment.centerLeft,
                  child: Text('-123,22',
                    style: TextStyles.textRed_w400_12,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
              ),
            ],
          ),
          Expanded(
            child: Container(),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.only(top: 10),
                  alignment: Alignment.centerRight,
                  child: Text('24H额',
                    style: TextStyles.textGray400_w400_12,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
              ),
              Container(
                  margin: EdgeInsets.only(top: 10),
                  alignment: Alignment.centerRight,
                  child: Text('24H量',
                    style: TextStyles.textGray400_w400_12,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
              ),
            ],
          ),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.only(top: 10),
                    alignment: Alignment.centerLeft,
                    child: Text('\$23,172,066,359',
                      style: TextStyles.textGray800_w400_12,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                ),
                Container(
                    margin: EdgeInsets.only(top: 10),
                    alignment: Alignment.centerLeft,
                    child: Text('1,776,069 BTC',
                      style: TextStyles.textGray800_w400_12,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                ),
              ],
            ),
          )

        ],
      ),
    );
  }
}
