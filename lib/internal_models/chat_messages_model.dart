// To parse this JSON data, do
//
//     final ChatMessage = ChatMessageFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

import 'package:mirrorfly_plugin/internal_models/profile_detail_model.dart';

import '../message_params.dart' show MessageMetaData;

/// Converts a JSON string into a list of [ChatMessage] objects.
///
/// This function decodes the provided JSON string into a list of maps,
/// and then maps each item to a [ChatMessage] object using the [ChatMessage.fromJson] factory constructor.
///
/// [str]: The JSON string to be decoded.
///
/// Returns a list of [ChatMessage] objects.
List<ChatMessage> chatMessageFromJson(String str) => List<ChatMessage>.from(
    json.decode(str).map((x) => ChatMessage.fromJson(x)));

/// Converts a list of [ChatMessage] objects into a JSON string.
///
/// This function takes each [ChatMessage] object in the provided list,
/// converts it to a JSON map using the [toJson] method, and then encodes the list of maps as a JSON string.
///
/// [data]: The list of [ChatMessage] objects to be converted.
///
/// Returns a JSON string representation of the list of chat messages.
String chatMessageToJson(List<ChatMessage> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

/// Converts a JSON string into a single [ChatMessage] object.
///
/// This function decodes the provided JSON string into a map,
/// and then uses the [ChatMessage.fromJson] factory constructor to create a [ChatMessage] object.
///
/// [str]: The JSON string to be decoded.
///
/// Returns a [ChatMessage] object.
ChatMessage sendMessageModelFromJson(String str) =>
    ChatMessage.fromJson(json.decode(str));

/// Converts a single [ChatMessage] object into a JSON string.
///
/// This function takes the provided [ChatMessage] object,
/// converts it to a JSON map using the [toJson] method, and then encodes the map as a JSON string.
///
/// [data]: The [ChatMessage] object to be converted.
///
/// Returns a JSON string representation of the chat message.
String sendMessageModelToJson(ChatMessage data) => json.encode(data.toJson());

/// Converts a nullable JSON string into a non-nullable JSON string representing a list of chat messages.
///
/// If the input string is null or empty, this function returns an empty string.
/// Otherwise, it decodes the string into a list of [ChatMessage] objects using [chatMessageFromJson],
/// and then serializes the list back into a JSON string using [chatMessageToJson].
///
/// [str]: The nullable JSON string to convert.
///
/// Returns a non-nullable JSON string.
String convertChatMessagesJsonFromString(String? str) =>
    (str == null || str.isEmpty)
        ? ""
        : chatMessageToJson(chatMessageFromJson(str));

/// Converts a nullable JSON string into a non-nullable JSON string representing a single chat message.
///
/// If the input string is null or empty, this function returns an empty string.
/// Otherwise, it decodes the string into a [ChatMessage] object using [sendMessageModelFromJson],
/// and then serializes the object back into a JSON string using [sendMessageModelToJson].
///
/// [str]: The nullable JSON string to convert.
///
/// Returns a non-nullable JSON string.
String convertChatMessageJsonFromString(String? str) =>
    (str == null || str.isEmpty)
        ? ""
        : sendMessageModelToJson(sendMessageModelFromJson(str));

/// Represents a chat message with various properties.
class ChatMessage {
  /// Constructs an instance of [ChatMessage].
  ChatMessage({
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
    required this.messageCustomField,
    required this.messageId,
    required this.messageSentTime,
    required this.messageStatus,
    required this.isMessageEdited,
    required this.messageTextContent,
    required this.messageType,
    required this.meetChatMessage,
    this.metaData = const [],
    this.mentionedUsersIds,
    required this.replyParentChatMessage,
    required this.senderNickName,
    required this.senderUserJid,
    required this.senderUserName,
    required this.contactChatMessage,
    required this.mediaChatMessage,
    required this.locationChatMessage,
    required this.topicId,
  });

  /// The JID of the user involved in the chat.
  String chatUserJid;

  /// The type of contact (e.g., live, local, deleted). Nullable.
  String? contactType;

  /// Indicates if the message is a carbon copy. Nullable.
  bool? isItCarbonMessage;

  /// Indicates if the contact is saved in the user's contacts. Nullable.
  bool? isItSavedContact;

  /// Indicates if the message has been deleted.
  bool isMessageDeleted;

  /// Indicates if the message has been recalled.
  bool isMessageRecalled;

  /// Indicates if the message was sent by the current user.
  bool isMessageSentByMe;

  /// Indicates if the message is starred.
  bool isMessageStarred;

  /// Indicates if the message is selected in the UI.
  bool isSelected;

  /// Indicates if this message is a reply to another message.
  bool isThisAReplyMessage;

  /// The type of chat (e.g., single chat, group chat).
  String messageChatType;

  /// A map of custom fields attached to the message.
  Map<String, dynamic> messageCustomField;

  /// The unique identifier of the message.
  String messageId;

  /// The time the message was sent. Can be of various types.
  dynamic messageSentTime;

  /// The status of the message (e.g., sent, delivered, seen).
  String messageStatus;

  /// Indicates if the message has been edited.
  bool isMessageEdited;

  /// The text content of the message. Nullable.
  String? messageTextContent;

  /// The type of message (e.g., text, image, video).
  String messageType;

  /// Details of the meet shared in the message. Nullable.
  MeetChatMessage? meetChatMessage;

  /// A list of metadata associated with the message. Nullable.
  List<MessageMetaData>? metaData;

  /// A list of userid associated with the mentioned Users.
  List<String>? mentionedUsersIds;

  /// Information about the parent message if this is a reply. Nullable.
  ReplyParentChatMessage? replyParentChatMessage;

  /// The nickname of the sender.
  String senderNickName;

  /// The JID of the sender.
  String senderUserJid;

  /// The username of the sender.
  String senderUserName;

  /// Details of the contact shared in the message. Nullable.
  ContactChatMessage? contactChatMessage;

  /// Details of the media shared in the message. Nullable.
  MediaChatMessage? mediaChatMessage;

  /// Details of the location shared in the message. Nullable.
  LocationChatMessage? locationChatMessage;

  /// The topic ID associated with the message. Nullable.
  String? topicId;

  /// Creates a [ChatMessage] instance from a JSON map.
  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
      chatUserJid: json["chatUserJid"] ?? "",
      contactType: getContactType(json),
      isItCarbonMessage: Platform.isAndroid
          ? json["isItCarbonMessage"] ?? false
          : json["isCarbonMessage"] ?? false,
      isItSavedContact: Platform.isAndroid
          ? json["isItSavedContact"] ?? false
          : json["isSavedContact"] ?? false,
      isMessageDeleted: json["isMessageDeleted"],
      isMessageRecalled: json["isMessageRecalled"],
      isMessageSentByMe: json["isMessageSentByMe"],
      isMessageStarred: json["isMessageStarred"],
      isSelected: json["isSelected"] ?? false,
      isThisAReplyMessage: Platform.isAndroid
          ? json["isThisAReplyMessage"]
          : json["isReplyMessage"],
      messageChatType:
          json["messageChatType"].toString().toLowerCase() == "singlechat"
              ? "chat"
              : json["messageChatType"].toLowerCase(),
      messageCustomField: json["messageCustomField"] ?? {},
      messageId: json["messageId"],
      messageSentTime: json["messageSentTime"].toInt(),
      messageStatus: getMessageStatus(Platform.isAndroid
          ? json["messageStatus"]["status"]
          : json["messageStatus"]),
      isMessageEdited:
          Platform.isAndroid ? json["isEdited"] : json["isMessageEdited"],
      messageTextContent: json["messageTextContent"].toString(),
      messageType: getMessageType(json["messageType"]),
      meetChatMessage:json['meetChatMessage'] == null ? null: MeetChatMessage.fromJson(json['meetChatMessage']),
      metaData: json["metaData"] == null
          ? []
          : List<MessageMetaData>.from(
              json["metaData"].map((x) => MessageMetaData.fromJson(x))),
      mentionedUsersIds: json["mentionedUsersIds"] == null
          ? []
          : Platform.isIOS
              ? List<String>.from(json["mentionedUsersIds"].map((x) => x))
              : List<String>.from(json["mentionedUsersIds"]
                  .map((x) => ProfileDetails.fromJson(x).jid?.split("@")[0])),
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
      topicId: Platform.isIOS ? json["topicID"] : json["topicId"]);

  /// Converts a [ChatMessage] instance to a JSON map.
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
         "meetChatMessage":meetChatMessage?.toJson(),
        "metaData": metaData == null
            ? null
            : List<dynamic>.from(metaData!.map((x) => x.toJson())),
        "mentionedUsersIds": mentionedUsersIds == null
            ? null
            : List<String>.from(mentionedUsersIds!.map((x) => x)),
        "replyParentChatMessage":
            replyParentChatMessage ?? replyParentChatMessage?.toJson(),
        "senderNickName": senderNickName,
        "senderUserJid": senderUserJid,
        "senderUserName": senderUserName,
        "contactChatMessage":
            contactChatMessage ?? contactChatMessage?.toJson(),
        "mediaChatMessage": mediaChatMessage ?? mediaChatMessage?.toJson(),
        "locationChatMessage":
            locationChatMessage ?? locationChatMessage?.toJson(),
        "topicId": topicId
      };
}

