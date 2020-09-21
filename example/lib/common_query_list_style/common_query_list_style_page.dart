import 'package:example/common_query_list_style/vo/common_query_extra_vo.dart';
import 'package:example/common_query_list_style/vo/common_query_list_vo.dart';
import 'package:example/common_with_info_style/delegate/common_with_info_image_delegate.dart';
import 'package:example/common_with_info_style/delegate/common_with_info_video_delegate.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_preview/photo_preview_export.dart';

///通用样式(传list形式）
class CommonQueryListStylePage {
  static void navigatorPush(BuildContext context) {
    ///测试返回一个实体数组
    List<CommonQueryListVo> resultList = [
      CommonQueryListVo(
          id: "1",
          picurl: "https://s1.ax1x.com/2020/09/17/wR3WnI.jpg",
          spicurl: "https://s1.ax1x.com/2020/09/17/wR3WnI.md.jpg",
          data: CommonQueryExtraVo(extra1: "风景", extra2: "风景说明")),
      CommonQueryListVo(
          id: "2",
          picurl: "https://v-cdn.zjol.com.cn/277001.mp4",
          spicurl: "https://s1.ax1x.com/2020/09/17/wR8uCD.jpg",
          data: CommonQueryExtraVo(extra1: "视频", extra2: "嘿嘿描述")),
      CommonQueryListVo(
          id: "3",
          picurl: "https://s1.ax1x.com/2020/09/17/wR0NmF.jpg",
          spicurl: "https://s1.ax1x.com/2020/09/17/wR0NmF.md.jpg",
          data: CommonQueryExtraVo(extra1: "图片", extra2: "图片")),
      CommonQueryListVo(
          id: "4",
          picurl: "https://s1.ax1x.com/2020/09/17/wR3H3Q.jpg",
          spicurl: "https://s1.ax1x.com/2020/09/17/wR3H3Q.md.jpg",
          data: CommonQueryExtraVo(extra1: "看看", extra2: "s "))
    ];

    PhotoPreviewPage.navigatorPush(
      context,
      PhotoPreviewDataSource.fromMap(resultList,
          mapToUrlKey: "picurl",
          mapToLoadingCoverUrlKey: "spicurl",
          mapToExtraKey: "data",
          mapToHeroTagKey: "id",
          extraTransformFunc: (extraMap){
            return {
              'title':extraMap["extra1"],
              'intro':extraMap["extra1"]
            };
          }),
        imageDelegate: CommonWithInfoImageDelegate(),
        videoDelegate: CommonWithInfoVideoDelegate());
  }

}
