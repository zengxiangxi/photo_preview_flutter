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

  ///图片视频边距
  EdgeInsetsGeometry get imgVideoMargin;

  ///获取整体组件 便于外部嵌套自定义组件如（Stack悬浮组件）
  Widget wholeWidget(Widget result);
}