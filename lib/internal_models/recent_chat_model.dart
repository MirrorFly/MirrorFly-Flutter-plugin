// To parse this JSON data, do
//
//     final recentChat = recentChatFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

import 'package:mirrorfly_plugin/message_params.dart' show MessageMetaData;
/// Converts a JSON string into a [RecentChat] object.
///
/// This function decodes the provided JSON string into a map and then uses the [RecentChat.fromJson]
/// constructor to create a [RecentChat] object.
///
/// Parameters:
///   [str] - A JSON string representing a single recent chat.
///
/// Returns:
///   A [RecentChat] object.
RecentChat recentChatFromJson(String str) =>
    RecentChat.fromJson(json.decode(str));

/// Converts a [RecentChat] object into a JSON string.
///
/// This function takes a [RecentChat] object, converts it to a map using the [toJson] method,
/// and then encodes the map as a JSON string.
///
/// Parameters:
///   [data] - A [RecentChat] object.
///
/// Returns:
///   A JSON string representing the recent chat.
String recentChatToJson(RecentChat data) => json.encode(data.toJson());

/// Converts a JSON string into a JSON string representing a [RecentChat] object.
///
/// This function checks if the provided string is null or empty. If it is, it returns an empty string.
/// Otherwise, it converts the string into a [RecentChat] object using [recentChatFromJson],
/// and then back into a JSON string using [recentChatToJson].
///
/// Parameters:
///   [str] - A JSON string or null.
///
/// Returns:
///   A JSON string representing a [RecentChat] object, or an empty string if the input is null or empty.
String convertRecentChatFromJson(String? str) => (str == null || str.isEmpty)
    ? ""
    : recentChatToJson(recentChatFromJson(str));

/// Converts a JSON string into a [RecentChatData] object.
///
/// This function decodes the provided JSON string into a map and then uses the [RecentChatData.fromJson]
/// constructor to create a [RecentChatData] object.
///
/// Parameters:
///   [str] - A JSON string representing recent chat data.
///
/// Returns:
///   A [RecentChatData] object.
RecentChatData recentChatDataFromJson(String str) =>
    RecentChatData.fromJson(json.decode(str));

/// Converts a [RecentChatData] object into a JSON string.
///
/// This function takes a [RecentChatData] object, converts it to a map using the [toJson] method,
/// and then encodes the map as a JSON string.
///
/// Parameters:
///   [str] - A [RecentChatData] object.
///
/// Returns:
///   A JSON string representing the recent chat data.
String recentChatDataToJson(RecentChatData str) => json.encode(str.toJson());

/// Converts a JSON string into a list of [RecentChat] objects.
///
/// This function decodes the provided JSON string into a list of maps, and then maps each one to a
/// [RecentChat] object using the [RecentChat.fromJson] constructor.
///
/// Parameters:
///   [str] - A JSON string representing a list of recent chats.
///
/// Returns:
///   A list of [RecentChat] objects.
List<RecentChat> recentChatListFromJson(String str) =>
    List<RecentChat>.from(json.decode(str).map((x) => RecentChat.fromJson(x)));

