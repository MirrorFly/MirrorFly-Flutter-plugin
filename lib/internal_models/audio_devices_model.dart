// To parse this JSON data, do
//
//     final audioDevices = audioDevicesFromJson(jsonString);

import 'dart:convert';

/// Converts JSON string into a list of [AudioDevices].
///
/// Parses a JSON string and returns a list of [AudioDevices] objects.
/// This function is useful for decoding JSON data fetched from an API or stored locally.
///
/// [str]: The JSON string to be parsed.
///
/// Returns a list of [AudioDevices] objects.
List<AudioDevices> audioDevicesFromJson(String str) => List<AudioDevices>.from(
    json.decode(str).map((x) => AudioDevices.fromJson(x)));

/// Converts a list of [AudioDevices] to a JSON string.
///
/// Encodes a list of [AudioDevices] objects into a JSON string.
/// This function can be used to encode data before sending it to an API or storing it locally.
///
/// [data]: The list of [AudioDevices] objects to be encoded.
///
/// Returns a JSON string representation of the list.
String audioDevicesToJson(List<AudioDevices> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

/// Converts a JSON string to a JSON string of [AudioDevices], or returns an empty string if null or empty.
///
/// This function is a convenience wrapper around [audioDevicesFromJson] and [audioDevicesToJson],
/// providing a quick way to convert a JSON string back to a JSON string after checking for null or emptiness.
///
/// [str]: The JSON string to be converted.
///
/// Returns a JSON string of [AudioDevices] if [str] is not null or empty; otherwise, returns an empty string.
String convertAudioDevicesToJson(String? str) => (str == null || str.isEmpty)
    ? ""
    : audioDevicesToJson(audioDevicesFromJson(str));

/// Represents an audio device with an ID, type, and name.
///
/// This class models an audio device, providing properties to store its ID, type, and name.
/// It includes a factory constructor for creating instances from JSON data and a method for converting instances back to JSON.
class AudioDevices {
  /// The unique identifier of the audio device.
  String? id;

  /// The type of the audio device (e.g., speaker, microphone).
  String? type;

  /// The name of the audio device.
  String? name;

  /// Constructs an instance of [AudioDevices].
  ///
  /// [id]: The unique identifier of the audio device.
  /// [type]: The type of the audio device.
  /// [name]: The name of the audio device.
  AudioDevices({
    this.id,
    this.type,
    this.name,
  });

  /// Creates an [AudioDevices] instance from a JSON map.
  ///
  /// [json]: The JSON map containing the audio device data.
  ///
  /// Returns an instance of [AudioDevices].
  factory AudioDevices.fromJson(Map<String, dynamic> json) => AudioDevices(
        id: json["id"],
        type: json["type"],
        name: json["name"],
      );

  /// Converts an [AudioDevices] instance to a JSON map.
  ///
  /// Returns a JSON map representation of the [AudioDevices] instance.
  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "name": name,
      };
}