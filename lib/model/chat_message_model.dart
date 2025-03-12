// To parse this JSON data, do
//
//     final chatMessageModel = chatMessageModelFromJson(jsonString);

import 'dart:convert';

import '../message_params.dart' show MessageMetaData;

/// Converts a JSON string into a list of [ChatMessageModel] objects.
///
/// This function decodes the given JSON string and uses the [fromJson] constructor
/// of the [ChatMessageModel] class to create a list of instances.
///
/// Parameters:
///   [str] - A JSON string representation of a list of [ChatMessageModel] objects.
///
/// Returns:
///   A list of [ChatMessageModel] instances populated with data from the given JSON string.
List<ChatMessageModel> chatMessageModelFromJson(String str) =>
    List<ChatMessageModel>.from(
        json.decode(str).map((x) => ChatMessageModel.fromJson(x)));

/// Converts a list of [ChatMessageModel] objects into a JSON string.
///
/// This function takes a list of [ChatMessageModel] objects, converts each into a map
/// using the [toJson] method, and then encodes this list of maps as a JSON string.
///
/// Parameters:
///   [data] - The list of [ChatMessageModel] objects to be converted into a JSON string.
///
/// Returns:
///   A JSON string representation of the list of [ChatMessageModel] objects.
String chatMessageModelToJson(List<ChatMessageModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

/// Converts a JSON string into a [ChatMessageModel] object.
///
/// This function decodes the given JSON string and uses the [fromJson] constructor
/// of the [ChatMessageModel] class to create an instance.
///
/// Parameters:
///   [str] - A JSON string representation of a [ChatMessageModel] object.
///
/// Returns:
///   An instance of [ChatMessageModel] populated with data from the given JSON string.
ChatMessageModel sendMessageModelFromJson(String str) =>
    ChatMessageModel.fromJson(json.decode(str));

/// Converts a [ChatMessageModel] object into a JSON string.
///
/// This function takes a [ChatMessageModel] object, converts it into a map
/// using the [toJson] method, and then encodes this map as a JSON string.
///
/// Parameters:
///   [data] - The [ChatMessageModel] object to be converted into a JSON string.
///
/// Returns:
///   A JSON string representation of the [ChatMessageModel] object.
String sendMessageModelToJson(ChatMessageModel data) =>
    json.encode(data.toJson());

/// Represents a chat message.
class ChatMessageModel {
  /// Constructs a [ChatMessageModel] instance.
  ChatMessageModel({
    required this.chatUserJid,
    required this.contactType,
    required this.isItCarbonMessage,
    required this.isItSavedContact,
    required this.isMessageDeleted,
    required this.isMessageRecalled,
    required this.isMessageSentByMe,
    required this.isMessageStarred,
    required this.isSelected,
    required this.isThisAReplyMessage,
    required this.messageChatType,
    this.messageCustomField,
    required this.messageId,
    required this.messageSentTime,
    required this.messageStatus,
    required this.isMessageEdited,
    required this.messageTextContent,
    required this.messageType,
    required this.meetChatMessage,
    this.metaData = const [],
    this.mentionedUsersIds,
    this.replyParentChatMessage,
    required this.senderNickName,
    required this.senderUserJid,
    required this.senderUserName,
    this.contactChatMessage, //
    this.mediaChatMessage, //
    this.locationChatMessage, //
    required this.topicId, //
  });

  /// The JID of the chat user.
  String chatUserJid;

  /// The type of contact.
  String contactType;

  /// Indicates whether the message is a carbon message.
  bool isItCarbonMessage;

  /// Indicates whether the contact is saved.
  bool isItSavedContact;

  /// Indicates whether the message is deleted.
  bool isMessageDeleted;

  /// Indicates whether the message is recalled.
  bool isMessageRecalled;

  /// Indicates whether the message was sent by the current user.
  bool isMessageSentByMe;

  /// Indicates whether the message is starred.
  bool isMessageStarred;

  /// Indicates whether the message is selected.
  bool isSelected;

  /// Indicates whether the message is a reply message.
  bool isThisAReplyMessage;

  /// The type of chat message.
  String messageChatType;

  /// The custom field of the message.
  MessageCustomField? messageCustomField;

  /// The ID of the message.
  String messageId;

  /// The time the message was sent.
  int messageSentTime;

  /// The status of the message.
  String messageStatus;

  /// Indicates whether the message is edited.
  bool isMessageEdited;

  /// The content of the message.
  String messageTextContent;

  /// The type of message.
  String messageType;

  ///the meet message
  final MeetChatMessage? meetChatMessage;


  /// The metadata of the message.
  List<MessageMetaData>? metaData;

  /// A list of userid associated with the mentioned Users.
  List<String>? mentionedUsersIds;

  /// The parent message of the reply message.
  ReplyParentChatMessage? replyParentChatMessage;

  /// The nickname of the sender.
  String senderNickName;

  /// The JID of the sender.
  String senderUserJid;

  /// The username of the sender.
  String senderUserName;

  /// The contact message.
  ContactChatMessage? contactChatMessage;

  /// The media message.
  MediaChatMessage? mediaChatMessage;

  /// The location message.
  LocationChatMessage? locationChatMessage;

  /// The ID of the topic.
  String topicId;

  /// Converts a JSON object into a [ChatMessageModel] instance.
  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      ChatMessageModel(
          chatUserJid: json["chatUserJid"],
          contactType: json["contactType"],
          isItCarbonMessage: json["isItCarbonMessage"],
          isItSavedContact: json["isItSavedContact"],
          isMessageDeleted: json["isMessageDeleted"],
          isMessageRecalled: json["isMessageRecalled"],
          isMessageSentByMe: json["isMessageSentByMe"],
          isMessageStarred: json["isMessageStarred"],
          isSelected: json["isSelected"],
          isThisAReplyMessage: json["isThisAReplyMessage"],
          messageChatType: json["messageChatType"],
          messageCustomField: json["messageCustomField"] == null
              ? null
              : MessageCustomField.fromJson(json["messageCustomField"]),
          messageId: json["messageId"],
          messageSentTime: json["messageSentTime"],
          messageStatus: json["messageStatus"],
          isMessageEdited: json["isMessageEdited"],
          messageTextContent: json["messageTextContent"],
          messageType: json["messageType"],
          meetChatMessage : json['meetChatMessage'] != null ? MeetChatMessage.fromJson(json['meetChatMessage'] as Map<String,dynamic>) : null,
          metaData: json["metaData"] == null
              ? []
              : List<MessageMetaData>.from(
                  json["metaData"].map((x) => MessageMetaData.fromJson(x))),
          mentionedUsersIds: json["mentionedUsersIds"] == null
              ? []
              : List<String>.from(json["mentionedUsersIds"].map((x) => x)),
          replyParentChatMessage: json["replyParentChatMessage"] == null
              ? null
              : ReplyParentChatMessage.fromJson(json["replyParentChatMessage"]),
          senderNickName: json["senderNickName"],
          senderUserJid: json["senderUserJid"],
          senderUserName: json["senderUserName"],
          contactChatMessage: json["contactChatMessage"] == null
              ? null
              : ContactChatMessage.fromJson(json["contactChatMessage"]),
          mediaChatMessage: json["mediaChatMessage"] == null
              ? null
              : MediaChatMessage.fromJson(json["mediaChatMessage"]),
          locationChatMessage: json["locationChatMessage"] == null
              ? null
              : LocationChatMessage.fromJson(json["locationChatMessage"]),
          topicId: json["topicId"]);

  /// Converts a [ChatMessageModel] instance into a JSON object.
  Map<String, dynamic> toJson() => {
        "chatUserJid": chatUserJid,
        "contactType": contactType,
        "isItCarbonMessage": isItCarbonMessage,
        "isItSavedContact": isItSavedContact,
        "isMessageDeleted": isMessageDeleted,
        "isMessageRecalled": isMessageRecalled,
        "isMessageSentByMe": isMessageSentByMe,
        "isMessageStarred": isMessageStarred,
        "isSelected": isSelected,
        "isThisAReplyMessage": isThisAReplyMessage,
        "messageChatType": messageChatType,
        "messageCustomField": messageCustomField,
        "messageId": messageId,
        "messageSentTime": messageSentTime,
        "messageStatus": messageStatus,
        "isMessageEdited": isMessageEdited,
        "messageTextContent": messageTextContent,
        "messageType": messageType,
        'meetChatMessage' : meetChatMessage?.toJson(),
        "metaData": metaData == null
            ? null
            : List<dynamic>.from(metaData!.map((x) => x.toJson())),
        "mentionedUsersIds": mentionedUsersIds == null
            ? null
            : List<String>.from(mentionedUsersIds!.map((x) => x)),
        "replyParentChatMessage": replyParentChatMessage?.toJson(),
        "senderNickName": senderNickName,
        "senderUserJid": senderUserJid,
        "senderUserName": senderUserName,
        "contactChatMessage": contactChatMessage?.toJson(),
        "mediaChatMessage": mediaChatMessage?.toJson(),
        "locationChatMessage": locationChatMessage?.toJson(),
        "topicId": topicId
      };
}

/// Represents a contact chat message.
class ContactChatMessage {
  /// The name of the contact.
  String contactName;

  /// The phone numbers of the contact.
  List<String> contactPhoneNumbers;

  /// Indicates whether the contact is a chat app user.
  List<bool> isChatAppUser;

  /// The ID of the message.
  String messageId;

  /// Constructs a [ContactChatMessage] instance.
  ContactChatMessage({
    required this.contactName,
    required this.contactPhoneNumbers,
    required this.isChatAppUser,
    required this.messageId,
  });

  /// Converts a JSON object into a [ContactChatMessage] instance.
  factory ContactChatMessage.fromJson(Map<String, dynamic> json) =>
      ContactChatMessage(
        contactName: json["contactName"],
        contactPhoneNumbers: json["contactPhoneNumbers"] == null
            ? []
            : List<String>.from(json["contactPhoneNumbers"]!.map((x) => x)),
        isChatAppUser: json["isChatAppUser"] == null
            ? []
            : List<bool>.from(json["isChatAppUser"]!.map((x) => x)),
        messageId: json["messageId"],
      );

  /// Converts a [ContactChatMessage] instance into a JSON object.
  Map<String, dynamic> toJson() => {
        "contactName": contactName,
        "contactPhoneNumbers":
            List<dynamic>.from(contactPhoneNumbers.map((x) => x)),
        "isChatAppUser": List<dynamic>.from(isChatAppUser.map((x) => x)),
        "messageId": messageId,
      };
}

/// Represents a location chat message.
class LocationChatMessage {
  /// The latitude of the location.
  double latitude;

  /// The longitude of the location.
  double longitude;

  /// The URL of the location.
  String mapLocationUrl;

  /// The ID of the message.
  String messageId;

  /// Constructs a [LocationChatMessage] instance.
  LocationChatMessage({
    required this.latitude,
    required this.longitude,
    required this.mapLocationUrl,
    required this.messageId,
  });

  /// Converts a JSON object into a [LocationChatMessage] instance.
  factory LocationChatMessage.fromJson(Map<String, dynamic> json) =>
      LocationChatMessage(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        mapLocationUrl: json["mapLocationUrl"],
        messageId: json["messageId"],
      );

  /// Converts a [LocationChatMessage] instance into a JSON object.
  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
        "mapLocationUrl": mapLocationUrl,
        "messageId": messageId,
      };
}

