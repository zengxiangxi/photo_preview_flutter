import 'dart:math';
import 'dart:ui';

import 'package:extended_image/src/extended_image_utils.dart';
import 'package:extended_image/src/gesture/extended_image_gesture_utils.dart';
import 'package:flutter/src/painting/edge_insets.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:photo_preview/src/constant/photo_preview_constant.dart';
import 'package:photo_preview/src/delegate/photo_preview_video_delegate.dart';
import 'package:photo_preview/src/utils/photo_preview_tool_utils.dart';
import 'package:photo_preview/src/utils/screen_util.dart';
import 'package:photo_preview/src/vo/photo_preview_info_vo.dart';

class DefaultPhotoPreviewVideoDelegate extends PhotoPreviewVideoDelegate{
  @override
  bool get enableLoadState => true;

  @override
  bool get enableSlideOutPage => true;

  @override
  GestureConfig initGestureConfigHandler(ExtendedImageState state, BuildContext context, {PhotoPreviewInfoVo videoInfo}) =>_initGestureConfigHandler(state,context);

  @override
  Widget videoWidget(PhotoPreviewInfoVo videoInfo, {Widget result}) => null;

  @override
  double get controllerBottomDistance => 0.0;

  @override
  EdgeInsetsGeometry get videoMargin => null;


  @override
  void dispose() => null;

  @override
  void initState() => null;

  ///初始化缩放配置回调
  final Function _initGestureConfigHandler =
      (ExtendedImageState state, context) {
    double initialScale = PhotoPreviewConstant.DEFAULT_INIT_SCALE;

    if (state?.extendedImageInfo != null &&
        state.extendedImageInfo.image != null) {
      initialScale = PhotoPreviewToolUtils.initScale(
          size:
          Size(ScreenUtils.screenW(context), ScreenUtils.screenH(context)),
          initialScale: initialScale,
          imageSize: Size(state.extendedImageInfo.image.width.toDouble(),
              state.extendedImageInfo.image.height.toDouble()));
    }
    return GestureConfig(
        inPageView: true,
        initialScale: initialScale,
        minScale: PhotoPreviewConstant.DEFAULT_MIX_SCALE * initialScale,
        maxScale: max(initialScale,
            PhotoPreviewConstant.DEFAULT_MAX_SCALE * initialScale),
        animationMaxScale: max(initialScale,
            PhotoPreviewConstant.DEFAULT_MAX_SCALE * initialScale),
        animationMinScale: min(initialScale,
            PhotoPreviewConstant.DEFAULT_MIX_SCALE * initialScale),
        initialAlignment: InitialAlignment.topCenter,
        //you can cache gesture state even though page view page change.
        //remember call clearGestureDetailsCache() method at the right time.(for example,this page dispose)
        cacheGesture: false);
  };



}