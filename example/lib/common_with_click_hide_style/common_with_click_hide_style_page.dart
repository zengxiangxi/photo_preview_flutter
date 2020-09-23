import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:photo_preview/photo_preview_export.dart';

import 'custom/common_with_click_hide_custom_class.dart';
import 'delegate/common_with_click_hide_image_delegate.dart';
import 'delegate/common_with_click_hide_slide_delegate.dart';

class CommonWithClickHideStylePage {
  static void navigatorPush(BuildContext context) {

    PhotoPreviewPage.navigatorPush(
        context,
        PhotoPreviewDataSource(initialPage: 0, imgVideoFullList: [
          PhotoPreviewInfoVo(
              url: "https://s1.ax1x.com/2020/09/17/wR0NmF.jpg",
              loadingCoverUrl: "https://s1.ax1x.com/2020/09/17/wR0NmF.md.jpg",
              type: PhotoPreviewType.image),
          PhotoPreviewInfoVo(
              url: "https://",
              loadingCoverUrl: "https://s1.ax1x.com/2020/09/17/wR3WnI.md.jpg",
              type: PhotoPreviewType.image),
          PhotoPreviewInfoVo(
              url: "https://v-cdn.zjol.com.cn/277001.mp4",
              loadingCoverUrl: "https://s1.ax1x.com/2020/09/17/wR8uCD.jpg",
              type: PhotoPreviewType.video),

          PhotoPreviewInfoVo(
              url: "https://s1.ax1x.com/2020/09/17/wR3H3Q.jpg",
              loadingCoverUrl: "https://s1.ax1x.com/2020/09/17/wR3H3Q.md.jpg",
              type: PhotoPreviewType.image)
        ]),
        customClass: CommonWithClickHideCustomClass(),
        extendedSlideDelegate:
            CommonWithClickHideSlideDelegate(),
        imageDelegate: CommonWithClickHideImageDelegate());
  }
}