/// Represents a media chat message.
class MediaChatMessage {
  /// Indicates whether the audio is recorded.
  bool isAudioRecorded;

  /// The caption text of the media.
  String mediaCaptionText;

  /// The download status of the media.
  int mediaDownloadStatus;

  /// The duration of the media.
  int mediaDuration;

  /// The name of the media file.
  String mediaFileName;

  /// The size of the media file.
  int mediaFileSize;

  /// The local storage path of the media.
  String mediaLocalStoragePath;

  /// The progress status of the media.
  int mediaProgressStatus;

  /// The thumbnail image of the media.
  String mediaThumbImage;

  /// The upload status of the media.
  int mediaUploadStatus;

  /// The ID of the message.
  String messageId;

  /// The type of message.
  String messageType;

  /// Constructs a [MediaChatMessage] instance.
  MediaChatMessage({
    required this.isAudioRecorded,
    required this.mediaCaptionText,
    required this.mediaDownloadStatus,
    required this.mediaDuration,
    required this.mediaFileName,
    required this.mediaFileSize,
    required this.mediaLocalStoragePath,
    required this.mediaProgressStatus,
    required this.mediaThumbImage,
    required this.mediaUploadStatus,
    required this.messageId,
    required this.messageType,
  });

  /// Converts a JSON object into a [MediaChatMessage] instance.
  factory MediaChatMessage.fromJson(Map<String, dynamic> json) =>
      MediaChatMessage(
        isAudioRecorded: json["isAudioRecorded"],
        mediaCaptionText: json["mediaCaptionText"],
        mediaDownloadStatus: json["mediaDownloadStatus"],
        mediaDuration: json["mediaDuration"],
        mediaFileName: json["mediaFileName"],
        mediaFileSize: json["mediaFileSize"],
        mediaLocalStoragePath: json["mediaLocalStoragePath"],
        mediaProgressStatus: json["mediaProgressStatus"],
        mediaThumbImage: json["mediaThumbImage"],
        mediaUploadStatus: json["mediaUploadStatus"],
        messageId: json["messageId"],
        messageType: json["messageType"],
      );

