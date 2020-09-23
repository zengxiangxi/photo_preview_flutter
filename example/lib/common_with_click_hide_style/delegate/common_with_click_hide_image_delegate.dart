import 'dart:async';

import 'package:example/common_with_click_hide_style/custom/common_with_click_hide_custom_class.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_preview/photo_preview_export.dart';

class CommonWithClickHideImageDelegate extends DefaultPhotoPreviewImageDelegate{
  CommonWithClickHideCustomClass _customClass;

  CommonWithClickHideImageDelegate();


  @override
  void initState() {
    _customClass = (PhotoPreviewCommonClass.of(context) as CommonWithClickHideCustomClass);
  }

  @override
  get onClick {
    return (ExtendedImageGestureState state,PhotoPreviewInfoVo infoVo,BuildContext context){
      _customClass?.clickController?.add(null);
    };
  }


  @override
  onTapCallBack get onLoadingClick {
    return (ExtendedImageGestureState state,PhotoPreviewInfoVo infoVo,BuildContext context){
      _customClass?.clickController?.add(null);

    };
  }

  @override
  void dispose() {
    super.dispose();
  }
}