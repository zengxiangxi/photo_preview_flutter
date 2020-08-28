import 'package:extended_image/extended_image.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_preview/src/vo/photo_preview_info_vo.dart';


///视频配置
abstract class PhotoPreviewVideoDelegate{
  ///自定义图片组件
  Widget videoWidget(PhotoPreviewInfoVo videoInfo,{Widget result});

  ///开启拖动下滑退出
  bool get enableSlideOutPage;

  ///启用加载状态
  bool get enableLoadState;

  ///初始化预览图片
  GestureConfig initGestureConfigHandler(ExtendedImageState state,
      BuildContext context,{PhotoPreviewInfoVo videoInfo});
}