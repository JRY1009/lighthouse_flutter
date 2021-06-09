
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:library_base/constant/constant.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/global/rt_account.dart';
import 'package:library_base/model/account.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/mvvm/provider_widget.dart';
import 'package:library_base/net/apis.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/router/routers.dart';
import 'package:library_base/utils/path_util.dart';
import 'package:library_base/utils/toast_util.dart';
import 'package:library_base/widget/clickbar/mine_clickbar.dart';
import 'package:library_base/widget/common_scroll_view.dart';
import 'package:library_base/widget/dialog/dialog_util.dart';
import 'package:library_base/widget/image/local_image.dart';
import 'package:module_mine/viewmodel/setting_model.dart';
import 'package:module_mine/widget/mine_appbar.dart';
import 'package:path_provider/path_provider.dart';

class MinePage extends StatefulWidget {

  const MinePage({
    Key? key,
  }) : super(key : key);

  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> with BasePageMixin<MinePage>, AutomaticKeepAliveClientMixin<MinePage>, SingleTickerProviderStateMixin {

  @override
  bool get wantKeepAlive => true;

  late SettingModel _settingModel;

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
          RTAccount.instance()!.logout();
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
            await PathUtils.delDir(cacheDir, onlyChild: true);
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
        backgroundColor: Colours.white,
        body: ProviderWidget<SettingModel>(
            model: _settingModel,
            builder: (context, model, child) {
              Account? account = RTAccount.instance()!.getActiveAccount();
              return CommonScrollView(
                  children: [
                    MineAppBar(
                      account: account,
                      onPressed: () => Routers.loginGuardNavigateTo(context, Routers.settingPage),
                      onActionPressed: () => ToastUtil.normal('通知'),
                      onAvatarPressed: () => Routers.loginGuardNavigateTo(context, Routers.settingPage),
                    ),
                    Container(
                      child: Column(
                        children: [
                          MineClickBar(
                            title: S.of(context).accountSecurity,
                            icon: LocalImage('icon_shield', package: Constant.baseLib, color: Colours.gray_350, width: 20, height: 20),
                            onPressed: () => Routers.loginGuardNavigateTo(context, Routers.settingPage),
                          ),
                          MineClickBar(
                              title: S.of(context).clearCache,
                              icon: LocalImage('icon_broom', package: Constant.baseLib, color: Colours.gray_350, width: 20, height: 20),
                              onPressed: _clearCache
                          ),
                          MineClickBar(
                              title: S.of(context).share,
                              icon: LocalImage('icon_share', package: Constant.baseLib, color: Colours.gray_350, width: 20, height: 20),
                              onPressed: () {
                                DialogUtil.showShareLinkDialog(context,
                                  title_share: '标题',
                                  summary_share: '内容',
                                  url_share: Apis.URL_OFFICIAL_WEBSITE,
                                );
                              }
                          ),
                          MineClickBar(
                              title: S.of(context).about + S.of(context).appName,
                              icon: LocalImage('icon_info', package: Constant.baseLib, color: Colours.gray_350, width: 20, height: 20),
                              onPressed: () => Routers.navigateTo(context, Routers.aboutPage)
                          ),
                        ],
                      ),
                    ),
//                    Gaps.vGap18,
//
//                    RTAccount.instance().isLogin() ? Container(
//                      margin: EdgeInsets.symmetric(horizontal: 12),
//                      decoration: BoxDecoration(
//                        color: Colours.white,
//                        borderRadius: BorderRadius.all(Radius.circular(14.0)),
//                        boxShadow: BoxShadows.normalBoxShadow,
//                      ),
//                      child: FlatButton(
//                          onPressed: () => _logout(),
//                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14.0))),
//                          padding: EdgeInsets.all(0.0),
//                          child: Container(
//                              alignment: Alignment.center,
//                              height: 50.0,
//                              width: double.infinity,
//                              child: Text(S.of(context).logout,
//                                style: TextStyles.textRedOri_w400_15,
//                                maxLines: 1,
//                                overflow: TextOverflow.ellipsis,
//                              )
//                          )
//                      ),
//                    ) : Gaps.empty
                  ]
              );
            }
        )
    );
  }
}
