import 'package:flutter/cupertino.dart';
import 'package:photo_preview/src/widget/inherit/photo_preview_custom_common_class_inherited_widget.dart';

///自定义传值类
abstract class PhotoPreviewCommonClass{

  ///获取传入类引用
  static PhotoPreviewCommonClass? of(BuildContext context){
    return PhotoPreviewCustomCommonClassInherited.of(context);
  }

  ///初始化
  void initState() => null;

  ///销毁
  void dispose() => null;
}