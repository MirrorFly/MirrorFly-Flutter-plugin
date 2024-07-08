// To parse this JSON data, do
//
//     final recentChat = recentChatFromJson(jsonString);

import 'dart:convert';

import 'package:mirrorfly_plugin/message_params.dart' show MessageMetaData;

/// Converts a JSON string into a [RecentChat] object.
///
/// This function decodes the given JSON string and uses the [fromJson] constructor
/// of the [RecentChat] class to create an instance.
///
/// Parameters:
///   [str] - A JSON string representation of a [RecentChat] object.
///
/// Returns:
///   An instance of [RecentChat] populated with data from the given JSON string.
RecentChat recentChatFromJson(String str) =>
    RecentChat.fromJson(json.decode(str));

/// Converts a JSON string into a [RecentChatData] object.
///
/// This function decodes the given JSON string and uses the [fromJson] constructor
/// of the [RecentChatData] class to create an instance.
///
/// Parameters:
///   [str] - A JSON string representation of a [RecentChatData] object.
///
/// Returns:
///   An instance of [RecentChatData] populated with data from the given JSON string.
RecentChatData recentChatDataFromJson(String str) =>
    RecentChatData.fromJson(json.decode(str));

/// Converts a JSON string into a list of [RecentChatData] objects.
///
/// This function decodes the given JSON string and uses the [fromJson] constructor
/// of the [RecentChatData] class to create a list of instances.
///
/// Parameters:
///   [str] - A JSON string representation of a list of [RecentChatData] objects.
///
/// Returns:
///   A list of [RecentChatData] instances populated with data from the given JSON string.
List<RecentChatData> recentChatDataListFromJson(String str) =>
    List<RecentChatData>.from(
        json.decode(str).map((x) => RecentChatData.fromJson(x)));

/// Converts a [RecentChat] object into a JSON string.
///
/// This function takes a [RecentChat] object, converts it into a map
/// using the [toJson] method, and then encodes this map as a JSON string.
///
/// Parameters:
///   [data] - The [RecentChat] object to be converted into a JSON string.
///
/// Returns:
///   A JSON string representation of the [RecentChat] object.
String recentChatToJson(RecentChat data) => json.encode(data.toJson());

/// Represents the recent chat data.
class RecentChat {

  /// Initializes a new instance of the [RecentChat] class.
  List<RecentChatData>? data;

  /// Converts a JSON object into a [RecentChat] instance.
  RecentChat({
    this.data,
  });

  /// Converts a [RecentChat] instance into a JSON object.
  factory RecentChat.fromJson(Map<String, dynamic> json) => RecentChat(
        data: json["data"] == null
            ? []
            : List<RecentChatData>.from(
                json["data"]!.map((x) => RecentChatData.fromJson(x))),
      );

  /// Converts a [RecentChat] instance into a JSON object.
  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

/// Represents the recent chat data.
class RecentChatData {

  /// The type of contact.
  String? contactType;

  /// Indicates whether the user is blocked by the admin.
  bool? isAdminBlocked;

  /// Indicates whether the user is blocked.
  bool? isBlocked;

  /// Indicates whether the user has blocked the current user.
  bool? isBlockedMe;

  /// Indicates whether the chat is a broadcast.
  bool? isBroadCast;

  /// Indicates whether the chat is archived.
  bool? isChatArchived;

  /// Indicates whether the chat is private.
  bool? isPrivateChat;

  /// Indicates whether the chat is pinned.
  bool? isChatPinned;

  /// Indicates whether the conversation is unread.
  bool? isConversationUnRead;

  /// Indicates whether the chat is a group.
  bool? isGroup;

  /// Indicates whether the group is in offline mode.
  bool? isGroupInOfflineMode;

  /// Indicates whether the contact is saved.
  bool? isItSavedContact;

  /// Indicates whether the last message was recalled by the user.
  bool? isLastMessageRecalledByUser;

  /// Indicates whether the last message was sent by the current user.
  bool? isLastMessageSentByMe;

  /// Indicates whether the chat is muted.
  bool? isMuted;

  /// Indicates whether the chat is selected.
  bool? isSelected;

  /// The unique identifier of the chat.
  String? jid;

  /// The content of the last message.
  String? lastMessageContent;

  /// The unique identifier of the last message.
  String? lastMessageId;

  /// The status of the last message.
  String? lastMessageStatus;

  /// The time when the last message was sent.
  int? lastMessageTime;

  /// The type of the last message.
  String? lastMessageType;

  /// The nickname of the user.
  String? nickName;

  /// The profile image of the user.
  String? profileImage;

  /// The profile name of the user.
  String? profileName;

  /// The number of unread messages.
  int? unreadMessageCount;

  /// The unique identifier of the topic.
  String? topicId;

  /// The metadata of the chat.
  List<MessageMetaData>? metaData;

  /// Initializes a new instance of the [RecentChatData] class.
  RecentChatData(
      {this.contactType,
      this.isAdminBlocked,
      this.isBlocked,
      this.isBlockedMe,
      this.isBroadCast,
      this.isChatArchived,
      this.isPrivateChat,
      this.isChatPinned,
      this.isConversationUnRead,
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

  /// Converts a JSON object into a [RecentChatData] instance.
  factory RecentChatData.fromJson(Map<String, dynamic> json) => RecentChatData(
        contactType: json["contactType"],
        isAdminBlocked: json["isAdminBlocked"],
        isBlocked: json["isBlocked"],
        isBlockedMe: json["isBlockedMe"],
        isBroadCast: json["isBroadCast"],
        isChatArchived: json["isChatArchived"],
        isPrivateChat: json["isPrivateChat"],
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
        lastMessageStatus: json["lastMessageStatus"],
        lastMessageTime: json["lastMessageTime"],
        lastMessageType: json["lastMessageType"],
        nickName: json["nickName"],
        profileImage: json["profileImage"],
        profileName: json["profileName"],
        unreadMessageCount: json["unreadMessageCount"],
        topicId: json["topicId"],
        metaData: json["metaData"] == null
            ? []
            : List<MessageMetaData>.from(
                json["metaData"].map((x) => MessageMetaData.fromJson(x))),
      );

  /// Converts a [RecentChatData] instance into a JSON object.
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
