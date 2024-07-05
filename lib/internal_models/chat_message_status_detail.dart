import 'dart:convert';

/// Converts a JSON string to a [ChatMessageStatusDetail] instance.
///
/// This function decodes a JSON string into a map and uses the [ChatMessageStatusDetail.fromJson]
/// constructor to create an instance of [ChatMessageStatusDetail].
///
/// [str]: The JSON string to decode.
///
/// Returns an instance of [ChatMessageStatusDetail].
ChatMessageStatusDetail chatMessageStatusDetailFromJson(String str) =>
    ChatMessageStatusDetail.fromJson(json.decode(str));

/// Converts a [ChatMessageStatusDetail] instance to a JSON string.
///
/// This function takes a [ChatMessageStatusDetail] instance, serializes it into a JSON map
/// using the [toJson] method, and then encodes the map as a JSON string.
///
/// [data]: The [ChatMessageStatusDetail] instance to serialize.
///
/// Returns a JSON string representation of the [ChatMessageStatusDetail].
String chatMessageStatusDetailToJson(ChatMessageStatusDetail data) =>
    json.encode(data.toJson());

/// Converts a nullable JSON string to a non-nullable JSON string.
///
/// If the input string is null or empty, this function returns an empty string.
/// Otherwise, it converts the input string to a [ChatMessageStatusDetail] instance
/// using [chatMessageStatusDetailFromJson], and then serializes it back to a JSON string
/// using [chatMessageStatusDetailToJson].
///
/// [str]: The nullable JSON string to convert.
///
/// Returns a non-nullable JSON string.
String convertChatMessageStatusDetailToJson(String? str) =>
    (str == null || str.isEmpty)
        ? ""
        : chatMessageStatusDetailToJson(chatMessageStatusDetailFromJson(str));


///
/// This class holds information about the times a chat message was sent, delivered, and seen.
///
/// Attributes:
class ChatMessageStatusDetail {

/// The time at which the message was delivered.
  String? deliveredTime;

///  The unique identifier of the message.
  String? messageId;

///  The time at which the message was seen.
  String? seenTime;

///  The time at which the message was sent.
  String? sentTime;

  /// Constructs an instance of [ChatMessageStatusDetail].
  ChatMessageStatusDetail({
    this.deliveredTime,
    this.messageId,
    this.seenTime,
    this.sentTime,
  });

  /// Creates a [ChatMessageStatusDetail] instance from a JSON map.
  ///
  /// This factory constructor parses a JSON map and creates a [ChatMessageStatusDetail]
  /// instance. It is used for decoding JSON data fetched from an API or stored locally.
  ///
  /// [json]: The JSON map to parse.
  factory ChatMessageStatusDetail.fromJson(Map<String, dynamic> json) =>
      ChatMessageStatusDetail(
        deliveredTime: json["deliveredTime"],
        messageId: json["messageId"],
        seenTime: json["seenTime"],
        sentTime: json["sentTime"],
      );


  /// Converts a [ChatMessageStatusDetail] instance to a JSON map.
  ///
  /// This method serializes the [ChatMessageStatusDetail] instance into a JSON map,
  /// making it easy to encode the chat message status details into a JSON string for storage
  /// or transmission.
  ///
  /// Returns a JSON map representation of the [ChatMessageStatusDetail].
  Map<String, dynamic> toJson() => {
        "deliveredTime": deliveredTime,
        "messageId": messageId,
        "seenTime": seenTime,
        "sentTime": sentTime,
      };
}
