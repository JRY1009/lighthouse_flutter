import 'dart:math';

import 'package:flutter/material.dart';
import 'package:library_base/event/event.dart';
import 'package:library_base/event/main_jump_event.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/mvvm/provider_widget.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/router/routers.dart';
import 'package:module_home/item/milestone_item.dart';
import 'package:module_home/model/milestone.dart';
import 'package:module_home/viewmodel/milestone_model.dart';

class HomeMileStoneBar extends StatefulWidget {
  final VoidCallback onPressed;

  const HomeMileStoneBar({
    Key key,
    this.onPressed,
  }) : super(key: key);

  @override
  _HomeMileStoneBarState createState() => _HomeMileStoneBarState();
}

class _HomeMileStoneBarState extends State<HomeMileStoneBar>
    with BasePageMixin<HomeMileStoneBar> {
  MileStoneModel _mileStoneModel;

  @override
  void initState() {
    super.initState();
    initViewModel();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initViewModel() {
    _mileStoneModel = MileStoneModel('all');
    _mileStoneModel.getMileStones(0, 3);
  }

  @override
  Future<void> refresh({slient = false}) {
    return _mileStoneModel.getMileStones(0, 3);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
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
                        child: Text(
                          S.of(context).blockMileStone,
                          style: TextStyles.textGray500_w400_14,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(S.of(context).all, style: TextStyles.textGray400_w400_12),
                  ),
                  Icon(Icons.keyboard_arrow_right,
                      color: Colours.gray_400, size: 16),
                ],
              ),
            )),
        GestureDetector(
            onTap: () => Routers.navigateTo(context, Routers.milestonePage),
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                decoration: BoxDecoration(
                  color: Colours.white,
                  borderRadius: BorderRadius.all(Radius.circular(14.0)),
                  boxShadow: BoxShadows.normalBoxShadow,
                ),
                child: ProviderWidget<MileStoneModel>(
                    model: _mileStoneModel,
                    builder: (context, model, child) {
                      return ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        padding: EdgeInsets.all(0.0),
                        itemBuilder: (context, index) {
                          MileStone mileStone = model.mileStoneList[index];
                          return MileStoneItem(
                            index: index,
                            content: mileStone?.content,
                            time: mileStone?.date,
                            isLast: index == (min(model.mileStoneList.length, 3) - 1),
                          );
                        },
                        itemCount: min(model.mileStoneList.length, 3),
                      );
                    }))
        ),
        GestureDetector(
          onTap: () => Event.eventBus.fire(MainJumpEvent(MainJumpPage.info, params: {"tab": 1})),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            height: 20,
            child: Row(
              children: [
                Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        S.of(context).latestInfo,
                        style: TextStyles.textGray500_w400_14,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(S.of(context).all,
                      style: TextStyles.textGray400_w400_12),
                ),
                Icon(Icons.keyboard_arrow_right,
                    color: Colours.gray_400, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
