import 'package:flutter/widgets.dart';
import 'package:photo_preview/photo_preview_export.dart';

class CommonSingleStylePage{
  static void navigatorPush(BuildContext context){
    PhotoPreviewPage.navigatorPush(context, PhotoPreviewDataSource.single(
              "https://s1.ax1x.com/2020/09/17/wR3WnI.jpg",
              loadingCoverUrl: "https://s1.ax1x.com/2020/09/17/wR3WnI.md.jpg"
    ));
  }
}