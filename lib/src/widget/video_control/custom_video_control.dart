import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_preview/src/delegate/photo_preview_video_delegate.dart';
import 'package:photo_preview/src/singleton/photo_preview_value_singleton.dart';
import 'package:photo_preview/src/utils/screen_util.dart';
import 'package:photo_preview/src/widget/custom_chewie/custom_chewie_widget.dart';
import 'package:photo_preview/src/widget/inherit/photo_preview_data_inherited_widget.dart';
import 'package:video_player/video_player.dart';

import 'custom_video_utils.dart';
import 'material_progress_bar.dart';
import 'chewie_progress_colors.dart';

class CustomControls extends StatefulWidget {
  final VideoPlayerController controller;
  final CustomChewieController chewieController;
  CustomControls({Key key,@required this.controller,@required this.chewieController,}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CustomControlsState();
  }
}

class _CustomControlsState extends State<CustomControls> {
  VideoPlayerValue _latestValue;
  double _latestVolume;
  bool _hideStuff = true;
  Timer _hideTimer;
  Timer _initTimer;
  Timer _showAfterExpandCollapseTimer;
  bool _dragging = false;
  bool _displayTapped = false;

  final barHeight = 48.0;
  final marginSize = 5.0;

  VideoPlayerController controller;
  CustomChewieController chewieController;

  PhotoPreviewVideoDelegate _videoDelegate;

  @override
  void initState() {
    super.initState();
    controller = widget?.controller;
    chewieController = widget?.chewieController;
  }

