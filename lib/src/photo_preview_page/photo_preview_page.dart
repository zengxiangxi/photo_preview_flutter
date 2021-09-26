import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_preview/photo_preview_export.dart';
import 'package:photo_preview/src/delegate/photo_preview_image_delegate.dart';
import 'package:photo_preview/src/delegate/photo_preview_video_delegate.dart';
import 'package:photo_preview/src/photo_preview_page/photo_preview_state.dart';
import 'package:photo_preview/src/singleton/photo_preview_common_class.dart';
import 'package:photo_preview/src/singleton/photo_preview_value_singleton.dart';
import 'package:photo_preview/src/utils/photo_callback.dart';
import 'package:photo_preview/src/vo/photo_preview_data_source.dart';
import 'package:photo_preview/src/vo/photo_preview_delegates_vo.dart';
import 'package:photo_preview/src/widget/inherit/photo_preview_custom_common_class_inherited_widget.dart';
import 'package:photo_preview/src/widget/inherit/photo_preview_data_inherited_widget.dart';
import 'package:photo_preview/src/widget/route/custom_page_transitions_builder.dart';

///自定义转场
typedef CustomPageRoute = PageRoute Function(Widget mainWidget);

///图片浏览器页面
class PhotoPreviewPage extends StatefulWidget {
  ///传入数据源
  final PhotoPreviewDataSource? dataSource;

  const PhotoPreviewPage._({
    Key? key,
    this.dataSource,
  }) : super(key: key);

  @override
  PhotoPreviewState createState() => PhotoPreviewState();

  /// 跳转到图片/视频预览页面
  ///
  /// @required context：上下文
  /// @required dataSource：数据源（多种构造方法）
  /// callback: Route回调
  /// extendedSlideDelegate: 滑动配置类（自定义需继承 DefaultExtendedSlideDelegate 重写方法）
  /// imageDelegate：图片配置（自定义需继承 DefaultPhotoPreviewImageDelegate 重写方法）
  /// videoDelegate：视频配置（自定义需继承 DefaultPhotoPreviewVideoDelegate 重写方法）
  /// customErrorWidget：自定义错误组件
  /// customClass: 自定义业务逻辑类（类似单例类，可在预览页面任何位置直接引用）
  ///              继承 PhotoPreviewCommonClass
  ///              引用方法 clazz = PhotoPreviewCommonClass.of(context);
  /// transitionDuration：Route加载时间
  /// customPageRoute：自定义转场
  static navigatorPush(BuildContext context, PhotoPreviewDataSource dataSource,
      {PhotoPreviewCallback? callback,
      ExtendedSlideDelegate? extendedSlideDelegate,
      PhotoPreviewImageDelegate? imageDelegate,
      PhotoPreviewVideoDelegate? videoDelegate,
      PhotoPreviewCommonClass? customClass,
      Widget? customErrorWidget,
      Duration? transitionDuration,
      CustomPageRoute? customPageRoute}) async {
    if (dataSource == null ||
        dataSource.imgVideoFullList == null ||
        dataSource.imgVideoFullList!.isEmpty) {
      callback?.onError!("数据为空");
      return;
    }

    ///优先获取缓存路径
    await PhotoPreviewValueSingleton.getInstance()!.getTemporaryForder();

    ///主要组件
    Widget _photoPreviewWidget = PhotoPreviewDataInherited(
        data: _getDelegatesVo(context,
            slideDelegate: extendedSlideDelegate,
            imageDelegate: imageDelegate,
            videoDelegate: videoDelegate),
        child: PhotoPreviewPage._(
          dataSource: dataSource,
        ));

    ///传入自定义类
    // if(customClass != null){
      _photoPreviewWidget = PhotoPreviewCustomCommonClassInherited(
        data: customClass,
        child: _photoPreviewWidget,
      );
    // }
    ///配置错误组件
    if(customErrorWidget != null){
      PhotoPreviewValueSingleton.getInstance()!.setCustomErrorWidget(customErrorWidget);
    }
    ///获取路由
    Route _route = customPageRoute != null
        ? customPageRoute(_photoPreviewWidget)
        : PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                _photoPreviewWidget,
            opaque: false,
            transitionDuration:
                transitionDuration ?? const Duration(milliseconds: 180),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return CustomFadePageTransitionsBuilder()
                  .buildTransitions<dynamic>(
                      null, context, animation, secondaryAnimation, child);
            },
          );
    Navigator.push<dynamic>(context, _route).then((value) {
      callback?.onSuccess!(value);
    });
  }

  ///设置滑动/图片/视频配置
  static PhotoPreviewDelegatesVo _getDelegatesVo(BuildContext context,
      {ExtendedSlideDelegate? slideDelegate,
      PhotoPreviewImageDelegate? imageDelegate,
      PhotoPreviewVideoDelegate? videoDelegate}) {
    ///设置默认配置
    if (slideDelegate == null) {
      slideDelegate = DefaultExtendedSlideDelegate();
    }
    if (imageDelegate == null) {
      imageDelegate = DefaultPhotoPreviewImageDelegate();
    }
    if (videoDelegate == null) {
      videoDelegate = DefaultPhotoPreviewVideoDelegate();
    }

    ///设置滑动监听
    PhotoPreviewValueSingleton.getInstance()!
        .setSlidingCallBack(slideDelegate.isSlidingStatus);
    PhotoPreviewValueSingleton.getInstance()!
        .setSlidingCallBack(imageDelegate.isSlidingStatus);
    PhotoPreviewValueSingleton.getInstance()!
        .setSlidingCallBack(videoDelegate.isSlidingStatus);

    ///设置页面切换监听
    PhotoPreviewValueSingleton.getInstance()!
        .setPageChangedCallBack(slideDelegate.pageChangeStatus);
    PhotoPreviewValueSingleton.getInstance()!
        .setPageChangedCallBack(imageDelegate.pageChangeStatus);
    PhotoPreviewValueSingleton.getInstance()!
        .setPageChangedCallBack(videoDelegate.pageChangeStatus);

    ///设置context
    imageDelegate.context = context;
    slideDelegate.context = context;
    videoDelegate.context = context;

    return PhotoPreviewDelegatesVo(
      slideDelegate: slideDelegate,
      imageDelegate: imageDelegate,
      videoDelegate: videoDelegate,
    );
  }
}
