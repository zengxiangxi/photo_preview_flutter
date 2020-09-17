
import 'package:flutter/foundation.dart';
import 'package:photo_preview/src/utils/photo_preview_tool_utils.dart';
import 'package:photo_preview/src/vo/photo_preview_type.dart';

class PhotoPreviewInfoVo {
  ///路径
  final String url;
  ///类型（通过路径尾缀判断）
  PhotoPreviewType _type;
  ///每一项hero
  final Object heroTag;
  ///视频封面路径(与加载使用)
  final String vCoverUrl;
  ///图片预加载路径
  final String pLoadingUrl;
  final dynamic extra;

  PhotoPreviewType get type  => _type;

  PhotoPreviewInfoVo({@required this.url,this.heroTag,this.vCoverUrl,this.pLoadingUrl,this.extra}){
    _type = PhotoPreviewToolUtils.getType(url);
  }


//  static PhotoPreviewListItemVo fromMap(Map<String, dynamic> map) {
//    if (map == null) return null;
//    PhotoPreviewListItemVo photoPreviewListItemVoBean = PhotoPreviewListItemVo();
//    return photoPreviewListItemVoBean;
//  }
//
//  Map toJson() => {
//  };
  bool isImageType(){
    if(_type == null){
      return false;
    }
    if(_type == PhotoPreviewType.image){
      return true;
    }
    return false;
  }

  bool isVideoType(){
    if(_type == null){
      return false;
    }
    if(_type == PhotoPreviewType.video){
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