import 'package:example/common_style/common_style_page.dart';
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
      getListViewItem("通用样式（类似微信）",()=> navigatPush(CommonStylePage())),
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

  void navigatPush(Widget widget){
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context){
        return widget ?? Container();
      }
    ));
  }
}
