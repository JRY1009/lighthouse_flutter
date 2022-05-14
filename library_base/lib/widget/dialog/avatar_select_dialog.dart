import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/utils/object_util.dart';

class AvatarSelectDialog extends StatelessWidget {

  final bool crop;
  final ValueChanged<String>? selectCallback;
  final Function? viewCallback;

  final ImagePicker _picker = ImagePicker();

  AvatarSelectDialog({
    Key? key,
    this.crop = false,
    this.selectCallback,
    this.viewCallback
  }) : super(key: key);

  Future<String?> _selectImage(ImageSource source) async {

    PickedFile? _pickedFile = await _picker.getImage(source: source);
    String? path = _pickedFile?.path;

    if (crop && _pickedFile != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: _pickedFile.path,
          aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
          maxWidth: 720,
          maxHeight: 720,
          uiSettings:[AndroidUiSettings(
              hideBottomControls: false)],
      );
      path = croppedFile?.path;
    }

    return path;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          mainAxisSize: MainAxisSize.min, //wrap_content
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colours.white,
                borderRadius: BorderRadius.all(Radius.circular(14.0)),
              ),
              child: Column(
                children: [
                  FlatButton(
                      onPressed: () {
                        _selectImage(ImageSource.camera).then((String? path) {
                          if (ObjectUtil.isNotEmpty(path)) {
                            Navigator.pop(context);
                            if (selectCallback != null) {
                              selectCallback!(path!);
                            }
                          }
                        });
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(14.0))),
                      padding: EdgeInsets.all(0.0),
                      child: Container(
                          alignment: Alignment.center,
                          height: 60.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(width: 0.6, color: Colours.default_line))
                          ),
                          child: Text(S.of(context).camera,
                            style: TextStyles.textGray800_w400_16,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                      )
                  ),

                  FlatButton(
                      onPressed: () {
                        _selectImage(ImageSource.gallery).then((path) {
                          if (ObjectUtil.isNotEmpty(path)) {
                            Navigator.pop(context);
                            if (selectCallback != null) {
                              selectCallback!(path!);
                            }
                          }
                        });
                      },
                      padding: EdgeInsets.all(0.0),
                      child: Container(
                          alignment: Alignment.center,
                          height: 60.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(width: 0.6, color: Colours.default_line))
                          ),
                          child: Text(S.of(context).gallery,
                            style: TextStyles.textGray800_w400_16,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                      )
                  ),

                  FlatButton(
                      onPressed: () {
                        if (viewCallback != null) {
                          viewCallback!();
                        }
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(14.0))),
                      padding: EdgeInsets.all(0.0),
                      child: Container(
                          alignment: Alignment.center,
                          height: 60.0,
                          width: double.infinity,
                          child: Text(S.of(context).viewFullSize,
                            style: TextStyles.textGray800_w400_16,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                      )
                  ),
                ],
              ),
            ),
            Gaps.vGap10,
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colours.white,
                borderRadius: BorderRadius.all(Radius.circular(14.0)),
              ),
              child: FlatButton(
                  onPressed: () => Navigator.pop(context),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14.0))),
                  padding: EdgeInsets.all(0.0),
                  child: Container(
                      alignment: Alignment.center,
                      height: 56.0,
                      width: double.infinity,
                      child: Text(S.of(context).cancel,
                        style: TextStyles.textGray800_w400_16,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                  )
              ),
            ),
            Gaps.vGap10,

          ],
        )
    );
  }
}
