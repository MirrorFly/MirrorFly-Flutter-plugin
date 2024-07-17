import 'dart:convert';

/// Converts a JSON string into a [MirrorflyNotificationAppLaunchDetails] object.
///
/// This function decodes the given JSON string and uses the [fromJson] constructor
/// of the [MirrorflyNotificationAppLaunchDetails] class to create an instance.
///
/// Parameters:
///   [str] - A JSON string representation of a [MirrorflyNotificationAppLaunchDetails] object.
///
/// Returns:
///   An instance of [MirrorflyNotificationAppLaunchDetails] populated with data from the given JSON string.
MirrorflyNotificationAppLaunchDetails
    mirrorflyNotificationAppLaunchDetailsFromJson(String str) =>
        MirrorflyNotificationAppLaunchDetails.fromJson(json.decode(str));

/// Converts a [MirrorflyNotificationAppLaunchDetails] object into a JSON string.
///
/// This function takes a [MirrorflyNotificationAppLaunchDetails] object, converts it into a map
/// using the [toJson] method, and then encodes this map as a JSON string.
///
/// Parameters:
///   [data] - The [MirrorflyNotificationAppLaunchDetails] object to be converted into a JSON string.
///
/// Returns:
///   A JSON string representation of the [MirrorflyNotificationAppLaunchDetails] object.
String mirrorflyNotificationAppLaunchDetailsToJson(
        MirrorflyNotificationAppLaunchDetails data) =>
    json.encode(data.toJson());

/// Contains details on the notification that launched the application.
class MirrorflyNotificationAppLaunchDetails {
  /// Indicates type of the notification.(MediaProgress,MissedCall)
  String? type;

  /// Indicates value of the notification.
  /// for MissedCall it will return true or false
  /// for MediaProgress it will return chat jid.
  String? value;

  /// Constructs an instance of [MirrorflyNotificationAppLaunchDetails].
  MirrorflyNotificationAppLaunchDetails({
    this.type,
    this.value,
  });

  /// Indicates if the app was launched via Media Upload/Download notification.
  bool get didMediaProgressNotificationLaunchApp =>
      type != null && type == "MediaProgress";

  /// Indicates if the app was launched via Missed Call notification.
  bool get didMissedCallNotificationLaunchApp =>
      type != null && type == "MissedCall";

  /// Contains chat jid of the Media Upload/Download notification that launched the app.
  String get mediaProgressChatJid => value ?? "";

  /// Contains details of the notification that launched the app.
  Map<String, dynamic> response() => {'type': type, 'value': value};

  /// Converts a JSON object into a [MirrorflyNotificationAppLaunchDetails] instance.
  factory MirrorflyNotificationAppLaunchDetails.fromJson(
          Map<String, dynamic> json) =>
      MirrorflyNotificationAppLaunchDetails(
        type: json["type"],
        value: json["value"],
      );

  /// Contains details of the notification that launched the app.
  Map<String, dynamic> toJson() => {
        "type": type,
        "value": value,
      };
}
