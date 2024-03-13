// To parse this JSON data, do
//
//     final recentChat = recentChatFromJson(jsonString);

import 'dart:convert';

RecentChat recentChatFromJson(String str) =>
    RecentChat.fromJson(json.decode(str));

RecentChatData recentChatDataFromJson(String str) =>
    RecentChatData.fromJson(json.decode(str));

List<RecentChatData> recentChatDataListFromJson(String str) =>
    List<RecentChatData>.from(
        json.decode(str).map((x) => RecentChatData.fromJson(x)));

String recentChatToJson(RecentChat data) => json.encode(data.toJson());

class RecentChat {
  List<RecentChatData>? data;

  RecentChat({
    this.data,
  });

  factory RecentChat.fromJson(Map<String, dynamic> json) => RecentChat(
        data: json["data"] == null
            ? []
            : List<RecentChatData>.from(
                json["data"]!.map((x) => RecentChatData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class RecentChatData {
  String? contactType;
  bool? isAdminBlocked;
  bool? isBlocked;
  bool? isBlockedMe;
  bool? isBroadCast;
  bool? isChatArchived;
  bool? isPrivateChat;
  bool? isChatPinned;
  bool? isConversationUnRead;
  bool? isGroup;
  bool? isGroupInOfflineMode;
  bool? isItSavedContact;
  bool? isLastMessageRecalledByUser;
  bool? isLastMessageSentByMe;
  bool? isMuted;
  bool? isSelected;
  String? jid;
  String? lastMessageContent;
  String? lastMessageId;
  String? lastMessageStatus;
  int? lastMessageTime;
  String? lastMessageType;
  String? nickName;
  String? profileImage;
  String? profileName;
  int? unreadMessageCount;
  String? topicId;

  RecentChatData({
    this.contactType,
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
  });

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
      );

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
      };
}
