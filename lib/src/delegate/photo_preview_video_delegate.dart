import 'package:extended_image/extended_image.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_preview/photo_preview_export.dart';
import 'package:photo_preview/src/vo/photo_preview_info_vo.dart';


///视频配置
abstract class PhotoPreviewVideoDelegate{

  BuildContext context;

  ///初始化自定义视频控制器
  ///（目的：储存自定义控制器，返回videoWidget）
  ///tips: 可通过dispose销毁
  dynamic initCustomVideoPlayerController(PhotoPreviewInfoVo videoInfo,VideoPlayerController videoPlayerController);

  ///自定义视频组件（可直接自定义视频播放组件）
  Widget videoWidget(PhotoPreviewInfoVo videoInfo,{Widget result,VideoPlayerController videoPlayerController,dynamic customVideoPlayerController});

  ///开启拖动下滑退出
  bool get enableSlideOutPage;

  ///启用加载状态
  bool get enableLoadState;

  ///初始化预览图片
  GestureConfig initGestureConfigHandler(ExtendedImageState state,
      BuildContext context,{PhotoPreviewInfoVo videoInfo});

  ///控制器距离底部距离
  double get controllerBottomDistance;

  ///视频的边距
  EdgeInsetsGeometry get videoMargin;

  ///滑动状态
  ValueChanged<bool> get isSlidingStatus;

  ///页面切换
  ValueChanged<int> get pageChangeStatus;

  ///初始化
  void initState();

  ///销毁
  void dispose();
}