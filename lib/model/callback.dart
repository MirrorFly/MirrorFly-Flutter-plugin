abstract class Callback {
  void onSuccessful(FlyResponse response);
}

class FlyException {
  final String code;
  final String? message;
  final dynamic throwable;

  FlyException(this.code, this.message, this.throwable);
}

class FlyResponse {
  final bool isSuccess;
  final String data;
  final String? message;
  final FlyException? exception;

  FlyResponse(this.isSuccess, this.data, this.message, [this.exception]);
}

// Anonymous class implementing FlyCallback
class FlyCallback implements Callback {
  Function(FlyResponse response) onResponse = (FlyResponse response) {};

  @override
  void onSuccessful(FlyResponse response) {
    onResponse(response);
  }
}
