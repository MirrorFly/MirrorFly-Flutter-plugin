import 'dart:convert';

/// Represents metadata associated with a topic.
///
/// This class holds key-value pairs representing specific metadata
/// about a topic, such as its name or description.
class TopicMetaData {
  /// Initializes a new instance of the [TopicMetaData] class.
  TopicMetaData({required this.key, required this.value});

  /// The key associated with the metadata.
  String key;

  /// The value of the metadata.
  String value;
}

/// Provides an extension method to convert [TopicMetaData] to a map.
///
/// This extension adds functionality to the [TopicMetaData] class, allowing
/// instances to be easily converted to a map structure for JSON serialization
/// or other uses.
extension ExtractTopicData on TopicMetaData {

  /// Converts a [TopicMetaData] instance to a map.
  Map<String, dynamic> toMap() => {'key': key, 'value': value};
}

/// Parses a JSON string to a list of [IdentifierMetaData].
///
/// This function decodes a JSON string into a list of [IdentifierMetaData]
/// objects. It is useful for deserializing JSON data into identifiable metadata
/// instances.
///
/// Parameters:
///   [str] - A JSON string representation of a list of identifier metadata.
///
/// Returns:
///   A list of [IdentifierMetaData] instances.
List<IdentifierMetaData> identifierMetaDataFromJson(String str) =>
    List<IdentifierMetaData>.from(
        json.decode(str).map((x) => IdentifierMetaData.fromJson(x)));

/// Converts a list of [IdentifierMetaData] to a JSON string.
///
/// This function serializes a list of [IdentifierMetaData] objects into a JSON
/// string. It is useful for converting identifiable metadata instances into a
/// JSON format for storage or transmission.
///
/// Parameters:
///   [data] - The list of [IdentifierMetaData] objects to serialize.
///
/// Returns:
///   A JSON string representation of the list of [IdentifierMetaData].
String identifierMetaDataToJson(List<IdentifierMetaData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

/// Represents identifiable metadata with a key-value pair.
///
/// This class is used to hold metadata that can be identified by a key,
/// along with its associated value. It is useful for storing additional
/// information that can be referenced by a unique identifier.
class IdentifierMetaData {
  /// Initializes a new instance of the [IdentifierMetaData] class.
  IdentifierMetaData({required this.key, required this.value});

  /// The key associated with the metadata.
  String key;

  /// The value of the metadata.
  String value;

  /// Creates an instance of [IdentifierMetaData] from a JSON map.
  ///
  /// This factory constructor is used to deserialize a JSON map into an
  /// [IdentifierMetaData] instance. It is useful for creating identifiable
  /// metadata from JSON data.
  ///
  /// Parameters:
  ///   [json] - A map representing JSON data.
  ///
  /// Returns:
  ///   An instance of [IdentifierMetaData].
  factory IdentifierMetaData.fromJson(Map<String, dynamic> json) =>
      IdentifierMetaData(
        key: json["key"],
        value: json["value"],
      );

  /// Converts an [IdentifierMetaData] instance to a JSON map.
  ///
  /// This method serializes an [IdentifierMetaData] instance into a map
  /// structure that can easily be converted to JSON. It is useful for storing
  /// or transmitting identifiable metadata in a JSON format.
  ///
  /// Returns:
  ///   A map representing the serialized form of the [IdentifierMetaData] instance.
  Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
      };
}

/// Provides an extension method to convert [IdentifierMetaData] to a map.
///
/// This extension adds functionality to the [IdentifierMetaData] class, allowing
/// instances to be easily converted to a map structure for JSON serialization
/// or other uses.
extension IdentifierMetaDataToMap on IdentifierMetaData {

  /// Converts an [IdentifierMetaData] instance to a map.
  Map<String, dynamic> toMap() => {'key': key, 'value': value};
}

/// Provides an extension method to convert a list of [IdentifierMetaData] to JSON.
///
/// This extension adds functionality to lists of [IdentifierMetaData], enabling
/// them to be easily serialized into a JSON string. It is useful for converting
/// multiple identifiable metadata instances into a JSON format for storage or
/// transmission.
extension IdentifierMetaDataListToMap on List<IdentifierMetaData> {

  /// Converts a list of [IdentifierMetaData] to a JSON string.
  String toJson() => json.encode(List<dynamic>.from(map((x) => x.toJson())));
}

/// Represents a list of metadata associated with users.
///
/// This class holds a key-value pair where the key identifies the metadata,
/// and the value is a list of strings representing user-related data.
class MetaDataUserList {

  /// Initializes a new instance of the [MetaDataUserList] class.
  MetaDataUserList({required this.key, required this.value});

  /// The key associated with the metadata.
  String key;

  /// The value of the metadata.
  List<String> value;
}

/// Provides an extension method to convert [MetaDataUserList] to a map.
///
/// This extension adds functionality to the [MetaDataUserList] class, allowing
/// instances to be easily converted to a map structure for JSON serialization
/// or other uses.
extension MetaDataUserListToMap on MetaDataUserList {

  /// Converts a [MetaDataUserList] instance to a map.
  Map<String, dynamic> toMap() => {'key': key, 'value': value};
}

/// Represents a list of metadata associated with messages.
///
/// This class holds a key-value pair where the key identifies the metadata,
/// and the value is a list of strings representing message-related data.
class MetaDataMessageList {

  /// Initializes a new instance of the [MetaDataMessageList] class.
  MetaDataMessageList({required this.key, required this.value});

  /// The key associated with the metadata.
  String key;

  /// The value of the metadata.
  List<String> value;
}

/// Provides an extension method to convert [MetaDataMessageList] to a map.
///
/// This extension adds functionality to the [MetaDataMessageList] class, allowing
/// instances to be easily converted to a map structure for JSON serialization
/// or other uses.
extension MetaDataMessageListToMap on MetaDataMessageList {

  /// Converts a [MetaDataMessageList] instance to a map.
  Map<String, dynamic> toMap() => {'key': key, 'value': value};
}
