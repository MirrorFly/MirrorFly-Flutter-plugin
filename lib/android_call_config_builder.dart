/// A configuration model for managing Android CallKit behavior.
///
/// Use this class to specify whether the ringtone and incoming call UI should be enabled.
class AndroidCallKitSettings {
  /// Whether the ringtone should be played for incoming calls.
  /// Defaults to `true`.
  final bool enableRingtone;

  /// Whether the default Android incoming call UI should be shown.
  /// Defaults to `true`.
  final bool enableIncomingCallUI;

  /// Creates a new instance of [AndroidCallKitSettings].
  ///
  /// Use this to configure the call experience on Android.
  AndroidCallKitSettings({
    this.enableRingtone = true,
    this.enableIncomingCallUI = true,
  });

  /// Converts the current settings to a [Map] for platform channel use.
  Map<String, dynamic> toMap() {
    return {
      "enableRingtone": enableRingtone,
      "enableIncomingCallUI": enableIncomingCallUI,
    };
  }
}
