import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:photo_preview/photo_preview_export.dart';

///媒体类型
enum PhotoPreviewType{
  //图片
  image,
  //视频
  video,
  //未知类型
  unknow,
}

typedef onDoubleTapCallBack = void Function(ExtendedImageGestureState state,PhotoPreviewInfoVo? infoVo,BuildContext context);

typedef onTapCallBack = void Function(ExtendedImageGestureState? state,PhotoPreviewInfoVo? infoVo,BuildContext context);