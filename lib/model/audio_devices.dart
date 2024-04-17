// To parse this JSON data, do
//
//     final audioDevices = audioDevicesFromJson(jsonString);

import 'dart:convert';

List<AudioDevices> audioDevicesFromJson(String str) => List<AudioDevices>.from(
    json.decode(str).map((x) => AudioDevices.fromJson(x)));

String audioDevicesToJson(List<AudioDevices> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

///[AudioDevices] for used in Calls
///[id] of the Audio device
///[type] of the Audio device
///[name] of the Audio device

class AudioDevices {
  String? id;
  String? type;
  String? name;

  AudioDevices({
    this.id,
    this.type,
    this.name,
  });

  factory AudioDevices.fromJson(Map<String, dynamic> json) => AudioDevices(
        id: json["id"],
        type: json["type"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "name": name,
      };
}
