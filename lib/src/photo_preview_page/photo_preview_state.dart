import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_preview/src/constant/photo_preview_constant.dart';
import 'package:photo_preview/src/photo_preview_page/photo_preview_page.dart';
import 'package:photo_preview/src/utils/photo_preview_tool_utils.dart';
import 'package:photo_preview/src/vo/photo_preview_list_item_vo.dart';
import 'package:photo_preview/src/widget/photo_preview_image_widget.dart';

class PhotoPreviewState extends State<PhotoPreviewPage>{

  ///数据源List
  List<PhotoPreviewListItemVo> _dataSourceList;

  ///page控制器
  PageController _pageController;

  ///记录是否正在滑动
  bool _isSlidingStatus = false;

  @override
  void initState() {
    super.initState();
    _dataSourceList = PhotoPreviewToolUtils.transDataToPhotoPreviewList(widget?.dataSourceList);
    //控制器初始化
    _pageController = PageController(initialPage: _getInitialPage() ?? PhotoPreviewConstant.DEFAULT_INIT_PAGE);
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
    if(_dataSourceList == null || _dataSourceList.isEmpty){
      return Container();
    }
    return ExtendedImageGesturePageView.builder(
      itemCount: _dataSourceList?.length ?? 0,
      controller: _pageController,
      physics: BouncingScrollPhysics(),
      itemBuilder: (BuildContext ctx,int index){
        if(_dataSourceList?.elementAt(index)?.isImageType() ?? false){
          return PhotoPreviewImageWidget(
            heroTag: widget?.heroTag,
            imageInfo: _dataSourceList?.elementAt(index),
            popCallBack: () => Navigator.of(context).maybePop(),
          );
        }
        return Container();
      },
    );
  }

  ///得到初始化页
  int  _getInitialPage(){
    if(_dataSourceList == null || _dataSourceList.isEmpty){
      return PhotoPreviewConstant.DEFAULT_INIT_PAGE;
    }
    if(widget?.initialUrl != null && widget.initialUrl.isNotEmpty){
      int index = _dataSourceList.indexOf(PhotoPreviewListItemVo(url: widget?.initialUrl));
      if(index != -1){
        return index;
      }
    }
    if(widget?.initialPage == null || widget.initialPage < 0){
      return PhotoPreviewConstant.DEFAULT_INIT_PAGE;
    }
    if(widget.initialPage > (_dataSourceList.length - 1)){
      return _dataSourceList.length - 1;
    }
    return widget?.initialPage ?? PhotoPreviewConstant.DEFAULT_INIT_PAGE;
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
    super.dispose();
  }
}