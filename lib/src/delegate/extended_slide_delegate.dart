import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';

///滑动配置
abstract class ExtendedSlideDelegate{

  SlideAxis get slideAxis;

  SlideType get slideType;

  SlidePageBackgroundHandler get slidePageBackgroundHandler;

  SlideScaleHandler get slideScaleHandler;

  SlideEndHandler get slideEndHandler;

  ValueChanged<bool> get isSlidingStatus;

  Duration get resetPageDuration;
}