/// Converts a list of [RecentChat] objects into a JSON string.
///
/// This function takes a list of [RecentChat] objects, converts each object to a map using the [toJson] method,
/// and then encodes the list of maps as a JSON string.
///
/// Parameters:
///   [data] - A list of [RecentChat] objects.
///
/// Returns:
///   A JSON string representing the list of recent chats.
String recentChatListToJson(List<RecentChat> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

/// Converts a JSON string into a JSON string representing a list of [RecentChat] objects.
///
/// This function checks if the provided string is null or empty. If it is, it returns an empty string.
/// Otherwise, it converts the string into a list of [RecentChat] objects using [recentChatListFromJson],
/// and then back into a JSON string using [recentChatListToJson].
///
/// Parameters:
///   [str] - A JSON string or null.
///
/// Returns:
///   A JSON string representing a list of [RecentChat] objects, or an empty string if the input is null or empty.
String convertRecentChatListFromJson(String? str) =>
    (str == null || str.isEmpty)
        ? ""
        : recentChatListToJson(recentChatListFromJson(str));

/// Converts a JSON string into a JSON string representing a list of [RecentChatData] objects.
///
/// This function checks if the provided string is null or empty. If it is, it returns an empty string.
/// Otherwise, it converts the string into a [RecentChatData] object using [recentChatDataFromJson],
/// and then back into a JSON string using [recentChatDataToJson].
///
/// Parameters:
///  [str] - A JSON string or null.
///
/// Returns:
/// A JSON string representing a list of [RecentChatData] objects, or an empty string if the input is null or empty.
String convertRecentChatDataJsonFromString(String? str) =>
    (str == null || str.isEmpty)
        ? ""
        : recentChatDataToJson(recentChatDataFromJson(str));

/// A class that represents the recent chat data.
class RecentChatData {
  /// Constructs a RecentChatData object with the provided parameters.
  RecentChatData({
    this.data,
  });

  /// A list of recent chats.
  List<RecentChat>? data;

  /// Creates a RecentChatData object from a JSON map.
  ///
  /// The [json] parameter should be a map containing the JSON data.
  ///
  /// Returns a [RecentChatData] object.
  factory RecentChatData.fromJson(Map<String, dynamic> json) => RecentChatData(
    data: json["data"] == null
        ? null
        : List<RecentChat>.from(
        json["data"].map((x) => RecentChat.fromJson(x))),
  );

  /// Converts the RecentChatData object to a JSON map.
  ///
  /// Returns a [Map<String, dynamic>] representing the JSON data.
  Map<String, dynamic> toJson() => {
    "data": data == null
        ? null
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

/// A class that represents a recent chat.
class RecentChat {
  /// Constructs a RecentChat object with the provided parameters.
  RecentChat(
      {this.contactType,
      this.isAdminBlocked,
      this.isBlocked,
      this.isBlockedMe,
      this.isBroadCast,
      this.isChatArchived,
      this.isPrivateChat,
      this.isChatPinned,
      this.isConversationUnRead, //// need to check
      this.isGroup,
      this.isGroupInOfflineMode,
      this.isItSavedContact,
      this.isLastMessageRecalledByUser,
      this.isLastMessageSentByMe,
      this.isMuted,
      this.isSelected,
      this.jid,
      this.lastMessageContent,
      this.lastMessageId,
      this.lastMessageStatus,
      this.lastMessageTime,
      this.lastMessageType,
      this.nickName,
      this.profileImage,
      this.profileName,
      this.unreadMessageCount,
      this.topicId,
      this.metaData});

  /// The type of contact.
  String? contactType;

  /// Whether the user is blocked by the admin.
  bool? isAdminBlocked;

  /// Whether the user is blocked.
  bool? isBlocked;

  /// Whether the user has blocked the current user.
  bool? isBlockedMe;

  /// Whether the chat is a broadcast.
  bool? isBroadCast;

  /// Whether the chat is archived.
  bool? isChatArchived;

  /// Whether the chat is private.
  bool? isPrivateChat;

  /// Whether the chat is pinned.
  bool? isChatPinned;

  /// Whether the conversation is unread.
  bool? isConversationUnRead;

  /// Whether the chat is a group.
  bool? isGroup;

  /// Whether the group is in offline mode.
  bool? isGroupInOfflineMode;

  /// Whether the contact is saved.
  bool? isItSavedContact;

  /// Whether the last message was recalled by the user.
  bool? isLastMessageRecalledByUser;

  /// Whether the last message was sent by the user.
  bool? isLastMessageSentByMe;

  /// Whether the chat is muted.
  bool? isMuted;

  /// Whether the chat is selected.
  bool? isSelected;

  /// The JID of the contact.
  String? jid;

  /// The content of the last message.
  String? lastMessageContent;

  /// The ID of the last message.
  String? lastMessageId;

  /// The status of the last message.
  String? lastMessageStatus;

  /// The time of the last message.
  dynamic lastMessageTime;

  /// The type of the last message.
  String? lastMessageType;

  /// The nickname of the contact.
  String? nickName;

  /// The profile image of the contact.
  String? profileImage;

  /// The profile name of the contact.
  String? profileName;

  /// The number of unread messages.
  dynamic unreadMessageCount;

  /// The topic ID.
  String? topicId;

  /// The metadata of the message.
  List<MessageMetaData>? metaData;

  /// Creates a RecentChat object from a JSON map.
  factory RecentChat.fromJson(Map<String, dynamic> json) => RecentChat(
        contactType: getContactType(json),
        isAdminBlocked: Platform.isAndroid
            ? json["isAdminBlocked"]
            : json["isBlockedByAdmin"],
        isBlocked: json["isBlocked"],
        isBlockedMe: json["isBlockedMe"],
        isBroadCast: json["isBroadCast"],
        isChatArchived: json["isChatArchived"],
        isPrivateChat:
            Platform.isAndroid ? json["isChatLocked"] : json["isPrivateChat"],
        isChatPinned: json["isChatPinned"],
        isConversationUnRead: json["isConversationUnRead"],
        isGroup: json["isGroup"],
        isGroupInOfflineMode: json["isGroupInOfflineMode"],
        isItSavedContact: json["isItSavedContact"],
        isLastMessageRecalledByUser: json["isLastMessageRecalledByUser"],
        isLastMessageSentByMe: json["isLastMessageSentByMe"],
        isMuted: json["isMuted"],
        isSelected: json["isSelected"],
        jid: json["jid"],
        lastMessageContent: json["lastMessageContent"],
        lastMessageId: json["lastMessageId"],
        lastMessageStatus: getLastMessageStatus(json["lastMessageStatus"]),
        lastMessageTime: json["lastMessageTime"].toInt().toString().length == 13
            ? json["lastMessageTime"] * 1000
            : json["lastMessageTime"],
        lastMessageType: getMessageType(json["lastMessageType"]),
        nickName: json["nickName"],
        profileImage: json["profileImage"],
        profileName: json["profileName"],
        unreadMessageCount: json["unreadMessageCount"],
        topicId: Platform.isAndroid ? json["topicId"] : json["topicID"],
        metaData: json["metaData"] == null
            ? []
            : List<MessageMetaData>.from(
                json["metaData"].map((x) => MessageMetaData.fromJson(x))),
      );

  /// Converts the RecentChat object to a JSON map.
  Map<String, dynamic> toJson() => {
        "contactType": contactType,
        "isAdminBlocked": isAdminBlocked,
        "isBlocked": isBlocked,
        "isBlockedMe": isBlockedMe,
        "isBroadCast": isBroadCast,
        "isChatArchived": isChatArchived,
        "isPrivateChat": isPrivateChat,
        "isChatPinned": isChatPinned,
        "isConversationUnRead": isConversationUnRead,
        "isGroup": isGroup,
        "isGroupInOfflineMode": isGroupInOfflineMode,
        "isItSavedContact": isItSavedContact,
        "isLastMessageRecalledByUser": isLastMessageRecalledByUser,
        "isLastMessageSentByMe": isLastMessageSentByMe,
        "isMuted": isMuted,
        "isSelected": isSelected,
        "jid": jid,
        "lastMessageContent": lastMessageContent,
        "lastMessageId": lastMessageId,
        "lastMessageStatus": lastMessageStatus,
        "lastMessageTime": lastMessageTime,
        "lastMessageType": lastMessageType,
        "nickName": nickName,
        "profileImage": profileImage,
        "profileName": profileName,
        "unreadMessageCount": unreadMessageCount,
        "topicId": topicId,
        "metaData": metaData == null
            ? null
            : List<dynamic>.from(metaData!.map((x) => x.toJson())),
      };
}

/// A function that returns the contact type.
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
    if (json["isItSavedContact"] == true) {
      return "live_contact";
    } else if (json["isDeletedUser"]) {
      return "deleted_contact";
    } else if (json["isGroup"] == false) {
      return "unknown_contact";
    } else {
      return "";
    }
  }
}

/// A function that returns the status of the last message.
String? getLastMessageStatus(dynamic status) {
  if (status == null) {
    return null;
  }
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

/// A function that returns the type of the last message.
String? getMessageType(dynamic type) {
  if (type == null) {
    return null;
  }
  return type.toString().toUpperCase() == "FILE"
      ? "DOCUMENT"
      : type.toString().toUpperCase();
}
