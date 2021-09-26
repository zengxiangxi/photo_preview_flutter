import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_preview/photo_preview_export.dart';

class CustomPhotoPreviewVideoDelegate extends DefaultPhotoPreviewVideoDelegate {
  @override
  bool get enableLoadState {
    return true;
  }

  @override
  bool get enableSlideOutPage {
    return true;
  }

  @override
  Widget? videoWidget(PhotoPreviewInfoVo? videoInfo, {Widget? result,VideoPlayerController? videoPlayerController,dynamic customVideoPlayerController}) {
    return null;
    // return ExtendedCustomWidget(
    //     child: Container(
    //   height: 200,
    //   color: Colors.green,
    // ));
  }
}
