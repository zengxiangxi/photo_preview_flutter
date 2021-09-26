import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_preview/photo_preview_export.dart';
import 'package:photo_preview/src/extended_custom/vo/extended_custom_mode.dart';
import 'package:photo_preview/src/singleton/photo_preview_value_singleton.dart';

class PhotoPreviewErrorWidget extends StatelessWidget {

  Widget? _customWidget;

  final bool? enableSlideOutPage;

  PhotoPreviewErrorWidget(this.enableSlideOutPage){
    _customWidget = PhotoPreviewValueSingleton.getInstance()!.customErrorWidget;
  }

  @override
  Widget build(BuildContext context) {
    return ExtendedCustomWidget(
      mode: ExtendedCustomMode.gesture,
      enableSlideOutPage:enableSlideOutPage ?? true,
      child: _customWidget ?? Material(
        child: Container(
          color: Colors.black,
          child: Center(
            child: Text("加载失败",style: TextStyle(color: Colors.white),),
          ),
        ),
      ),
    );
  }



}
