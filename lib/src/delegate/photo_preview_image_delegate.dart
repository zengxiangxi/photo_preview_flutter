import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:photo_preview/src/vo/photo_preview_info_vo.dart';
import 'package:photo_preview/src/vo/photo_preview_type.dart';

///图片组件配置
abstract class PhotoPreviewImageDelegate {
  BuildContext context;

  ///自定义图片组件
  Widget imageWidget(PhotoPreviewInfoVo imageInfo,{Widget result});

  ///开启拖动下滑退出
  bool get enableSlideOutPage;

  ///图片模式
  ExtendedImageMode get mode;

  ///启用加载状态
  bool get enableLoadState;

  ///加载状态变化
  Widget loadStateChanged(
      ExtendedImageState state,{ PhotoPreviewInfoVo imageInfo});

  ///单击
  onTapCallBack get onClick;


  ///双击图片
  onDoubleTapCallBack get onDoubleTap;

  ///初始化图片
  GestureConfig initGestureConfigHandler(ExtendedImageState state,{PhotoPreviewInfoVo imageInfo});

  ///Hero配置
  Widget heroBuilderForSlidingPage(Widget result,{PhotoPreviewInfoVo imageInfo});


}
