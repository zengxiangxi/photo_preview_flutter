import 'package:example/common_with_bottom_status_style/delegate/common_with_bottom_status_slide_delegate.dart';
import 'package:example/common_with_bottom_status_style/delegate/common_with_bottom_status_video_delegate.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_preview/photo_preview_export.dart';

class CommonWithBottomStatusStylePage {
  static void navigatorPush(BuildContext context) {
    PhotoPreviewPage.navigatorPush(
        context,
        PhotoPreviewDataSource(
            initialPage: 2,
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
        extendedSlideDelegate: CommonWithBottomStatusSlideDelegate(imgVideoCount: 4),
        videoDelegate: CommonWithBottomStatusVideoDelegate(),
    );
  }
}
