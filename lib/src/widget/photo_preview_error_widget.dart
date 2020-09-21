import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_preview/photo_preview_export.dart';
import 'package:photo_preview/src/extended_custom/vo/extended_custom_mode.dart';

class PhotoPreviewErrorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExtendedCustomWidget(
      mode: ExtendedCustomMode.gesture,
      enableSlideOutPage: true,
      child: Material(
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
