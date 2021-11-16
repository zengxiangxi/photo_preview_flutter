import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_preview/src/constant/photo_preview_constant.dart';
import 'package:photo_preview/src/delegate/photo_preview_video_delegate.dart';
import 'package:photo_preview/src/utils/photo_preview_tool_utils.dart';
import 'package:photo_preview/src/utils/screen_util.dart';
import 'package:photo_preview/src/widget/custom_chewie/custom_chewie_widget.dart';
import 'package:video_player/video_player.dart';

class CustomVideoAspectRatioWidget extends StatefulWidget {
  final String? vCoverUrl;
  final PhotoPreviewVideoDelegate? videoDelegate;

  const CustomVideoAspectRatioWidget(
      {Key? key, this.vCoverUrl, this.videoDelegate})
      : super(key: key);

  @override
  _CustomVideoAspectRatioWidgetState createState() =>
      _CustomVideoAspectRatioWidgetState();
}

class _CustomVideoAspectRatioWidgetState
    extends State<CustomVideoAspectRatioWidget>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  CustomChewieController? chewieController;

  double? _aspectRatio;

  ///视频比例
  double? _videoAspectRatio;

  bool isCompleteFlag = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    _aspectRatio = ScreenUtils.getInstance().screenWidth /
        ScreenUtils.getInstance().screenHeight;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Center(
        child: AspectRatio(
      aspectRatio: _videoAspectRatio ?? _aspectRatio!,
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          Container(
            child: VideoPlayer(chewieController!.videoPlayerController),
          ),
          Container(
              child: Offstage(
            offstage: !(widget.videoDelegate?.enableLoadState ?? true),
            child: AnimatedOpacity(
              opacity: widget.vCoverUrl == null ||
                      widget.vCoverUrl!.isEmpty ||
                      isCompleteFlag == true
                  ? 0
                  : 1,
              duration: Duration(milliseconds: 250),
              child: Center(child: _toPlaceHolderWidget()),
            ),
          )),
        ],
      ),
    ));
  }

  Widget _toPlaceHolderWidget() {
    if (widget.vCoverUrl == null || widget.vCoverUrl!.isEmpty) {
      return Container();
    }
    if (PhotoPreviewToolUtils.isNetUrl(widget.vCoverUrl)) {
      return ExtendedImage.network(widget.vCoverUrl!,
          loadStateChanged: (state) => _loadStateChangedImage(state),
          initGestureConfigHandler: (state) =>
              widget.videoDelegate!.initGestureConfigHandler(state, context)!);
    } else {
      return ExtendedImage.file(File(widget.vCoverUrl!),
          initGestureConfigHandler: (state) =>
              widget.videoDelegate!.initGestureConfigHandler(state, context)!);
    }
  }

  Widget _loadStateChangedImage(ExtendedImageState state) {
    _setAspectRatioByImageSize(state);
    if (state == null) {
      return Container();
    }
    switch (state.extendedImageLoadState) {
      case LoadState.loading:
        return Container();
        break;
      case LoadState.completed:
        return state.completedWidget;
        break;
      case LoadState.failed:
        return Container();
    }
    return Container();
  }

  ///根据图片大小设置比例
  void _setAspectRatioByImageSize(ExtendedImageState state) {
    if (state.extendedImageInfo?.image == null) {
      return;
    }
    int? imageWidth = state.extendedImageInfo?.image.width;
    int? imageHeight = state.extendedImageInfo?.image.height;
    if (imageWidth == null ||
        imageWidth <= 0 ||
        imageHeight == null ||
        imageHeight <= 0) {
      return;
    }
    Future.delayed(Duration(milliseconds: 0), () {
      if (_videoAspectRatio == null) {
        setState(() {
          _videoAspectRatio = _aspectRatio = imageWidth / imageHeight;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    final _oldController = chewieController;
    chewieController = CustomChewieController.of(context);
    if (_oldController != chewieController) {
      _dispose();
      chewieController!.videoPlayerController.addListener(_updateState);
      _updateState();
    }

    super.didChangeDependencies();
  }

  void _dispose() {
    chewieController!.videoPlayerController.removeListener(_updateState);
  }

  @override
  void dispose() {
    _videoAspectRatio = null;
    _aspectRatio = null;
    _dispose();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  void _updateState() {
    VideoPlayerValue? value = chewieController?.videoPlayerController?.value;
    //避免过快加载问题
    if (value != null && value.isInitialized) {
      double newAspectRatio = value.size != null ? _getLastedAspectRatio(value?.size): null;
      if (newAspectRatio != null && (!isCompleteFlag)) {
        if (mounted) {
          setState(() {
            isCompleteFlag = true;
            _videoAspectRatio =
                _aspectRatio = _getLastedAspectRatio(value.size);
          });
        }
      }
    }
  }

  double? _getLastedAspectRatio(Size videoSize) {
    if (videoSize == null ||
        videoSize.width == null ||
        videoSize.height == null ||
        videoSize.width <= 0 ||
        videoSize.height <= 0) {
      return _aspectRatio;
    }
    return videoSize.width / videoSize.height;
  }

  @override
  bool get wantKeepAlive => true;
}
