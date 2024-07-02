// To parse this JSON data, do
//
//     final audioDevices = audioDevicesFromJson(jsonString);

import 'dart:convert';

/// Converts a JSON string to a list of [AudioDevices].
///
/// Takes a JSON string [str] and maps it to a list of [AudioDevices] objects.
///
/// Example usage:
///
/// ```dart
/// String jsonString = '[{"id":"1", "type":"speaker", "name":"Speaker 1"}]';
/// List<AudioDevices> audioDevicesList = audioDevicesFromJson(jsonString);
/// ```

List<AudioDevices> audioDevicesFromJson(String str) => List<AudioDevices>.from(
    json.decode(str).map((x) => AudioDevices.fromJson(x)));

/// Converts a list of [AudioDevices] to a JSON string.
///
/// Takes a list of [AudioDevices] objects [data] and converts it to a JSON string.
///
/// Example usage:
///
/// ```dart
/// List<AudioDevices> audioDevicesList = [AudioDevices(id: "1", type: "speaker", name: "Speaker 1")];
/// String jsonString = audioDevicesToJson(audioDevicesList);
/// ```

String audioDevicesToJson(List<AudioDevices> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

/// A class representing audio devices used in calls.
///
/// The [AudioDevices] class contains the following properties:
/// - [id]: The ID of the audio device.
/// - [type]: The type of the audio device.
/// - [name]: The name of the audio device.
///
/// Example usage:
///
/// ```dart
/// AudioDevices device = AudioDevices(id: "1", type: "speaker", name: "Speaker 1");
/// ```

class AudioDevices {
  String? id;
  String? type;
  String? name;

  /// Creates an instance of [AudioDevices].
  ///
  /// The constructor allows you to initialize the [id], [type], and [name] of the audio device.
  AudioDevices({
    this.id,
    this.type,
    this.name,
  });

  /// Creates an instance of [AudioDevices] from a JSON object.
  ///
  /// Takes a JSON map [json] and converts it to an [AudioDevices] object.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// Map<String, dynamic> jsonMap = {"id": "1", "type": "speaker", "name": "Speaker 1"};
  /// AudioDevices device = AudioDevices.fromJson(jsonMap);
  /// ```
  factory AudioDevices.fromJson(Map<String, dynamic> json) => AudioDevices(
        id: json["id"],
        type: json["type"],
        name: json["name"],
      );

  /// Converts an [AudioDevices] object to a JSON map.
  ///
  /// Returns a JSON map representation of the [AudioDevices] object.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// AudioDevices device = AudioDevices(id: "1", type: "speaker", name: "Speaker 1");
  /// Map<String, dynamic> jsonMap = device.toJson();
  /// ```
  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "name": name,
      };
}
