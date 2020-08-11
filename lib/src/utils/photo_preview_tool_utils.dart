import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:photo_preview/src/vo/photo_preview_list_item_vo.dart';
import 'package:photo_preview/src/vo/photo_preview_type.dart';

///图片工具类
class PhotoPreviewToolUtils {
  ///转化数据源
  static List<PhotoPreviewListItemVo> transDataToPhotoPreviewList(
      List<String> dataSourceList) {
    if (dataSourceList == null || dataSourceList.isEmpty) {
      return null;
    }
    List<PhotoPreviewListItemVo> _photoPreviewList = List();
    dataSourceList.forEach((element) {
      if (element == null || element.isEmpty) {
        return;
      }
      _photoPreviewList
          ?.add(PhotoPreviewListItemVo(url: element, type: _getType(element)));
    });
    return _photoPreviewList;
  }

  ///测试数据
  static List<PhotoPreviewListItemVo> getTestList(){
    List<PhotoPreviewListItemVo> _photoPreviewList = List();
    for(int i = 0; i < 4;i++){
      _photoPreviewList?.add(PhotoPreviewListItemVo(url: "https://zts-tx.oss-cn-beijing.aliyuncs.com/picture/splash_ad/3.png",type: PhotoPreviewType.image));
      _photoPreviewList?.add(PhotoPreviewListItemVo(url: "https://s3.jpg.cm/2020/08/10/b4bhG.jpg",type: PhotoPreviewType.image));
    }
    return _photoPreviewList;
  }

  ///初始化计算缩放
  static double initScale({Size imageSize, Size size, double initialScale}) {
    final double n1 = imageSize.height / imageSize.width;
    final double n2 = size.height / size.width;
    //todo：强制宽
    final FittedSizes fittedSizes = applyBoxFit(BoxFit.contain, imageSize, size);
    //final Size sourceSize = fittedSizes.source;
    final Size destinationSize = fittedSizes.destination;
    return size.width / destinationSize.width;
    if (n1 > n2) {
      final FittedSizes fittedSizes = applyBoxFit(BoxFit.contain, imageSize, size);
      //final Size sourceSize = fittedSizes.source;
      final Size destinationSize = fittedSizes.destination;
      return size.width / destinationSize.width;
    } else if (n1 / n2 < 1 / 4) {
      final FittedSizes fittedSizes = applyBoxFit(BoxFit.contain, imageSize, size);
      //final Size sourceSize = fittedSizes.source;
      final Size destinationSize = fittedSizes.destination;
      return size.height / destinationSize.height;
    }

    return initialScale;
  }

  ///判断是否是网络路径
  static bool isNetUrl(String url){
    if(url == null || url.isEmpty){
      return false;
    }
    if(url.startsWith("http://") || url.contains("https://")){
      return true;
    }
    return false;
  }

  ///路径类型
  static PhotoPreviewType _getType(String url) {
    if (url == null || url.isEmpty) {
      return PhotoPreviewType.unknow;
    }
    if (isImage(url)) {
      return PhotoPreviewType.image;
    }
    if (isVideo(url)) {
      return PhotoPreviewType.video;
    }
    return PhotoPreviewType.unknow;
  }

  ///是否是图片类型
  static bool isImage(String path) {
    if (path == null || path.isEmpty) {
      return false;
    }
    List<String> typeList = ["jpg", "jpeg", "png", "bmp", "webp"];
    int index = path.lastIndexOf(".");
    String suffix = path.substring(index + 1);
    if (suffix == null || suffix.isEmpty) {
      return false;
    }
    return typeList.indexOf(suffix) != -1 ||
        typeList.indexOf(suffix.toLowerCase()) != -1;
  }

  ///是否是视频类型
  static bool isVideo(String path) {
    if (path == null || path.isEmpty) {
      return false;
    }
    List<String> typeList = [
      "mpeg",
      "mpg",
      "mp4",
      "mov",
      "3gp",
      "mkv",
      "webm",
      "ts",
      "avi",
      "3gpp",
      "3gpp2",
      "3g2",
      "m4u"
    ];
    int index = path.lastIndexOf(".");
    String suffix = path.substring(index + 1);
    if (suffix == null || suffix.isEmpty) {
      return false;
    }
    return typeList.indexOf(suffix) != -1 ||
        typeList.indexOf(suffix.toLowerCase()) != -1;
  }
}
