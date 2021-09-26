import 'dart:async';

import 'package:example/common_with_click_hide_style/custom/common_with_click_hide_custom_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_preview/photo_preview_export.dart';

class CommonWithClickHideSlideDelegate extends DefaultExtendedSlideDelegate{

  CommonWithClickHideCustomClass? _customClass;

  CommonWithClickHideSlideDelegate();



  @override
  void initState() {
    super.initState();
    _customClass = (PhotoPreviewCommonClass.of(context!) as CommonWithClickHideCustomClass?);
  }

  @override
  Widget topWidget(bool? isSlideStatus) {
    return StreamBuilder<Null>(
      stream: _customClass?.clickController?.stream,
      builder: (context, snapshot) {
        return AnimatedOpacity(
          opacity:  _customClass?.isShow == false || isSlideStatus! ? 0: 1,
          duration: Duration(milliseconds: 200),
          child: Container(
            color: Colors.black.withOpacity(0.4),
            height: 100,
            alignment: Alignment.center,
            child: Text(
                 "标题",
                 overflow: TextOverflow.ellipsis,
                 maxLines: 1,
                 style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                 ),
            ),
          ),
        );
      }
    );
  }

  @override
  Widget? bottomWidget(bool? isSlideStatus) {
    return null;
  }

  @override
  void dispose() {
    super.dispose();
  }
}