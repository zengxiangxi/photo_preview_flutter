
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:photo_preview/photo_preview_export.dart';

import 'delegate/common_with_click_hide_image_delegate.dart';
import 'delegate/common_with_click_hide_slide_delegate.dart';

class CommonWithClickHideStylePage {

  static void navigatorPush(BuildContext context) {
    StreamController<Null> _clickController = StreamController.broadcast();

    PhotoPreviewPage.navigatorPush(
      context,
      PhotoPreviewDataSource(
          initialPage: 0,
          imgVideoFullList: [
            PhotoPreviewInfoVo(
                url:"https://s1.ax1x.com/2020/09/17/wR3WnI.jpg",
                loadingCoverUrl: "https://s1.ax1x.com/2020/09/17/wR3WnI.md.jpg"
            ),
            PhotoPreviewInfoVo(
                url: "https://v-cdn.zjol.com.cn/277001.mp4",
                loadingCoverUrl: "https://s1.ax1x.com/2020/09/17/wR8uCD.jpg"),
            PhotoPreviewInfoVo(
                url: "https://s1.ax1x.com/2020/09/17/wR0NmF.jpg",
                loadingCoverUrl: "https://s1.ax1x.com/2020/09/17/wR0NmF.md.jpg"),
            PhotoPreviewInfoVo(
                url: "https://s1.ax1x.com/2020/09/17/wR3H3Q.jpg",
                loadingCoverUrl: "https://s1.ax1x.com/2020/09/17/wR3H3Q.md.jpg")
          ]),
      extendedSlideDelegate: CommonWithClickHideSlideDelegate(_clickController),
      imageDelegate: CommonWithClickHideImageDelegate(_clickController)
    );
  }
}