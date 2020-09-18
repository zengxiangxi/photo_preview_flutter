import 'package:example/common_style/common_style_page.dart';
import 'package:example/common_with_bottom_status_style/common_with_bottom_status_style_page.dart';
import 'package:example/common_with_hero_style/common_with_hero_style_page.dart';
import 'package:example/common_with_info_style/common_with_info_style_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ShowListPage extends StatefulWidget {
  @override
  _ShowListPageState createState() => _ShowListPageState();
}

class _ShowListPageState extends State<ShowListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: getListView(),
      ),
    );
  }

  List<Widget> getListView() {
    return [
      getListViewItem("通用样式（类似微信）",()=> CommonStylePage.navigatorPush(context)),
      getListViewItem("通用样式带有底部页码状态",()=> CommonWithBottomStatusStylePage.navigatorPush(context)),
      getListViewItem("通用样式带有信息",()=> CommonWithInfoStylePage.navigatorPush(context)),
      getListViewItem("通用样式带有Hero动画",() => navigatorPush(CommonWithHeroStylePage())),

    ];
  }

  Widget getListViewItem(String title, VoidCallback callback) {
    return ListTile(
      title: Text(
        title ?? "",
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      onTap: () {
        if (callback != null) {
          callback();
        }
      },
    );
  }

  void navigatorPush(Widget widget){
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context){
        return widget ?? Container();
      }
    ));
  }
}
