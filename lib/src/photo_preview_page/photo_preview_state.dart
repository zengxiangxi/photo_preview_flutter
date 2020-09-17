import 'dart:async';
import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_preview/src/constant/photo_preview_constant.dart';
import 'package:photo_preview/src/delegate/default/default_extended_slide_delegate.dart';
import 'package:photo_preview/src/photo_preview_page/photo_preview_page.dart';
import 'package:photo_preview/src/widget/inherit/photo_preview_data_inherited_widget.dart';
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
              _extendedSlideDelegate?.slidePageBackgroundHandler,
          //滑动缩放
          slideScaleHandler:
              _extendedSlideDelegate?.slideScaleHandler,
          //滑动结束
          slideEndHandler:
              _extendedSlideDelegate?.slideEndHandler,
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
        popCallBack: () => Navigator.of(context).maybePop(),
      );
    }
    //视频
    if (itemVo?.isVideoType() ?? false) {
      return PhotoPreviewVideoWidget(
          videoInfo: itemVo,
          currentPostion: index,
          videoMargin: _extendedSlideDelegate?.imgVideoMargin);
    }
    return PhotoPreviewErrorWidget();
  }

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


  @override
  void didChangeDependencies() {
    bool isNeedInit = false;
    if(_extendedSlideDelegate == null){
      isNeedInit = true;
    }
    _extendedSlideDelegate = PhotoPreviewDataInherited.of(context)?.slideDelegate;
    ///如果未初始化过，跳转到初始页
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if(isNeedInit) {
        _extendedSlideDelegate?.initState();
        _extendedSlideDelegate?.pageChangeStatus(
            widget?.dataSource?.lastInitPageNum ??
                PhotoPreviewConstant.DEFAULT_INIT_PAGE);
      }
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    _extendedSlideDelegate = null;
    PhotoPreviewValueSingleton.getInstance().dispose();
    _extendedSlideDelegate?.dispose();
    super.dispose();
  }
}
