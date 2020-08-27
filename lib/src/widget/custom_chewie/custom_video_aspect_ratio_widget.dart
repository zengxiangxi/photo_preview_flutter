import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_preview/src/constant/photo_preview_constant.dart';
import 'package:photo_preview/src/utils/photo_preview_tool_utils.dart';
import 'package:photo_preview/src/utils/screen_util.dart';
import 'package:photo_preview/src/widget/custom_chewie/custom_chewie_widget.dart';
import 'package:video_player/video_player.dart';

class CustomVideoAspectRatioWidget extends StatefulWidget {
  final String vCoverUrl;

  const CustomVideoAspectRatioWidget({Key key, this.vCoverUrl})
      : super(key: key);

  @override
  _CustomVideoAspectRatioWidgetState createState() =>
      _CustomVideoAspectRatioWidgetState();
}

class _CustomVideoAspectRatioWidgetState
    extends State<CustomVideoAspectRatioWidget> with WidgetsBindingObserver,AutomaticKeepAliveClientMixin{
  CustomChewieController chewieController;

  double _aspectRatio;

  ///视频比例
  double _videoAspectRatio;

  bool isCompleteFlag = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _aspectRatio = ScreenUtils.getInstance().screenWidth /
        ScreenUtils.getInstance().screenHeight;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Center(
        child: AspectRatio(
      aspectRatio: _videoAspectRatio ?? _aspectRatio,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            child: VideoPlayer(chewieController?.videoPlayerController),
          ),
          Container(
            child: AnimatedOpacity(
              opacity: widget?.vCoverUrl == null || widget.vCoverUrl.isEmpty || isCompleteFlag == true? 0: 1,
              duration: Duration(milliseconds: 250),
              child: _toPlaceHolderWidget(),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _toPlaceHolderWidget() {
    if (widget?.vCoverUrl == null || widget.vCoverUrl.isEmpty) {
      return Container();
    }
    if (PhotoPreviewToolUtils.isNetUrl(widget?.vCoverUrl)) {
      return ExtendedImage.network(
        widget.vCoverUrl,
        loadStateChanged: (state) => _loadStateChangedImage(state),
        initGestureConfigHandler: (state) =>
            _initGestureConfigHandler(state, context),
      );
    } else {
      return ExtendedImage.file(
        File(widget.vCoverUrl),
        initGestureConfigHandler: (state) =>
            _initGestureConfigHandler(state, context),
      );
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
    if (state?.extendedImageInfo?.image == null) {
      return;
    }
    int imageWidth = state?.extendedImageInfo?.image?.width;
    int imageHeight = state?.extendedImageInfo?.image?.height;
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
        print("通过封面设置比例：${_videoAspectRatio}");
      }
    });
  }

  @override
  void didChangeDependencies() {
    final _oldController = chewieController;
    chewieController = CustomChewieController.of(context);
    if (_oldController != chewieController) {
      _dispose();
      chewieController.videoPlayerController.addListener(_updateState);
      _updateState();
    }
    super.didChangeDependencies();
  }

  void _dispose() {
    chewieController.videoPlayerController.removeListener(_updateState);
  }

  @override
  void dispose() {
    _videoAspectRatio = null;
    _aspectRatio = null;
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _updateState() {
    VideoPlayerValue value = chewieController?.videoPlayerController?.value;
//    if ((value?.initialized ??false)&& (value?.position?.inMilliseconds ?? 0) > 0) {
//      isCompleteFlag = true;
//    }
    if (value != null) {
      double newAspectRatio = value.size != null ? value.aspectRatio : null;
      if (newAspectRatio != null && newAspectRatio != _aspectRatio) {
        if(mounted) {
          setState(() {
            isCompleteFlag = true;
            _videoAspectRatio = _aspectRatio =
                _getLastedAspectRatio(value?.size);
          });
          print("通过视频回调设置比例：${_videoAspectRatio}");
        }
      }
    }
  }

  double _getLastedAspectRatio(Size videoSize) {
    if (videoSize == null ||
        videoSize.width == null ||
        videoSize.height == null ||
        videoSize.width <= 0 ||
        videoSize.height <= 0) {
      return _aspectRatio;
    }
    return videoSize.width / videoSize.height;
  }

  ///初始化缩放配置回调
  final Function _initGestureConfigHandler =
      (ExtendedImageState state, context) {
    double initialScale = PhotoPreviewConstant.DEFAULT_INIT_SCALE;

    if (state?.extendedImageInfo != null &&
        state.extendedImageInfo.image != null) {
      initialScale = PhotoPreviewToolUtils.initScale(
          size:
              Size(ScreenUtils.screenW(context), ScreenUtils.screenH(context)),
          initialScale: initialScale,
          imageSize: Size(state.extendedImageInfo.image.width.toDouble(),
              state.extendedImageInfo.image.height.toDouble()));
    }
    return GestureConfig(
        inPageView: true,
        initialScale: initialScale,
        minScale: PhotoPreviewConstant.DEFAULT_MIX_SCALE * initialScale,
        maxScale: max(initialScale,
            PhotoPreviewConstant.DEFAULT_MAX_SCALE * initialScale),
        animationMaxScale: max(initialScale,
            PhotoPreviewConstant.DEFAULT_MAX_SCALE * initialScale),
        animationMinScale: min(initialScale,
            PhotoPreviewConstant.DEFAULT_MIX_SCALE * initialScale),
        initialAlignment: InitialAlignment.topCenter,
        //you can cache gesture state even though page view page change.
        //remember call clearGestureDetailsCache() method at the right time.(for example,this page dispose)
        cacheGesture: false);
  };

  @override
  bool get wantKeepAlive => true;
}
