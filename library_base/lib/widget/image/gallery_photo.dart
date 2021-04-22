import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:library_base/constant/constant.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/utils/object_util.dart';
import 'package:library_base/utils/toast_util.dart';
import 'package:library_base/widget/dialog/dialog_util.dart';
import 'package:library_base/widget/dialog/loading_center_dialog.dart';
import 'package:library_base/widget/image/local_image.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class Gallery {
  Gallery({this.id, this.resource});

  final String id;
  final String resource;
}


class GalleryPhotoViewWrapper extends StatefulWidget{
  GalleryPhotoViewWrapper({
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialIndex,
    @required this.galleryItems,
    this.scrollDirection = Axis.horizontal,
  }) : pageController = PageController(initialPage: initialIndex);

  final LoadingBuilder loadingBuilder;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List<Gallery> galleryItems;
  final Axis scrollDirection;

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewWrapperState();
  }
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> with BasePageMixin<GalleryPhotoViewWrapper>  {
  int currentIndex;

  @override
  void initState() {
    currentIndex = widget.initialIndex;
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: widget.backgroundDecoration,
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: _buildItem,
              itemCount: widget.galleryItems.length,
              loadingBuilder: widget.loadingBuilder ?? (context, event) {
                return Center(
                  child: SpinKitCircle(
                    color: Colours.app_main,
                    size: 30.0,
                  ),
                );
              },
              backgroundDecoration: widget.backgroundDecoration,
              pageController: widget.pageController,
              onPageChanged: onPageChanged,
              scrollDirection: widget.scrollDirection,
            ),
            Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.all(30.0),
              child: Text(
                "${currentIndex + 1} / ${widget.galleryItems.length}",
                style: TextStyles.textWhite16
              ),
            ),
            Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.only(right: 30, bottom: 30.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                      onTap: (){
                        final Gallery item = widget.galleryItems[currentIndex];
                        DialogUtil.showShareImageDialog(context,
                          imgUrl: item.resource,
                        );
                      },
                      child: LocalImage('icon_share_dark', package: Constant.baseLib, width: 38, height: 38)
                  ),
                  Gaps.hGap24,
                  GestureDetector(
                      onTap: () => _save(context),
                      child: LocalImage('icon_save_dark', package: Constant.baseLib, width: 38, height: 38)
                  ),
                ],
              ),
            )

          ],
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final Gallery item = widget.galleryItems[index];
    return PhotoViewGalleryPageOptions(
      imageProvider: NetworkImage(item.resource),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 4.1,
      heroAttributes: PhotoViewHeroAttributes(tag: item.id),
      onTapUp: (context, details, controllerValue) => Navigator.pop(context),
    );
  }

  @override
  Widget buildProgress({String content, bool showContent}) {
    return LoadingCenterDialog(
        content: content,
        showContent: showContent);
  }

  Future<void> _save(BuildContext context) async {
    PermissionStatus status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
      return;
    }

    showProgress(content: S.of(context).saving);
    final Gallery item = widget.galleryItems[currentIndex];
    var response = await Dio().get(item.resource, options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));

    closeProgress();
    if (ObjectUtil.isEmpty(result)){
      ToastUtil.error(S.of(context).saveFailed);
    } else{
      String suffix = result['filePath'] != null ? result['filePath']?.replaceAll("file://", "") : '';
      ToastUtil.success(S.of(context).saveSuccess + suffix);
    }
  }
}
