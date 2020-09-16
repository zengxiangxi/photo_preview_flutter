
import 'package:flutter/widgets.dart';
import 'package:photo_preview/photo_preview_export.dart';

class CustomPhotoPreviewImageDelegate extends DefaultPhotoPreviewImageDelegate{

  @override
  bool get enableLoadState {
    return false;
  }

  @override
  bool get enableSlideOutPage {
    return true;
  }

  @override
  ExtendedImageMode get mode {
    return ExtendedImageMode.gesture;
  }

  @override
  Widget imageWidget(PhotoPreviewInfoVo imageInfo, {Widget result}) {
    return null;
    // return Container(
    //   padding: const EdgeInsets.only(top: 50,bottom: 50),
    //   child: result ?? Container(),
    // );
  }
}