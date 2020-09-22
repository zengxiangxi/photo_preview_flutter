import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_preview/photo_preview_export.dart';

class CommonWithClickHideSlideDelegate extends DefaultExtendedSlideDelegate{

  final StreamController<Null> clickController;

  CommonWithClickHideSlideDelegate(this.clickController);

  bool _isShowWidget = false;
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget topWidget(bool isSlideStatus) {
    return StreamBuilder<bool>(
      initialData: true,
      stream: clickController?.stream,
      builder: (context, snapshot) {
        _isShowWidget = !_isShowWidget;
        return AnimatedOpacity(
          opacity: _isShowWidget == false || isSlideStatus ? 0: 1,
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
  Widget bottomWidget(bool isSlideStatus) {
    return null;
  }

  @override
  void dispose() {
    clickController?.close();
    super.dispose();
  }
}