  /// Converts a [MediaChatMessage] instance into a JSON object.
  Map<String, dynamic> toJson() => {
        "isAudioRecorded": isAudioRecorded,
        "mediaCaptionText": mediaCaptionText,
        "mediaDownloadStatus": mediaDownloadStatus,
        "mediaDuration": mediaDuration,
        "mediaFileName": mediaFileName,
        "mediaFileSize": mediaFileSize,
        "mediaLocalStoragePath": mediaLocalStoragePath,
        "mediaProgressStatus": mediaProgressStatus,
        "mediaThumbImage": mediaThumbImage,
        "mediaUploadStatus": mediaUploadStatus,
        "messageId": messageId,
        "messageType": messageType,
      };
}
/// Represents a meet chat message.
class MeetChatMessage {
  ///Meet link for the event
  final String? link;

  /// Unique identifier for the message
  final String? messageId;

  /// Scheduled date and time of the event (in milliseconds since epoch)
  final int? scheduledDateTime;

  /// Title of the meeting or event
  final String? title;

  /// Constructs a [MeetChatMessage] instance.
  MeetChatMessage({
    required this.link,
    required this.messageId,
    required this.scheduledDateTime,
    required this.title,
  });

  /// Converts a JSON object into a [MeetChatMessage] instance.
  MeetChatMessage.fromJson(Map<String, dynamic> json)
      : link = json['link'] as String?,
        messageId = json['messageId'] as String?,
        scheduledDateTime = json['scheduledDateTime'] as int?,
        title = json['title'] as String?;

