// To parse this JSON data, do
//
//     final profileData = profileDataFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

ProfileModel profileDataFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileDataToJson(ProfileModel data) => json.encode(data.toJson());

String convertProfileJsonFromString(String? str) =>
    (str == null || str.isEmpty) ? "" : json.encode(profileDataFromJson(str).toJson());

class ProfileModel {
  ProfileModel({
    this.data,
    this.status,
  });

  Profile? data;
  bool? status;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        data: json["data"] == null ? null : Profile.fromJson(json["data"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": data ?? data?.toJson(),
        "status": status,
      };
}

class Profile {
  Profile({
    this.email,
    this.image,
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
    this.mobileNumber,
    this.name,
    this.nickName,
    this.status,
    this.thumbImage,
  });

  String? email;
  String? image;
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
  String? mobileNumber;
  String? name;
  String? nickName;
  String? status;
  String? thumbImage;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        email: json["email"],
        image: json["image"],
        isAdminBlocked: Platform.isAndroid ? json["isAdminBlocked"] : json["isBlockedByAdmin"],
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
        mobileNumber: json["mobileNumber"],
        name: json["name"],
        nickName: json["nickName"],
        status: json["status"],
        thumbImage: json["thumbImage"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "image": image,
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
        "mobileNumber": mobileNumber,
        "name": name,
        "nickName": nickName,
        "status": status,
        "thumbImage": thumbImage,
      };
}
