import 'package:flutter/foundation.dart';

import 'fly_chat_method_channel.dart';

/// `LogMessage` is a class that provides a static method for logging messages.
class LogMessage {

  /// Logs a debug message if debug logging is enabled and the application is in debug mode.
  ///
  /// The `d` method accepts a `tag` and a `message` as parameters. The `tag` is a string that
  /// identifies the source of the log message. The `message` can be of any type, and it will be
  /// converted to a string for logging.
  ///
  /// If `enableDebugLog` and `kDebugMode` are both `true`, the method
  /// will log the message. The message is split into chunks of up to 800 characters, and each chunk
  /// is logged separately. This is done to prevent issues with long log messages.
  ///
  /// @param tag a string that identifies the source of the log message.
  /// @param message the message to be logged. This can be of any type.
  static void d(String tag, dynamic message) {
    if (MethodChannelFlyChatFlutter.enableDebugLog && kDebugMode) {

      // Create a regular expression pattern that matches up to 800 characters.
      final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk

      // Apply the pattern to the message, converting it to a string. For each match (chunk of the
      // message), log the chunk with the tag.
      pattern.allMatches(message.toString()).forEach(
          (match) => debugPrint("MirrorFly : $tag==> ${match.group(0)}"));
    }
  }
}