  /// Converts a [MeetChatMessage] instance into a JSON object.
  Map<String, dynamic> toJson() => {
    'link' : link,
    'messageId' : messageId,
    'scheduledDateTime' : scheduledDateTime,
    'title' : title
  };
}
/// Represents a custom field of a message.
class MessageCustomField {
  /// Constructs a [MessageCustomField] instance.
  MessageCustomField();

  /// Converts a JSON object into a [MessageCustomField] instance.
  factory MessageCustomField.fromJson(Map<String, dynamic> json) =>
      MessageCustomField();

  /// Converts a [MessageCustomField] instance into a JSON object.
  Map<String, dynamic> toJson() => {};
}

/// Represents a parent chat message for a reply message.
class ReplyParentChatMessage {
  /// The JID of the chat user.
  String chatUserJid;

  /// Indicates whether the message is deleted.
  bool isMessageDeleted;

  /// Indicates whether the message is recalled.
  bool isMessageRecalled;

  /// Indicates whether the message was sent by the current user.
  bool isMessageSentByMe;

  /// Indicates whether the message is starred.
  bool isMessageStarred;

  /// The ID of the message.
  String messageId;

  /// The time the message was sent.
  int messageSentTime;

  /// The content of the message.
  String messageTextContent;

  /// The type of message.
  String messageType;

  /// the meet message
  MeetChatMessage? meetChatMessage;

  /// The nickname of the sender.
  String senderNickName;

  /// The username of the sender.
  String senderUserName;

  /// The location message.
  LocationChatMessage? locationChatMessage;

