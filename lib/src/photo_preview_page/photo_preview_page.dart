import 'package:extended_image/extended_image.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_preview/src/photo_preview_page/photo_preview_state.dart';
import 'package:photo_preview/src/utils/photo_callback.dart';

///图片浏览器页面
class PhotoPreviewPage extends StatefulWidget {
  ///传入数据源
  final List<String> dataSourceList;

  ///初始页（默认为0）
  final int initialPage;

  ///初始页url (优先级大于initialPage)
  final String initialUrl;

  ///hero标志
  final String heroTag;

  const PhotoPreviewPage(
      {Key key, this.dataSourceList, this.initialPage, this.heroTag, this.initialUrl})
      : super(key: key);

  @override
  PhotoPreviewState createState() => PhotoPreviewState();

  ///跳转到
  static navigatorPush(BuildContext context,
      {List<String> dataSourceList, int initialPage, String initialUrl,String heroTag,PhotoPreviewCallback callback}) {
    if(dataSourceList == null || dataSourceList.isEmpty){
      callback?.onError("数据为空");
      return;
    }
    Navigator.push(
      context,
      // TransparentMaterialPageRoute
      TransparentCupertinoPageRoute(builder: (_) => PhotoPreviewPage(
        dataSourceList: dataSourceList,
        initialPage: initialPage,
        initialUrl:initialUrl,
        heroTag: heroTag,
      )),
    ).then((value){
      callback?.onSuccess(value);
    });
  }
}
