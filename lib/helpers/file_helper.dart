import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:mirrorfly_plugin/helpers/file_helper_model.dart';

/// A helper class for reading Flutter asset files, typically used for
/// localization or configuration within the MirrorFly platform.
class MirrorFlyFileHelper {
  /// Reads and parses a JSON asset file from the Flutter bundle.
  ///
  /// This method attempts to load an asset file using [rootBundle.loadString]
  /// and decode it into a `Map<String, String>`. It supports loading from both
  /// the main app's asset bundle and from external packages.
  ///
  /// - If the [fileNameOrPath] is a simple filename (e.g. `en.json`), it is
  ///   prefixed with `assets/i18n/` by default.
  /// - If [packageName] is provided, the asset is read from the specified
  ///   external package using the `packages/` prefix.
  /// - If the file does not exist, is empty, or is invalid JSON, an error
  ///   message is returned in the result.
  ///
  /// Example:
  /// ```dart
  /// final result = await MirrorFlyFileHelper.readFile(
  ///   fileNameOrPath: 'en.json',
  ///   packageName: 'my_package', // optional
  /// );
  ///
  /// if (result.isSuccess) {
  ///   final translations = result.map;
  ///   // Use the loaded map
  /// } else {
  ///   print('Failed: ${result.errorMessage}');
  /// }
  /// ```
  ///
  /// [fileNameOrPath] - The relative file name or path to the asset file.
  /// [packageName] - Optional; name of the package if the asset is located
  /// in a different Flutter package.
  ///
  /// Returns a [FileReadResult] containing the parsed map if successful,
  /// or an error message if the operation fails.
  static Future<FileReadResult> readFile({
    required String fileNameOrPath,
    String? packageName,
  }) async {
    try {
      const String defaultPrefix = 'assets/i18n/';
      final bool isFullPath = fileNameOrPath.contains('/');
      final String fullPath =
          isFullPath ? fileNameOrPath : '$defaultPrefix$fileNameOrPath';

      String pathToRead;
      if (packageName != null) {
        pathToRead = 'packages/$packageName/$fullPath';
      } else {
        pathToRead = fullPath;
      }

      final String jsonString = await rootBundle.loadString(pathToRead);
      if (jsonString.trim().isEmpty) {
        return FileReadResult(
          map: null,
          isSuccess: false,
          errorMessage: "File is empty or contains invalid content: $fullPath",
        );
      }

      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      final Map<String, String> stringMap = jsonMap.map(
        (key, value) => MapEntry(key, value.toString()),
      );

      return FileReadResult(
        map: stringMap,
        isSuccess: true,
        errorMessage: null,
      );
    } catch (e) {
      return FileReadResult(
        map: null,
        isSuccess: false,
        errorMessage: "Error loading file [$fileNameOrPath]: ${e.toString()}",
      );
    }
  }
}
