import 'dart:async';
import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_preview/src/constant/photo_preview_constant.dart';
import 'package:photo_preview/src/delegate/default/default_extended_slide_delegate.dart';
import 'package:photo_preview/src/photo_preview_page/photo_preview_page.dart';
import 'package:photo_preview/src/widget/photo_preview_error_widget.dart';
import 'package:photo_preview/src/widget/photo_preview_image_widget.dart';
import 'package:photo_preview/src/widget/photo_preview_video_widget.dart';

import '../../photo_preview_export.dart';
import 'singleton/photo_preview_value_singleton.dart';

class PhotoPreviewState extends State<PhotoPreviewPage> {
  ///page控制器
  PageController _pageController;

  ///记录是否正在滑动
  bool _isSlidingStatus = false;

  ///滑动配置
  ExtendedSlideDelegate _extendedSlideDelegate;

  @override
  void initState() {
    super.initState();

    ///页码控制器初始化
    _pageController = PageController(
        initialPage: widget?.dataSource?.lastInitPageNum ??
            PhotoPreviewConstant.DEFAULT_INIT_PAGE);

    ///初始化滑动配置
    if (widget?.extendedSlideDelegate != null) {
      _extendedSlideDelegate = widget?.extendedSlideDelegate;
    } else {
      _extendedSlideDelegate = DefaultExtendedSlideDelegate();
    }

    ///设置滑动监听
    PhotoPreviewValueSingleton.getInstance()
        .setSlidingCallBack(_extendedSlideDelegate?.isSlidingStatus);
  }

  @override
  Widget build(BuildContext context) {
    final Widget slideWidget = _toSlideWidget();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        child: _extendedSlideDelegate?.wholeWidget(slideWidget) ?? slideWidget

      ),
    );
  }

  Widget _toSlideWidget() {
    return Stack(
      children: <Widget>[
        ExtendedImageSlidePage(
          slideAxis: _extendedSlideDelegate?.slideAxis ?? SlideAxis.both,
          slideType: _extendedSlideDelegate?.slideType ?? SlideType.wholePage,
          //滑动背景变化
          slidePageBackgroundHandler:
              _extendedSlideDelegate?.slidePageBackgroundHandler ??
                  _slidePageBackgroundHandler,
          //滑动缩放
          slideScaleHandler:
              _extendedSlideDelegate?.slideScaleHandler ?? _slideScaleHandler,
          //滑动结束
          slideEndHandler:
              _extendedSlideDelegate?.slideEndHandler ?? _slideEndHandler,
          //滑动监听
          onSlidingPage: (state) => _onSlidingPage(state),
          //重置时间
          resetPageDuration: _extendedSlideDelegate?.resetPageDuration ??
              Duration(milliseconds: PhotoPreviewConstant.DEFAULT_RESET_MILL),
          child: _toMainWidget(),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: StreamBuilder<bool>(
              initialData: false,
              stream: PhotoPreviewValueSingleton.getInstance()
                  ?.isSlidingController
                  ?.stream,
              builder: (context, snapshot) {
                return _extendedSlideDelegate?.topWidget(snapshot?.data) ??
                    Container();
              }),
        ),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: StreamBuilder<bool>(
                initialData: false,
                stream: PhotoPreviewValueSingleton.getInstance()
                    ?.isSlidingController
                    ?.stream,
                builder: (context, snapshot) {
                  return _extendedSlideDelegate?.bottomWidget(snapshot?.data) ??
                      Container();
                })),
      ],
    );
  }

  ///主体
  Widget _toMainWidget() {
    ///空页面
    if (widget?.dataSource?.imgVideoFullList == null ||
        widget.dataSource.imgVideoFullList.isEmpty) {
      return Container();
    }
    return ExtendedImageGesturePageView.builder(
      itemCount: widget.dataSource.imgVideoFullList?.length ?? 0,
      controller: _pageController,
      physics: BouncingScrollPhysics(),
      onPageChanged: (int position) {
        PhotoPreviewValueSingleton.getInstance()
            .pageIndexController
            ?.add(position);
      },
      itemBuilder: (BuildContext ctx, int index) {
        return _toListItemWidget(ctx, index);
      },
    );
  }

  ///图片或照片组件
  Widget _toListItemWidget(BuildContext ctx, int index) {
    final PhotoPreviewInfoVo itemVo =
        widget?.dataSource?.imgVideoFullList?.elementAt(index);
    //图片
    if (itemVo?.isImageType() ?? false) {
      return PhotoPreviewImageWidget(
        imageInfo: itemVo,
        currentPostion: index,
        imgMargin: _extendedSlideDelegate?.imgVideoMargin,
        imageDelegate: widget?.imageDelegate,
        popCallBack: () => Navigator.of(context).maybePop(),
      );
    }
    //视频
    if (itemVo?.isVideoType() ?? false) {
      return PhotoPreviewVideoWidget(
          videoInfo: itemVo,
          currentPostion: index,
          videoDelegate: widget?.videoDelegate,
          videoMargin: _extendedSlideDelegate?.imgVideoMargin);
    }
    return PhotoPreviewErrorWidget();
  }

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

  ///滑动状态回调
  void _onSlidingPage(state) {
    var showSwiper = state.isSliding ?? false;
    if (_isSlidingStatus != showSwiper) {
      _isSlidingStatus = showSwiper;
      PhotoPreviewValueSingleton.getInstance()
          .isSlidingController
          ?.add(showSwiper);
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
    if (offset.dy <= 0) {
      return false;
    }
//    return offset.distance >
//        Offset(state?.context?.size?.width ?? 0,
//                    state?.context?.size?.height ?? 0)
//                .distance /
//            12;
    return offset.dy > 100;
  };

  @override
  void dispose() {
    _pageController?.dispose();
    _extendedSlideDelegate = null;
    PhotoPreviewValueSingleton.getInstance().dispose();
    super.dispose();
  }
}
