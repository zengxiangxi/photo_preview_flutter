
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_preview/photo_preview_export.dart';
import 'package:photo_preview/src/delegate/photo_preview_image_delegate.dart';
import 'package:photo_preview/src/delegate/photo_preview_video_delegate.dart';
import 'package:photo_preview/src/photo_preview_page/photo_preview_state.dart';
import 'package:photo_preview/src/photo_preview_page/singleton/photo_preview_value_singleton.dart';
import 'package:photo_preview/src/utils/photo_callback.dart';
import 'package:photo_preview/src/vo/photo_preview_data_source.dart';
import 'package:photo_preview/src/vo/photo_preview_delegates_vo.dart';
import 'package:photo_preview/src/widget/inherit/photo_preview_data_inherited_widget.dart';
import 'package:photo_preview/src/widget/route/custom_page_transitions_builder.dart';

///图片浏览器页面
class PhotoPreviewPage extends StatefulWidget {
  ///传入数据源
  final PhotoPreviewDataSource dataSource;

  const PhotoPreviewPage({
    Key key,
    this.dataSource,
  }) : super(key: key);

  @override
  PhotoPreviewState createState() => PhotoPreviewState();

  ///跳转到
  static navigatorPush(BuildContext context, PhotoPreviewDataSource dataSource,
      {PhotoPreviewCallback callback,
      ExtendedSlideDelegate extendedSlideDelegate,
      PhotoPreviewImageDelegate imageDelegate,
      PhotoPreviewVideoDelegate videoDelegate}) async {
    if (dataSource == null ||
        dataSource.imgVideoFullList == null ||
        dataSource.imgVideoFullList.isEmpty) {
      callback?.onError("数据为空");
      return;
    }

    ///优先获取缓存路径
    await PhotoPreviewValueSingleton.getInstance().getTemporaryForder();
    Route _route = PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          PhotoPreviewDataInherited(
        data: _getDelegatesVo(context,
            slideDelegate: extendedSlideDelegate,
            imageDelegate: imageDelegate,
            videoDelegate: videoDelegate),
        child: PhotoPreviewPage(
          dataSource: dataSource,
        ),
      ),
      opaque: false,
      transitionDuration:const Duration(milliseconds: 180),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return CustomFadePageTransitionsBuilder().buildTransitions<dynamic>(
            null, context, animation, secondaryAnimation, child);
      },
    );
    Navigator.push<dynamic>(context, _route).then((value) {
      callback?.onSuccess(value);
    });
  }

  ///设置滑动/图片/视频配置
  static PhotoPreviewDelegatesVo _getDelegatesVo(BuildContext context,
      {ExtendedSlideDelegate slideDelegate,
      PhotoPreviewImageDelegate imageDelegate,
      PhotoPreviewVideoDelegate videoDelegate}) {
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
    PhotoPreviewValueSingleton.getInstance()
        .setSlidingCallBack(slideDelegate?.isSlidingStatus);
    PhotoPreviewValueSingleton.getInstance()
        .setSlidingCallBack(imageDelegate?.isSlidingStatus);
    PhotoPreviewValueSingleton.getInstance()
        .setSlidingCallBack(videoDelegate?.isSlidingStatus);

    ///设置页面切换监听
    PhotoPreviewValueSingleton.getInstance()
        .setPageChangedCallBack(slideDelegate?.pageChangeStatus);
    PhotoPreviewValueSingleton.getInstance()
        .setPageChangedCallBack(imageDelegate?.pageChangeStatus);
    PhotoPreviewValueSingleton.getInstance()
        .setPageChangedCallBack(videoDelegate?.pageChangeStatus);

    ///设置context
    imageDelegate.context = context;
    slideDelegate.context = context;

    return PhotoPreviewDelegatesVo(
      slideDelegate: slideDelegate,
      imageDelegate: imageDelegate,
      videoDelegate: videoDelegate,
    );
  }
}
