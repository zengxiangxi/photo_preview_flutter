import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class PhotoPreviewValueSingleton{
  static PhotoPreviewValueSingleton _instance;

  PhotoPreviewValueSingleton._();

  static PhotoPreviewValueSingleton getInstance() {
    if (_instance == null) {
      _instance = new PhotoPreviewValueSingleton._();
    }
    return _instance;
  }

  Directory _temporaryDirectory;
  Directory get temporaryDirectory => _temporaryDirectory;

  ///先获取缓存路径
  Future<Directory> getTemporaryForder() async{
    _temporaryDirectory = await getTemporaryDirectory();
    return _temporaryDirectory;
  }

  ///滑动
  StreamController<bool> isSlidingController = StreamController.broadcast();

  ///page切换监听
  StreamController<int> pageIndexController = StreamController.broadcast();

  ///自定义错误组件
  Widget _customErrorWidget;
  Widget get customErrorWidget => _customErrorWidget;


  //销毁
  void dispose(){
    isSlidingController?.close();
    pageIndexController?.close();
    resetCustomErrorWidget();
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

  ///设置页面切换状态回调
  void setPageChangedCallBack(ValueChanged<int> callBack){
    if(callBack == null){
      return;
    }
    pageIndexController?.stream?.listen((page) {
      callBack(page);
    });
  }

  ///设置自定义错误组件
  void setCustomErrorWidget(Widget customErrorWidget){
    if(customErrorWidget == null){
      return;
    }
    _customErrorWidget = customErrorWidget;
  }

  ///重置自定义错误组件
  void resetCustomErrorWidget(){
    _customErrorWidget = null;
  }

}