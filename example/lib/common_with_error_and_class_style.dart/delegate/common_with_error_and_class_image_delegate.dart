
import 'package:example/common_with_error_and_class_style.dart/custom/common_custom_transimit.dart';
import 'package:photo_preview/photo_preview_export.dart';

class CommonWithErrorAndClassImageDelegate extends DefaultPhotoPreviewImageDelegate {

  CommonCustomTransmitClass _viewModel;

  @override
  void initState() {
    _viewModel = PhotoPreviewCommonClass.of(context);
    print("测试是否传值成功: ${_viewModel?.value ?? "-"}");
  }
}
