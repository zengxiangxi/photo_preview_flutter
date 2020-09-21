import 'package:example/common_with_info_style/delegate/common_with_info_video_delegate.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_preview/photo_preview_export.dart';

import 'delegate/common_with_info_image_delegate.dart';

class CommonWithInfoStylePage{
  static void navigatorPush(BuildContext context) {
    PhotoPreviewPage.navigatorPush(
      context,
      PhotoPreviewDataSource(
          initialUrl: "https://v-cdn.zjol.com.cn/277001.mp4",
          imgVideoFullList: [
            PhotoPreviewInfoVo(
                url:"https://s1.ax1x.com/2020/09/17/wR3WnI.jpg",
                loadingCoverUrl: "https://s1.ax1x.com/2020/09/17/wR3WnI.md.jpg",
                extra: {"title":"标题1","intro":"介绍1"}
            ),
            PhotoPreviewInfoVo(
                url: "https://v-cdn.zjol.com.cn/277001.mp4",
                loadingCoverUrl: "https://s1.ax1x.com/2020/09/17/wR8uCD.jpg",
                extra: {"title":"标题2","intro":"介绍2"}
            ),
            PhotoPreviewInfoVo(
                url: "https://s1.ax1x.com/2020/09/17/wR0NmF.jpg",
                loadingCoverUrl: "https://s1.ax1x.com/2020/09/17/wR0NmF.md.jpg",
                extra: {"title":"标题3","intro":"介绍3"}
            ),
            PhotoPreviewInfoVo(
                url: "https://s1.ax1x.com/2020/09/17/wR3H3Q.jpg",
                loadingCoverUrl: "https://s1.ax1x.com/2020/09/17/wR3H3Q.md.jpg",
                extra: {"title":"标题4","intro":"介绍4"}
            )
          ]),
        imageDelegate: CommonWithInfoImageDelegate(),
      videoDelegate: CommonWithInfoVideoDelegate()
    );
  }
}