import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_preview/photo_preview_export.dart';

class CommonSingleStylePage extends StatefulWidget {
  @override
  _CommonSingleStylePageState createState() => _CommonSingleStylePageState();
}

class _CommonSingleStylePageState extends State<CommonSingleStylePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).padding.top + 20,
            left: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).maybePop();
              },
              child: Text(
                " X ",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: PhotoPreviewHeroWidget(
              onClickForTag: (tag) {
                PhotoPreviewPage.navigatorPush(
                    context,
                    PhotoPreviewDataSource.single(
                        "https://s1.ax1x.com/2020/09/17/wR3WnI.jpg",
                        loadingCoverUrl:
                            "https://s1.ax1x.com/2020/09/17/wR3WnI.md.jpg",
                        heroTag: tag));
              },
              child: ExtendedImage.network(
                "https://s1.ax1x.com/2020/09/17/wR3WnI.md.jpg",
                width: 200,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