/*class MessageMetaData {
  MessageMetaData({required this.key, required this.value});

  String key;
  String value;

  factory MessageMetaData.fromJson(Map<String, dynamic> json) =>
      MessageMetaData(
        key: json["key"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
      };
}*/

/// Represents a contact shared in a chat message.
class ContactChatMessage {
  /// Constructs an instance of [ContactChatMessage].
  ContactChatMessage({
    required this.contactName,
    required this.contactPhoneNumbers,
    required this.isChatAppUser,
    required this.messageId,
  });

  /// The name of the contact.
  String contactName;

  /// The phone numbers of the contact.
  List<String> contactPhoneNumbers;

  /// Indicates if the contact is a user of the chat app.
  List<bool> isChatAppUser;

  /// The unique identifier of the message.
  String messageId;

  /// Creates a [ContactChatMessage] instance from a JSON map.
  factory ContactChatMessage.fromJson(Map<String, dynamic> json) =>
      ContactChatMessage(
        contactName: json["contactName"],
        contactPhoneNumbers:
            List<String>.from(json["contactPhoneNumbers"].map((x) => x)),
        isChatAppUser: Platform.isAndroid
            ? List<bool>.from(json["isChatAppUser"].map((x) => x))
            : List<bool>.from(json["isChatUser"].map((x) => x)),
        messageId: json["messageId"],
      );

