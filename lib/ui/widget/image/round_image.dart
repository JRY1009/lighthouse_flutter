
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/res/colors.dart';

class RoundImage extends StatelessWidget {
  
  const RoundImage(this.imageUrl, {
    Key key,
    this.width, 
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius
  }) : assert(imageUrl != null, 'The [imageUrl] argument must not be null.'),
       super(key: key);
  
  final String imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final BorderRadiusGeometry borderRadius;
  
  @override
  Widget build(BuildContext context) {

    return CachedNetworkImage(
      imageUrl: imageUrl ?? '',
      fit: fit,
      imageBuilder: (context, imageProvider) => Container(
        height: width,
        width: height,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          image: DecorationImage(
            image: imageProvider,
            fit: fit,
          ),
        ),
      ),
      placeholder: (context, url) => Container(
        color: Colours.gray_200,
      ),
      errorWidget: (_, __, dynamic error) => Container(
        color: Colours.gray_200,
      ),

    );
  }
}
