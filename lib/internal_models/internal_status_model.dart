// To parse this JSON data, do
//
//     final statusData = statusDataFromJson(jsonString);

import 'dart:convert';
/// Converts a JSON string into a [Status] object.
///
/// This function decodes the provided JSON string into a map,
/// and then uses the [Status.fromJson] factory constructor to create a [Status] object.
///
/// [str]: The JSON string to be decoded.
///
/// Returns a [Status] object.
Status statusFromJson(String str) => Status.fromJson(json.decode(str));

/// Converts a [Status] object into a JSON string.
///
/// This function takes the provided [Status] object,
/// converts it to a JSON map using the [toJson] method, and then encodes the map as a JSON string.
///
/// [data]: The [Status] object to be converted.
///
/// Returns a JSON string representation of the [Status].
String statusToJson(Status data) => json.encode(data.toJson());

/// Converts a nullable JSON string into a non-nullable JSON string representing a [Status].
///
/// If the input string is null or empty, this function returns an empty string.
/// Otherwise, it decodes the string into a [Status] object using [statusFromJson],
/// and then serializes the object back into a JSON string using [statusToJson].
///
/// [str]: The nullable JSON string to convert.
///
/// Returns a non-nullable JSON string.
String convertStatusFromJson(String? str) =>
    (str == null || str.isEmpty) ? "" : statusToJson(statusFromJson(str));

/// Converts a JSON string into a list of [Status] objects.
///
/// This function decodes the provided JSON string into a list of maps,
/// and then uses the [Status.fromJson] factory constructor to create each [Status] object in the list.
///
/// [str]: The JSON string to be decoded.
///
/// Returns a list of [Status] objects.
List<Status> statusListFromJson(String str) =>
    List<Status>.from(json.decode(str).map((x) => Status.fromJson(x)));

/// Converts a list of [Status] objects into a JSON string.
///
/// This function takes the provided list of [Status] objects,
/// converts each to a JSON map using the [toJson] method, and then encodes the list of maps as a JSON string.
///
/// [data]: The list of [Status] objects to be converted.
///
/// Returns a JSON string representation of the list of [Status] objects.
String statusListToJson(List<Status> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

/// Converts a nullable JSON string into a non-nullable JSON string representing a list of [Status] objects.
///
/// If the input string is null or empty, this function returns an empty string.
/// Otherwise, it decodes the string into a list of [Status] objects using [statusListFromJson],
/// and then serializes the list back into a JSON string using [statusListToJson].
///
/// [str]: The nullable JSON string to convert.
///
/// Returns a non-nullable JSON string.
String convertStatusListFromJson(String? str) => (str == null || str.isEmpty)
    ? ""
    : statusListToJson(statusListFromJson(str));

/// Represents a status model with an ID, current status flag, and status message.
class Status {

  /// Constructs an instance of [Status].
  Status({
    this.id,
    this.isCurrentStatus,
    this.status,
  });

  /// The ID of the status.
  String? id;
  /// The current status flag.
  bool? isCurrentStatus;
  /// The status message.
  String? status;

  /// Creates a [Status] object from a JSON map.
  factory Status.fromJson(Map<String, dynamic> json) => Status(
        id: json["id"].toString(),
        isCurrentStatus: json["isCurrentStatus"],
        status: json["status"],
      );

  /// Converts a [Status] object to a JSON map.
  Map<String, dynamic> toJson() => {
        "id": id,
        "isCurrentStatus": isCurrentStatus,
        "status": status,
      };
}
