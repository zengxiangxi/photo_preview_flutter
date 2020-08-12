import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_preview/src/photo_preview_page/photo_preview_state.dart';
import 'package:photo_preview/src/utils/photo_callback.dart';
import 'package:photo_preview/src/vo/photo_preview_quality_type.dart';

///图片浏览器页面
class PhotoPreviewPage extends StatefulWidget {
  ///传入数据源
  final List<String> dataSourceList;

  ///初始页（默认为0）
  final int initialPage;

  ///初始页url (优先级大于initialPage)
  final String initialUrl;

  ///hero标志（默认各自url为tag）
  final String heroTag;

  ///预加载图质量类型 （默认中等级）
  final PhotoPreviewQualityType qualityType;

  const PhotoPreviewPage(
      {Key key,
      this.dataSourceList,
      this.initialPage,
      this.heroTag,
      this.initialUrl,
      this.qualityType = PhotoPreviewQualityType.MIDDLE})
      : super(key: key);

  @override
  PhotoPreviewState createState() => PhotoPreviewState();

  ///跳转到
  static navigatorPush(BuildContext context,
      {List<String> dataSourceList,
      int initialPage,
      String initialUrl,
      String heroTag,
      PhotoPreviewCallback callback}) {
    if (dataSourceList == null || dataSourceList.isEmpty) {
      callback?.onError("数据为空");
      return;
    }
    Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              PhotoPreviewPage(
            dataSourceList: dataSourceList,
            initialPage: initialPage,
            initialUrl: initialUrl,
            heroTag: heroTag,
          ),
          opaque: false,
          transitionDuration:const Duration(milliseconds: 200),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return child;
          },
        )).then((value) {
      callback?.onSuccess(value);
    });
  }

  ///返回带有统一hero的组件
  static Widget heroWidget({Widget child,String tag}){
    return Hero(
      tag: tag ?? "",
      child: child ?? Container(),
      transitionOnUserGestures: true,
      placeholderBuilder: (BuildContext ctx,Size size,Widget result){
        return result;
      },
    );
  }

  Route _createRoute() {
    return PageRouteBuilder();
  }
}
