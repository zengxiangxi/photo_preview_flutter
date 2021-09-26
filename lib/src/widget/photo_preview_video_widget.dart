import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_preview/photo_preview_export.dart';
import 'package:photo_preview/src/delegate/default/default_photo_preview_video_delegate.dart';
import 'package:photo_preview/src/delegate/photo_preview_video_delegate.dart';
import 'package:photo_preview/src/singleton/photo_preview_value_singleton.dart';
import 'package:photo_preview/src/utils/photo_preview_tool_utils.dart';
import 'package:photo_preview/src/widget/custom_chewie/custom_chewie_widget.dart';
import 'package:photo_preview/src/widget/video_control/custom_video_control.dart';
import 'package:photo_preview/src/widget/video_control/photo_video_status_type.dart';
import 'package:video_player/video_player.dart';

import 'inherit/photo_preview_data_inherited_widget.dart';

///视频播放器
class PhotoPreviewVideoWidget extends StatefulWidget {
  ///视频详情
  final PhotoPreviewInfoVo? videoInfo;

  ///当前位置
  final int? currentPostion;

  final EdgeInsetsGeometry? videoMargin;

  const PhotoPreviewVideoWidget({
    Key? key,
    this.videoInfo,
    this.currentPostion,
    this.videoMargin,
  }) : super(key: key);

  @override
  _PhotoPreviewVideoWidgetState createState() =>
      _PhotoPreviewVideoWidgetState();
}

class _PhotoPreviewVideoWidgetState extends State<PhotoPreviewVideoWidget>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  VideoPlayerController? videoPlayerController;
  CustomChewieController? chewieController;

  ///记录状态类型
  PhotoVideoStatusType? recordType;

  ///是否加载完成
  bool isLoadComplete = false;

  ///视频配置
  PhotoPreviewVideoDelegate? _videoDelegate;

  ///页面位置
  ///获取默认跳转的位置
  int _pagePositon =
      PhotoPreviewValueSingleton.getInstance()!.currentPagePostion;

  ///缓存自定义视频控制器
  dynamic _customVideoPlayer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);

    if (widget.videoInfo?.url == null || widget.videoInfo!.url!.isEmpty) {
      return;
    } else if (PhotoPreviewToolUtils.isNetUrl(widget.videoInfo?.url)) {
      videoPlayerController =
          VideoPlayerController.network(widget.videoInfo?.url ??"");
    } else {
      videoPlayerController =
          VideoPlayerController.file(File(widget.videoInfo?.url ?? ""));
    }
    _initListener();
    _initData();
  }

  _initListener() {
    //监听初始化未完成时
    videoPlayerController?.addListener(() {
      //处理当前视频控制
      if ((_pagePositon) == widget.currentPostion) {
        _processWakeLock();
      }
      _initVideoControllerListener();
    });

    if (widget.currentPostion != null && widget.currentPostion! >= 0) {
      PhotoPreviewValueSingleton.getInstance()!
          .pageIndexController
          .stream
          .listen((position) {
        _pagePositon = position;
        if (position != widget.currentPostion) {
          ///未记录
          if (recordType == null) {
            recordType = (videoPlayerController?.value.isPlaying ?? true)
                ? PhotoVideoStatusType.playing
                : PhotoVideoStatusType.pause;
            videoPlayerController?.pause();
            _processWakeLock();
          }
        } else if (position == widget.currentPostion) {
          ///释放记录类型状态
          if (recordType != null) {
            if (recordType == PhotoVideoStatusType.playing) {
              videoPlayerController?.play();
            } else {
              videoPlayerController?.pause();
            }
            recordType = null;
            _processWakeLock();
          }
        }
      });
    }
  }

  ///处理唤醒锁
  _processWakeLock() {
    if (videoPlayerController!.value.isPlaying) {
      PhotoPreviewToolUtils.wakeLockEnable();
    } else {
      PhotoPreviewToolUtils.wakeLockDisable();
    }
  }

  _initVideoControllerListener() {
    ///初始化完成
    if (!isLoadComplete) {
      if ((videoPlayerController?.value?.isInitialized ?? false) &&
          (videoPlayerController?.value?.position?.inMilliseconds ?? 0) > 200) {
        //完成标志
        isLoadComplete = true;
        if (recordType != null) {
          videoPlayerController?.pause();
        } else {
          videoPlayerController?.play();
        }
      }
    }
//    ///判断去除封面的原因
//    if(videoPlayerController?.value != null){
//      isLoadCompleteController?.add(true);
//    }
  }

  _initData() {

    chewieController = CustomChewieController(
        videoPlayerController: videoPlayerController!,
        aspectRatio: null,
        autoPlay: true,
        looping: false,
        startAt: null,
//        placeholder: _toPlaceHolderWidget(),
        customControls: CustomControls(
          controller: videoPlayerController,
          chewieController: chewieController,
        ));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
        padding: widget.videoMargin,
        child: Container(
          padding: _videoDelegate?.videoMargin,
          child: _toExtendedSlideWidget(),
        ));
  }

  Widget _toExtendedSlideWidget() {
    return ExtendedCustomWidget(
      enableSlideOutPage: _videoDelegate?.enableSlideOutPage ?? true,
      child: Container(
          child: _videoDelegate?.videoWidget(
                widget.videoInfo,
                result: _toVideoPlayerWidget(),
                videoPlayerController: videoPlayerController,
                customVideoPlayerController: _customVideoPlayer,
              ) ??
              _toVideoPlayerWidget()),
    );
  }

  Widget _toVideoPlayerWidget() {
    if (widget.videoInfo?.url == null || widget.videoInfo!.url!.isEmpty) {
      return Container();
    }
    return CustomChewie(
      vCoverUrl: widget.videoInfo?.loadingCoverUrl,
      controller: chewieController!,
    );
  }

//  Widget _toPlaceHolderWidget(){
//    return StreamBuilder<bool>(
//      initialData: false,
//      stream: isLoadCompleteController?.stream,
//      builder: (context, snapshot) {
//        return Offstage(
//          offstage: snapshot?.data == true,
//          child: Center(
//            child: Container(
//              width: 400,
//              height: 300,
//              color: Colors.green,
//            ),
//          ),
//        );
//      }
//    );
//  }

  @override
  void dispose() {
    videoPlayerController?.pause();
    videoPlayerController?.dispose();
    chewieController!.dispose();
//    isLoadCompleteController.close();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _videoDelegate = PhotoPreviewDataInherited.of(context)?.videoDelegate;

    ///执行自定义控制器获取
    _customVideoPlayer ??= _videoDelegate?.initCustomVideoPlayerController(
        widget.videoInfo, videoPlayerController);

    super.didChangeDependencies();
  }

  @override
  bool get wantKeepAlive => true;
}
