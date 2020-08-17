import 'dart:async';
import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_preview/src/constant/photo_preview_constant.dart';
import 'package:photo_preview/src/photo_preview_page/photo_preview_page.dart';
import 'package:photo_preview/src/widget/photo_preview_image_widget.dart';
import 'package:photo_preview/src/widget/photo_preview_video_widget.dart';

import '../../photo_preview_export.dart';

class PhotoPreviewState extends State<PhotoPreviewPage>{

  ///page控制器
  PageController _pageController;

  ///记录是否正在滑动
  bool _isSlidingStatus = false;

  ///是否滑动streamController
  StreamController<bool> _isSlidingStreamController = StreamController.broadcast();

  @override
  void initState() {
    super.initState();
    //控制器初始化
    _pageController = PageController(initialPage: widget?.dataSource?.lastInitPageNum ?? PhotoPreviewConstant.DEFAULT_INIT_PAGE);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        child: _toSlideWidget(),
      ),
    );
  }

  Widget _toSlideWidget(){
    return ExtendedImageSlidePage(
      slideAxis: SlideAxis.both,
      slideType: SlideType.wholePage,
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
      child: _toMainWidget(),
    );
  }

  ///主体
  Widget _toMainWidget(){
    ///空页面
    if(widget?.dataSource?.imgVideoFullList == null || widget.dataSource.imgVideoFullList.isEmpty){
      return Container();
    }
    return ExtendedImageGesturePageView.builder(
      itemCount: widget.dataSource.imgVideoFullList?.length ?? 0,
      controller: _pageController,
      physics: BouncingScrollPhysics(),
      itemBuilder: (BuildContext ctx,int index){
        return _toListItemWidget(ctx, index);
      },
    );
  }

  ///图片或照片组件
  Widget _toListItemWidget(BuildContext ctx , int index){
    final PhotoPreviewInfoVo itemVo = widget?.dataSource?.imgVideoFullList?.elementAt(index);
    //图片
    if(itemVo?.isImageType() ?? false){
      return PhotoPreviewImageWidget(
        imageInfo: itemVo,
        isSlidingController:_isSlidingStreamController,
        popCallBack: () => Navigator.of(context).maybePop(),
      );
    }
    //视频
    if(itemVo?.isVideoType() ?? false){
      return PhotoPreviewVideoWidget(
        videoInfo: itemVo,
        isSlidingController:_isSlidingStreamController,
      );
    }
    return Container();
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
    if(_isSlidingStatus != showSwiper){
      _isSlidingStatus = showSwiper;
      _isSlidingStreamController.add(showSwiper);
      print("滑动状态-----${showSwiper}");
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
    _isSlidingStreamController?.close();
    super.dispose();
  }
}