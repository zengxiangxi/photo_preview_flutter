
typedef OnSuccess = void Function(Object o);
typedef OnError = void Function(String msg);

class PhotoPreviewCallback {
  OnSuccess onSuccess;
  OnError onError;

  PhotoPreviewCallback({this.onSuccess, this.onError});
}
