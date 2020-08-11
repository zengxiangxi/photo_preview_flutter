import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_preview/src/constant/photo_preview_constant.dart';
import 'package:photo_preview/src/photo_preview_page/photo_preview_page.dart';
import 'package:photo_preview/src/utils/photo_preview_tool_utils.dart';
import 'package:photo_preview/src/vo/photo_preview_list_item_vo.dart';
import 'package:photo_preview/src/widget/photo_preview_image_widget.dart';

class PhotoPreviewState extends State<PhotoPreviewPage>{

  ///数据源List
  List<PhotoPreviewListItemVo> _dataSourceList;

  ///page控制器
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _dataSourceList = PhotoPreviewToolUtils.transDataToPhotoPreviewList(widget?.dataSourceList);
    //控制器初始化
    _pageController = PageController(initialPage: _getInitialPage() ?? PhotoPreviewConstant.DEFAULT_INIT_PAGE);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        child: _toMainWidget(),
      ),
    );
  }

  ///主体
  Widget _toMainWidget(){
    ///空页面
    if(_dataSourceList == null || _dataSourceList.isEmpty){
      return Container();
    }
    return ExtendedImageGesturePageView.builder(
      itemCount: _dataSourceList?.length ?? 0,
      controller: _pageController,
      itemBuilder: (BuildContext ctx,int index){
        if(_dataSourceList?.elementAt(index)?.isImageType() ?? false){
          return PhotoPreviewImageWidget(
            heroTag: widget?.heroTag,
            imageInfo: _dataSourceList?.elementAt(index),
          );
        }
        return Container();
      },
    );
  }

  ///得到初始化页
  int  _getInitialPage(){
    if(_dataSourceList == null || _dataSourceList.isEmpty){
      return PhotoPreviewConstant.DEFAULT_INIT_PAGE;
    }
    if(widget?.initialUrl != null && widget.initialUrl.isNotEmpty){
      int index = _dataSourceList.indexOf(PhotoPreviewListItemVo(url: widget?.initialUrl));
      if(index != -1){
        return index;
      }
    }
    if(widget?.initialPage == null || widget.initialPage < 0){
      return PhotoPreviewConstant.DEFAULT_INIT_PAGE;
    }
    if(widget.initialPage > (_dataSourceList.length - 1)){
      return _dataSourceList.length - 1;
    }
    return widget?.initialPage ?? PhotoPreviewConstant.DEFAULT_INIT_PAGE;
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }
}