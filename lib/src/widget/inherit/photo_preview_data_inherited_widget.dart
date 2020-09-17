import 'package:flutter/widgets.dart';
import 'package:photo_preview/src/vo/photo_preview_delegates_vo.dart';

class PhotoPreviewDataInherited extends InheritedWidget{

  final PhotoPreviewDelegatesVo data;

  const PhotoPreviewDataInherited({@required this.data,@required Widget child}):super(child:child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static PhotoPreviewDelegatesVo of(BuildContext context){
    return context?.dependOnInheritedWidgetOfExactType<PhotoPreviewDataInherited>()?.data;
  }

}