  /// Converts a [ContactChatMessage] instance to a JSON map.
  Map<String, dynamic> toJson() => {
        "contactName": contactName,
        "contactPhoneNumbers":
            List<dynamic>.from(contactPhoneNumbers.map((x) => x)),
        "isChatAppUser": List<dynamic>.from(isChatAppUser.map((x) => x)),
        "messageId": messageId,
      };
}


/// Represents a contact shared in a chat message.
class MeetChatMessage {
  ///Meet link for the event
  final String link;

  /// Unique identifier for the message
  final String messageId;

  /// Scheduled date and time of the event (in milliseconds since epoch)
  final int scheduledDateTime;

  /// Title of the meeting or event
  final String title;

  /// Constructs an instance of [MeetChatMessage].
  MeetChatMessage({
    required this.link,
    required this.messageId,
    required this.scheduledDateTime,
    required this.title,
  });

  ///Factory constructor to create an instance from a JSON object
  factory MeetChatMessage.fromJson(Map<String, dynamic> json) {
    return MeetChatMessage(
      link: json['link'] ?? '', // Default empty string if null
      messageId: json['messageId'] ?? '', // Default empty string if null
      scheduledDateTime: json['scheduledDateTime'] ?? 0, // Default 0 if null
      title: json['title'] ?? '', // Default empty string if null
    );
  }

  /// Converts the object into a JSON representation
  Map<String, dynamic> toJson() {
    return {
      'link': link,
      'messageId': messageId,
      'scheduledDateTime': scheduledDateTime,
      'title': title,
    };
  }
}

/// Represents a location shared in a chat message.
class LocationChatMessage {
  /// Constructs an instance of [LocationChatMessage].
  LocationChatMessage({
    required this.latitude,
    required this.longitude,
    required this.mapLocationUrl,
    required this.messageId,
  });

  /// The latitude of the location.
  double latitude;

  /// The longitude of the location.
  double longitude;

  /// The URL of the location on a map.
  String mapLocationUrl;

  /// The unique identifier of the message.
  String messageId;

  /// Creates a [LocationChatMessage] instance from a JSON map.
  factory LocationChatMessage.fromJson(Map<String, dynamic> json) =>
      LocationChatMessage(
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        mapLocationUrl: json["mapLocationUrl"],
        messageId: json["messageId"],
      );

  /// Converts a [LocationChatMessage] instance to a JSON map.
  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
        "mapLocationUrl": mapLocationUrl,
        "messageId": messageId,
      };
}

/// Represents a media shared in a chat message.
class MediaChatMessage {
  /// Constructs an instance of [MediaChatMessage].
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

  /// Indicates if the audio is recorded.
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

  /// The local storage path of the media file.
  String mediaLocalStoragePath;

  /// The progress status of the media.
  int mediaProgressStatus;

  /// The thumbnail image of the media.
  String mediaThumbImage;

  /// The upload status of the media.
  int mediaUploadStatus;

  /// The unique identifier of the message.
  String messageId;

  /// The type of the message.
  String messageType;

