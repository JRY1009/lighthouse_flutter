
import 'package:flutter/material.dart';
import 'package:lighthouse/net/model/account.dart';
import 'package:lighthouse/net/rt_account.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/styles.dart';
import 'package:lighthouse/ui/page/base_page.dart';
import 'package:lighthouse/ui/widget/appbar/mine_appbar.dart';
import 'package:lighthouse/ui/widget/common_scroll_view.dart';
import 'package:lighthouse/ui/widget/image/circle_image.dart';
import 'package:lighthouse/utils/toast_util.dart';

class MinePage extends StatefulWidget {

  const MinePage({
    Key key,
  }) : super(key : key);

  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> with BasePageMixin<MinePage>, AutomaticKeepAliveClientMixin<MinePage> {

  @override
  bool get wantKeepAlive => true;

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
              onPressed: () => ToastUtil.normal('点你就是点击'),
              onActionPressed: () => ToastUtil.normal('点你就是点击 通知'),
              onAvatarPressed: () => ToastUtil.normal('点你就是点击 头像'),
            ),

            Padding(
              padding: EdgeInsets.only(top: 110),
              child: CommonScrollView(
                  children: <Widget>[

                  ]
              ),)

          ],
        )
    );
  }

}
