import 'package:photo_preview/src/constant/photo_preview_constant.dart';
import 'package:photo_preview/src/utils/photo_preview_tool_utils.dart';

import '../../photo_preview_export.dart';

///用户交互数据源数据
class PhotoPreviewDataSource {


  ///完整数据源（优先级高）
  List<PhotoPreviewInfoVo> imgVideoFullList;

  ///最终初始化页码数
  int _lastInitPageNum;
  int get lastInitPageNum => _lastInitPageNum;

//  ///初始页（默认为0）
//  final int initialPage;
//
//  ///初始页url (优先级大于initialPage)
//  final String initialUrl;


  PhotoPreviewDataSource({List<String> imgVideoUrlList, this.imgVideoFullList,String initialUrl,int initialPage}) {

    ///路径有值，完整数据无值 进行赋值操作
    if ((imgVideoFullList == null || imgVideoFullList.isEmpty) &&
        (imgVideoUrlList != null && imgVideoUrlList.isNotEmpty)) {
      imgVideoFullList = _getPreviewListByUrlList(imgVideoUrlList);
    }
    _lastInitPageNum = _getInitialPage(initialUrl,initialPage);
  }




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
