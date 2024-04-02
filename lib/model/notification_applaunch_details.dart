import 'dart:convert';

MirrorflyNotificationAppLaunchDetails
    mirrorflyNotificationAppLaunchDetailsFromJson(String str) =>
        MirrorflyNotificationAppLaunchDetails.fromJson(json.decode(str));

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