  /// The contact message.
  ContactChatMessage? contactChatMessage;

  /// The media message.
  MediaChatMessage? mediaChatMessage;

  /// A list of userid associated with the mentioned Users.
  List<String>? mentionedUsersIds;

  /// Constructs a [ReplyParentChatMessage] instance.
  ReplyParentChatMessage(
      {required this.chatUserJid,
      required this.isMessageDeleted,
      required this.isMessageRecalled,
      required this.isMessageSentByMe,
      required this.isMessageStarred,
      required this.messageId,
      required this.messageSentTime,
      required this.messageTextContent,
      required this.messageType,
        required this.meetChatMessage,
      required this.senderNickName,
      required this.senderUserName,
      required this.locationChatMessage,
      required this.contactChatMessage,
      required this.mediaChatMessage,
      required this.mentionedUsersIds});

  /// Converts a JSON object into a [ReplyParentChatMessage] instance.
  factory ReplyParentChatMessage.fromJson(Map<String, dynamic> json) =>
      ReplyParentChatMessage(
        chatUserJid: json["chatUserJid"],
        isMessageDeleted: json["isMessageDeleted"],
        isMessageRecalled: json["isMessageRecalled"],
        isMessageSentByMe: json["isMessageSentByMe"],
        isMessageStarred: json["isMessageStarred"],
        messageId: json["messageId"],
        messageSentTime: json["messageSentTime"],
        messageTextContent: json["messageTextContent"],
        messageType: json["messageType"],
        meetChatMessage : json['meetChatMessage'] != null ? MeetChatMessage.fromJson(json['meetChatMessage'] as Map<String,dynamic>) : null,
        senderNickName: json["senderNickName"],
        senderUserName: json["senderUserName"],
        locationChatMessage: json["locationChatMessage"],
        contactChatMessage: json["contactChatMessage"],
        mediaChatMessage: json["mediaChatMessage"] == null
            ? null
            : MediaChatMessage.fromJson(json["mediaChatMessage"]),
        mentionedUsersIds: json["mentionedUsersIds"] == null
            ? []
            : List<String>.from(json["mentionedUsersIds"].map((x) => x)),
      );

  /// Converts a [ReplyParentChatMessage] instance into a JSON object.
  Map<String, dynamic> toJson() => {
        "chatUserJid": chatUserJid,
        "isMessageDeleted": isMessageDeleted,
        "isMessageRecalled": isMessageRecalled,
        "isMessageSentByMe": isMessageSentByMe,
        "isMessageStarred": isMessageStarred,
        "messageId": messageId,
        "messageSentTime": messageSentTime,
        "messageTextContent": messageTextContent,
        "messageType": messageType,
        "senderNickName": senderNickName,
        "senderUserName": senderUserName,
        "locationChatMessage": locationChatMessage?.toJson(),
        "contactChatMessage": contactChatMessage?.toJson(),
        'meetChatMessage' : meetChatMessage?.toJson(),
        "mediaChatMessage": mediaChatMessage?.toJson(),
        "mentionedUsersIds": mentionedUsersIds == null
            ? null
            : List<String>.from(mentionedUsersIds!.map((x) => x)),
      };
}

/// Represents the status of a message.
abstract class MessageStatus {
  /// The status of the message.
  final String status;

  const MessageStatus._(this.status); // Private constructor

  /// Indicates whether the message is sent.
  static const MessageStatus sent = _Sent(); // Instances of subclasses

  /// Indicates whether the message is acknowledged.
  static const MessageStatus acknowledged = _Acknowledged();

  /// Indicates whether the message is delivered.
  static const MessageStatus delivered = _Delivered();

  /// Indicates whether the message is seen.
  static const MessageStatus seen = _Seen();

  /// Indicates whether the message is received.
  static const MessageStatus received = _Received();
}

class _Sent extends MessageStatus {
  const _Sent() : super._("N");
}

class _Acknowledged extends MessageStatus {
  const _Acknowledged() : super._("A");
}

class _Delivered extends MessageStatus {
  const _Delivered() : super._("D");
}

class _Seen extends MessageStatus {
  const _Seen() : super._("S");
}

class _Received extends MessageStatus {
  const _Received() : super._("R");
}
