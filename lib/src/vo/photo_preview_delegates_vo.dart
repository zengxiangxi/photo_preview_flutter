import 'package:photo_preview/photo_preview_export.dart';
import 'package:photo_preview/src/delegate/photo_preview_image_delegate.dart';
import 'package:photo_preview/src/delegate/photo_preview_video_delegate.dart';

class PhotoPreviewDelegatesVo{
  final ExtendedSlideDelegate? slideDelegate;
  final PhotoPreviewImageDelegate? imageDelegate;
  final PhotoPreviewVideoDelegate? videoDelegate;

  PhotoPreviewDelegatesVo({this.slideDelegate, this.imageDelegate, this.videoDelegate});
}