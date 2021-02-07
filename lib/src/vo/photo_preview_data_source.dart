import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:photo_preview/src/constant/photo_preview_constant.dart';
import 'package:photo_preview/src/utils/photo_preview_tool_utils.dart';
import 'package:photo_preview/src/vo/photo_preview_type.dart';

import '../../photo_preview_export.dart';

///处理需要传值转化
typedef ValueTransformFunc<T> = T Function(dynamic data);

///用户交互数据源数据
class PhotoPreviewDataSource {
  /// (1) 数据源路径
  ///     params: List<PhotoPreViewInfoVo> imgVideoFullList => 完整数据源路径（优先级高） 包括url(资源路径)、heroTag(平行标记)、vCover(视频封面图)、pLoadingUrl(图片预载图)
  ///     or
  ///     params: List<String> imgVideoUrlList => 仅有资源路径（优先级低）
  ///
  /// (2) params: String inititalUrl => 需要跳转到为资源路径（优先级高） 根据路径计算出跳转位置
  ///     or
  ///     parms: int intitialPage => 直接跳转的位置（优先级低）
  PhotoPreviewDataSource(
      {List<String> imgVideoUrlList,
      this.imgVideoFullList,
      String initialUrl,
      int initialPage}) {
    ///路径有值，完整数据无值 进行赋值操作
    if ((imgVideoFullList == null || imgVideoFullList.isEmpty) &&
        (imgVideoUrlList != null && imgVideoUrlList.isNotEmpty)) {
      imgVideoFullList = _getPreviewListByUrlList(imgVideoUrlList);
    }
    _lastInitPageNum = _getInitialPage(initialUrl, initialPage);
  }

  ///传入imgVideoList通过json格式化获取PhotoPreviewDataSource
  ///（1）imgVideoList 需重新toJson 否则无法格式化
  ///（2）mapKey值是imgVideoList的映射字段（根据对应值一一改写）
  ///（3）extra为非基本类型或需要特殊处理时，需通过传ExtraTransformFunc转换方法进行解析，其他同理
  factory PhotoPreviewDataSource.fromMap(List imgVideoList,
      {String mapToUrlKey = "url",
      String mapToHeroTagKey = "heroTag",
      String mapToLoadingCoverUrlKey = "loadingCoverUrl",
      String mapToTypeKey = "type",
      String mapToExtraKey = "extra",
      String initialUrl,
      int initialPage,
      ValueTransformFunc extraTransformFunc,
      ValueTransformFunc urlTrasformFunc,
      ValueTransformFunc typeTransformFunc,
      ValueTransformFunc loadingTransformFunc,
      ValueTransformFunc heroTransformFunc}) {
    // assert(imgVideoList != null && imgVideoList.isNotEmpty, "数据源不能为空");
    List<PhotoPreviewInfoVo> list = (json.decode(json.encode(imgVideoList))
            as List)
        .map((map) => PhotoPreviewInfoVo(
            url: urlTrasformFunc != null
                ? urlTrasformFunc(map[mapToUrlKey])
                : map[mapToUrlKey],
            loadingCoverUrl: loadingTransformFunc != null
                ? loadingTransformFunc(map[mapToLoadingCoverUrlKey])
                : map[mapToLoadingCoverUrlKey],
            type: typeTransformFunc != null
                ? typeTransformFunc(map[mapToTypeKey])
                : map[mapToTypeKey],
            heroTag: heroTransformFunc != null
                ? heroTransformFunc(map[mapToHeroTagKey])
                : map[mapToHeroTagKey],
            extra: extraTransformFunc != null
                ? extraTransformFunc(map[mapToExtraKey])
                : map[mapToExtraKey]))
        .toList()
        .cast();
    return PhotoPreviewDataSource(
        imgVideoFullList: list,
        initialUrl: initialUrl,
        initialPage: initialPage);
  }

  ///传入imgVideoList通过json格式化获取PhotoPreviewDataSource
  ///（1）imgVideoList 需重新toJson 否则无法格式化
  factory PhotoPreviewDataSource.customMap(List imgVideoList,
      {String initialUrl,
      int initialPage,
      ValueTransformFunc<dynamic> extraTransformFunc,
      ValueTransformFunc<String> urlTrasformFunc,
      ValueTransformFunc<PhotoPreviewType> typeTransformFunc,
      ValueTransformFunc<String> loadingTransformFunc,
      ValueTransformFunc<dynamic> heroTransformFunc}) {
    // assert(imgVideoList != null && imgVideoList.isNotEmpty, "数据源不能为空");
    List<PhotoPreviewInfoVo> list = imgVideoList.map((itemBean) =>
        PhotoPreviewInfoVo(
            url: urlTrasformFunc(itemBean),
            loadingCoverUrl: loadingTransformFunc(itemBean),
            type: typeTransformFunc(itemBean),
            heroTag: heroTransformFunc(itemBean),
            extra: extraTransformFunc(itemBean).toList(),)).toList();
    return PhotoPreviewDataSource(
        imgVideoFullList: list,
        initialUrl: initialUrl,
        initialPage: initialPage);
  }

  ///单图/视频构造
  factory PhotoPreviewDataSource.single(String url,
      {Object heroTag,
      String loadingCoverUrl,
      dynamic extra,
      PhotoPreviewType type}) {
    if (url == null || url.isEmpty) {
      return null;
    }
    return PhotoPreviewDataSource(imgVideoFullList: [
      PhotoPreviewInfoVo(
          url: url,
          heroTag: heroTag,
          loadingCoverUrl: loadingCoverUrl,
          extra: extra,
          type: type)
    ]);
  }

  ///完整数据源 带有预载图 herotag等信息（优先级高）
  List<PhotoPreviewInfoVo> imgVideoFullList;

  ///最终初始化页码数
  int _lastInitPageNum;

  int get lastInitPageNum => _lastInitPageNum;

  ///得到初始化页
  int _getInitialPage(String initialUrl, int initialPage) {
    if (imgVideoFullList == null || imgVideoFullList.isEmpty) {
      return PhotoPreviewConstant.DEFAULT_INIT_PAGE;
    }
    if (initialUrl != null && initialUrl.isNotEmpty) {
      int index = imgVideoFullList.indexOf(PhotoPreviewInfoVo(url: initialUrl));
      if (index != -1) {
        return index;
      }
    }
    if (initialPage == null || initialPage < 0) {
      return PhotoPreviewConstant.DEFAULT_INIT_PAGE;
    }
    if (initialPage > (imgVideoFullList.length - 1)) {
      return imgVideoFullList.length - 1;
    }
    return initialPage ?? PhotoPreviewConstant.DEFAULT_INIT_PAGE;
  }

  ///根据url判断类型 无hero和loading
  List<PhotoPreviewInfoVo> _getPreviewListByUrlList(
      List<String> imgVideoUrlList) {
    if (imgVideoUrlList == null || imgVideoUrlList.isEmpty) {
      return null;
    }
    List<PhotoPreviewInfoVo> imgVideoFullList = List();
    for (String url in imgVideoUrlList) {
      if (url == null || url.isEmpty) {
        continue;
      }
      imgVideoFullList.add(
          PhotoPreviewInfoVo(url: url, heroTag: null, loadingCoverUrl: null));
    }

    return imgVideoFullList;
  }
}
