# photo_preview
# 通用图片视频浏览器（flutter）

## 引入说明

主要使用了第三方图片库 `zmtzawqlp` 的 [fluttercandies/extended_image](https://github.com/fluttercandies/extended_image)


## 预览效果

[预览图](https://img.vim-cn.com/91/15d405f199664f3a991693fea90583a9419ed9.gif)
![效果图](https://img.vim-cn.com/91/15d405f199664f3a991693fea90583a9419ed9.gif)


## 说明

对多个图片/视频大图查看器封装，支持自定义图片、视频和滑动效果等多种样式配置，具有高扩展性。

目前主要支持功能

* 图片
	* 双击放大和还原，单击退出
	* 滑动缩小退出
	* 预加载缩略图
* 视频
	* 视频预加载封面
	* 滑动缩小退出
	* 切换自动暂停和还原状态
* 操作
	* 自定义图片显示效果
	* 自定义视频显示效果
	* 自定义滑动拖动效果
	* 自定义显示错误效果
	* Hero飞行效果
	* 多种数据源构造方法

## 使用

#### 引入库

`pubspec.yaml`配置文件引入

```
photo_preview:
	git:
		url: $仓库地址
		ref: master

```

#### 基础使用

调用 `PhotoPreviewPage.navigatorPush(...)`方法

```
PhotoPreviewPage.navigatorPush(context, PhotoPreviewDataSource(
        imgVideoFullList: [
          PhotoPreviewInfoVo(
            url:"https://s1.ax1x.com/2020/09/17/wR3WnI.jpg",
            loadingCoverUrl: "https://s1.ax1x.com/2020/09/17/wR3WnI.md.jpg",
            type: PhotoPreviewType.image
          ),
          PhotoPreviewInfoVo(
              url: "https://v-cdn.zjol.com.cn/277001.mp4",
              loadingCoverUrl:"https://s1.ax1x.com/2020/09/17/wR8uCD.jpg",
              type: PhotoPreviewType.video
          ),
          PhotoPreviewInfoVo(
              url: "https://s1.ax1x.com/2020/09/17/wR0NmF.jpg",
              loadingCoverUrl: "https://s1.ax1x.com/2020/09/17/wR0NmF.md.jpg",
              type: PhotoPreviewType.image
          ),
          PhotoPreviewInfoVo(
            url: "https://s1.ax1x.com/2020/09/17/wR3H3Q.jpg",
            loadingCoverUrl: "https://s1.ax1x.com/2020/09/17/wR3H3Q.md.jpg",
              type: PhotoPreviewType.image
          )
        ]
    ));

```

#### 多种数据源方式构造

*PhotoPreviewDataSource字段*

| 参数                    | 说明                    | 默认值                |
| -----------------------| ---------------------  | -------------------  |
| imgVideoUrlList 		  | 仅有资源路径（优先级低）   | null                 |
| imgVideoFullList       | 完整数据源路径（优先级低） | null                 |
| initialUrl 				  | 初始url（优先级高）      | null                 |
| initialPage            |  初始页（优先级低）        | null                 |

**1.单数据**

通过 `PhotoPreviewDataSource.single` 构建查看单图数据源

```
 PhotoPreviewPage.navigatorPush(
 	context,
 	PhotoPreviewDataSource.single(
 		"https://s1.ax1x.com/2020/09/17/wR3WnI.jpg",
 		loadingCoverUrl:"https://s1.ax1x.com/2020/09/17/wR3WnI.md.jpg",
 		heroTag: tag
 		));
```

**2.List数组数据**

利用json编解码构建数据源list

| 参数                    | 说明                   | 默认值                |
| ----------------------- | --------------------- | ------------------- |
| list（必填）             | 自定义实体数组           | null                |
| mapToUrlKey             | 资源文件url对应字段      | url                  |
| mapToLoadingCoverUrlKey | 预加载url对应字段         | loadingCoverurl     |
| mapToExtraKey           | 额外传值对应字段         | extra               |
| mapToHeroTagKey         | herotag标志            | heroTag             |
| mapToTypeKey            | 资源类型对应字段         | type                |
| extraTransformFunc等相关 | 自定义处理结果           |（非基本类型需实现该方法) |
| initialUrl 				   | 初始url（优先级高）       |null                 |
| initialPage             | 初始页（优先级低）        |null                 |




```
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

```

**3.直接构造数据源**

直接将转换好的 `PhotoPreviewDataSource`传值

```
 PhotoPreviewPage.navigatorPush(context, PhotoPreviewDataSource(
        imgVideoFullList: [
          PhotoPreviewInfoVo(
            url:"https://s1.ax1x.com/2020/09/17/wR3WnI.jpg",
            loadingCoverUrl: "https://s1.ax1x.com/2020/09/17/wR3WnI.md.jpg",
            type: PhotoPreviewType.image
          ),
          PhotoPreviewInfoVo(
              url: "https://v-cdn.zjol.com.cn/277001.mp4",
              loadingCoverUrl:"https://s1.ax1x.com/2020/09/17/wR8uCD.jpg",
              type: PhotoPreviewType.video
          ),
          PhotoPreviewInfoVo(
              url: "https://s1.ax1x.com/2020/09/17/wR0NmF.jpg",
              loadingCoverUrl: "https://s1.ax1x.com/2020/09/17/wR0NmF.md.jpg",
              type: PhotoPreviewType.image
          ),
          PhotoPreviewInfoVo(
            url: "https://s1.ax1x.com/2020/09/17/wR3H3Q.jpg",
            loadingCoverUrl: "https://s1.ax1x.com/2020/09/17/wR3H3Q.md.jpg",
              type: PhotoPreviewType.image
          )
        ]
    ));
```

#### 自定义图片

待完善文档...


#### 自定义视频

待完善文档...


#### 自定义滑动效果

待完善文档...

#### 自定义传值

待完善文档...






