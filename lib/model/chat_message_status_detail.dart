import 'dart:convert';

/// Converts a JSON string into a [ChatMessageStatusDetail] object.
///
/// This function decodes the given JSON string and uses the [fromJson] constructor
/// of the [ChatMessageStatusDetail] class to create an instance.
///
/// Parameters:
///   [str] - A JSON string representation of a [ChatMessageStatusDetail] object.
///
/// Returns:
///   An instance of [ChatMessageStatusDetail] populated with data from the given JSON string.
ChatMessageStatusDetail chatMessageStatusDetailFromJson(String str) =>
    ChatMessageStatusDetail.fromJson(json.decode(str));

/// Converts a [ChatMessageStatusDetail] object into a JSON string.
///
/// This function takes a [ChatMessageStatusDetail] object, converts it into a map
/// using the [toJson] method, and then encodes this map as a JSON string.
///
/// Parameters:
///   [data] - The [ChatMessageStatusDetail] object to be converted into a JSON string.
///
/// Returns:
///   A JSON string representation of the [ChatMessageStatusDetail] object.
String chatMessageStatusDetailToJson(ChatMessageStatusDetail data) =>
    json.encode(data.toJson());

/// Represents the detailed status of a chat message.
///
/// This class holds information about the times when a chat message was sent, delivered, and seen.
///
class ChatMessageStatusDetail {

  /// The time when the message was delivered.
  String? deliveredTime;

  /// The unique identifier of the message.
  String? messageId;

  /// The time when the message was seen.
  String? seenTime;

  /// The time when the message was sent.
  String? sentTime;

  /// Initializes a new instance of the [ChatMessageStatusDetail] class.
  ChatMessageStatusDetail({
    this.deliveredTime,
    this.messageId,
    this.seenTime,
    this.sentTime,
  });

  /// Converts a JSON object into a [ChatMessageStatusDetail] instance.
  factory ChatMessageStatusDetail.fromJson(Map<String, dynamic> json) =>
      ChatMessageStatusDetail(
        deliveredTime: json["deliveredTime"],
        messageId: json["messageId"],
        seenTime: json["seenTime"],
        sentTime: json["sentTime"],
      );

  /// Converts a [ChatMessageStatusDetail] instance into a JSON object.
  Map<String, dynamic> toJson() => {
        "deliveredTime": deliveredTime,
        "messageId": messageId,
        "seenTime": seenTime,
        "sentTime": sentTime,
      };
}
