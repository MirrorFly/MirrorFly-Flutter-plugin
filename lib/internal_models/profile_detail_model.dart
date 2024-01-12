// To parse this JSON data, do
//
//     final member = memberFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

List<ProfileDetails> profileDetailsFromJson(String str) =>
    List<ProfileDetails>.from(json.decode(str).map((x) => ProfileDetails.fromJson(x)));

String profileDetailsToJson(List<ProfileDetails> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
String convertProfileDetailsJsonFromString(String? str) => (str == null || str.isEmpty) ? "" : profileDetailsToJson(profileDetailsFromJson(str));

ProfileDetails profileDetailFromJson(String str) =>ProfileDetails.fromJson(json.decode(str));

String profileDetailToJson(ProfileDetails data) => json.encode(data.toJson());

String convertProfileDetailJsonFromString(String? str) => (str == null || str.isEmpty) ? "" : profileDetailToJson(profileDetailFromJson(str));

class ProfileDetails {
  ProfileDetails({
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

  factory ProfileDetails.fromJson(Map<String, dynamic> json) => ProfileDetails(
        contactType: json["contactType"] == "unknown"
            ? "unknown_contact"
            : json["contactType"] == "live"
                ? "live_contact"
                : json["contactType"] == "local"
                    ? "local_contact"
                    : json["contactType"] == "deleted"
                        ? "deleted_contact"
                        : json["contactType"],
        email: json["email"],
        groupCreatedTime: json["groupCreatedTime"].toString(),
        image: json["image"],
        imagePrivacyFlag: json["imagePrivacyFlag"].toString(),
        isAdminBlocked:
            Platform.isIOS ? json["isBlockedByAdmin"] : json["isAdminBlocked"],
        isBlocked: json["isBlocked"],
        isBlockedMe: json["isBlockedMe"],
        isGroupAdmin: json["isGroupAdmin"],
        isGroupInOfflineMode: json["isGroupInOfflineMode"],
        isGroupProfile: Platform.isIOS
            ? json["profileChatType"].toString().toLowerCase() == "singlechat"
                ? false
                : true
            : json["isGroupProfile"],
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
