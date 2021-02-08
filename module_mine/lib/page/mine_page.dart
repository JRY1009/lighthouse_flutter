
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:library_base/event/event.dart';
import 'package:library_base/event/user_event.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/model/account.dart';
import 'package:library_base/global/rt_account.dart';
import 'package:library_base/mvvm/provider_widget.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/router/routers.dart';
import 'package:library_base/widget/clickbar/mine_clickbar.dart';
import 'package:library_base/widget/common_scroll_view.dart';
import 'package:library_base/widget/dialog/dialog_util.dart';
import 'package:library_base/utils/path_util.dart';
import 'package:library_base/utils/toast_util.dart';
import 'package:module_mine/viewmodel/setting_model.dart';
import 'package:module_mine/widget/mine_appbar.dart';
import 'package:path_provider/path_provider.dart';

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

  SettingModel _settingModel;

  @override
  void initState() {
    super.initState();
    initViewModel();
  }

  void initViewModel() {
    _settingModel = SettingModel();
    _settingModel.listenEvent();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _logout() {
    DialogUtil.showCupertinoAlertDialog(context,
        title: S.of(context).logout,
        content: S.of(context).logoutConfirm,
        cancel: S.of(context).cancel,
        confirm: S.of(context).confirm,
        cancelPressed: () => Navigator.of(context).pop(),
        confirmPressed: () {
          Navigator.of(context).pop();
          RTAccount.instance().logout();
        }
    );
  }

  Future<void> _clearCache() async {
    Directory cacheDir = await getTemporaryDirectory();
    double cacheSize = await PathUtils.getTotalSizeOfFilesInDir(cacheDir);
    if (cacheSize > 0) {

      DialogUtil.showCupertinoAlertDialog(context,
          title: S.of(context).clearCache,
          content: S.of(context).cacheSize + PathUtils.renderSize(cacheSize) + S.of(context).clearCacheConfirm,
          cancel: S.of(context).cancel,
          confirm: S.of(context).confirm,
          cancelPressed: () => Navigator.of(context).pop(),
          confirmPressed: () async {
            Navigator.of(context).pop();
            await PathUtils.delDir(cacheDir);
            ToastUtil.normal(S.of(context).clearCacheSuccess);
          }
      );

    } else {
      ToastUtil.normal(S.of(context).clearCacheSuccess);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        backgroundColor: Colours.normal_bg,
        appBar: AppBar(
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Colours.white,
          automaticallyImplyLeading: false,
          toolbarHeight: 10,
        ),
        body: ProviderWidget<SettingModel>(
            model: _settingModel,
            builder: (context, model, child) {
              Account account = RTAccount.instance().getActiveAccount();

              return Stack(
                children: <Widget>[
                  MineAppBar(
                    account: account,
                    onPressed: () => Routers.loginGuardNavigateTo(context, Routers.settingPage),
                    onActionPressed: () => ToastUtil.normal('点鸡 通知'),
                    onAvatarPressed: () => Routers.loginGuardNavigateTo(context, Routers.settingPage),
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
                                  icon: Icon(Icons.security, color: Colours.gray_350, size: 20),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(14.0))),
                                  onPressed: () => Routers.loginGuardNavigateTo(context, Routers.settingPage),
                                ),
                                MineClickBar(
                                    title: S.of(context).clearCache,
                                    icon: Icon(Icons.cleaning_services, color: Colours.gray_350, size: 20),
                                    onPressed: _clearCache
                                ),
                                MineClickBar(
                                    title: S.of(context).share,
                                    icon: Icon(Icons.share, color: Colours.gray_350, size: 20),
                                    onPressed: () => DialogUtil.showShareDialog(context)
                                ),
                                MineClickBar(
                                    title: S.of(context).about + S.of(context).appName,
                                    icon: Icon(Icons.info_outline, color: Colours.gray_350, size: 20),
                                    onPressed: () => Routers.loginGuardNavigateTo(context, Routers.aboutPage)
                                ),
                                MineClickBar(
                                    title: S.of(context).checkUpdate,
                                    icon: Icon(Icons.update, color: Colours.gray_350, size: 20),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(14.0))),
                                    onPressed: () => FlutterBugly.checkUpgrade()
                                ),
                              ],
                            ),
                          ),

                          Gaps.vGap18,

                          RTAccount.instance().isLogin() ? Container(
                            margin: EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colours.white,
                              borderRadius: BorderRadius.all(Radius.circular(14.0)),
                              boxShadow: BoxShadows.normalBoxShadow,
                            ),
                            child: FlatButton(
                                onPressed: () => _logout(),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14.0))),
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
                          ) : Gaps.empty


                        ]
                    ),
                  )

                ],
              );
            }
        )
    );
  }
}
