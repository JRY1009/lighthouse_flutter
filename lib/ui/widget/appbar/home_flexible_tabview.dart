
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

class HomeFlexibleTabView extends StatefulWidget {

  final Account account;
  final VoidCallback onPressed;

  const HomeFlexibleTabView({
    Key key,
    this.account,
    this.onPressed,
  }): super(key: key);


  @override
  _HomeFlexibleTabViewState createState() => _HomeFlexibleTabViewState();
}

class _HomeFlexibleTabViewState extends State<HomeFlexibleTabView> with AutomaticKeepAliveClientMixin<HomeFlexibleTabView>, SingleTickerProviderStateMixin{

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
      height: 270,
      padding: EdgeInsets.symmetric(horizontal: 12),
      color: Colours.transparent,
      child: Column(
        children: [
          Container(
            height: 170,
            child: SimpleLineChart(),
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
                            child: Text(S.of(context).proTotalMarketValue,
                              style: TextStyles.textGray400_w400_12,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                        ),
                        Gaps.vGap5,
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Text('2333.4',
                              style: TextStyles.textBlack20,
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
                            child: Text(S.of(context).pro24hVolume,
                              style: TextStyles.textGray400_w400_12,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                        ),
                        Gaps.vGap5,
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Text('233',
                              style: TextStyles.textBlack20,
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
                            child: Text(S.of(context).proComputePower,
                              style: TextStyles.textGray400_w400_12,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                        ),
                        Gaps.vGap5,
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Text('122.33',
                              style: TextStyles.textBlack20,
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
          InkWell(
            onTap: () => Routers.navigateTo(context, Routers.mainPage),
            child: Container(
              height: 20,
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(S.of(context).viewDetail,
                          style: TextStyles.textGray500_w400_12,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                  ),
                  Icon(Icons.keyboard_arrow_right, color: Colours.gray_500, size: 20),
                ],
              ),
            ),
          )

        ],
      ),
    );
  }
}
