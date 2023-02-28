import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluwx/fluwx.dart';
import 'package:library_base/constant/constant.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/mvvm/provider_widget.dart';
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
import 'package:module_info/viewmodel/article_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleRequestPage extends StatefulWidget {
  final num article_id;
  final bool captureAllGestures;

  ArticleRequestPage(this.article_id, {
    this.captureAllGestures = false,
  });
  _ArticleRequestPageState createState() => _ArticleRequestPageState();
}

class _ArticleRequestPageState extends State<ArticleRequestPage> {

  InAppWebViewController? webviewController;
  PullToRefreshController? pullToRefreshController;
  ContextMenu? contextMenu;

  late ArticleModel _articleModel;

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
        pullToRefreshController!.endRefreshing();
      },
    );

    _articleModel = ArticleModel('');

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (mounted) {
        initViewModel();
      }
    });
  }

  void initViewModel() {
    _articleModel.getArticle(widget.article_id);

    _articleModel.addListener(() {
      if (_articleModel.isError) {
        ToastUtil.error(_articleModel.viewStateError!.message!);
      }
    });
  }

  Future<void> _share() async {
    DialogUtil.showShareLinkDialog(context,
      title_share: _articleModel.article?.title ?? '',
      summary_share: _articleModel.article?.summary ?? '',
      url_share: _articleModel.article?.url ?? '',
      thumb_share: _articleModel.article?.snapshot_url ?? '',
    );
  }

  Future<void> _shareWechat(BuildContext context, WeChatScene scene) async {
    bool result = await isWeChatInstalled;
    if (!result) {
      ToastUtil.waring(S.of(context).shareWxNotInstalled);
      return;
    }

    shareToWeChat(WeChatShareWebPageModel(_articleModel.article?.url ?? '',
        title: _articleModel.article?.title ?? '',
        description: ObjectUtil.isEmpty(_articleModel.article?.summary) ? null : _articleModel.article?.summary,
        thumbnail: ObjectUtil.isEmpty(_articleModel.article?.snapshot_url) ? WeChatImage.asset('assets/images/logo_share_wechat.png?package=library_base', suffix: '.png') : WeChatImage.network(_articleModel.article?.snapshot_url ?? ''),
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
                final bool canGoBack = await webviewController!.canGoBack();
                if (canGoBack) {
                  // 网页可以返回时，优先返回上一页
                  await webviewController!.goBack();
                }
              }
              Navigator.maybePop(context);
            },
          ),
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
          backgroundColor: Colours.white,
          actions: <Widget>[
            IconButton(
              icon: LocalImage('icon_share', package: Constant.baseLib, width: 20, height: 20),
              onPressed: _share,
            )
          ],
          centerTitle: true,
          title: Text('', style: TextStyles.textBlack18),
        ),
        body: ProviderWidget<ArticleModel>(
            model: _articleModel,
            builder: (context, model, child) {
              return Stack(
                  children: [
                    model.isFirst ? Gaps.empty : Opacity(
                        opacity: _opacity,
                        // --- FIX_BLINK ---
                        child: InAppWebView(
                          initialUrlRequest: URLRequest(url: Uri.parse(model.article?.url_app ?? '')),
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
                            webviewController!.addJavaScriptHandler(handlerName: 'share', callback: (args) {
                              WeChatScene scene = args[0] == 1 ? WeChatScene.SESSION : args[0] == 2 ? WeChatScene.TIMELINE : WeChatScene.SESSION;
                              _shareWechat(context, scene);
                            });

                            webviewController!.addJavaScriptHandler(handlerName: 'previewPictures', callback: (args) {
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
                          onLoadStart: (InAppWebViewController controller, Uri? url) {
                            setState(() {
                            });
                          },
                          onLoadStop: (InAppWebViewController controller, Uri? url) async {
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
              );
            })
    );
  }
}

