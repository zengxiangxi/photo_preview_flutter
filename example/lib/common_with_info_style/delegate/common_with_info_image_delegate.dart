import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_preview/photo_preview_export.dart';

class CommonWithInfoImageDelegate extends DefaultPhotoPreviewImageDelegate{

  StreamController<bool> _isSlideStream = StreamController.broadcast();

  @override
  ValueChanged<bool> get isSlidingStatus {
    return (status){
      _isSlideStream.add(status);
    };
  }


  @override
  Widget imageWidget(PhotoPreviewInfoVo? imageInfo, {Widget? result}) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        result!,
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: StreamBuilder<bool>(
            initialData: false,
            stream: _isSlideStream.stream,
            builder: (context, snapshot) {
              return AnimatedOpacity(
                opacity: snapshot.data == true ? 0: 1,
                duration: Duration(milliseconds: 50),
                child: Container(
                  height: 70,
                  color: Colors.black.withOpacity(0.4),
                  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top,left: 20,right: 20),
                  alignment: Alignment.centerLeft,
                  child: Text(
                       imageInfo?.extra["title"] ?? "",
                       overflow: TextOverflow.ellipsis,
                       maxLines: 1,
                       style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                       ),
                  ),
                ),
              );
            }
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: StreamBuilder<bool>(
            initialData: false,
            stream: _isSlideStream.stream,
            builder: (context, snapshot) {
              return AnimatedOpacity(
                opacity: snapshot.data == true ? 0: 1,
                duration: Duration(milliseconds: 50),
                child: Container(
                  height: 100,
                  color: Colors.black.withOpacity(0.4),
                  padding: const EdgeInsets.only(top: 10,right: 20,left: 20),
                  child: Text(
                       imageInfo?.extra['intro'] ?? "",
                       style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                       ),
                  ),
                ),
              );
            }
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    _isSlideStream.close();
    super.dispose();
  }
}