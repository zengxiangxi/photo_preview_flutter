import 'package:flutter/widgets.dart';
import 'package:photo_preview/src/singleton/photo_preview_common_class.dart';

class PhotoPreviewCustomCommonClassInherited extends InheritedWidget{

  final PhotoPreviewCommonClass? data;

  const PhotoPreviewCustomCommonClassInherited({required this.data,required Widget child}):super(child:child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static PhotoPreviewCommonClass? of(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<PhotoPreviewCustomCommonClassInherited>()?.data;
  }

}