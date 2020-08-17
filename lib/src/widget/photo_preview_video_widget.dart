import 'dart:async';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_preview/photo_preview_export.dart';
import 'package:photo_preview/src/utils/photo_preview_tool_utils.dart';
import 'package:photo_preview/src/widget/video_control/custom_video_control.dart';
import 'package:video_player/video_player.dart';

///视频播放器
class PhotoPreviewVideoWidget extends StatefulWidget {

  ///视频详情
  final PhotoPreviewInfoVo videoInfo;

  final StreamController isSlidingController;

  const PhotoPreviewVideoWidget({Key key, this.videoInfo, this.isSlidingController}) : super(key: key);

  @override
  _PhotoPreviewVideoWidgetState createState() => _PhotoPreviewVideoWidgetState();
}

class _PhotoPreviewVideoWidgetState extends State<PhotoPreviewVideoWidget> with AutomaticKeepAliveClientMixin{

  VideoPlayerController videoPlayerController;
  ChewieController chewieController;

  ///是否销毁
  bool isDisposed = false;

  @override
  void initState() {
    super.initState();

    if(widget?.videoInfo?.url == null || widget.videoInfo.url.isEmpty){
      return;
    }else if(PhotoPreviewToolUtils.isNetUrl(widget?.videoInfo?.url)){
      videoPlayerController = VideoPlayerController.network(widget?.videoInfo?.url);
    }else {
      videoPlayerController = VideoPlayerController.file(File(widget?.videoInfo?.url));
    }

    chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        aspectRatio: null,
        autoPlay: true,
        looping: false,
        startAt: null,
        customControls: CustomControls(
          controller: videoPlayerController,
          chewieController: chewieController,
          isSlidingController: widget?.isSlidingController,
        )
        );

  }

  _initListener(){
//    widget?.isSlidingController?.stream?.listen((isSliding) {
//      if(isSliding == null){
//        return;
//      }
//      if(isSliding is! bool){
//        return;
//      }
//
//    });
  }

  _initData(){

  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _toMainWidget();
  }

  Widget _toMainWidget(){
    if(widget?.videoInfo?.url == null || widget.videoInfo.url.isEmpty){
      return Container();
    }
    return ExtendsCustomWidget(
      child: Container(
        child: Chewie(
          controller: chewieController,
        )
      ),
    );
  }

  @override
  void dispose() {
    isDisposed = true;
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
