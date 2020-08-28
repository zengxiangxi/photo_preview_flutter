import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_preview/src/extended_custom/vo/extended_custom_mode.dart';
import 'package:photo_preview/src/utils/photo_preview_tool_utils.dart';
import 'package:photo_preview/src/utils/screen_util.dart';

///自定义组件可下拉
class ExtendedCustomWidget extends StatefulWidget {
  ///组件模式（编辑，手势，无）
  final ExtendedCustomMode mode;

  ///是否开启下滑动画
  final bool enableSlideOutPage;

  ///初始化配置
  final InitGestureConfigHandler initGestureConfigHandler;

  ///hero配置
  final HeroBuilderForSlidingPage heroBuilderForSlidingPage;

  ///展示内容
  final Widget child;

  const ExtendedCustomWidget({Key key,
    this.mode,
    this.enableSlideOutPage = true,
    this.initGestureConfigHandler,
    this.child,
    this.heroBuilderForSlidingPage})
      : super(key: key);

  @override
  _ExtendedCustomWidgetState createState() => _ExtendedCustomWidgetState();
}

class _ExtendedCustomWidgetState extends State<ExtendedCustomWidget>
    with ExtendedImageState, WidgetsBindingObserver {
  ExtendedImageSlidePageState _slidePageState;

  @override
  Widget build(BuildContext context) {
    return _toSlidePageHandler();
  }

  ///嵌套监听
  Widget _toSlidePageHandler() {
    return ExtendedImageSlidePageHandler(widget?.child ?? Container(),
        _slidePageState, widget.heroBuilderForSlidingPage);
  }

  ///根据模式嵌套最终组件
  Widget _getCompletedWidget() {
    Widget current;
    if (widget.mode == ExtendedCustomMode.gesture) {
      current = ExtendedImageGesture(
        this,
//        key: widget.extendedImageGestureKey,
      );
    } else if (widget.mode == ExtendedCustomMode.editor) {
      current = ExtendedImageEditor(
        extendedImageState: this,
//        key: widget.extendedImageEditorKey,
      );
    } else {
//      current = _buildExtendedRawImage();
    }
    return current;
  }

  ///默认手势缩放参数
  GestureConfig _defaultInitGestureConfigHanlder(state, context) {
    double initialScale = 1.0;

    if (state.extendedImageInfo != null &&
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
        minScale: initialScale,
        initialScale: initialScale,
        maxScale: max(initialScale, 5.0 * initialScale),
        animationMaxScale: max(initialScale, 5.0 * initialScale),
        initialAlignment: InitialAlignment.topCenter,
        //you can cache gesture state even though page view page change.
        //remember call clearGestureDetailsCache() method at the right time.(for example,this page dispose)
        cacheGesture: false);
  }

  @override
  void didChangeDependencies() {
    _slidePageState = null;
    if (widget.enableSlideOutPage) {
      _slidePageState =
          context.findAncestorStateOfType<ExtendedImageSlidePageState>();
    }
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(ExtendedCustomWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enableSlideOutPage != oldWidget.enableSlideOutPage) {
      _slidePageState = null;
      if (widget.enableSlideOutPage) {
        _slidePageState =
            context.findAncestorStateOfType<ExtendedImageSlidePageState>();
      }
    }
  }

  @override
  Widget get completedWidget => _getCompletedWidget ?? Container();

  @override
  // TODO: implement extendedImageInfo
  ImageInfo get extendedImageInfo => throw UnimplementedError();

  @override
  // TODO: implement extendedImageLoadState
  LoadState get extendedImageLoadState => throw UnimplementedError();

  @override
  // TODO: implement frameNumber
  int get frameNumber => throw UnimplementedError();

  @override
  // TODO: implement imageProvider
  ImageProvider get imageProvider => throw UnimplementedError();

  @override
  // TODO: implement imageStreamKey
  Object get imageStreamKey => throw UnimplementedError();

  @override
  ExtendedImage get imageWidget =>
      ExtendedImage(
          initGestureConfigHandler: widget?.initGestureConfigHandler ??
                  (state) => _defaultInitGestureConfigHanlder(state, context));

  @override
  // TODO: implement invertColors
  bool get invertColors => throw UnimplementedError();

  @override
  // TODO: implement loadingProgress
  ImageChunkEvent get loadingProgress => throw UnimplementedError();

  @override
  void reLoadImage() {
    // TODO: implement reLoadImage
  }

  @override
  ExtendedImageSlidePageState get slidePageState => _slidePageState;

  @override
  // TODO: implement wasSynchronouslyLoaded
  bool get wasSynchronouslyLoaded => throw UnimplementedError();
}
