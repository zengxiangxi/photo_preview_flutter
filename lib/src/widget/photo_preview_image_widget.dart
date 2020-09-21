import 'dart:async';
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
import 'package:photo_preview/src/widget/photo_preview_error_widget.dart';

import '../../photo_preview_export.dart';
import 'inherit/photo_preview_data_inherited_widget.dart';

class PhotoPreviewImageWidget extends StatefulWidget {
  ///图片详情
  final PhotoPreviewInfoVo imageInfo;

  final VoidCallback popCallBack;

  final int currentPostion;

  final EdgeInsetsGeometry imgMargin;

  const PhotoPreviewImageWidget(
      {Key key,
      this.imageInfo,
      this.popCallBack,
      this.currentPostion,
      this.imgMargin})
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

  ///缓存的手势Key
  GlobalKey<ExtendedImageGestureState> _loadGestureGlobalKey;

  ///图片配置
  PhotoPreviewImageDelegate _imageDelegate;

  ExtendedImage _extendedImage;

  @override
  void initState() {
    super.initState();
    _gestureGlobalKey = GlobalKey();
    _loadGestureGlobalKey = GlobalKey();
    _doubleClickAnimationController = AnimationController(
        duration: const Duration(
            milliseconds: PhotoPreviewConstant.DOUBLE_CLICK_SCAL_TIME_MILL),
        vsync: this);
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
            child: Container(
                padding: _imageDelegate?.imgMargin,
                child: _imageDelegate?.imageWidget(widget?.imageInfo,
                        result: _toImageWidget()) ??
                    _toImageWidget())));
  }

  ///图片组件
  Widget _toImageWidget() {
    if (widget?.imageInfo?.url == null || widget.imageInfo.url.isEmpty) {
      return PhotoPreviewErrorWidget();
    }
    if (_extendedImage != null) {
      return _extendedImage;
    }

    if (PhotoPreviewToolUtils.isNetUrl(widget?.imageInfo?.url)) {
      _extendedImage = ExtendedImage.network(widget?.imageInfo?.url ?? "",
          //可拖动下滑退出
          enableSlideOutPage: _imageDelegate?.enableSlideOutPage ?? true,
          mode: _imageDelegate?.mode ?? ExtendedImageMode.gesture,
          enableLoadState: _imageDelegate?.enableLoadState ?? true,
          extendedImageGestureKey: _gestureGlobalKey,
          loadStateChanged: (ExtendedImageState state) =>
              _imageDelegate?.loadStateChanged(state,
                  imageInfo: widget?.imageInfo) ??
              _toLoadStateChanged(state),
          onDoubleTap: (state) {
            if (_imageDelegate?.onDoubleTap != null) {
              _imageDelegate?.onDoubleTap(state, widget?.imageInfo, context);
              return;
            }
            _onDoubleTap(state);
          },
          initGestureConfigHandler: (state) => _imageDelegate
              ?.initGestureConfigHandler(state, imageInfo: widget?.imageInfo),
          heroBuilderForSlidingPage: (Widget result) =>
              _imageDelegate?.heroBuilderForSlidingPage(result,
                  imageInfo: widget?.imageInfo));
    } else {
      _extendedImage = ExtendedImage.file(File(widget?.imageInfo?.url),
          //可拖动下滑退出
          enableSlideOutPage: _imageDelegate?.enableSlideOutPage ?? true,
          mode: _imageDelegate?.mode ?? ExtendedImageMode.gesture,
          onDoubleTap: (state) => (state) {
                if (_imageDelegate?.onDoubleTap != null) {
                  _imageDelegate?.onDoubleTap(
                      state, widget?.imageInfo, context);
                  return;
                }
                _onDoubleTap(state);
              },
          enableLoadState: _imageDelegate?.enableLoadState ?? true,
          extendedImageGestureKey: _gestureGlobalKey,
          initGestureConfigHandler: (state) => _imageDelegate
              ?.initGestureConfigHandler(state, imageInfo: widget?.imageInfo),
          heroBuilderForSlidingPage: (Widget result) =>
              _imageDelegate?.heroBuilderForSlidingPage(result,
                  imageInfo: widget?.imageInfo));
    }
    return _extendedImage;
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
        break;
    }
    return Container();
  }

  ///预加载已缓存的类型
  Widget _toPrelLoadingImageWidget() {
    // if (widget?.imageInfo?.pLoadingUrl == null ||
    //     widget.imageInfo.pLoadingUrl.isEmpty) {
    //   return null;
    // }
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: (){
        _onClickPop(key: _loadGestureGlobalKey);
      },
      child: ExtendedImage.network(widget?.imageInfo?.loadingCoverUrl ?? "",
          //可拖动下滑退出
          enableSlideOutPage: _imageDelegate?.enableSlideOutPage ?? true,
          mode: _imageDelegate?.mode ?? ExtendedImageMode.gesture,
          loadStateChanged: (ExtendedImageState state) {
            switch (state.extendedImageLoadState) {
              case LoadState.failed:
                return PhotoPreviewErrorWidget();
                break;
            }
            return null;
          },
          extendedImageGestureKey: _loadGestureGlobalKey,
          onDoubleTap: (state) => (state) {
                if (_imageDelegate?.onDoubleTap != null) {
                  _imageDelegate?.onDoubleTap(state, widget?.imageInfo, context);
                  return;
                }
                _onDoubleTap(state);
              },
          initGestureConfigHandler: (state) => _imageDelegate
              ?.initGestureConfigHandler(state, imageInfo: widget?.imageInfo)),
    );
  }

  ///单击退出
  _onClickPop({GlobalKey key}) {
    if(key == null){
      key = _gestureGlobalKey;
    }
    if (key == null) {
      return;
    }
    ExtendedImageGestureState state = key?.currentState;
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
  void didChangeDependencies() {
    bool isNeedInit = false;
    if (_imageDelegate == null) {
      isNeedInit = true;
    }
    _imageDelegate = PhotoPreviewDataInherited.of(context)?.imageDelegate;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _doubleClickAnimationListener = null;
    _doubleClickAnimationController.dispose();
    _gestureGlobalKey = null;
    _loadGestureGlobalKey = null;
    _extendedImage = null;
    super.dispose();
  }
}
