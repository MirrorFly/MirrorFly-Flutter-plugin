/// A model representing the result of reading a file.
class FileReadResult {
  /// An optional contains map content from the file as a JSON.
  final Map<String, String>? map;

  /// Indicates whether the file was successfully read.
  final bool isSuccess;

  /// An optional error message if the file read failed.
  final String? errorMessage;

  /// Creates an instance of [FileReadResult].
  ///
  /// [map] is the map content of the file.
  /// [isSuccess] is `true` if reading the file was successful.
  /// [errorMessage] contains the error message if any; empty if successful.
  FileReadResult({
    required this.map,
    required this.isSuccess,
    required this.errorMessage,
  });
}
