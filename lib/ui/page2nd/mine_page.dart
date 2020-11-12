
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lighthouse/event/event.dart';
import 'package:lighthouse/event/user_event.dart';
import 'package:lighthouse/generated/l10n.dart';
import 'package:lighthouse/net/model/account.dart';
import 'package:lighthouse/net/rt_account.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/gaps.dart';
import 'package:lighthouse/res/styles.dart';
import 'package:lighthouse/router/routers.dart';
import 'package:lighthouse/ui/page/base_page.dart';
import 'package:lighthouse/ui/widget/appbar/mine_appbar.dart';
import 'package:lighthouse/ui/widget/clickbar/mine_clickbar.dart';
import 'package:lighthouse/ui/widget/common_scroll_view.dart';
import 'package:lighthouse/utils/log_util.dart';
import 'package:lighthouse/utils/toast_util.dart';

class MinePage extends StatefulWidget {

  const MinePage({
    Key key,
  }) : super(key : key);

  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> with BasePageMixin<MinePage>, AutomaticKeepAliveClientMixin<MinePage>, SingleTickerProviderStateMixin {

  @override
  bool get wantKeepAlive => true;

  StreamSubscription _userSubscription;

  @override
  void initState() {
    super.initState();

    _userSubscription = Event.eventBus.on<UserEvent>().listen((event) {
      setState(() {
      });
    });
  }

  @override
  void dispose() {
    if (_userSubscription != null) {
      _userSubscription.cancel();
    }

    super.dispose();
  }

  void _mineAppbarPresed() {
    if (RTAccount.instance().isLogin()) {
      ToastUtil.normal('点你就是点鸡');
    } else {
      Routers.navigateTo(context, Routers.loginPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Account account = RTAccount.instance().getActiveAccount();
    return Scaffold(
        backgroundColor: Colours.normal_bg,
        appBar: AppBar(
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Colours.white,
          automaticallyImplyLeading: false,
          toolbarHeight: 10,
        ),
        body: Stack(
          children: <Widget>[
            MineAppBar(
              account: account,
              onPressed: () => _mineAppbarPresed(),
              onActionPressed: () => ToastUtil.normal('点你就是点鸡 通知'),
              onAvatarPressed: () => ToastUtil.normal('点你就是点鸡 头像'),
            ),

            Padding(
              padding: EdgeInsets.only(top: 110),
              child: CommonScrollView(
                  children: <Widget>[
                    Gaps.vGap18,
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colours.white,
                        borderRadius: BorderRadius.all(Radius.circular(14.0)),
                        boxShadow: BoxShadows.normalBoxShadow,
                      ),
                      child: Column(
                        children: [
                          MineClickBar(
                              title: S.of(context).accountSecurity,
                              icon: Icon(Icons.security, color: Colours.gray_800, size: 20),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(14.0))),
                              onPressed: () => ToastUtil.normal('点你就是点鸡 1')
                          ),
                          MineClickBar(
                              title: S.of(context).accountSecurity,
                              icon: Icon(Icons.security, color: Colours.gray_800, size: 20),
                              onPressed: () => ToastUtil.normal('点你就是点鸡 2')
                          ),
                          MineClickBar(
                              title: S.of(context).accountSecurity,
                              icon: Icon(Icons.security, color: Colours.gray_800, size: 20),
                              onPressed: () => ToastUtil.normal('点你就是点鸡 3')
                          ),
                          MineClickBar(
                              title: S.of(context).accountSecurity,
                              icon: Icon(Icons.security, color: Colours.gray_800, size: 20),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(14.0))),
                              onPressed: () => ToastUtil.normal('点你就是点鸡 4')
                          )
                        ],
                      ),
                    ),

                    Gaps.vGap18,

                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colours.white,
                        borderRadius: BorderRadius.all(Radius.circular(14.0)),
                        boxShadow: BoxShadows.normalBoxShadow,
                      ),
                      child: FlatButton(
                          onPressed: () => RTAccount.instance().logout(),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14.0))),
                          padding: EdgeInsets.all(0.0),
                          child: Container(
                              alignment: Alignment.center,
                              height: 50.0,
                              width: double.infinity,
                              child: Text(S.of(context).logout,
                                style: TextStyles.textGray800_w400_14,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                          )
                      ),
                    )


                  ]
              ),)

          ],
        )
    );
  }

}
