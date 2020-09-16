import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_preview/photo_preview_export.dart';

///通用样式
class CommonStylePage extends StatefulWidget {
  @override
  _CommonStylePageState createState() => _CommonStylePageState();
}

class _CommonStylePageState extends State<CommonStylePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          behavior:  HitTestBehavior.translucent,
          onTap: (){
            PhotoPreviewPage.navigatorPush(context, PhotoPreviewDataSource(
              imgVideoFullList: [
                PhotoPreviewInfoVo(
                  url:"https://p.pstatp.com/origin/1379a000109aa279a2bd8.jpg",
                ),
                PhotoPreviewInfoVo(
                  url: "https://v-cdn.zjol.com.cn/277001.mp4",
                  vCoverUrl:"https://p.pstatp.com/origin/1379a000109aa279a2bd8.jpg"
                )
              ]
            ));
          },
          child: Container(
            width: 500,
            height: 600,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
