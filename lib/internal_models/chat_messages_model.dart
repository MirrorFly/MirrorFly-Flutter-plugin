// To parse this JSON data, do
//
//     final ChatMessage = ChatMessageFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

import '../message_params.dart' show MessageMetaData;

List<ChatMessage> chatMessageFromJson(String str) => List<ChatMessage>.from(
    json.decode(str).map((x) => ChatMessage.fromJson(x)));

String chatMessageToJson(List<ChatMessage> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

ChatMessage sendMessageModelFromJson(String str) =>
    ChatMessage.fromJson(json.decode(str));

String sendMessageModelToJson(ChatMessage data) => json.encode(data.toJson());

String convertChatMessagesJsonFromString(String? str) =>
    (str == null || str.isEmpty)
        ? ""
        : chatMessageToJson(chatMessageFromJson(str));

String convertChatMessageJsonFromString(String? str) =>
    (str == null || str.isEmpty)
        ? ""
        : sendMessageModelToJson(sendMessageModelFromJson(str));

class ChatMessage {
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
    this.metaData = const [],
    required this.replyParentChatMessage, //
    required this.senderNickName,
    required this.senderUserJid,
    required this.senderUserName,
    required this.contactChatMessage, //
    required this.mediaChatMessage, //
    required this.locationChatMessage, //
    required this.topicId, //
  });

  String chatUserJid;
  String? contactType;
  bool? isItCarbonMessage;
  bool? isItSavedContact;
  bool isMessageDeleted;
  bool isMessageRecalled;
  bool isMessageSentByMe;
  bool isMessageStarred;
  bool isSelected;
  bool isThisAReplyMessage;
  String messageChatType;
  Map<String, dynamic> messageCustomField;
  String messageId;
  dynamic messageSentTime;
  String messageStatus;
  bool isMessageEdited;
  String? messageTextContent;
  String messageType;
  List<MessageMetaData>? metaData;
  ReplyParentChatMessage? replyParentChatMessage;
  String senderNickName;
  String senderUserJid;
  String senderUserName;
  ContactChatMessage? contactChatMessage;
  MediaChatMessage? mediaChatMessage;
  LocationChatMessage? locationChatMessage;
  String? topicId;

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
      metaData: json["metaData"] == null
          ? []
          : List<MessageMetaData>.from(
              json["metaData"].map((x) => MessageMetaData.fromJson(x))),
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
        "metaData": metaData == null
            ? null
            : List<dynamic>.from(metaData!.map((x) => x.toJson())),
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

class ContactChatMessage {
  ContactChatMessage({
    required this.contactName,
    required this.contactPhoneNumbers,
    required this.isChatAppUser,
    required this.messageId,
  });

  String contactName;
  List<String> contactPhoneNumbers;
  List<bool> isChatAppUser;
  String messageId;

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

  Map<String, dynamic> toJson() => {
        "contactName": contactName,
        "contactPhoneNumbers":
            List<dynamic>.from(contactPhoneNumbers.map((x) => x)),
        "isChatAppUser": List<dynamic>.from(isChatAppUser.map((x) => x)),
        "messageId": messageId,
      };
}

class LocationChatMessage {
  LocationChatMessage({
    required this.latitude,
    required this.longitude,
    required this.mapLocationUrl,
    required this.messageId,
  });

  double latitude;
  double longitude;
  String mapLocationUrl;
  String messageId;

  factory LocationChatMessage.fromJson(Map<String, dynamic> json) =>
      LocationChatMessage(
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        mapLocationUrl: json["mapLocationUrl"],
        messageId: json["messageId"],
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
        "mapLocationUrl": mapLocationUrl,
        "messageId": messageId,
      };
}

class MediaChatMessage {
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

  bool isAudioRecorded;
  String mediaCaptionText;
  int mediaDownloadStatus;
  int mediaDuration;
  String mediaFileName;
  int mediaFileSize;
  String mediaLocalStoragePath;
  int mediaProgressStatus;
  String mediaThumbImage;
  int mediaUploadStatus;
  String messageId;
  String messageType;

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

class MessageCustomField {
  MessageCustomField();

  factory MessageCustomField.fromJson(Map<String, dynamic> json) =>
      MessageCustomField();

  Map<String, dynamic> toJson() => {};
}

class MessageStatus {
  MessageStatus({
    required this.status,
  });

  String status;

  factory MessageStatus.fromJson(Map<String, dynamic> json) => MessageStatus(
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
      };
}

class ReplyParentChatMessage {
  ReplyParentChatMessage({
    required this.chatUserJid,
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
  });

  String chatUserJid;
  bool isMessageDeleted;
  bool isMessageRecalled;
  bool isMessageSentByMe;
  bool isMessageStarred;
  String messageId;
  int messageSentTime;
  String? messageTextContent;
  String messageType;
  String senderNickName;
  String senderUserName;
  LocationChatMessage? locationChatMessage;
  ContactChatMessage? contactChatMessage;
  MediaChatMessage? mediaChatMessage;

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
      );

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
      };
}

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

String getMessageType(dynamic type) {
  if (type == null) {
    return "";
  }
  return type.toString().toUpperCase() == "FILE"
      ? "DOCUMENT"
      : type.toString().toUpperCase();
}

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

String getMediaMessageType(String type) {
  return type.toString().toUpperCase() == "FILE"
      ? "DOCUMENT"
      : type.toString().toUpperCase();
}

String getReplyMessageType(dynamic json) {
  if (Platform.isAndroid) {
    return json["messageType"].toString().toUpperCase();
  } else {
    if (json["messageTextContent"].toString().isNotEmpty) {
      return "TEXT";
    } else if (json["mediaChatMessage"] != null &&
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
    } else {
      return "";
    }
  }
}

abstract class MMessageStatus {
  final String status;

  const MMessageStatus._(this.status); // Private constructor

  static const MMessageStatus sent = _Sent(); // Instances of subclasses
  static const MMessageStatus acknowledged = _Acknowledged();
  static const MMessageStatus delivered = _Delivered();
  static const MMessageStatus seen = _Seen();
  static const MMessageStatus received = _Received();
}

class _Sent extends MMessageStatus {
  const _Sent() : super._("N");
}

class _Acknowledged extends MMessageStatus {
  const _Acknowledged() : super._("A");
}

class _Delivered extends MMessageStatus {
  const _Delivered() : super._("D");
}

class _Seen extends MMessageStatus {
  const _Seen() : super._("S");
}

class _Received extends MMessageStatus {
  const _Received() : super._("R");
}
