// To parse this JSON data, do
//
//     final messageDelivered = messageDeliveredFromJson(jsonString);

import 'dart:convert';



List<MessageDeliveredStatus> messageDeliveredStatusFromJson(String str) => List<MessageDeliveredStatus>.from(json.decode(str).map((x) => MessageDeliveredStatus.fromJson(x)));

String messageDeliveredStatusToJson(List<MessageDeliveredStatus> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MessageDeliveredStatus {
  MessageDeliveredStatus({
    this.memberProfileDetails,
    this.messageId,
    this.status,
    this.time,
    this.userJid,
  });

  MemberProfileDetails? memberProfileDetails;
  String? messageId;
  Status? status;
  String? time;
  String? userJid;

  factory MessageDeliveredStatus.fromJson(Map<String, dynamic> json) => MessageDeliveredStatus(
    memberProfileDetails: json["memberProfileDetails"] ?? MemberProfileDetails.fromJson(json["memberProfileDetails"]),
    messageId: json["messageId"] ?? json["messageId"],
    status: json["status"] ?? Status.fromJson(json["status"]),
    time: json["time"] ?? json["time"],
    userJid: json["userJid"] ?? json["userJid"],
  );

  Map<String, dynamic> toJson() => {
    "memberProfileDetails": memberProfileDetails ?? memberProfileDetails?.toJson(),
    "messageId": messageId ?? messageId,
    "status": status ?? status?.toJson(),
    "time": time ?? time,
    "userJid": userJid ?? userJid,
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

  factory MemberProfileDetails.fromJson(Map<String, dynamic> json) => MemberProfileDetails(
    contactType: json["contactType"],
    email: json["email"],
    groupCreatedTime: json["groupCreatedTime"],
    image: json["image"],
    imagePrivacyFlag: json["imagePrivacyFlag"],
    isAdminBlocked: json["isAdminBlocked"],
    isBlocked: json["isBlocked"],
    isBlockedMe: json["isBlockedMe"],
    isGroupAdmin: json["isGroupAdmin"],
    isGroupInOfflineMode: json["isGroupInOfflineMode"],
    isGroupProfile: json["isGroupProfile"],
    isItSavedContact: json["isItSavedContact"],
    isMuted: json["isMuted"],
    isSelected: json["isSelected"],
    jid: json["jid"],
    lastSeenPrivacyFlag: json["lastSeenPrivacyFlag"],
    mobileNUmberPrivacyFlag: json["mobileNUmberPrivacyFlag"],
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


class Status {
  Status({
    required this.status,
  });

  String status;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
  };
}
