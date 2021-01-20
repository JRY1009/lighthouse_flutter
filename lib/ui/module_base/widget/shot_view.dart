import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ShotView extends StatefulWidget {
  final Widget child;
  final ShotController controller;

  ShotView({@required this.child, this.controller});

  @override
  _ShotViewState createState() => _ShotViewState();
}

class _ShotViewState extends State<ShotView> {
  GlobalKey<_OverRepaintBoundaryState> globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      widget.controller.setGlobalKey(globalKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _OverRepaintBoundary(
          key: globalKey,
          child: RepaintBoundary(
            child: widget.child,
          ),
        );
  }
}

class _OverRepaintBoundary extends StatefulWidget {
  final Widget child;

  const _OverRepaintBoundary({Key key, this.child}) : super(key: key);

  @override
  _OverRepaintBoundaryState createState() => _OverRepaintBoundaryState();
}

class _OverRepaintBoundaryState extends State<_OverRepaintBoundary> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class ShotController {
  GlobalKey<_OverRepaintBoundaryState> globalKey;

  Future<Uint8List> makeImageUint8List() async {
    RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
    // 这个可以获取当前设备的像素比
    var dpr = ui.window.devicePixelRatio;
    ui.Image image = await boundary.toImage(pixelRatio: dpr);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    return pngBytes;
  }

  setGlobalKey(GlobalKey<_OverRepaintBoundaryState> globalKey) {
    this.globalKey = globalKey;
  }
}