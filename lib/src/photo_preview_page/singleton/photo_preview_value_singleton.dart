import 'dart:async';

import 'package:flutter/cupertino.dart';

class PhotoPreviewValueSingleton{
  static PhotoPreviewValueSingleton _instance;

  PhotoPreviewValueSingleton._();

  static PhotoPreviewValueSingleton getInstance() {
    if (_instance == null) {
      _instance = new PhotoPreviewValueSingleton._();
    }
    return _instance;
  }

  ///滑动
  StreamController<bool> isSlidingController = StreamController.broadcast();

  ///page切换监听
  StreamController<int> pageIndexController = StreamController.broadcast();

  //销毁
  void dispose(){
    isSlidingController?.close();
    pageIndexController?.close();
    _instance = null;
  }

  ///设置滑动状态回调
  void setSlidingCallBack(ValueChanged<bool> callBack){
    if(callBack == null || isSlidingController.isClosed){
      return;
    }
    isSlidingController?.stream?.listen((isSlidingStatus) {
      callBack(isSlidingStatus);
    });
  }

}