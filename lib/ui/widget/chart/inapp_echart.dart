library flutter_echarts;

// --- FIX_BLINK ---
import 'dart:io' show Platform;
// --- FIX_BLINK ---

import 'package:flutter/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:flutter_echarts/echarts_script.dart' show echartsScript;

/// <!DOCTYPE html><html><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=0, target-densitydpi=device-dpi" /><style type="text/css">body,html,#chart{height: 100%;width: 100%;margin: 0px;}div {-webkit-tap-highlight-color:rgba(255,255,255,0);}</style></head><body><div id="chart" /></body></html>
/// 'data:text/html;base64,' + base64Encode(const Utf8Encoder().convert( /* STRING ABOVE */ ))
const htmlBase64 = 'data:text/html;base64,PCFET0NUWVBFIGh0bWw+PGh0bWw+PGhlYWQ+PG1ldGEgY2hhcnNldD0idXRmLTgiPjxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MS4wLCBtYXhpbXVtLXNjYWxlPTEuMCwgbWluaW11bS1zY2FsZT0xLjAsIHVzZXItc2NhbGFibGU9MCwgdGFyZ2V0LWRlbnNpdHlkcGk9ZGV2aWNlLWRwaSIgLz48c3R5bGUgdHlwZT0idGV4dC9jc3MiPmJvZHksaHRtbCwjY2hhcnR7aGVpZ2h0OiAxMDAlO3dpZHRoOiAxMDAlO21hcmdpbjogMHB4O31kaXYgey13ZWJraXQtdGFwLWhpZ2hsaWdodC1jb2xvcjpyZ2JhKDI1NSwyNTUsMjU1LDApO308L3N0eWxlPjwvaGVhZD48Ym9keT48ZGl2IGlkPSJjaGFydCIgLz48L2JvZHk+PC9odG1sPg==';

class InappEcharts extends StatefulWidget {
  InappEcharts({
    Key key,
    @required this.option,
    this.extraScript = '',
    this.onMessage,
    this.extensions = const [],
    this.theme,
    this.captureAllGestures = false,
    this.onLoad,
  }) : super(key: key);

  final String option;

  final String extraScript;

  final void Function(String message) onMessage;

  final List<String> extensions;

  final String theme;

  final bool captureAllGestures;

  final void Function() onLoad;

  @override
  InappEchartsState createState() => InappEchartsState();
}

class InappEchartsState extends State<InappEcharts> {
  InAppWebViewController webviewController;

  String _currentOption;

  // --- FIX_BLINK ---
  double _opacity = Platform.isAndroid ? 0.0 : 1.0;
  // --- FIX_BLINK ---

  @override
  void initState() {
    super.initState();
    _currentOption = widget.option;
  }

  void init() async {
    final extensionsStr = this.widget.extensions.length > 0
        ? this.widget.extensions.reduce(
            (value, element) => (value ?? '') + '\n' + (element ?? '')
    )
        : '';
    final themeStr = this.widget.theme != null ? '\'${this.widget.theme}\'' : 'null';
    await webviewController?.evaluateJavascript(source: '''
      $echartsScript
      $extensionsStr
      var chart = echarts.init(document.getElementById('chart'), $themeStr);
      ${this.widget.extraScript}
      chart.setOption($_currentOption, true);
    ''');
    if (widget.onLoad != null) {
      widget.onLoad();
    }
  }

  void update(String preOption) async {
    _currentOption = widget.option;
    if (_currentOption != preOption) {
      await webviewController?.evaluateJavascript(source: '''
        try {
          chart.setOption($_currentOption, true);
        } catch(e) {
        }
      ''');
    }
  }

  @override
  void didUpdateWidget(InappEcharts oldWidget) {
    super.didUpdateWidget(oldWidget);
    update(oldWidget.option);
  }

  // --- FIX_IOS_LEAK ---
  @override
  void dispose() {
    if (Platform.isIOS) {
      webviewController.clearCache();
    }
    super.dispose();
  }
  // --- FIX_IOS_LEAK ---

  @override
  Widget build(BuildContext context) {
    // --- FIX_BLINK ---
    return Opacity(
        opacity: _opacity,
        // --- FIX_BLINK ---
        child: InAppWebView(
          initialUrl: htmlBase64,
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              useShouldOverrideUrlLoading: true,
              useOnLoadResource: true,
              javaScriptEnabled: true,
              incognito: true,
              mediaPlaybackRequiresUserGesture: false,
              clearCache: true,
              javaScriptCanOpenWindowsAutomatically: false,
            ),
            android: AndroidInAppWebViewOptions(
                hardwareAcceleration: false
            ),
            ios: IOSInAppWebViewOptions(
                allowsAirPlayForMediaPlayback: false,
                allowsInlineMediaPlayback: true),
          ),

          onWebViewCreated: (InAppWebViewController controller) {
            webviewController = controller;
          },
          onLoadStart: (InAppWebViewController controller, String url) {
            setState(() {
            });
          },
          onLoadStop: (InAppWebViewController controller, String url) async {
            if (Platform.isAndroid) {
              setState(() { _opacity = 1.0; });
            }
            // --- FIX_BLINK ---
            init();
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
    );
  }
}
