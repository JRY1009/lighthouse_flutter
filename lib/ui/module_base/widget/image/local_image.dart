
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/utils/image_util.dart';

/// 加载本地资源图片
class LocalImage extends StatelessWidget {
  
  const LocalImage(this.image, {
    Key key,
    this.width,
    this.height, 
    this.cacheWidth,
    this.cacheHeight,
    this.fit,
    this.format = ImageFormat.png,
    this.color,
    this.gaplessPlayback = false
  }): super(key: key);

  final String image;
  final double width;
  final double height;
  final int cacheWidth;
  final int cacheHeight;
  final BoxFit fit;
  final ImageFormat format;
  final Color color;
  final bool gaplessPlayback;
  
  @override
  Widget build(BuildContext context) {

    return Image.asset(
      ImageUtil.getImgPath(image, format: format),
      height: height,
      width: width,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
      fit: fit,
      color: color,
      /// 忽略图片语义
      excludeFromSemantics: true,
      gaplessPlayback: gaplessPlayback,
    );
  }
}
