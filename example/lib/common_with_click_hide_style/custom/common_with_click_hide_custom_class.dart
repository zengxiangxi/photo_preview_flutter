
import 'dart:async';

import 'package:photo_preview/photo_preview_export.dart';

class CommonWithClickHideCustomClass extends PhotoPreviewCommonClass{

  StreamController<Null> clickController = StreamController.broadcast();

  bool isShow = true;

  @override
  void initState() {
    clickController.stream.listen((event) {
      isShow = !isShow;
    });
  }

  @override
  void dispose() {
    clickController.close();
  }
}