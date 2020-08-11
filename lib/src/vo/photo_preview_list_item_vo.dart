
import 'package:photo_preview/src/vo/photo_preview_type.dart';

class PhotoPreviewListItemVo {
  ///路径
  final String url;
  ///类型（通过路径尾缀判断）
  final PhotoPreviewType type;

  PhotoPreviewListItemVo({this.url, this.type});


//  static PhotoPreviewListItemVo fromMap(Map<String, dynamic> map) {
//    if (map == null) return null;
//    PhotoPreviewListItemVo photoPreviewListItemVoBean = PhotoPreviewListItemVo();
//    return photoPreviewListItemVoBean;
//  }
//
//  Map toJson() => {
//  };
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
    if(!(other is PhotoPreviewListItemVo)){
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