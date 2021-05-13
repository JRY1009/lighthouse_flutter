import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluwx/fluwx.dart';
import 'package:library_base/constant/constant.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/net/apis.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/router/fade_route.dart';
import 'package:library_base/utils/log_util.dart';
import 'package:library_base/utils/object_util.dart';
import 'package:library_base/utils/toast_util.dart';
import 'package:library_base/widget/button/back_button.dart';
import 'package:library_base/widget/dialog/dialog_util.dart';
import 'package:library_base/widget/easyrefresh/first_refresh.dart';
import 'package:library_base/widget/image/gallery_photo.dart';
import 'package:library_base/widget/image/local_image.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticlePage extends StatefulWidget {
  final String url;
  final String title;
  final String title_share;
  final String summary_share;
  final String url_share;
  final String thumb_share;
  final bool show_share;
  final bool captureAllGestures;

  ArticlePage(this.url, this.title, {
    this.title_share,
    this.url_share,
    this.summary_share,
    this.thumb_share,
    this.show_share = true,
    this.captureAllGestures = false,
  });
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {

  InAppWebViewController webviewController;
  PullToRefreshController pullToRefreshController;
  ContextMenu contextMenu;

  double _opacity = 0.01;
  bool loaded = false;

  @override
  void initState() {
    super.initState();

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
          enabled: Platform.isIOS,
          color: Colours.transparent,
          backgroundColor: Colours.transparent
      ),
      onRefresh: () async {
        pullToRefreshController.endRefreshing();
      },
    );
  }

  Future<void> _share() async {
    DialogUtil.showShareLinkDialog(context,
      title_share: widget.title_share,
      summary_share: widget.summary_share,
      url_share: widget.url_share,
      thumb_share: widget.thumb_share,
    );
  }

  Future<void> _shareWechat(BuildContext context, WeChatScene scene) async {
    bool result = await isWeChatInstalled;
    if (!result) {
      ToastUtil.waring(S.of(context).shareWxNotInstalled);
      return;
    }

    shareToWeChat(WeChatShareWebPageModel(widget.url_share,
        title: widget.title_share,
        description: ObjectUtil.isEmpty(widget.summary_share) ? null : widget.summary_share,
        thumbnail: ObjectUtil.isEmpty(widget.thumb_share) ? WeChatImage.asset('assets/images/logo_share_wechat.png?package=library_base', suffix: '.png') : WeChatImage.network(widget.thumb_share),
        scene: scene)
    );
  }

  String getFontUri(ByteData data, String mime) {
    final buffer = data.buffer;
    return Uri.dataFromBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
        mimeType: mime)
        .toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colours.white,
        appBar: AppBar(
          leading: BackButtonEx(
            onPressed: () async {
              if (webviewController != null) {
                final bool canGoBack = await webviewController.canGoBack();
                if (canGoBack) {
                  // 网页可以返回时，优先返回上一页
                  await webviewController.goBack();
                }
              }
              Navigator.maybePop(context);
            },
          ),
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Colours.white,
          actions: widget.show_share ? <Widget>[
            IconButton(
              icon: LocalImage('icon_share', package: Constant.baseLib, width: 20, height: 20),
              onPressed: _share,
            )
          ] : null,
          centerTitle: true,
          title: Text(widget.title, style: TextStyles.textBlack18),
        ),
        body: Stack(
            children: [
              Opacity(
                  opacity: _opacity,
                  // --- FIX_BLINK ---
                  child: InAppWebView(
                    initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
                    pullToRefreshController: pullToRefreshController,
                    initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(
                        useShouldOverrideUrlLoading: true,
                        useOnLoadResource: true,
                        javaScriptEnabled: true,
                        incognito: true,
                        mediaPlaybackRequiresUserGesture: false,
                        clearCache: false,
                        javaScriptCanOpenWindowsAutomatically: false,
                      ),
                      android: AndroidInAppWebViewOptions(
                        hardwareAcceleration: true,
                        useHybridComposition: true,
                      ),
                      ios: IOSInAppWebViewOptions(
                          allowsAirPlayForMediaPlayback: false,
                          allowsInlineMediaPlayback: true),
                    ),
                    shouldOverrideUrlLoading: (InAppWebViewController controller, NavigationAction navigationAction) async {
                      var uri = navigationAction.request.url;
                      LogUtil.v('Open Url : ${uri}');

                      if (uri.toString().contains(Apis.URL_DISPLAY_WEBSITE)) {
                        return NavigationActionPolicy.ALLOW;

                      } else {
                        if (await canLaunch(uri.toString())) {
                          await launch(uri.toString());
                        }
                        return NavigationActionPolicy.CANCEL;
                      }
                    },
                    onWebViewCreated: (InAppWebViewController controller) {
                      webviewController = controller;
                      webviewController.addJavaScriptHandler(handlerName: 'share', callback: (args) {
                        WeChatScene scene = args[0] == 1 ? WeChatScene.SESSION : args[0] == 2 ? WeChatScene.TIMELINE : WeChatScene.SESSION;
                        _shareWechat(context, scene);
                      });

                      webviewController.addJavaScriptHandler(handlerName: 'previewPictures', callback: (args) {
                        LogUtil.v('previewPictures : ${args}');

                        List<Gallery> galleryList = [];
                        int length = args[0]?.length;
                        for (int i=0; i<length; i++) {
                          galleryList.add(Gallery(id: args[0][i], resource: args[0][i]));
                        }

                        Navigator.push(
                          context,
                          FadeRoute(
                            pageBuilder: (context) => GalleryPhotoViewWrapper(
                              galleryItems: galleryList,
                              backgroundDecoration: const BoxDecoration(
                                color: Colors.black,
                              ),
                              initialIndex: args.length >= 2 ? args[1] : 0,
                              scrollDirection: Axis.horizontal,
                            ),
                          ),
                        );
                      });
                    },
                    onLoadStart: (InAppWebViewController controller, Uri url) {
                      setState(() {
                      });
                    },
                    onLoadStop: (InAppWebViewController controller, Uri url) async {
                      if (!loaded) {
                        loaded = true;
                        setState(() { _opacity = 1.0; });
                      }

                      //init();
                    },
                  )
              ),

              !loaded ? FirstRefresh() : Gaps.empty
            ]
        )
    );
  }
}

