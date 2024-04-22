abstract class Callback {
  void onSuccessful(FlyResponse response);
}

/// Exception class for representing Mirrorfly related errors.
class FlyException {
  /// Error code associated with the exception.
  final String code;

  /// Error message associated with the exception, if available.
  final String? message;

  /// The underlying exception or error, if available.
  final dynamic throwable;

  /// Constructs a FlyException with the given [code], [message], and [throwable].
  FlyException(this.code, this.message, this.throwable);

  /// Returns a string representation of the exception.
  ///
  /// The returned string includes the error [code], [message], and [throwable].
  /// Example:
  /// ```
  /// code : 500, message: Server error, exception: SocketException: Connection timed out
  /// ```
  @override
  String toString() {
    return "code : $code, message: $message, exception: $throwable";
  }
}

/// Represents a response from a Mirrorfly operation.
class FlyResponse {
  /// Indicates whether the operation was successful.
  final bool isSuccess;

  /// The data returned from the operation.
  final String data;

  /// An optional message associated with the response.
  final String? message;

  /// An optional exception that occurred during the operation.
  final FlyException? exception;

  /// Constructs a FlyResponse instance.
  ///
  /// The [isSuccess] parameter indicates whether the operation was successful.
  /// The [data] parameter represents the Json.Encoded String data returned from the operation.
  /// The [message] parameter is an optional message associated with the response.
  /// The [exception] parameter is an optional exception that occurred during the operation.
  FlyResponse(this.isSuccess, this.data, this.message, [this.exception]);

  /// Indicates whether the response contains data.
  bool get hasData => data.isNotEmpty;

  /// Indicates whether the response contains error.
  bool get hasError => exception != null;

  /// Retrieves the error message associated with the response.
  ///
  /// Returns the error message if an exception occurred during the operation;
  /// otherwise, returns an empty string.
  String get errorMessage => exception?.message ?? "";

  /// Retrieves the error message details associated with the error message.
  ///
  /// Returns the error message if an exception is thrown during the operation;
  /// otherwise, returns an null.
  dynamic get errorDetails => exception?.throwable;

  @override
  String toString() {
    return "isSuccess : $isSuccess, data: $data, message: $message, exception: {${exception.toString()}}";
  }
}

