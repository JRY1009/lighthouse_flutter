import 'dart:async';
import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluwx/fluwx.dart';
import 'package:library_base/constant/constant.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/utils/object_util.dart';
import 'package:library_base/utils/toast_util.dart';
import 'package:library_base/widget/button/back_button.dart';
import 'package:library_base/widget/dialog/dialog_util.dart';
import 'package:library_base/widget/easyrefresh/first_refresh.dart';
import 'package:library_base/widget/image/local_image.dart';

class InappWebviewPage extends StatefulWidget {
  final String url;
  final String title;
  final String title_share;
  final String summary_share;
  final String url_share;
  final String thumb_share;
  final bool show_share;
  final bool captureAllGestures;

  InappWebviewPage(this.url, this.title, {
    this.title_share,
    this.url_share,
    this.summary_share,
    this.thumb_share,
    this.show_share = true,
    this.captureAllGestures = false,
  });
  _InappWebviewPageState createState() => _InappWebviewPageState();
}

class _InappWebviewPageState extends State<InappWebviewPage> {

  InAppWebViewController webviewController;

  double _opacity = 0.0;
  bool loaded = false;

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

  void init() async {

    final fontData = await rootBundle.load('assets/fonts/HYQiHei-55S.otf');
    final fontUri = getFontUri(fontData, 'font/opentype').toString();
    final fontCss =
        '@font-face { font-family: customFont; src: url($fontUri); } * { font-family: customFont; }';

    await webviewController?.injectCSSCode(source: fontCss);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.white,
      appBar: AppBar(
        leading: BackButtonEx(),
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
                initialUrl: widget.url,
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
                      hardwareAcceleration: true
                  ),
                  ios: IOSInAppWebViewOptions(
                      allowsAirPlayForMediaPlayback: false,
                      allowsInlineMediaPlayback: true),
                ),

                onWebViewCreated: (InAppWebViewController controller) {
                  webviewController = controller;
                  webviewController.addJavaScriptHandler(handlerName: 'share', callback: (args) {
                    WeChatScene scene = args[0] == 1 ? WeChatScene.SESSION : args[0] == 2 ? WeChatScene.TIMELINE : WeChatScene.SESSION;
                    _shareWechat(context, scene);
                  });
                },
                onLoadStart: (InAppWebViewController controller, String url) {
                  setState(() {
                  });
                },
                onLoadStop: (InAppWebViewController controller, String url) async {
                  loaded = true;

                  setState(() { _opacity = 1.0; });

                  //init();
                },
                gestureRecognizers: widget.captureAllGestures
                    ? (Set()
                  ..add(Factory<VerticalDragGestureRecognizer>(() {
                    return VerticalDragGestureRecognizer()
                      ..onStart = (DragStartDetails details) {}
                      ..onUpdate = (DragUpdateDetails details) {}
                      ..onDown = (DragDownDetails details) {}
                      ..onCancel = () {}
                      ..onEnd = (DragEndDetails details) {};
                  }))
                  ..add(Factory<HorizontalDragGestureRecognizer>(() {
                    return HorizontalDragGestureRecognizer()
                      ..onStart = (DragStartDetails details) {}
                      ..onUpdate = (DragUpdateDetails details) {}
                      ..onDown = (DragDownDetails details) {}
                      ..onCancel = () {}
                      ..onEnd = (DragEndDetails details) {};
                  })))
                    : null,
              )
          ),

          !loaded ? FirstRefresh() : Gaps.empty
        ]
      )
    );
  }
}

