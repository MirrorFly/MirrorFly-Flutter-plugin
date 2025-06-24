import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:mirrorfly_plugin/helpers/file_helper_model.dart';

/// A helper class for working with Flutter asset files.
class MirrorFlyFileHelper {
  /// Checks whether an asset file exists in the Flutter bundle.
  ///
  /// This method attempts to load the asset at the given [fileName]
  /// using [rootBundle.loadString]. If the asset exists and loads
  /// successfully, it returns `true`. If the file is missing or
  /// an error occurs while loading, it returns `false`.
  ///
  /// Example:
  /// ```dart
  /// final FileReadResult result = await MirrorFlyFileHelper.readFile(filePath);
  /// if (result.isSuccess) {
  ///   // Proceed with reading the file
  /// }
  /// ```
  ///
  /// [filepath]: Relative path to the asset as declared in `pubspec.yaml`.
  static Future<FileReadResult> readFile(String fileName) async {
    try {
      final String jsonString = await rootBundle.loadString("assets/i18n/$fileName");
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      final Map<String, String> stringMap = jsonMap.map(
        (key, value) => MapEntry(key, value.toString()),
      );
      return FileReadResult(
          map: stringMap, isSuccess: true, errorMessage: null);
    } catch (e) {
      return FileReadResult(
          map: null, isSuccess: false, errorMessage: e.toString());
    }
  }
}
