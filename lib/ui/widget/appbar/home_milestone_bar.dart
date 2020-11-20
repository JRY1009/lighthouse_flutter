
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lighthouse/event/event.dart';
import 'package:lighthouse/event/main_jump_event.dart';
import 'package:lighthouse/generated/l10n.dart';
import 'package:lighthouse/net/model/milestone.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/styles.dart';
import 'package:lighthouse/router/routers.dart';
import 'package:lighthouse/ui/item/milestone_item.dart';

class HomeMileStoneBar extends StatefulWidget {

  final List<MileStone> mileStones;
  final VoidCallback onPressed;

  const HomeMileStoneBar({
    Key key,
    this.mileStones,
    this.onPressed,
  }): super(key: key);


  @override
  _HomeMileStoneBarState createState() => _HomeMileStoneBarState();
}

class _HomeMileStoneBarState extends State<HomeMileStoneBar>{

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

    return Column(
      children: <Widget>[
        InkWell(
          onTap: () => Routers.navigateTo(context, Routers.milestonePage),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            height: 20,
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(S.of(context).blockMileStone,
                        style: TextStyles.textGray500_w400_14,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(S.of(context).all, style: TextStyles.textGray400_w400_12),
                ),
                Icon(Icons.keyboard_arrow_right, color: Colours.gray_400, size: 16),
              ],
            ),
          )
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 12 , vertical: 9),

          decoration: BoxDecoration(
            color: Colours.white,
            borderRadius: BorderRadius.all(Radius.circular(14.0)),
            boxShadow: BoxShadows.normalBoxShadow,
          ),
          child: ListView.builder(
            shrinkWrap: true,
            primary: false,
            padding: EdgeInsets.all(0.0),
            itemBuilder: (context, index) {
              return MileStoneItem(
                index: index,
                content: widget.mileStones[index].daily_desc,
                time: widget.mileStones[index].created_at,
                isLast: index == (min(widget.mileStones.length, 3) - 1),
              );
            },
            itemCount: min(widget.mileStones.length, 3),
          ),
        ),

        GestureDetector(
          onTap: () => Event.eventBus.fire(MainJumpEvent(MainJumpPage.info)),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            height: 20,
            child: Row(
              children: [
                Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(S.of(context).latestInfo,
                        style: TextStyles.textGray500_w400_14,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(S.of(context).all, style: TextStyles.textGray400_w400_12),
                ),
                Icon(Icons.keyboard_arrow_right, color: Colours.gray_400, size: 16),
              ],
            ),
          ),
        ),

      ],
    );
  }
}
