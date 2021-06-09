import 'package:flutter/material.dart';

class FrameAnimationImage extends StatefulWidget {
  final List<String> assetList;
  final double? width;
  final double? height;
  final int interval;
  final bool repeat;

  const FrameAnimationImage(this.assetList, {
    this.width,
    this.height,
    this.interval = 25,
    this.repeat = false
  });

  @override
  State<StatefulWidget> createState() {
    return _FrameAnimationImageState();
  }
}

class _FrameAnimationImageState extends State<FrameAnimationImage>
    with SingleTickerProviderStateMixin {
  // 动画控制
  late Animation<double> _animation;
  late AnimationController _controller;
  int interval = 25;

  @override
  void initState() {
    super.initState();

    if (widget.interval != null) {
      interval = widget.interval;
    }
    final int imageCount = widget.assetList.length;
    final int maxTime = interval * imageCount;

    // 启动动画controller
    _controller = new AnimationController(
        duration: Duration(milliseconds: maxTime), vsync: this);
    _controller.addStatusListener((AnimationStatus status) {
      if(status == AnimationStatus.completed && widget.repeat) {
        _controller.forward(from: 0.0); // 完成后重新开始
      }
    });

    _animation = new Tween<double>(begin: 0, end: imageCount.toDouble()-1).animate(_controller)
      ..addListener(() {
        setState(() {
        });
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int ix = _animation.value.floor() % widget.assetList.length;

    List<Widget> images = [];
    // 把所有图片都加载进内容，否则每一帧加载时会卡顿
    for (int i = 0; i < widget.assetList.length; ++i) {
      if (i != ix) {
        images.add(Image.asset(
          widget.assetList[i],
          width: 0,
          height: 0,
          gaplessPlayback: true,
        ));
      }
    }

    images.add( Image.asset(
      widget.assetList[ix],
      width: widget.width,
      height: widget.height,
      gaplessPlayback: true,
    ) );


    return Stack(
        alignment: AlignmentDirectional.center,
        children: images);
  }
}