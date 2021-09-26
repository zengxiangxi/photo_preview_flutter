import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:photo_preview/src/vo/photo_preview_info_vo.dart';
import 'package:photo_preview/src/vo/photo_preview_type.dart';

///图片组件配置
abstract class PhotoPreviewImageDelegate {
  BuildContext? context;

  ///自定义图片组件
  Widget? imageWidget(PhotoPreviewInfoVo? imageInfo,{Widget? result});

  ///开启拖动下滑退出
  bool get enableSlideOutPage;

  ///图片模式
  ExtendedImageMode get mode;

  ///启用加载状态
  bool get enableLoadState;

  ///加载状态变化
  Widget? loadStateChanged(
      ExtendedImageState state,{ PhotoPreviewInfoVo? imageInfo});

  ///单击
  onTapCallBack? get onClick;

  ///加载图单击
  onTapCallBack? get onLoadingClick;

  ///双击图片
  onDoubleTapCallBack? get onDoubleTap;

  ///加载图双击（暂时无法收到回调）
  onDoubleTapCallBack? get onLoadingDoubleTap;

  ///初始化图片
  GestureConfig? initGestureConfigHandler(ExtendedImageState state,{PhotoPreviewInfoVo? imageInfo});

  ///Hero配置
  Widget? heroBuilderForSlidingPage(Widget result,{PhotoPreviewInfoVo? imageInfo});

  ///图片边距
  EdgeInsetsGeometry? get imgMargin;

  ///滑动状态
  ValueChanged<bool>? get isSlidingStatus;

  ///页面切换
  ValueChanged<int>? get pageChangeStatus;

  ///初始化
  void initState();

  ///销毁
  void dispose();

}