  /// Creates a [MediaChatMessage] instance from a JSON map.
  factory MediaChatMessage.fromJson(Map<String, dynamic> json) =>
      MediaChatMessage(
        isAudioRecorded: Platform.isAndroid
            ? json["isAudioRecorded"] ?? false
            : json["audioType"] == "recording"
                ? true
                : false,
        mediaCaptionText: json["mediaCaptionText"] ?? "",
        mediaDownloadStatus:
            getMediaDownloadStatus(json["mediaDownloadStatus"]),
        mediaDuration: json["mediaDuration"],
        mediaFileName: json["mediaFileName"],
        mediaFileSize: json["mediaFileSize"],
        mediaLocalStoragePath: json["mediaLocalStoragePath"],
        mediaProgressStatus: json["mediaProgressStatus"],
        mediaThumbImage: json["mediaThumbImage"]
            .toString()
            .replaceAll("\\\\n", "\\n")
            .replaceAll("\\n", "\n")
            .replaceAll("\n", "")
            .replaceAll(" ", ""),
        mediaUploadStatus: getMediaUploadStatus(json["mediaUploadStatus"]),
        messageId: json["messageId"],
        messageType: getMediaMessageType(json["messageType"]),
      );

  /// Converts a [MediaChatMessage] instance to a JSON map.
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

/// Represents a custom field attached to a message.
class MessageCustomField {
  /// Constructs an instance of [MessageCustomField].
  MessageCustomField();

  /// Creates a [MessageCustomField] instance from a JSON map.
  factory MessageCustomField.fromJson(Map<String, dynamic> json) =>
      MessageCustomField();

  /// Converts a [MessageCustomField] instance to a JSON map.
  Map<String, dynamic> toJson() => {};
}

/// Represents the status of a message.
class MessageStatus {
  /// Constructs an instance of [MessageStatus].
  MessageStatus({
    required this.status,
  });

  /// The status of the message.
  String status;

  /// Creates a [MessageStatus] instance from a JSON map.
  factory MessageStatus.fromJson(Map<String, dynamic> json) => MessageStatus(
        status: json["status"],
      );

  /// Converts a [MessageStatus] instance to a JSON map.
  Map<String, dynamic> toJson() => {
        "status": status,
      };
}

/// Represents a parent message that is being replied to.
class ReplyParentChatMessage {
  /// Constructs an instance of [ReplyParentChatMessage].
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
      required this.senderNickName,
      required this.senderUserName,
      required this.locationChatMessage,
      required this.contactChatMessage,
      required this.mediaChatMessage,
        required this.meetChatMessage,
      required this.mentionedUsersIds});

  /// The JID of the user involved in the chat.
  String chatUserJid;

  /// Indicates if the message has been deleted.
  bool isMessageDeleted;

  /// Indicates if the message has been recalled.
  bool isMessageRecalled;

  /// Indicates if the message was sent by the current user.
  bool isMessageSentByMe;

  /// Indicates if the message is starred.
  bool isMessageStarred;

  /// The unique identifier of the message.
  String messageId;

  /// The time the message was sent.
  int messageSentTime;

  /// The text content of the message.
  String? messageTextContent;

  /// The type of message (e.g., text, image, video).
  String messageType;

  /// The nickname of the sender.
  String senderNickName;

  /// The username of the sender.
  String senderUserName;

  /// Details of the location shared in the message. Nullable.
  LocationChatMessage? locationChatMessage;

  /// Details of the contact shared in the message. Nullable.
  ContactChatMessage? contactChatMessage;

  /// Details of the media shared in the message. Nullable.
  MediaChatMessage? mediaChatMessage;

  /// Details of the meet shared in the message. Nullable.
  MeetChatMessage? meetChatMessage;

  /// A list of userid associated with the mentioned Users.
  List<String>? mentionedUsersIds;

  /// Creates a [ReplyParentChatMessage] instance from a JSON map.
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
        messageType: getReplyMessageType(json),
        senderNickName: json["senderNickName"],
        senderUserName: json["senderUserName"],
        locationChatMessage: json["locationChatMessage"] == null
            ? null
            : LocationChatMessage.fromJson(json["locationChatMessage"]),
        contactChatMessage: json["contactChatMessage"] == null
            ? null
            : ContactChatMessage.fromJson(json["contactChatMessage"]),
        mediaChatMessage: json["mediaChatMessage"] == null
            ? null
            : MediaChatMessage.fromJson(json["mediaChatMessage"]),
        meetChatMessage:json['meetChatMessage'] == null ? null: MeetChatMessage.fromJson(json['meetChatMessage']),
        mentionedUsersIds: json["mentionedUsersIds"] == null
            ? []
            : Platform.isIOS
                ? List<String>.from(json["mentionedUsersIds"].map((x) => x))
                : List<String>.from(json["mentionedUsersIds"]
                    .map((x) => ProfileDetails.fromJson(x).jid?.split("@")[0])),
      );

  /// Converts a [ReplyParentChatMessage] instance to a JSON map.
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
        "locationChatMessage":
            locationChatMessage ?? locationChatMessage?.toJson(),
        "contactChatMessage":
            contactChatMessage ?? contactChatMessage?.toJson(),
        "mediaChatMessage": mediaChatMessage ?? mediaChatMessage?.toJson(),
        "meetChatMessage":meetChatMessage?.toJson(),
        "mentionedUsersIds": mentionedUsersIds == null
            ? null
            : List<String>.from(mentionedUsersIds!.map((x) => x)),
      };
}

