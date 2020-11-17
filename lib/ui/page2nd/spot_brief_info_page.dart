
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/generated/l10n.dart';
import 'package:lighthouse/net/constant.dart';
import 'package:lighthouse/net/dio_util.dart';
import 'package:lighthouse/net/model/spot_brief_info.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/styles.dart';
import 'package:lighthouse/ui/item/milestone_item.dart';
import 'package:lighthouse/ui/item/spot_brief_info_item.dart';
import 'package:lighthouse/ui/page/base_page.dart';
import 'package:lighthouse/ui/widget/common_scroll_view.dart';
import 'package:lighthouse/utils/other_util.dart';
import 'package:lighthouse/utils/toast_util.dart';

class SpotBriefInfoPage extends StatefulWidget {

  const SpotBriefInfoPage({
    Key key,
  }): super(key: key);


  @override
  _SpotBriefInfoPageState createState() => _SpotBriefInfoPageState();
}

class _SpotBriefInfoPageState extends State<SpotBriefInfoPage> with BasePageMixin<SpotBriefInfoPage>, AutomaticKeepAliveClientMixin<SpotBriefInfoPage>, SingleTickerProviderStateMixin{

  @override
  bool get wantKeepAlive => true;

  List<SpotBriefInfo> _briefList = [];

  @override
  void initState() {
    super.initState();
    _requestData().then((value) => setState((){}));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Future<void> refresh({slient = false}) {
    return _requestData().then((value) => setState((){}));
  }

  Future<void> _requestData() {

    Map<String, dynamic> params = {
      'auth': 1,
      'sort': 1,
      'page': 0,
      'page_size': 10,
    };

    return DioUtil.getInstance().post(Constant.URL_GET_NEWS, params: params,
        successCallBack: (data, headers) {
          if (data == null || data['data'] == null) {
            return;
          }

          List<SpotBriefInfo> briefList = SpotBriefInfo.fromJsonList(data['data']['account_info']) ?? [];

          _briefList.clear();
          _briefList.addAll(briefList);
        },
        errorCallBack: (error) {
          ToastUtil.error(error[Constant.MESSAGE]);
        });
  }

  @override
  Widget build(BuildContext context) {

    return CommonScrollView(
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
                      title: _briefList[index].account_name,
                      subTitle: _briefList[index].city,
                      showDetail: index == 2,
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
                  itemCount: _briefList.length,
                  itemBuilder: (_, index) {
                    return Text.rich(
                        TextSpan(
                          text: _briefList[index].account_name,
                          style: TextStyles.textMain14,
                          recognizer: new TapGestureRecognizer()..onTap = () => OtherUtil.launchURL('https://www.baidu.com/'),
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
              ),

              ListView.builder(
                shrinkWrap: true,
                primary: false,
                padding: EdgeInsets.all(0.0),
                itemBuilder: (context, index) {
                  return MileStoneItem(
                    index: index,
                    content: _briefList[index].account_name,
                    time: _briefList[index].account_name,
                    isLast: index == (min(_briefList.length, 3) - 1),
                  );
                },
                itemCount: min(_briefList.length, 3),
              ),
            ],
          ),
        )
      ],
    );
  }
}
