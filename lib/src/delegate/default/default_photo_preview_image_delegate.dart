import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_preview/photo_preview_export.dart';
import 'package:photo_preview/src/constant/photo_preview_constant.dart';
import 'package:photo_preview/src/delegate/photo_preview_image_delegate.dart';
import 'package:photo_preview/src/utils/photo_preview_tool_utils.dart';
import 'package:photo_preview/src/utils/screen_util.dart';
import 'package:photo_preview/src/vo/photo_preview_info_vo.dart';

///默认图片配置
class DefaultPhotoPreviewImageDelegate extends PhotoPreviewImageDelegate{

  @override
  bool get enableLoadState => true;

  @override
  bool get enableSlideOutPage => true;

  @override
  heroBuilderForSlidingPage(Widget result, {PhotoPreviewInfoVo? imageInfo}) => _heroBuilderForSlidingPage(result,imageInfo?.heroTag,imageInfo?.url);

  @override
  Widget? imageWidget(PhotoPreviewInfoVo? imageInfo,{Widget? result}) =>null;

  @override
  initGestureConfigHandler(ExtendedImageState state,{PhotoPreviewInfoVo? imageInfo}) =>_initGestureConfigHandler(state,context);

  @override
  Widget? loadStateChanged(ExtendedImageState state, {PhotoPreviewInfoVo? imageInfo}) => null;

  @override
  ExtendedImageMode get mode => ExtendedImageMode.gesture;

  @override
  onTapCallBack? get onClick => null;

  @override
  onTapCallBack? get onLoadingClick => null;

  @override
  onDoubleTapCallBack? get onDoubleTap => null;

  @override
  onDoubleTapCallBack? get onLoadingDoubleTap => null;

  @override
  EdgeInsetsGeometry? get imgMargin => null;

  @override
  ValueChanged<bool>? get isSlidingStatus => null;

  @override
  ValueChanged<int>? get pageChangeStatus => null;

  @override
  void dispose() => null;

  @override
  void initState() => null;


  ///飞行动效
  final Function _heroBuilderForSlidingPage = (Widget result, Object? heroTag,String? url){
    if (heroTag == null || url == null || url.isEmpty) {
      return result;
    }
    if (!(PhotoPreviewToolUtils.isHasCacheNetImageUrl(url))){
      return result;
    }

    return Hero(
      tag: heroTag,
      child: result,
      transitionOnUserGestures: true,
      flightShuttleBuilder: (BuildContext flightContext,
          Animation<double> animation,
          HeroFlightDirection flightDirection,
          BuildContext fromHeroContext,
          BuildContext toHeroContext) {
        final Hero hero = (flightDirection == HeroFlightDirection.pop
            ? fromHeroContext.widget
            : toHeroContext.widget) as Hero;
        return hero.child;
      },
    );
  };


  ///初始化缩放配置回调
  final Function _initGestureConfigHandler =
      (ExtendedImageState state, context) {
    double? initialScale = PhotoPreviewConstant.DEFAULT_INIT_SCALE;

    if (state.extendedImageInfo != null) {
      initialScale = PhotoPreviewToolUtils.initScale(
          size:
          Size(ScreenUtils.screenW(context), ScreenUtils.screenH(context)),
          initialScale: initialScale,
          imageSize: Size(state.extendedImageInfo!.image.width.toDouble(),
              state.extendedImageInfo!.image.height.toDouble()));
    }
    return GestureConfig(
        inPageView: true,
        initialScale: initialScale!,
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