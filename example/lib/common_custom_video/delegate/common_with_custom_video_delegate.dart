import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_preview/photo_preview_export.dart';
import 'package:photo_preview/src/utils/screen_util.dart';

class CommonWithCustomVideoDelegate extends DefaultPhotoPreviewVideoDelegate {
  List<ChewieController> _list = [];

  ValueNotifier<bool>? _isSlideValueNotifier;

  @override
  initCustomVideoPlayerController(PhotoPreviewInfoVo? videoInfo,
      VideoPlayerController? videoPlayerController) {
    if (videoPlayerController == null) {
      return null;
    }
    //videoplayercontroller监听逻辑
    videoPlayerController.addListener(() {
      if (videoPlayerController.value.isPlaying) {
        // print("播放");
      } else {
        // print("暂停");
      }
    });
    //自定义
    ChewieController controller = ChewieController(
        videoPlayerController: videoPlayerController,
        //避免报已经初始化错误
        autoInitialize: false,
        autoPlay: false,
        aspectRatio: null,
        looping: false,
        startAt: null,
        placeholder: Center(child: _toCoverWidget(videoInfo)));
    _list.add(controller);
    return controller;
  }

  @override
  void initState() {
    super.initState();
    _isSlideValueNotifier = ValueNotifier(false);
  }

  @override
  void dispose() {
    ///及时销毁
    _list.forEach((element) {
      element.dispose();
    });
    _isSlideValueNotifier?.dispose();
    super.dispose();
  }

  @override
  Widget videoWidget(PhotoPreviewInfoVo? videoInfo,
      {Widget? result,
      VideoPlayerController? videoPlayerController,
      dynamic customVideoPlayerController}) {
    if (customVideoPlayerController is! ChewieController) {
      return Container();
    }

    ///自定义的视频控件（包括控制栏）
    return _toAnimWidget(
        child: Chewie(
      controller: customVideoPlayerController,
    ));
  }

  @override
  ValueChanged<bool> get isSlidingStatus {
    return (bool isSlideStatus) {
      _isSlideValueNotifier?.value = isSlideStatus;
    };
  }

  ///模拟滑动监听
  Widget _toAnimWidget({Widget? child}) {
    return ValueListenableBuilder(
      valueListenable: _isSlideValueNotifier!,
      builder: (BuildContext context, bool isSlideStatus, Widget? child) {
        return AnimatedOpacity(
          opacity: isSlideStatus ? 0.1 : 1,
          duration: Duration(milliseconds: 200),
          child: child,
        );
      },
      child: child,
    );
  }

  Widget _toCoverWidget(PhotoPreviewInfoVo? videoInfo) {
    if (PhotoPreviewToolUtils.isNetUrl(videoInfo?.loadingCoverUrl)) {
      return ExtendedImage.network(videoInfo?.loadingCoverUrl ?? "",
          fit: BoxFit.cover,
          loadStateChanged: (state) => null,
          initGestureConfigHandler: null);
    } else {
      return ExtendedImage.file(File(videoInfo?.loadingCoverUrl ?? ""),
          fit: BoxFit.cover, initGestureConfigHandler: ((state) => null) as GestureConfig Function(ExtendedImageState)?);
    }
  }
}
