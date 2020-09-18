import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_preview/photo_preview_export.dart';

import 'delegate/common_with_hero_image_delegate.dart';

class CommonWithHeroStylePage extends StatefulWidget {

  static void navigatorPush(BuildContext context,List fullList) {
    PhotoPreviewPage.navigatorPush(
      context,
      PhotoPreviewDataSource(
          initialUrl: "https://s1.ax1x.com/2020/09/17/wR3WnI.jpg",
          imgVideoFullList:fullList,),
      imageDelegate: CommonWithHeroImageDelegate()
    );
  }

  @override
  _CommonWithHeroStylePageState createState() =>
      _CommonWithHeroStylePageState();
}

class _CommonWithHeroStylePageState extends State<CommonWithHeroStylePage> {

  static String TEST_HERO_TAG = "testHeroTag";
  ///或者通过id设置tag
  List<PhotoPreviewInfoVo> _list =
  [
    PhotoPreviewInfoVo(
      url: "https://s1.ax1x.com/2020/09/17/wR3WnI.jpg",
      pLoadingUrl: "https://s1.ax1x.com/2020/09/17/wR3WnI.md.jpg",
      heroTag: TEST_HERO_TAG
    ),
    PhotoPreviewInfoVo(
      url: "https://v-cdn.zjol.com.cn/277001.mp4",
      vCoverUrl: "https://s1.ax1x.com/2020/09/17/wR8uCD.jpg",
      heroTag: Uuid().v1()

    ),
    PhotoPreviewInfoVo(
      url: "https://s1.ax1x.com/2020/09/17/wR0NmF.jpg",
      pLoadingUrl: "https://s1.ax1x.com/2020/09/17/wR0NmF.md.jpg", heroTag: Uuid().v1()

    ),
    PhotoPreviewInfoVo(
      url: "https://s1.ax1x.com/2020/09/17/wR3H3Q.jpg",
      pLoadingUrl: "https://s1.ax1x.com/2020/09/17/wR3H3Q.md.jpg", heroTag: Uuid().v1()
    ),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).padding.top+20,
            left: 20,
            child: GestureDetector(
              onTap: (){
                clearDiskCachedImage("https://s1.ax1x.com/2020/09/17/wR3WnI.jpg");
                clearMemoryImageCache();
                Navigator.of(context).maybePop();
              },
              child: Text(
                   " X ",
                   overflow: TextOverflow.ellipsis,
                   maxLines: 1,
                   style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                   ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: PhotoPreviewHeroWidget(
              tag: TEST_HERO_TAG,
              onClickForTag: (tag){
                CommonWithHeroStylePage.navigatorPush(context,_list);
              },
              child: ExtendedImage.network(
                "https://s1.ax1x.com/2020/09/17/wR3WnI.md.jpg", width: 200,),
            ),
          ),
        ],
      ),
    );
  }
}