  @override
  Widget build(BuildContext context) {
    if (_latestValue.hasError) {
      return chewieController.errorBuilder != null
          ? chewieController.errorBuilder(
        context,
        chewieController.videoPlayerController.value.errorDescription,
      )
          : Center(
        child: Icon(
          Icons.error,
          color: Colors.white,
          size: 42,
        ),
      );
    }

    return StreamBuilder<bool>(
      initialData: false,
      stream: PhotoPreviewValueSingleton.getInstance().isSlidingController?.stream,
      builder: (context, snapshot) {
        return snapshot.data == true
        ?Container()
            :
        MouseRegion(
          onHover: (_) {
            _cancelAndRestartTimer();
          },
          child: GestureDetector(
            ///双击暂停和播放
            onDoubleTap: (){
//          _playPause();
//          _cancelAndRestartTimer();
            },
            onTap: (){
              _playPause();
              _cancelAndRestartTimer();
              },
            child: AbsorbPointer(
              absorbing: _hideStuff,
              child: Container(
                ///弹出底部写成透明颜色
//            color: _hideStuff ? Colors.transparent : Color(0x54000000),
                color: Colors.transparent,
                child: Column(
                  children: <Widget>[
                    ///目的：播放暂停键居中
                    Container(
                      height: barHeight + (_videoDelegate?.controllerBottomDistance ?? 0),
                    ),
                    _latestValue != null &&
                        !_latestValue.isPlaying &&
                        _latestValue.duration == null ||
                        _latestValue.isBuffering
                        ? const Expanded(
                      child: const Center(
                        child: const CircularProgressIndicator(),
                      ),
                    )
                        : _buildHitArea(),
                    _buildBottomBar(context),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  void _dispose() {
    controller.removeListener(_updateState);
    _hideTimer?.cancel();
    _initTimer?.cancel();
    _showAfterExpandCollapseTimer?.cancel();
  }

  @override
  void didChangeDependencies() {
    final _oldController = chewieController;
    chewieController = CustomChewieController.of(context);
    controller = chewieController.videoPlayerController;
    _videoDelegate = PhotoPreviewDataInherited.of(context)?.videoDelegate;

    if (_oldController != chewieController) {
      _dispose();
      _initialize();
    }

    super.didChangeDependencies();
  }

  AnimatedOpacity _buildBottomBar(
      BuildContext context,
      ) {
    final iconColor = Theme.of(context).textTheme.button.color;
    final bottomStatus = ScreenUtils.getBottomBarH(context);
    return AnimatedOpacity(
      opacity: _hideStuff ? 0.0 : 1.0,
      duration: Duration(milliseconds: 300),
      child: Container(
        ///背景透明
        height: barHeight + bottomStatus + (_videoDelegate?.controllerBottomDistance ?? 0),
        padding: EdgeInsets.only(bottom: bottomStatus+ (_videoDelegate?.controllerBottomDistance ?? 0)),
        decoration: BoxDecoration(
//          color: Colors.transparent,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF000000).withOpacity(0),
              Color(0xFF000000).withOpacity(0.5)
            ]
          )
        ),
        child: Row(
          children: <Widget>[
            _buildPlayPause(controller),
            chewieController.isLive
                ? Expanded(child: const Text('LIVE'))
                : _buildPosition(iconColor),
            chewieController.isLive ? const SizedBox() : _buildProgressBar(),
            chewieController.allowMuting
                ? _buildMuteButton(controller)
                : Container(),
            chewieController.allowFullScreen
                ? _buildExpandButton()
                : Container(),
            chewieController.isLive ? Container() : _buildDuration(iconColor),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandButton() {
    ///IOS隐藏全屏（无法退出）
    if(Platform.isIOS){
      return Container();
    }
    return GestureDetector(
      onTap: _onExpandCollapse,
      child: AnimatedOpacity(
        opacity: _hideStuff ? 0.0 : 1.0,
        duration: Duration(milliseconds: 300),
        child: Container(
          height: barHeight,
          margin: EdgeInsets.only(right: 12.0),
          padding: EdgeInsets.only(
            left: 8.0,
            right: 8.0,
          ),
          child: Center(
            child: Icon(
                chewieController.isFullScreen
                    ? Icons.fullscreen_exit
                    : Icons.fullscreen,
                color: Colors.white),
          ),
        ),
      ),
    );
  }

  Expanded _buildHitArea() {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          ///单击控制播放暂停
//          if (_latestValue != null && _latestValue.isPlaying) {
//            if (_displayTapped) {
//              setState(() {
//                _hideStuff = true;
//              });
//            } else
//              _cancelAndRestartTimer();
//          } else {
            _playPause();
            _cancelAndRestartTimer();
//            setState(() {
//              _hideStuff = true;
//            });
//          }
        },
        child: Container(
          color: Colors.transparent,
          child: Center(
            child: AnimatedOpacity(
              opacity:
              _latestValue != null && !_latestValue.isPlaying && !_dragging
                  ? 1.0
                  : 0.0,
              duration: Duration(milliseconds: 300),
              child: GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
//                    color: Theme.of(context).dialogBackgroundColor,
                  color: Colors.transparent,
                    borderRadius: BorderRadius.circular(48.0),
                  ),
                  child: Image.asset("images/play_list_home.png", width: 60,package: "photo_preview",),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector _buildMuteButton(
      VideoPlayerController controller,
      ) {
    return GestureDetector(
      onTap: () {
        _cancelAndRestartTimer();

        if (_latestValue.volume == 0) {
          controller.setVolume(_latestVolume ?? 0.5);
        } else {
          _latestVolume = controller.value.volume;
          controller.setVolume(0.0);
        }
      },
      child: AnimatedOpacity(
        opacity: _hideStuff ? 0.0 : 1.0,
        duration: Duration(milliseconds: 300),
        child: ClipRect(
          child: Container(
            child: Container(
              height: barHeight,
              padding: EdgeInsets.only(
                left: 8.0,
                right: 8.0,
              ),
              child: Icon(
                (_latestValue != null && _latestValue.volume > 0)
                    ? Icons.volume_up
                    : Icons.volume_off,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector _buildPlayPause(VideoPlayerController controller) {
    return GestureDetector(
      onTap: _playPause,
      child: Container(
        height: barHeight,
        color: Colors.transparent,
        margin: EdgeInsets.only(left: 8.0, right: 4.0),
        padding: EdgeInsets.only(
          left: 12.0,
          right: 12.0,
        ),
        child: Icon(
          controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildPosition(Color iconColor) {
    final position = _latestValue != null && _latestValue.position != null
        ? _latestValue.position
        : Duration.zero;

    return Padding(
      padding: EdgeInsets.only(right: 24.0),
      child: Text(
        '${formatDuration(position)}',
        style: TextStyle(fontSize: 14.0, color: Colors.white),
      ),
    );
  }

  Widget _buildDuration(Color iconColor) {
    final duration = _latestValue != null && _latestValue.duration != null
        ? _latestValue.duration
        : Duration.zero;

    return Padding(
      padding: EdgeInsets.only(right: 24.0),
      child: Text(
        '${formatDuration(duration)}',
        style: TextStyle(fontSize: 14.0, color: Colors.white),
      ),
    );
  }

  void _cancelAndRestartTimer() {
    _hideTimer?.cancel();
    _startHideTimer();

    setState(() {
      _hideStuff = false;
      _displayTapped = true;
    });
  }

  Future<Null> _initialize() async {
    controller.addListener(_updateState);

    _updateState();

    if ((controller.value != null && controller.value.isPlaying) ||
        chewieController.autoPlay) {
      _startHideTimer();
    }

    if (chewieController.showControlsOnInitialize) {
      _initTimer = Timer(Duration(milliseconds: 200), () {
        setState(() {
          _hideStuff = false;
        });
      });
    }
  }

  void _onExpandCollapse() {
    setState(() {
      _hideStuff = true;

      chewieController.toggleFullScreen();
      _showAfterExpandCollapseTimer = Timer(Duration(milliseconds: 300), () {
        setState(() {
          _cancelAndRestartTimer();
        });
      });
    });
  }

  void _playPause() {
    if(_latestValue == null){
      return;
    }
    bool isFinished = _latestValue.position >= _latestValue.duration;

    setState(() {
      if (controller.value.isPlaying) {
        _hideStuff = false;
        _hideTimer?.cancel();
        controller.pause();
      } else {
        _cancelAndRestartTimer();

        if (!controller.value.isInitialized) {
          controller.initialize().then((_) {
            controller.play();
          });
        } else {
          if (isFinished) {
            controller.seekTo(Duration(seconds: 0));
          }
          controller.play();
        }
      }
    });
  }

  void _startHideTimer() {
    _hideTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _hideStuff = true;
      });
    });
  }

  void _updateState() {
    setState(() {
      _latestValue = controller.value;
    });
  }

  Widget _buildProgressBar() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: 20.0),
        child: MaterialVideoProgressBar(
          controller,
          onDragStart: () {
            setState(() {
              _dragging = true;
            });

            _hideTimer?.cancel();
          },
          onDragEnd: () {
            setState(() {
              _dragging = false;
            });

            _startHideTimer();
          },
          colors: chewieController.materialProgressColors ??
              CustomChewieProgressColors(
                  playedColor: Theme.of(context).accentColor,
                  handleColor: Theme.of(context).accentColor,
                  bufferedColor: Theme.of(context).backgroundColor,
                  backgroundColor: Theme.of(context).disabledColor),
        ),
      ),
    );
  }
}