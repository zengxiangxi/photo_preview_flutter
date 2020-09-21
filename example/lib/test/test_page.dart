import 'package:example/test/custom_delegate/custom_photo_preview_video_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_preview/photo_preview_export.dart';

import 'custom_delegate/custom_photo_preview_image_delegate.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: _toMainWidget(),
      ),
    );
  }

  Widget _toMainWidget() {
    return PhotoPreviewHeroWidget(
      tag: "a",
      onClickForTag: (tag) {
        PhotoPreviewPage.navigatorPush(
            context,
            PhotoPreviewDataSource(imgVideoFullList: [

              PhotoPreviewInfoVo(
                  url: "https://v-cdn.zjol.com.cn/277001.mp4",
                  loadingCoverUrl:
                      "https://zts-tx.oss-cn-beijing.aliyuncs.com/picture/splash_ad/3.png",
                  heroTag: "a"),
              PhotoPreviewInfoVo(
                url: "https://p.pstatp.com/origin/1379a000109aa279a2bd8.jpg",
              ),
              PhotoPreviewInfoVo(
                  url:
                      "https://zts-tx.oss-cn-beijing.aliyuncs.com/picture/splash_ad/3.png",
                  heroTag: "test"),
            ]),
            videoDelegate: CustomPhotoPreviewVideoDelegate(),
            imageDelegate: CustomPhotoPreviewImageDelegate());
      },
      child: Text("跳转到图片浏览器"),
    );
  }
}
