
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/generated/l10n.dart';
import 'package:lighthouse/net/constant.dart';
import 'package:lighthouse/net/dio_util.dart';
import 'package:lighthouse/net/model/friend_link.dart';
import 'package:lighthouse/net/model/milestone.dart';
import 'package:lighthouse/net/model/spot_brief_info.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/styles.dart';
import 'package:lighthouse/router/routers.dart';
import 'package:lighthouse/ui/item/milestone_item.dart';
import 'package:lighthouse/ui/item/spot_brief_info_item.dart';
import 'package:lighthouse/ui/page/base_page.dart';
import 'package:lighthouse/ui/widget/common_scroll_view.dart';
import 'package:lighthouse/ui/widget/easyrefresh/first_refresh.dart';
import 'package:lighthouse/ui/widget/shot_view.dart';
import 'package:lighthouse/utils/other_util.dart';
import 'package:lighthouse/utils/toast_util.dart';

class SpotBriefInfoPage extends StatefulWidget {

  final String coin_code;

  const SpotBriefInfoPage({
    Key key,
    this.coin_code
  }): super(key: key);


  @override
  _SpotBriefInfoPageState createState() => _SpotBriefInfoPageState();
}

class _SpotBriefInfoPageState extends State<SpotBriefInfoPage> with BasePageMixin<SpotBriefInfoPage>, AutomaticKeepAliveClientMixin<SpotBriefInfoPage>, SingleTickerProviderStateMixin{

  @override
  bool get wantKeepAlive => true;

  ShotController _shotController = new ShotController();

  List<SpotBriefInfo> _briefList = [];
  List<FriendLink> _friendLinkList = [];
  List<MileStone> _milestoneList = [];

  bool _init = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(new Duration(milliseconds: 100), () {
      if (mounted) {
        _requestData();
      }
    });
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
    return _requestData();
  }

  Future<void> _requestData() {

    Map<String, dynamic> params = {
      'chain': 'bitcoin',
    };

    return DioUtil.getInstance().get(Constant.URL_GET_CHAIN_DETAIL, params: params,
        successCallBack: (data, headers) {
          if (data == null || data['data'] == null) {
            _finishRequest(success: false);
            return;
          }

          List<SpotBriefInfo> briefList = SpotBriefInfo.fromJsonList(data['data']['chain_detail']) ?? [];
          List<FriendLink> linkList = FriendLink.fromJsonList(data['data']['friend_link']) ?? [];
          List<MileStone> milestoneList = FriendLink.fromJsonList(data['data']['milestone']) ?? [];

          _briefList.clear();
          _briefList.addAll(briefList);

          _friendLinkList.clear();
          _friendLinkList.addAll(linkList);

          _milestoneList.clear();
          _milestoneList.addAll(milestoneList);

          _finishRequest(success: true);
        },
        errorCallBack: (error) {
          _finishRequest(success: false);
          ToastUtil.error(error[Constant.MESSAGE]);
        });
  }

  void _finishRequest({bool success}) {
    if (!_init) {
      _init = true;
    }

    if (mounted) {
      setState((){});
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return !_init ? FirstRefresh() : CommonScrollView(
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
                    return SpotBriefInfoItem(
                      index: index,
                      title: _briefList[index].title,
                      subTitle: _briefList[index].value,
                      showDetail: _briefList[index].value.length > 30,
                    );
                  },
                  itemCount: _briefList.length,
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
                  itemCount: _friendLinkList.length,
                  itemBuilder: (_, index) {
                    return Text.rich(
                        TextSpan(
                          text: _friendLinkList[index].name,
                          style: TextStyles.textMain14,
                          recognizer: new TapGestureRecognizer()..onTap = () => OtherUtil.launchURL(_friendLinkList[index].url),
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
                  return MileStoneItem(
                    index: index,
                    content: _milestoneList[index].content,
                    time: _milestoneList[index].date,
                    isLast: index == (min(_milestoneList.length, 3) - 1),
                  );
                },
                itemCount: min(_milestoneList.length, 3),
              ),
            ],
          ),
        )
      ],
    );
  }
}
