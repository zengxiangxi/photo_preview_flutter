import 'package:photo_preview/src/constant/photo_preview_constant.dart';
import 'package:photo_preview/src/utils/photo_preview_tool_utils.dart';

import '../../photo_preview_export.dart';

///用户交互数据源数据
class PhotoPreviewDataSource {


  /// (1) 数据源路径
  ///     params: List<PhotoPreViewInfoVo> imgVideoFullList => 完整数据原路径（优先级高） 包括url(资源路径)、heroTag(平行标记)、vCover(视频封面图)、pLoadingUrl(图片预载图)
  ///     or
  ///     params: List<String> imgVideoUrlList => 仅有资源路径（优先级di）
  ///
  /// (2) params: String inititalUrl => 需要跳转到为资源路径（优先级高） 根据路径计算出跳转位置
  ///     or
  ///     parms: int intitialPage => 直接跳转的位置（优先级低）
  PhotoPreviewDataSource({List<String> imgVideoUrlList, this.imgVideoFullList,String initialUrl,int initialPage}) {

    ///路径有值，完整数据无值 进行赋值操作
    if ((imgVideoFullList == null || imgVideoFullList.isEmpty) &&
        (imgVideoUrlList != null && imgVideoUrlList.isNotEmpty)) {
      imgVideoFullList = _getPreviewListByUrlList(imgVideoUrlList);
    }
    _lastInitPageNum = _getInitialPage(initialUrl,initialPage);
  }



  ///完整数据源 带有预载图 herotag等信息（优先级高）
  List<PhotoPreviewInfoVo> imgVideoFullList;

  ///最终初始化页码数
  int _lastInitPageNum;
  int get lastInitPageNum => _lastInitPageNum;


  ///得到初始化页
  int  _getInitialPage(String initialUrl, int initialPage){
    if(imgVideoFullList == null || imgVideoFullList.isEmpty){
      return PhotoPreviewConstant.DEFAULT_INIT_PAGE;
    }
    if(initialUrl != null && initialUrl.isNotEmpty){
      int index = imgVideoFullList.indexOf(PhotoPreviewInfoVo(url: initialUrl));
      if(index != -1){
        return index;
      }
    }
    if(initialPage == null || initialPage < 0){
      return PhotoPreviewConstant.DEFAULT_INIT_PAGE;
    }
    if(initialPage > (imgVideoFullList.length - 1)){
      return imgVideoFullList.length - 1;
    }
    return initialPage ?? PhotoPreviewConstant.DEFAULT_INIT_PAGE;
  }


  ///根据url判断类型 无hero和loading
  List<PhotoPreviewInfoVo> _getPreviewListByUrlList(List<String> imgVideoUrlList){
    if(imgVideoUrlList == null || imgVideoUrlList.isEmpty){
      return null;
    }
    List<PhotoPreviewInfoVo> imgVideoFullList = List();
    for(String url in imgVideoUrlList){
      if(url == null ||url.isEmpty){
        continue;
      }
      imgVideoFullList.add(
        PhotoPreviewInfoVo(
          url: url,
          heroTag: null,
          vCoverUrl: null,
          pLoadingUrl: null
        )
      );
    }

    return imgVideoFullList;
  }
}
