// To parse this JSON data, do
//
//     final recentChat = recentChatFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

RecentChat recentChatFromJson(String str) =>
    RecentChat.fromJson(json.decode(str));
RecentChatData recentChatDataFromJson(String str) =>
    RecentChatData.fromJson(json.decode(str));

String recentChatToJson(RecentChat data) => json.encode(data.toJson());
String? convertRecentChatJsonFromString(String str) => str.isEmpty ? null : json.encode(recentChatFromJson(str).toJson());

class RecentChat {
  RecentChat({
    this.data,
  });

  List<RecentChatData>? data;

  factory RecentChat.fromJson(Map<String, dynamic> json) => RecentChat(
        data: json["data"] == null
            ? null
            : List<RecentChatData>.from(
                json["data"].map((x) => RecentChatData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class RecentChatData {
  RecentChatData({
    this.contactType,
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
  });

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
  dynamic lastMessageTime;
  String? lastMessageType;
  String? nickName;
  String? profileImage;
  String? profileName;
  dynamic unreadMessageCount;
  String? topicId;

  factory RecentChatData.fromJson(Map<String, dynamic> json) => RecentChatData(
        contactType: getContactType(json),
        isAdminBlocked: Platform.isAndroid ? json["isAdminBlocked"] : json["isBlockedByAdmin"] ,
        isBlocked: json["isBlocked"],
        isBlockedMe: json["isBlockedMe"],
        isBroadCast: json["isBroadCast"],
        isChatArchived: json["isChatArchived"],
        isPrivateChat: Platform.isAndroid ? json["isChatLocked"] : json["isPrivateChat"],
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
        lastMessageType: json["lastMessageType"],
        nickName: json["nickName"],
        profileImage: json["profileImage"],
        profileName: json["profileName"],
        unreadMessageCount: json["unreadMessageCount"],
        topicId: Platform.isAndroid ? json["topicId"] : json["topicID"],
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

String getContactType(Map<String, dynamic> json){
  if(Platform.isAndroid){
    switch(json["contactType"]){
      case "unknown" : return "unknown_contact";
      case "live" : return "live_contact";
      case "local" : return "local_contact";
      case "deleted" : return "deleted_contact";
      default : return json["contactType"];
    }
  }else{
    if(json["isItSavedContact"]==true){
      return "live_contact";
    }else if(json["isDeletedUser"]){
      return "deleted_contact";
    }else if(json["isGroup"]==false){
      return "unknown_contact";
    }else{
      return "";
    }
  }
}

String? getLastMessageStatus(dynamic status){
  if(Platform.isAndroid) {
    return status;
  }else {
    switch (status) {
      case 2 :
        return "A"; //acknowledge
      case 3 :
        return "D"; //delivered
      case 4 :
        return "S"; //seen
      case 5 :
        return "R"; //received
      default :
        return "N"; //"N" for "notAcknowledged" in iOS,
    }
  }
}