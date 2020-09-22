import 'package:example/common_with_error_and_class_style.dart/custom/common_custom_transimit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_preview/photo_preview_export.dart';

import 'delegate/common_with_error_and_class_image_delegate.dart';

class CommonWithErrorAndClassStyle {
  static void navigatorPush(BuildContext context) {
    PhotoPreviewPage.navigatorPush(
        context,
        PhotoPreviewDataSource(imgVideoFullList: [
          PhotoPreviewInfoVo(
              url: "",
              loadingCoverUrl: "https://s1.ax1x.com/2020/09/17/wR3WnI.md.jpg"),
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
        customClass: CommonCustomTransmitClass("测试参数"),
        imageDelegate: CommonWithErrorAndClassImageDelegate(),
        customErrorWidget: Container(
          child: Center(
            child: Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
        ));
  }
}
