// To parse this JSON data, do
//
//     final messageDeliveredStatus = messageDeliveredStatusFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

import 'profile_detail_model.dart';

MessageStatusDetail messageDeliveredStatusFromJson(String str) =>
    MessageStatusDetail.fromJson(json.decode(str));

String messageDeliveredStatusToJson(MessageStatusDetail data) =>
    json.encode(data);

MessageStatusDetail messageReadStatusFromJson(String str) =>
    MessageStatusDetail.fromJson(json.decode(str));

MessageStatusDetail messageStatusDetailFromJson(String str) =>
    MessageStatusDetail.fromJson(json.decode(str));

String convertMessageDeliveredStatusToJson(String? str) =>
    (str == null || str.isEmpty)
        ? ""
        : messageDeliveredStatusToJson(messageDeliveredStatusFromJson(str));

class MessageStatusDetail {
  MessageStatusDetail({
    this.count,
    this.totalParticipantCount,
    required this.participantList,
  });

  String? count;
  int? totalParticipantCount;
  List<ParticipantList> participantList;

  factory MessageStatusDetail.fromJson(Map<String, dynamic> json) =>
      MessageStatusDetail(
        count: json["count"],
        totalParticipantCount: json["totalParticipantCount"],
        participantList: List<ParticipantList>.from(
            json["participantList"].map((x) => ParticipantList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "totalParticipantCount": totalParticipantCount,
        "participantList":
            List<dynamic>.from(participantList.map((x) => x.toJson())),
      };
}

class ParticipantList {
  ParticipantList({
    this.profileDetails,
    this.messageId,
    this.time,
  });

  ProfileDetails? profileDetails;
  String? messageId;
  String? time;

  factory ParticipantList.fromJson(Map<String, dynamic> json) =>
      ParticipantList(
        profileDetails: ProfileDetails.fromJson((Platform.isAndroid
            ? json["memberProfileDetails"]
            : json["profileDetails"])),
        messageId: json["messageId"],
        time: json["time"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "profileDetails": profileDetails?.toJson(),
        "messageId": messageId,
        "time": time,
      };
}

class MemberProfileDetails {
  MemberProfileDetails({
    this.contactType,
    this.email,
    this.groupCreatedTime,
    this.image,
    this.imagePrivacyFlag,
    this.isAdminBlocked,
    this.isBlocked,
    this.isBlockedMe,
    this.isGroupAdmin,
    this.isGroupInOfflineMode,
    this.isGroupProfile,
    this.isItSavedContact,
    this.isMuted,
    this.isSelected,
    this.jid,
    this.lastSeenPrivacyFlag,
    this.mobileNUmberPrivacyFlag,
    this.mobileNumber,
    this.name,
    this.nickName,
    this.status,
    this.thumbImage,
  });

  String? contactType;
  String? email;
  String? groupCreatedTime;
  String? image;
  String? imagePrivacyFlag;
  bool? isAdminBlocked;
  bool? isBlocked;
  bool? isBlockedMe;
  bool? isGroupAdmin;
  bool? isGroupInOfflineMode;
  bool? isGroupProfile;
  bool? isItSavedContact;
  bool? isMuted;
  bool? isSelected;
  String? jid;
  String? lastSeenPrivacyFlag;
  String? mobileNUmberPrivacyFlag;
  String? mobileNumber;
  String? name;
  String? nickName;
  String? status;
  String? thumbImage;

  factory MemberProfileDetails.fromJson(Map<String, dynamic> json) =>
      MemberProfileDetails(
        contactType: getContactType(json["contactType"].toString()),
        email: json["email"],
        groupCreatedTime: json["groupCreatedTime"].toString(),
        image: json["image"],
        imagePrivacyFlag: json["imagePrivacyFlag"].toString(),
        isAdminBlocked: Platform.isAndroid
            ? json["isAdminBlocked"]
            : json["isBlockedByAdmin"],
        isBlocked: json["isBlocked"],
        isBlockedMe: json["isBlockedMe"],
        isGroupAdmin: json["isGroupAdmin"],
        isGroupInOfflineMode: json["isGroupInOfflineMode"],
        isGroupProfile: Platform.isAndroid
            ? json["isGroupProfile"]
            : json["profileChatType"].toString().toLowerCase() == "singlechat"
                ? false
                : true,
        isItSavedContact: json["isItSavedContact"],
        isMuted: json["isMuted"],
        isSelected: json["isSelected"],
        jid: json["jid"],
        lastSeenPrivacyFlag: json["lastSeenPrivacyFlag"].toString(),
        mobileNUmberPrivacyFlag: json["mobileNUmberPrivacyFlag"].toString(),
        mobileNumber: json["mobileNumber"],
        name: json["name"],
        nickName: json["nickName"],
        status: json["status"],
        thumbImage: json["thumbImage"],
      );

  Map<String, dynamic> toJson() => {
        "contactType": contactType,
        "email": email,
        "groupCreatedTime": groupCreatedTime,
        "image": image,
        "imagePrivacyFlag": imagePrivacyFlag,
        "isAdminBlocked": isAdminBlocked,
        "isBlocked": isBlocked,
        "isBlockedMe": isBlockedMe,
        "isGroupAdmin": isGroupAdmin,
        "isGroupInOfflineMode": isGroupInOfflineMode,
        "isGroupProfile": isGroupProfile,
        "isItSavedContact": isItSavedContact,
        "isMuted": isMuted,
        "isSelected": isSelected,
        "jid": jid,
        "lastSeenPrivacyFlag": lastSeenPrivacyFlag,
        "mobileNUmberPrivacyFlag": mobileNUmberPrivacyFlag,
        "mobileNumber": mobileNumber,
        "name": name,
        "nickName": nickName,
        "status": status,
        "thumbImage": thumbImage,
      };
}

String getContactType(String contactType) {
  switch (contactType) {
    case "unknown":
      return "unknown_contact";
    case "live":
      return "live_contact";
    case "local":
      return "local_contact";
    case "deleted":
      return "deleted_contact";
    default:
      return contactType;
  }
}
