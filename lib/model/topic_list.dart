// To parse this JSON data, do
//
//     final topics = topicsFromJson(jsonString);

import 'dart:convert';

/// Converts a JSON string into a list of [Topics] objects.
///
/// This function decodes the given JSON string and maps each JSON object
/// to a [Topics] instance using the [Topics.fromJson] constructor.
///
/// Parameters:
///   [str] - A JSON string representation of a list of [Topics] objects.
///
/// Returns:
///   A list of [Topics] instances populated with data from the given JSON string.
List<Topics> topicsFromJson(String str) =>
    List<Topics>.from(json.decode(str).map((x) => Topics.fromJson(x)));

/// Converts a list of [Topics] objects into a JSON string.
///
/// This function takes a list of [Topics] objects, converts each object into a map
/// using the [toJson] method, and then encodes the list of maps as a JSON string.
///
/// Parameters:
///   [data] - The list of [Topics] objects to be converted into a JSON string.
///
/// Returns:
///   A JSON string representation of the list of [Topics] objects.
String topicsToJson(List<Topics> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

/// A model representing a topic.
///
/// This class holds the details of a topic, including its name, ID, and any
/// associated metadata.
///
/// Parameters:
///   [topicName] - The name of the topic.
///   [topicId] - The unique identifier of the topic.
///   [metaData] - Additional metadata associated with the topic.
class Topics {
  /// The name of the topic.
  String? topicName;

  /// The unique identifier of the topic.
  String? topicId;

  /// Additional metadata associated with the topic.
  dynamic metaData;

  /// Initializes a new instance of the [Topics] class.
  Topics({
    this.topicName,
    this.topicId,
    this.metaData,
  });

  /// Creates a [Topics] instance from a JSON map.
  ///
  /// This factory constructor is used to create an instance of [Topics]
  /// from a map structure representing JSON data. This is useful for
  /// deserializing JSON data retrieved from a database or an API.
  ///
  /// Parameters:
  ///   [json] - A map representing JSON data.
  ///
  /// Returns:
  ///   An instance of [Topics].
  factory Topics.fromJson(Map<String, dynamic> json) => Topics(
        topicName: json["topicName"],
        topicId: json["topicId"],
        metaData: json["metaData"],
      );

  /// Converts an instance of [Topics] to a JSON map.
  ///
  /// This method is used to serialize [Topics] instances into a map
  /// structure that can easily be converted to JSON. This is useful for
  /// storing the instance in a database or sending it over a network.
  ///
  /// Returns:
  ///   A map representing the serialized form of the [Topics] instance.
  Map<String, dynamic> toJson() => {
        "topicName": topicName,
        "topicId": topicId,
        "metaData": metaData,
      };
}
