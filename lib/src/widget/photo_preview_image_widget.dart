import 'dart:io';
import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_preview/src/constant/photo_preview_constant.dart';
import 'package:photo_preview/src/utils/photo_preview_tool_utils.dart';
import 'package:photo_preview/src/utils/screen_util.dart';
import 'package:photo_preview/src/vo/photo_preview_list_item_vo.dart';
import 'package:photo_preview/src/vo/photo_preview_quality_type.dart';
import 'package:photo_preview/src/vo/photo_preview_type.dart';

class PhotoPreviewImageWidget extends StatefulWidget {
  ///图片详情
  final PhotoPreviewListItemVo imageInfo;

  ///飞行标记
  final String heroTag;

  ///预加载质量类型
  final PhotoPreviewQualityType qualityType;

  const PhotoPreviewImageWidget(
      {Key key,
      this.imageInfo,
      this.heroTag,
      this.qualityType = PhotoPreviewQualityType.MIDDLE})
      : super(key: key);

  @override
  _PhotoPreviewImageWidgetState createState() =>
      _PhotoPreviewImageWidgetState();
}

class _PhotoPreviewImageWidgetState extends State<PhotoPreviewImageWidget>
    with TickerProviderStateMixin {
  ///记录是否正在滑动
  bool _isSlidingStatus = false;

  ///双击缩放控制器
  AnimationController _doubleClickAnimationController;
  Function _doubleClickAnimationListener;
  Animation<double> _doubleClickAnimation;

  @override
  void initState() {
    super.initState();
    _doubleClickAnimationController = AnimationController(
        duration: const Duration(milliseconds: 150), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    if (widget?.imageInfo == null ||
        widget.imageInfo.type == null ||
        widget.imageInfo.type != PhotoPreviewType.image) {
      return Container();
    }
    return ExtendedImageSlidePage(
      slideAxis: SlideAxis.both,
      slideType: SlideType.onlyImage,
      //滑动背景变化
      slidePageBackgroundHandler: _slidePageBackgroundHandler,
      //滑动缩放
      slideScaleHandler: _slideScaleHandler,
      //滑动结束
      slideEndHandler: _slideEndHandler,
      //滑动监听
      onSlidingPage: (state) => _onSlidingPage(state),
      //重置时间
      resetPageDuration:
          Duration(milliseconds: PhotoPreviewConstant.DEFAULT_RESET_MILL),
      child: _toImageWidget(),
    );
  }

  ///图片组件
  Widget _toImageWidget() {
    if (widget?.imageInfo?.url == null || widget.imageInfo.url.isEmpty) {
      return Container();
    }
    if (PhotoPreviewToolUtils.isNetUrl(widget?.imageInfo?.url)) {
      return ExtendedImage.network(
        widget?.imageInfo?.url ?? "",
        //可拖动下滑退出
        enableSlideOutPage: true,
        mode: ExtendedImageMode.gesture,
        enableLoadState: true,
//        loadStateChanged: (ExtendedImageState state) =>
//            _toLoadStateChanged(state),
        onDoubleTap: (state) => _onDoubleTap(state),
        initGestureConfigHandler: (state) =>
            _initGestureConfigHandler(state, context),
        heroBuilderForSlidingPage: (Widget result) =>
            _heroBuilderForSlidingPage(
                result,
                widget?.heroTag == null || widget.heroTag.isEmpty
                    ? widget?.imageInfo?.url
                    : widget?.heroTag),
      );
    } else {
      return ExtendedImage.file(
        File(widget?.imageInfo?.url),
        //可拖动下滑退出
        enableSlideOutPage: true,
        mode: ExtendedImageMode.gesture,
        onDoubleTap: (state) => _onDoubleTap(state),
        initGestureConfigHandler: (state) =>
            _initGestureConfigHandler(state, context),
        heroBuilderForSlidingPage: (Widget result) =>
            _heroBuilderForSlidingPage(
                result,
                widget?.heroTag == null || widget.heroTag.isEmpty
                    ? widget?.imageInfo?.url
                    : widget?.heroTag),
      );
    }
  }

  ///滑动背景变化回调
  final SlidePageBackgroundHandler _slidePageBackgroundHandler =
      (Offset offset, Size pageSize) {
    double opacity = 0.0;
    //向上滑动不改变透明度
    if(offset.dy >0) {
      opacity = offset.distance /
          (Offset(pageSize.width, pageSize.height).distance / 2.0);
    }else{
      opacity = 0;
    }
    return PhotoPreviewConstant.DEFAULT_BACK_GROUND_COLOR
        .withOpacity(min(1.0, max(1.0 - opacity, 0.0)));
  };

  ///滑动状态回调
  void _onSlidingPage(state) {
    _isSlidingStatus = (state?.isSliding ?? false);
    var showSwiper = state.isSliding;
    if (_isSlidingStatus != showSwiper) {
      _isSlidingStatus = showSwiper;
    }
  }

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
    if(offset.dy <= 0){
      return false;
    }
    return offset.distance >
        Offset(state?.context?.size?.width ?? 0,
                    state?.context?.size?.height ?? 0)
                .distance /
            6;
  };

  ///图片双击回调
  void _onDoubleTap(ExtendedImageGestureState state) {
    double initialScale = PhotoPreviewConstant.DEFAULT_INIT_SCALE;

    if (state?.imageGestureConfig?.initialScale != null &&
        state.imageGestureConfig.initialScale >=
            PhotoPreviewConstant.DEFAULT_INIT_SCALE) {
      initialScale = state?.imageGestureConfig?.initialScale;
    }
    final Offset pointerDownPosition = state.pointerDownPosition;
    final double begin = state.gestureDetails.totalScale;
    double end;

    //remove old
    _doubleClickAnimation?.removeListener(_doubleClickAnimationListener);

    //stop pre
    _doubleClickAnimationController.stop();

    //reset to use
    _doubleClickAnimationController.reset();

    if (begin ==
        PhotoPreviewConstant.DEFAULT_DOUBLE_TAP_SCALE[0] * initialScale) {
      end = PhotoPreviewConstant.DEFAULT_DOUBLE_TAP_SCALE[1] * initialScale;
    } else {
      end = PhotoPreviewConstant.DEFAULT_DOUBLE_TAP_SCALE[0] * initialScale;
    }

    _doubleClickAnimationListener = () {
      //print(_animation.value);
      state.handleDoubleTap(
          scale: _doubleClickAnimation.value,
          doubleTapPosition: pointerDownPosition);
    };
    _doubleClickAnimation = _doubleClickAnimationController
        .drive(Tween<double>(begin: begin, end: end));

    _doubleClickAnimation.addListener(_doubleClickAnimationListener);

    _doubleClickAnimationController.forward();
  }

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

  ///飞行动效
  final Function _heroBuilderForSlidingPage = (Widget result, String heroTag) {
    return Hero(
      tag: heroTag ?? "",
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

  ///加载状态
  Widget _toLoadStateChanged(ExtendedImageState state) {
    switch (state.extendedImageLoadState) {
      case LoadState.loading:
        return _toPrelLoadingImageWidget();
        break;
      case LoadState.completed:
        return state.completedWidget;
        break;
      case LoadState.failed:
        return _toPrelLoadingImageWidget();
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            state?.reLoadImage();
          },
          child: Container(
            alignment: Alignment.center,
            child: Text(
              "图片加载失败",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
        break;
    }
    return Container();
  }

  ///预加载已缓存的类型
  Widget _toPrelLoadingImageWidget() {
    return ExtendedImage.network(
      PhotoPreviewToolUtils.getAppendQualityTypeUrl(
              widget?.imageInfo?.url, widget?.qualityType) ??
          "",
      //可拖动下滑退出
      enableSlideOutPage: false,
      mode: ExtendedImageMode.gesture,
//      loadStateChanged: (ExtendedImageState state) =>
//          _toLoadStateChanged(state),
      onDoubleTap: (state) => _onDoubleTap(state),
      initGestureConfigHandler: (state) =>
          _initGestureConfigHandler(state, context),
//      heroBuilderForSlidingPage: (Widget result) => _heroBuilderForSlidingPage(
//          result,
//          widget?.heroTag == null || widget.heroTag.isEmpty
//              ? widget?.imageInfo?.url
//              : widget?.heroTag),
    );
  }

  @override
  void dispose() {
    _doubleClickAnimationListener = null;
    _doubleClickAnimationController.dispose();
    super.dispose();
  }
}
