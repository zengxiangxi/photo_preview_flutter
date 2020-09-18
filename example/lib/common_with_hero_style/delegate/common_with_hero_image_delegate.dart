import 'package:photo_preview/photo_preview_export.dart';

class CommonWithHeroImageDelegate extends DefaultPhotoPreviewImageDelegate{

  @override
  bool get enableLoadState {
    return true;
  }
}