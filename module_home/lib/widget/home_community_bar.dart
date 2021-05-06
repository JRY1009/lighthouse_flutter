
import 'package:flutter/material.dart';
import 'package:library_base/constant/constant.dart';
import 'package:library_base/event/event.dart';
import 'package:library_base/event/main_jump_event.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/mvvm/provider_widget.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/router/routers.dart';
import 'package:library_base/widget/easyrefresh/first_refresh_top.dart';
import 'package:library_base/widget/easyrefresh/loading_empty_top.dart';
import 'package:module_home/home_router.dart';
import 'package:module_home/item/leave_message_item.dart';
import 'package:module_home/viewmodel/leave_message_model.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeCommunityBar extends StatefulWidget {
  final VoidCallback onPressed;

  const HomeCommunityBar({
    Key key,
    this.onPressed,
  }) : super(key: key);

  @override
  _HomeCommunityBarState createState() => _HomeCommunityBarState();
}

class _HomeCommunityBarState extends State<HomeCommunityBar> with BasePageMixin<HomeCommunityBar> {

  LeaveMessageModel _leaveMessageModel;

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
    _leaveMessageModel = LeaveMessageModel();
    _leaveMessageModel.pageSize = 10;
    _leaveMessageModel.refresh();
  }

  @override
  Future<void> refresh({slient = false}) {
    return _leaveMessageModel.refresh();
  }

  @override
  Widget build(BuildContext context) {

    return ProviderWidget<LeaveMessageModel>(
        model: _leaveMessageModel,
        builder: (context, model, child) {

          Widget refreshWidget = FirstRefreshTop();
          Widget emptyWidget = LoadingEmptyTop();

          return Column(
            children: <Widget>[
              GestureDetector(
                onTap: () => Routers.navigateTo(context, Routers.communityPage),
                child: Container(
                  margin: EdgeInsets.only(left: 12, right: 12, top: 40),
                  height: 24,
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              S.of(context).dtCommunity,
                              style: TextStyles.textGray800_w600_18,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )),
                      Container(
                          alignment: Alignment.bottomLeft,
                          child: Row(
                            children: [
                              Text(S.of(context).more, style: TextStyles.textGray400_w400_12),
                              Gaps.hGap3,
                              Icon(Icons.keyboard_arrow_right, color: Colours.gray_400, size: 15),
                            ],
                          )
                      ),
                    ],
                  ),
                ),
              ),
              Gaps.vGap5,
              model.isFirst ? refreshWidget : (model.isEmpty || model.isError) ? emptyWidget : Container(
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 250,
                      viewportFraction: 0.98,
                      disableCenter: true,
                      enableInfiniteScroll: false,
                    ),
                    items: model.messageList.map((item) {
                      return LeaveMessageItem(
                          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                          maxLines: 4,
                          lvMessage: item
                      );
                    }).toList(),
                  )
              ),
              Gaps.vGap24,

              GestureDetector(
                onTap: () => Event.eventBus.fire(MainJumpEvent(MainJumpPage.info, params: {"tab": 1})),
                child: Container(
                  margin: EdgeInsets.only(left: 12, right: 12, bottom: 9),
                  height: 24,
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              S.of(context).latestInfo,
                              style: TextStyles.textGray800_w600_18,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )),
                      Container(
                          alignment: Alignment.bottomLeft,
                          child: Row(
                            children: [
                              Text(S.of(context).more, style: TextStyles.textGray400_w400_12),
                              Gaps.hGap3,
                              Icon(Icons.keyboard_arrow_right, color: Colours.gray_400, size: 15),
                            ],
                          )
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
    );
  }
}
