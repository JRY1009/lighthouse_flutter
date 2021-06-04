
import 'package:flutter/material.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_kchart/depth_chart.dart';
import 'package:library_kchart/entity/depth_entity.dart';

class SpotDepthBar extends StatefulWidget {

  final List<DepthEntity> bids, asks;

  const SpotDepthBar({
    Key key,
    this.bids,
    this.asks,
  }): super(key: key);


  @override
  _SpotDepthBarState createState() => _SpotDepthBarState();
}

class _SpotDepthBarState extends State<SpotDepthBar> {

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
        height: 180,
        width: double.infinity,
        child: Column(
          children: [
            Container(
              height: 6.0,
              color: Colours.gray_150,
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(left: 9, top: 12),
              child: Text(S.of(context).proDepth,
                style: TextStyles.textGray400_w400_11,
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 11.0,
                    width: 11.0,
                    color: Colours.text_green,
                  ),
                  Gaps.hGap3,
                  Text(S.of(context).proBid,
                    style: TextStyles.textGray400_w400_11,
                  ),
                  Gaps.hGap12,
                  Container(
                    height: 11.0,
                    width: 11.0,
                    color: Colours.text_red,
                  ),
                  Gaps.hGap3,
                  Text(S.of(context).proAsk,
                    style: TextStyles.textGray400_w400_11,
                  ),
                ],
              ),
            ),
            Expanded(
                child: DepthChart(widget.bids, widget.asks)
            ),
            Gaps.vGap3,
            Container(
              height: 6.0,
              color: Colours.gray_150,
            ),
          ],
        )
    );
  }
}
