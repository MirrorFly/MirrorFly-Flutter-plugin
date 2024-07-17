// To parse this JSON data, do
//
//     final statusData = statusDataFromJson(jsonString);

import 'dart:convert';

/// Converts a JSON string into a list of [StatusData] objects.
///
/// This function decodes the given JSON string and maps each JSON object
/// to a [StatusData] instance using the [StatusData.fromJson] constructor.
///
/// Parameters:
///   [str] - A JSON string representation of a list of [StatusData] objects.
///
/// Returns:
///   A list of [StatusData] instances populated with data from the given JSON string.
List<StatusData> statusDataFromJson(String str) =>
    List<StatusData>.from(json.decode(str).map((x) => StatusData.fromJson(x)));

/// Converts a list of [StatusData] objects into a JSON string.
///
/// This function takes a list of [StatusData] objects, converts each object into a map
/// using the [toJson] method, and then encodes the list of maps as a JSON string.
///
/// Parameters:
///   [data] - The list of [StatusData] objects to be converted into a JSON string.
///
/// Returns:
///   A JSON string representation of the list of [StatusData] objects.
String statusDataToJson(List<StatusData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

/// A model representing the status data.
///
/// This class holds the details of a status, including its ID, current status flag,
/// and the status text itself.
///
/// Parameters:
///   [id] - The unique identifier of the status.
///   [isCurrentStatus] - A boolean indicating if this is the current status.
///   [status] - The text of the status.
class StatusData {
  /// Initializes a new instance of the [StatusData] class.
  StatusData({
    this.id,
    this.isCurrentStatus,
    this.status,
  });

  /// The unique identifier of the status.
  String? id;

  /// A boolean indicating if this is the current status.
  bool? isCurrentStatus;

  /// The text of the status.
  String? status;

  /// Creates a [StatusData] instance from a JSON map.
  ///
  /// This factory constructor is used to create an instance of [StatusData]
  /// from a map structure representing JSON data. This is useful for
  /// deserializing JSON data retrieved from a database or an API.
  ///
  /// Parameters:
  ///   [json] - A map representing JSON data.
  ///
  /// Returns:
  ///   An instance of [StatusData].
  factory StatusData.fromJson(Map<String, dynamic> json) => StatusData(
        id: json["id"].toString(),
        isCurrentStatus: json["isCurrentStatus"],
        status: json["status"],
      );

  /// Converts an instance of [StatusData] to a JSON map.
  ///
  /// This method is used to serialize [StatusData] instances into a map
  /// structure that can easily be converted to JSON. This is useful for
  /// storing the instance in a database or sending it over a network.
  ///
  /// Returns:
  ///   A map representing the serialized form of the [StatusData] instance.
  Map<String, dynamic> toJson() => {
        "id": id,
        "isCurrentStatus": isCurrentStatus,
        "status": status,
      };
}
