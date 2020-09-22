import 'package:extended_image/extended_image.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_preview/src/vo/photo_preview_info_vo.dart';


///视频配置
abstract class PhotoPreviewVideoDelegate{

  BuildContext context;

  ///自定义图片组件（可直接自定义视频播放组件）
  Widget videoWidget(PhotoPreviewInfoVo videoInfo,{Widget result});

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