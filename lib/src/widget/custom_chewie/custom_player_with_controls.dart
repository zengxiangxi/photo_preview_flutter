import 'dart:ui';

import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_preview/src/delegate/photo_preview_video_delegate.dart';
import 'package:photo_preview/src/widget/custom_chewie/custom_video_aspect_ratio_widget.dart';
import 'package:photo_preview/src/widget/inherit/photo_preview_data_inherited_widget.dart';

import 'custom_chewie_widget.dart';

class CustomPlayerWithControls extends StatelessWidget {
  final String? vCoverUrl;

  const CustomPlayerWithControls({Key? key, this.vCoverUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PhotoPreviewVideoDelegate? _videoDelegate = PhotoPreviewDataInherited.of(context)?.videoDelegate;

    final CustomChewieController chewieController = CustomChewieController.of(context);

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: _buildPlayerWithControls(chewieController, context,_videoDelegate),
        ),
        Container(
            child: _buildControls(context, chewieController))
      ],
    );
  }

  Container _buildPlayerWithControls(
      CustomChewieController chewieController, BuildContext context,PhotoPreviewVideoDelegate? videoDelegate) {
    return Container(
      child: Stack(
        children: <Widget>[
          chewieController.placeholder ?? Container(),
          CustomVideoAspectRatioWidget(vCoverUrl:vCoverUrl,videoDelegate:videoDelegate),
          chewieController.overlay ?? Container(),

        ],
      ),
    );
  }

  Widget? _buildControls(
      BuildContext context,
      CustomChewieController chewieController,
      ) {
    return chewieController.showControls
        ? chewieController.customControls != null
        ? chewieController.customControls
        : Theme.of(context).platform == TargetPlatform.android
        ? MaterialControls()
        : CupertinoControls(
      backgroundColor: Color.fromRGBO(41, 41, 41, 0.7),
      iconColor: Color.fromARGB(255, 200, 200, 200),
    )
        : Container();
  }

  double _calculateAspectRatio(CustomChewieController controller, BuildContext context) {

    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return width > height ? width / height : height / width;
//  return width / height;
  }


}
