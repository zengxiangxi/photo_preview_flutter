import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PhotoPreviewErrorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("加载失败",style: TextStyle(color: Colors.white),),
      ),
    );
  }
}
