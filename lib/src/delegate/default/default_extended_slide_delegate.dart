import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:extended_image/src/gesture/extended_image_slide_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_preview/photo_preview_export.dart';
import 'package:photo_preview/src/constant/photo_preview_constant.dart';

///默认滑动配置
class DefaultExtendedSlideDelegate extends ExtendedSlideDelegate {
  @override
  SlideAxis get slideAxis => SlideAxis.vertical;

  @override
  SlideType get slideType => SlideType.wholePage;

  @override
  SlidePageBackgroundHandler get slidePageBackgroundHandler =>
      _slidePageBackgroundHandler;

  @override
  ValueChanged<bool> get isSlidingStatus => null;

  @override
  Duration get resetPageDuration =>
      Duration(milliseconds: PhotoPreviewConstant.DEFAULT_RESET_MILL);

  @override
  SlideEndHandler get slideEndHandler => _slideEndHandler;

  @override
  SlideScaleHandler get slideScaleHandler => _slideScaleHandler;

  @override
  Widget topWidget(bool isSlideStatus) => null;

  @override
  Widget bottomWidget(bool isSlideStatus) => null;

  @override
  Widget wholeWidget(Widget result) => null;

  @override
  EdgeInsetsGeometry get imgVideoMargin => null;

  @override
  ValueChanged<int> get pageChangeStatus => null;

  @override
  void dispose() => null;

  @override
  void initState() => null;


  ///滑动背景变化回调
  final SlidePageBackgroundHandler _slidePageBackgroundHandler =
      (Offset offset, Size pageSize) {
    double opacity = 0.0;
    //向上滑动不改变透明度
    if (offset.dy > 0) {
      opacity = offset.distance /
          (Offset(pageSize.width, pageSize.height).distance / 2.0);
    } else {
      opacity = 0;
    }
    return PhotoPreviewConstant.DEFAULT_BACK_GROUND_COLOR
        .withOpacity(min(1.0, max(1.0 - opacity, 0.0)));
  };

  ///滑动缩放回调
  final SlideScaleHandler _slideScaleHandler = (
      Offset offset, {
        ExtendedImageSlidePageState state,
      }) {
    double scale = 0.0;
    scale = offset.distance /
        Offset(state?.context?.size?.width, state?.context?.size?.height)
            .distance;
    return max(1.0 - scale, 0.2);
  };

  ///滑动结束回调
  final SlideEndHandler _slideEndHandler = (
      Offset offset, {
        ExtendedImageSlidePageState state,
        ScaleEndDetails details,
      }) {
    //如果放大
    if ((state?.imageGestureState?.gestureDetails?.totalScale ??
        PhotoPreviewConstant.DEFAULT_TOTAL_SCALE) >
        (state?.imageGestureState?.imageGestureConfig?.initialScale ??
            PhotoPreviewConstant.DEFAULT_INIT_SCALE)) {
      return false;
    }
    //向上滑回弹
    if (offset.dy <= 0) {
      return false;
    }
    return offset.dy > 100;
  };
}
