import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:photo_preview/photo_preview_export.dart';

class CommonWithClickHideImageDelegate extends DefaultPhotoPreviewImageDelegate{
  final StreamController<Null> clickController;

  CommonWithClickHideImageDelegate(this.clickController);


  @override
  get onClick {
    return (ExtendedImageGestureState state,PhotoPreviewInfoVo infoVo,BuildContext context){
      clickController?.add(null);
    };
  }

  @override
  void dispose() {
    clickController?.close();
    super.dispose();
  }
}