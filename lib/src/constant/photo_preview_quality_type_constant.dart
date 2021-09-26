import 'package:photo_preview/src/vo/photo_preview_quality_type.dart';

class PhotoPreviewQualityTypeConstant{

  /// 阿里oss所用图片地址拼接参数来控制所显示的图片清晰程度

  // 原图
  static final String ORIGINAL = "?x-oss-process=style/style_s";

  static final String HIGH = "?x-oss-process=style/style1000";

  static final String MIDDLE_UP = "?x-oss-process=style/style800";

  static final String MIDDLE = "?x-oss-process=style/style600";

  static final String MIDDLE_DOWN = "?x-oss-process=style/style400";

  static final String LOW = "?x-oss-process=style/style300";

  static final String LOWEST = "?x-oss-process=style/style100";

  ///得到质量类型串
  static String? getQualityTypeStr(PhotoPreviewQualityType type){
    if(type == null){
      return null;
    }
    switch(type){
      case PhotoPreviewQualityType.ORIGINAL:
        return ORIGINAL;
        break;
      case PhotoPreviewQualityType.HIGH:
        return HIGH;
        break;
      case PhotoPreviewQualityType.MIDDLE_UP:
        return MIDDLE_UP;
        break;
      case PhotoPreviewQualityType.MIDDLE:
        return MIDDLE;
        break;
      case PhotoPreviewQualityType.MIDDLE_DOWN:
        return MIDDLE_DOWN;
        break;
      case PhotoPreviewQualityType.LOW:
        return LOW;
        break;
      case PhotoPreviewQualityType.LOWEST:
        return LOWEST;
        break;
    }
    return null;
  }
}