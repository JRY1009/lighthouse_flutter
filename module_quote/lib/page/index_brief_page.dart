
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/item/milestone_item.dart';
import 'package:library_base/model/friend_link.dart';
import 'package:library_base/model/milestone.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/mvvm/provider_widget.dart';
import 'package:library_base/net/apis.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/router/parameters.dart';
import 'package:library_base/router/routers.dart';
import 'package:library_base/utils/other_util.dart';
import 'package:library_base/widget/common_scroll_view.dart';
import 'package:library_base/widget/easyrefresh/first_refresh_top.dart';
import 'package:library_base/widget/image/round_image.dart';
import 'package:library_base/widget/shot_view.dart';
import 'package:module_quote/item/index_brief_item.dart';
import 'package:module_quote/model/index_brief.dart';
import 'package:module_quote/viewmodel/index_brief_model.dart';

class IndexBriefPage extends StatefulWidget {

  final String coinCode;

  const IndexBriefPage({
    Key key,
    this.coinCode
  }): super(key: key);


  @override
  _IndexBriefPageState createState() => _IndexBriefPageState();
}

class _IndexBriefPageState extends State<IndexBriefPage> with BasePageMixin<IndexBriefPage>, AutomaticKeepAliveClientMixin<IndexBriefPage>, SingleTickerProviderStateMixin{

  @override
  bool get wantKeepAlive => true;

  ShotController _shotController = new ShotController();

  IndexBriefModel _briefModel;

  @override
  void initState() {
    super.initState();

    _briefModel = IndexBriefModel();
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

    return ProviderWidget<IndexBriefModel>(
        model: _briefModel,
        builder: (context, model, child) {
          return model.isFirst ? FirstRefreshTop() : CommonScrollView(
            shotController: _shotController,
            physics: ClampingScrollPhysics(),
            children: [
              Container(
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        padding: EdgeInsets.all(0.0),
                        itemBuilder: (context, index) {
                          IndexBrief spotBrief = model.briefList[index];
                          return IndexBriefItem(
                            index: index,
                            title: spotBrief.title,
                            subTitle: spotBrief.value,
                            detailInfo: spotBrief.detail,
                            type: spotBrief.type,
                          );
                        },
                        itemCount: model.briefList.length,
                      ),

                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(15, 15, 16, 17),
                        child: Text(S.of(context).moreLink, style: TextStyles.textGray800_w700_14),
                      ),

                      GridView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.fromLTRB(15, 0, 16, 12),
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 4.0,
                        ),
                        itemCount: model.friendLinkList.length,
                        itemBuilder: (_, index) {
                          FriendLink friendLink = model.friendLinkList[index];
                          return Container(
                            alignment: Alignment.centerLeft,
//                            padding: const EdgeInsets.only(left: 10),
//                            decoration: BoxDecoration(
//                                border: Border.all(width: 0.6, color: Colours.default_line)
//                            ),
                            child: Text.rich(
                                TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child: RoundImage(friendLink.ico ?? '',
                                          width: 19,
                                          height: 19,
                                          borderRadius: BorderRadius.all(Radius.circular(0)),
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' ${friendLink.name}',
                                        style: TextStyles.textMain500_14,
                                        recognizer: new TapGestureRecognizer()..onTap = () => OtherUtil.launchURL(friendLink.url),
                                      )
                                    ]
                                )
                            ),
                          );
                        },
                      )
                    ],
                  )
              ),

              Container(
                child: Column(
                  children: [
                    Container(
                        margin: const EdgeInsets.fromLTRB(15, 18, 16, 9),
                        height: 24,
                        child: InkWell(
                          onTap: () {
                            int index = widget.coinCode == Apis.COIN_BITCOIN ? 1 : widget.coinCode == Apis.COIN_ETHEREUM ? 2 : 0;
                            Routers.navigateTo(context, Routers.milestonePage,
                                parameters: Parameters()..putInt('initialIndex', index)
                            );
                          } ,
                          child: Row(
                            children: [
                              Expanded(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      S.of(context).blockMileStone,
                                      style: TextStyles.textGray800_w700_18,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )),
                              Container(
                                  alignment: Alignment.bottomLeft,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(S.of(context).all, style: TextStyles.textMain500_14),
                                      Gaps.hGap3,
                                      Icon(Icons.keyboard_arrow_right, color: Colours.app_main_500, size: 15),
                                    ],
                                  )
                              ),
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
