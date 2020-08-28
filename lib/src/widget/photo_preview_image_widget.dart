import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_preview/src/constant/photo_preview_constant.dart';
import 'package:photo_preview/src/delegate/default/default_photo_preview_image_delegate.dart';
import 'package:photo_preview/src/delegate/photo_preview_image_delegate.dart';
import 'package:photo_preview/src/utils/photo_preview_tool_utils.dart';
import 'package:photo_preview/src/utils/screen_util.dart';
import 'package:photo_preview/src/vo/photo_preview_quality_type.dart';
import 'package:photo_preview/src/vo/photo_preview_type.dart';

import '../../photo_preview_export.dart';

class PhotoPreviewImageWidget extends StatefulWidget {
  ///图片详情
  final PhotoPreviewInfoVo imageInfo;

  final VoidCallback popCallBack;

  final int currentPostion;

  final PhotoPreviewImageDelegate imageDelegate;

  final EdgeInsetsGeometry imgMargin;

  const PhotoPreviewImageWidget(
      {Key key,
      this.imageInfo,
      this.popCallBack,
      this.currentPostion,
      this.imageDelegate, this.imgMargin})
      : super(key: key);

  @override
  _PhotoPreviewImageWidgetState createState() =>
      _PhotoPreviewImageWidgetState();
}

class _PhotoPreviewImageWidgetState extends State<PhotoPreviewImageWidget>
    with TickerProviderStateMixin {
  ///双击缩放控制器
  AnimationController _doubleClickAnimationController;
  Function _doubleClickAnimationListener;
  Animation<double> _doubleClickAnimation;

  ///手势key
  GlobalKey<ExtendedImageGestureState> _gestureGlobalKey;

  ///图片配置
  PhotoPreviewImageDelegate _imageDelegate;

  @override
  void initState() {
    super.initState();
    _gestureGlobalKey = GlobalKey();
    _doubleClickAnimationController = AnimationController(
        duration: const Duration(
            milliseconds: PhotoPreviewConstant.DOUBLE_CLICK_SCAL_TIME_MILL),
        vsync: this);

    ///初始化图片配置
    if (widget?.imageDelegate != null) {
      _imageDelegate = widget?.imageDelegate;
    } else {
      _imageDelegate = DefaultPhotoPreviewImageDelegate();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget?.imageInfo == null ||
        widget.imageInfo.type == null ||
        widget.imageInfo.type != PhotoPreviewType.image) {
      return Container();
    }
    return _toGestureWidget();
  }

  ///注册点击
  Widget _toGestureWidget() {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (_imageDelegate?.onClick != null) {
            _imageDelegate?.onClick(
                _gestureGlobalKey?.currentState, widget?.imageInfo, context);
            return;
          }
          _onClickPop();
        },
        child: Container(
                padding: widget?.imgMargin,
                child: _imageDelegate?.imageWidget(widget?.imageInfo) ?? _toImageWidget()));
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
        enableSlideOutPage: _imageDelegate?.enableSlideOutPage ?? true,
        mode: _imageDelegate?.mode ?? ExtendedImageMode.gesture,
        enableLoadState: _imageDelegate?.enableLoadState ?? true,
        extendedImageGestureKey: _gestureGlobalKey,
        loadStateChanged: (ExtendedImageState state) =>
            _imageDelegate?.loadStateChanged(state,imageInfo: widget?.imageInfo) ??
            _toLoadStateChanged(state),
        onDoubleTap: (state) {
          if (_imageDelegate?.onDoubleTap != null) {
            _imageDelegate?.onDoubleTap(state, widget?.imageInfo, context);
            return;
          }
          _onDoubleTap(state);
        },
        initGestureConfigHandler: (state) =>
            _imageDelegate?.initGestureConfigHandler(
                state, context,imageInfo: widget?.imageInfo) ??
            _initGestureConfigHandler(state, context),
        heroBuilderForSlidingPage: (Widget result) =>
            _imageDelegate?.heroBuilderForSlidingPage(
                result,imageInfo:  widget?.imageInfo) ??
            _heroBuilderForSlidingPage(result, widget?.imageInfo?.heroTag),
      );
    } else {
      return ExtendedImage.file(
        File(widget?.imageInfo?.url),
        //可拖动下滑退出
        enableSlideOutPage: _imageDelegate?.enableSlideOutPage ?? true,
        mode: _imageDelegate?.mode ?? ExtendedImageMode.gesture,
        onDoubleTap: (state) => (state) {
          if (_imageDelegate?.onDoubleTap != null) {
            _imageDelegate?.onDoubleTap(state, widget?.imageInfo, context);
            return;
          }
          _onDoubleTap(state);
        },
        enableLoadState: _imageDelegate?.enableLoadState ?? true,
        extendedImageGestureKey: _gestureGlobalKey,
        initGestureConfigHandler: (state) =>
            _imageDelegate?.initGestureConfigHandler(
                state, context,imageInfo:  widget?.imageInfo) ??
            _initGestureConfigHandler(state, context),
        heroBuilderForSlidingPage: (Widget result) =>
            _imageDelegate?.heroBuilderForSlidingPage(
                result,imageInfo:  widget?.imageInfo) ??
            _heroBuilderForSlidingPage(result, widget?.imageInfo?.heroTag),
      );
    }
  }

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
    if (heroTag == null) {
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

  ///加载状态
  Widget _toLoadStateChanged(ExtendedImageState state) {
    if (widget?.imageInfo?.pLoadingUrl == null ||
        widget.imageInfo.pLoadingUrl.isEmpty) {
      return null;
    }
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
      widget?.imageInfo?.pLoadingUrl ?? "",
      //可拖动下滑退出
      enableSlideOutPage: _imageDelegate?.enableSlideOutPage ?? true,
      mode: _imageDelegate?.mode ?? ExtendedImageMode.gesture,
//      loadStateChanged: (ExtendedImageState state) =>
//          _toLoadStateChanged(state),
      onDoubleTap: (state) => (state) {
        if (_imageDelegate?.onDoubleTap != null) {
          _imageDelegate?.onDoubleTap(state, widget?.imageInfo, context);
          return;
        }
        _onDoubleTap(state);
      },
      initGestureConfigHandler: (state) => _imageDelegate?.initGestureConfigHandler(state, context, imageInfo: widget?.imageInfo) ??
          _initGestureConfigHandler(state, context),
//      heroBuilderForSlidingPage: (Widget result) => _heroBuilderForSlidingPage(
//          result,
//          widget?.heroTag == null || widget.heroTag.isEmpty
//              ? widget?.imageInfo?.url
//              : widget?.heroTag),
    );
  }

  ///单击退出
  _onClickPop() {
    if (_gestureGlobalKey == null) {
      return;
    }
    ExtendedImageGestureState state = _gestureGlobalKey?.currentState;
    if (state == null) {
      return;
    }
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
      if (widget?.popCallBack != null) {
        widget?.popCallBack();
      }
      return;
//      end = PhotoPreviewConstant.DEFAULT_DOUBLE_TAP_SCALE[1] * initialScale;
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

    if (widget?.popCallBack != null) {
      Future.delayed(
          Duration(
              milliseconds: PhotoPreviewConstant.DOUBLE_CLICK_SCAL_TIME_MILL),
          () {
        widget?.popCallBack();
      });
    }
  }

  @override
  void dispose() {
    _doubleClickAnimationListener = null;
    _doubleClickAnimationController.dispose();
    _gestureGlobalKey = null;
    super.dispose();
  }
}
