
import 'package:flutter/foundation.dart';
import 'package:photo_preview/src/utils/photo_preview_tool_utils.dart';
import 'package:photo_preview/src/vo/photo_preview_type.dart';

class PhotoPreviewInfoVo {

  ///路径
  final String url;

  ///类型（通过路径尾缀判断或者传值）
  PhotoPreviewType type;

  ///每一项hero
  final Object heroTag;

  ///图片/视频预加载封面路径
  final String loadingCoverUrl;

  ///自定义传额外参数
  final dynamic extra;


  PhotoPreviewInfoVo({@required this.url,this.heroTag,this.loadingCoverUrl,this.extra,PhotoPreviewType type}){
    //无类型默认通过尾缀判断
    if(type == null) {
      this.type = PhotoPreviewToolUtils.getType(url);
    }
  }

  bool isImageType(){
    if(type == null){
      return false;
    }
    if(type == PhotoPreviewType.image){
      return true;
    }
    return false;
  }

  bool isVideoType(){
    if(type == null){
      return false;
    }
    if(type == PhotoPreviewType.video){
      return true;
    }
    return false;
  }

  @override
  bool operator ==(other) {
    if(other == null){
      return false;
    }
    if(!(other is PhotoPreviewInfoVo)){
      return false;
    }

    if(other.url == null || other.url.isEmpty){
      return false;
    }
    if(this.url == null || this.url.isEmpty){
      return false;
    }
    if(this.url == other.url){
      return true;
    }
    return false;
  }

  @override
  int get hashCode => super.hashCode;

}