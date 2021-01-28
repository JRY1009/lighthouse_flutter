
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/mvvm/provider_widget.dart';
import 'package:lighthouse/net/model/friend_link.dart';
import 'package:lighthouse/net/model/milestone.dart';
import 'package:lighthouse/net/model/spot_brief.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/styles.dart';
import 'package:lighthouse/router/routers.dart';
import 'package:library_base/widget/common_scroll_view.dart';
import 'package:library_base/widget/easyrefresh/first_refresh.dart';
import 'package:library_base/widget/shot_view.dart';
import 'package:lighthouse/ui/module_home/item/milestone_item.dart';
import 'package:lighthouse/ui/module_home/item/spot_brief_item.dart';
import 'package:lighthouse/ui/module_home/viewmodel/spot_brief_model.dart';
import 'package:library_base/utils/other_util.dart';

class SpotBriefPage extends StatefulWidget {

  final String coinCode;

  const SpotBriefPage({
    Key key,
    this.coinCode
  }): super(key: key);


  @override
  _SpotBriefPageState createState() => _SpotBriefPageState();
}

class _SpotBriefPageState extends State<SpotBriefPage> with BasePageMixin<SpotBriefPage>, AutomaticKeepAliveClientMixin<SpotBriefPage>, SingleTickerProviderStateMixin{

  @override
  bool get wantKeepAlive => true;

  ShotController _shotController = new ShotController();

  SpotBriefModel _briefModel;

  @override
  void initState() {
    super.initState();

    _briefModel = SpotBriefModel();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        initViewModel();
      }
    });
  }

  void initViewModel() {
    _briefModel.getBrief(widget.coinCode);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Future<Uint8List> screenShot() {
    return _shotController.makeImageUint8List();
  }

  @override
  Future<void> refresh({slient = false}) {
    return _briefModel.getBrief(widget.coinCode);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ProviderWidget<SpotBriefModel>(
        model: _briefModel,
        builder: (context, model, child) {
          return model.isFirst ? FirstRefresh() : CommonScrollView(
            shotController: _shotController,
            physics: ClampingScrollPhysics(),
            children: [
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 12 , vertical: 9),
                  decoration: BoxDecoration(
                    color: Colours.white,
                    borderRadius: BorderRadius.all(Radius.circular(14.0)),
                    boxShadow: BoxShadows.normalBoxShadow,
                  ),
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        padding: EdgeInsets.all(0.0),
                        itemBuilder: (context, index) {
                          SpotBrief spotBrief = model.briefList[index];
                          return SpotBriefItem(
                            index: index,
                            title: spotBrief.title,
                            subTitle: spotBrief.value,
                            type: spotBrief.type,
                          );
                        },
                        itemCount: model.briefList.length,
                      ),

                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(15, 15, 16, 20),
                        child: Text(S.of(context).moreLink, style: TextStyles.textGray800_w400_14),
                      ),

                      GridView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.fromLTRB(15, 0, 16, 12),
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 5.0,
                        ),
                        itemCount: model.friendLinkList.length,
                        itemBuilder: (_, index) {
                          FriendLink friendLink = model.friendLinkList[index];
                          return Text.rich(
                              TextSpan(
                                text: friendLink.name,
                                style: TextStyles.textMain14,
                                recognizer: new TapGestureRecognizer()..onTap = () => OtherUtil.launchURL(friendLink.url),
                              )
                          );
                        },
                      )
                    ],
                  )
              ),

              Container(
                margin: const EdgeInsets.fromLTRB(12, 9, 12, 18),
                decoration: BoxDecoration(
                  color: Colours.white,
                  borderRadius: BorderRadius.all(Radius.circular(14.0)),
                  boxShadow: BoxShadows.normalBoxShadow,
                ),
                child: Column(
                  children: [
                    Container(
                        margin: const EdgeInsets.fromLTRB(15, 18, 16, 9),
                        height: 20,
                        child: InkWell(
                          onTap: () => Routers.navigateTo(context, Routers.milestonePage),
                          child: Row(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(S.of(context).blockMileStone,
                                  style: TextStyles.textGray800_w400_14,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Expanded(
                                child: Container(),
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

                    ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      padding: EdgeInsets.all(0.0),
                      itemBuilder: (context, index) {
                        MileStone mileStone = model.milestoneList[index];
                        return MileStoneItem(
                          index: index,
                          content: mileStone.content,
                          time: mileStone.date,
                          isLast: index == (min(model.milestoneList.length, 3) - 1),
                        );
                      },
                      itemCount: min(model.milestoneList.length, 3),
                    ),
                  ],
                ),
              )
            ],
          );
        }
    );
  }
}