/// Determines the contact type based on the provided JSON map.
///
/// This method checks the platform (Android or iOS) and the `contactType` field within the JSON map to determine the contact type.
/// For Android, it directly uses the `contactType` value with specific cases for "unknown", "live", "local", and "deleted" contacts.
/// For iOS, it infers the contact type based on other fields such as `isSavedContact` and `isDeletedUser`.
///
/// [json]: The JSON map containing contact information.
///
/// Returns a string representing the contact type.
String getContactType(Map<String, dynamic> json) {
  if (Platform.isAndroid) {
    switch (json["contactType"]) {
      case "unknown":
        return "unknown_contact";
      case "live":
        return "live_contact";
      case "local":
        return "local_contact";
      case "deleted":
        return "deleted_contact";
      default:
        return json["contactType"];
    }
  } else {
    if (json["isSavedContact"] == true) {
      return "live_contact";
    } else if (json["isDeletedUser"]) {
      return "deleted_contact";
    } else if (json["messageChatType"].toString().toLowerCase() ==
        "singlechat") {
      return "unknown_contact";
    } else {
      return "";
    }
  }
}

/// Determines the message status based on the provided status value.
String getMessageStatus(dynamic status) {
  if (Platform.isAndroid) {
    return status;
  } else {
    switch (status) {
      case 2:
        return "A"; //acknowledge
      case 3:
        return "D"; //delivered
      case 4:
        return "S"; //seen
      case 5:
        return "R"; //received
      default:
        return "N"; //"N" for "notAcknowledged" in iOS,
    }
  }
}

/// Determines the message type based on the provided type value.
String getMessageType(dynamic type) {
  if (type == null) {
    return "";
  }
  return type.toString().toUpperCase() == "FILE"
      ? "DOCUMENT"
      : type.toString().toUpperCase();
}

/// Determines the media download status for a given status code.
///
/// Returns an integer representing the unified download status code.
///
int getMediaDownloadStatus(int mediaDownloadStatus) {
  if (Platform.isIOS) {
    return mediaDownloadStatus == 4
        ? 5
        : mediaDownloadStatus == 5
            ? 3
            : mediaDownloadStatus == 6
                ? 4
                : mediaDownloadStatus == 7
                    ? 6
                    : mediaDownloadStatus == 9
                        ? 401
                        : mediaDownloadStatus;
  } else {
    return mediaDownloadStatus;
  }
}

/// Determines the media upload status for a given status code.
int getMediaUploadStatus(int mediaUploadStatus) {
  if (Platform.isIOS) {
    return mediaUploadStatus == 3
        ? 7
        : mediaUploadStatus == 8
            ? 0
            : mediaUploadStatus;
  } else {
    return mediaUploadStatus;
  }
}

/// Determines the media message type based on the provided type value.
String getMediaMessageType(String type) {
  return type.toString().toUpperCase() == "FILE"
      ? "DOCUMENT"
      : type.toString().toUpperCase();
}

/// Determines the reply message type based on the provided JSON map.
String getReplyMessageType(dynamic json) {
  if (Platform.isAndroid) {
    return json["messageType"].toString().toUpperCase();
  } else {
    if (json["mediaChatMessage"] != null &&
        json["mediaChatMessage"]["mediaFileType"].toString().isNotEmpty) {
      return json["mediaChatMessage"]["mediaFileType"]
                  .toString()
                  .toUpperCase() ==
              "FILE"
          ? "DOCUMENT"
          : json["mediaChatMessage"]["mediaFileType"].toString().toUpperCase();
    } else if (json["contactChatMessage"] != null) {
      return "CONTACT";
    } else if (json["locationChatMessage"] != null) {
      return "LOCATION";
    } else if (json["messageTextContent"].toString().isNotEmpty) {
      return "TEXT";
    } else {
      return "";
    }
  }
}
