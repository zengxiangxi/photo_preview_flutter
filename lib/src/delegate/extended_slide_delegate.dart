import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';

///滑动配置
abstract class ExtendedSlideDelegate{

  BuildContext context;

  SlideAxis get slideAxis;

  SlideType get slideType;

  SlidePageBackgroundHandler get slidePageBackgroundHandler;

  SlideScaleHandler get slideScaleHandler;

  SlideEndHandler get slideEndHandler;

  ValueChanged<bool> get isSlidingStatus;

  ValueChanged<int> get pageChangeStatus;

  Duration get resetPageDuration;

  ///顶部需要添加的组件
  Widget topWidget(bool isSlidingStatus);

  ///底部需要添加组件
  Widget bottomWidget(bool isSlidingStatus);

  ///所有图片和视频边距（若想只控制图片或者视频，需配置imageDelegate或者videoDelegate）
  EdgeInsetsGeometry get imgVideoMargin;

  ///获取整体组件 便于外部嵌套自定义组件如（Stack悬浮组件）
  Widget wholeWidget(Widget result);

  ///需要初始化的内容
  void initState();

  ///需要销毁的内容
  void dispose();
}