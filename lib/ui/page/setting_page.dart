
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
import 'package:lighthouse/router/fade_route.dart';
import 'package:lighthouse/router/routers.dart';
import 'package:lighthouse/ui/page/base_page.dart';
import 'package:lighthouse/ui/widget/button/back_button.dart';
import 'package:lighthouse/ui/widget/clickbar/setting_avatar_clickbar.dart';
import 'package:lighthouse/ui/widget/clickbar/setting_clickbar.dart';
import 'package:lighthouse/ui/widget/common_scroll_view.dart';
import 'package:lighthouse/ui/widget/dialog/dialog_util.dart';
import 'package:lighthouse/ui/widget/image/gallery_photo.dart';
import 'package:lighthouse/utils/toast_util.dart';

class SettingPage extends StatefulWidget {

  const SettingPage({
    Key key,
  }) : super(key : key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> with BasePageMixin<SettingPage>{


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

  void _avatarSelect() {
    DialogeUtil.showAvatarSelectDialog(context,
      crop: true,
      selectCallback: (path) {
        ToastUtil.normal(path);
      },
      viewCallback: _viewAvatar
    );
  }

  void _viewAvatar() {

    Account account = RTAccount.instance().getActiveAccount();
    List<Gallery> galleryList = [Gallery(id: 'avatar', resource: account?.avatar_300)];

    Navigator.push(
      context,
      FadeRoute(
        pageBuilder: (context) => GalleryPhotoViewWrapper(
          galleryItems: galleryList,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: 0,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

  void _logout() {
    DialogeUtil.showCupertinoAlertDialog(context,
      title: S.of(context).logout,
      content: S.of(context).logoutConfirm,
      cancel: S.of(context).cancel,
      confirm: S.of(context).confirm,
      cancelPressed: () => Navigator.of(context).pop(),
      confirmPressed: () {
        Navigator.of(context).pop();
        Routers.goBack(context);
        RTAccount.instance().logout();
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    Account account = RTAccount.instance().getActiveAccount();
    return Scaffold(
        backgroundColor: Colours.normal_bg,
        appBar: AppBar(
            leading: BackButtonEx(),
            elevation: 0.5,
            brightness: Brightness.light,
            backgroundColor: Colours.white,
            centerTitle: true,
            title: Text(S.of(context).accountSecurity, style: TextStyles.textBlack18)
        ),
        body: CommonScrollView(
            children: <Widget>[
              Gaps.vGap10,

              SettingAvatarClickBar(
                  title: S.of(context).myAvatar,
                  account: account,
                  onPressed: _avatarSelect
              ),
              SettingClickBar(
                  title: S.of(context).accountSecurity,
                  subTitle: S.of(context).accountSecurity,
                  onPressed: () => ToastUtil.normal('点你就是点鸡 1')
              ),
              SettingClickBar(
                  title: S.of(context).accountSecurity,
                  onPressed: () => ToastUtil.normal('点你就是点鸡 2')
              ),
              SettingClickBar(
                  title: S.of(context).accountSecurity,
                  onPressed: () => ToastUtil.normal('点你就是点鸡 3')
              ),
              SettingClickBar(
                  title: S.of(context).accountSecurity,
                  onPressed: () => ToastUtil.normal('点你就是点鸡 4')
              ),

              Gaps.vGap18,

              FlatButton(
                  color: Colours.white,
                  onPressed: () => _logout(),
                  padding: EdgeInsets.all(0.0),
                  child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      width: double.infinity,
                      child: Text(S.of(context).logout,
                        style: TextStyles.textRed_w400_15,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                  )
              ),


            ]
        )
    );
  }

}
