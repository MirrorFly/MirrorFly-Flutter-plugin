// To parse this JSON data, do
//
//     final profileData = profileDataFromJson(jsonString);

import 'dart:convert';

/// Converts a JSON string into a [ProfileModel] object.
///
/// This function decodes the given JSON string and uses the [fromJson] constructor
/// of the [ProfileModel] class to create an instance.
///
/// Parameters:
///   [str] - A JSON string representation of a [ProfileModel] object.
///
/// Returns:
///   An instance of [ProfileModel] populated with data from the given JSON string.

ProfileModel profileDataFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

/// Converts a JSON string into a [ProfileData] object.
///
/// This function decodes the given JSON string and uses the [fromJson] constructor
/// of the [ProfileData] class to create an instance.
///
/// Parameters:
///   [str] - A JSON string representation of a [ProfileData] object.
///
/// Returns:
///   An instance of [ProfileData] populated with data from the given JSON string.
ProfileData profileData(String str) => ProfileData.fromJson(json.decode(str));

/// Converts a [ProfileModel] object into a JSON string.
///
/// This function takes a [ProfileModel] object, converts it into a map
/// using the [toJson] method, and then encodes this map as a JSON string.
///
/// Parameters:
///   [data] - The [ProfileModel] object to be converted into a JSON string.
///
/// Returns:
///   A JSON string representation of the [ProfileModel] object.
String profileDataToJson(ProfileModel data) => json.encode(data.toJson());

/// Represents the profile data.
class ProfileModel {

  /// Initializes a new instance of the [ProfileModel] class.
  ProfileModel({
    this.data,
    this.status,
  });

  /// The profile data.
  ProfileData? data;

  /// The status of the profile.
  bool? status;

  /// Converts a JSON object into a [ProfileModel] instance.
  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        data: json["data"] == null ? null : ProfileData.fromJson(json["data"]),
        status: json["status"],
      );

  /// Converts a [ProfileModel] instance into a JSON object.
  Map<String, dynamic> toJson() => {
        "data": data ?? data?.toJson(),
        "status": status,
      };
}

/// Represents the profile data.
class ProfileData {

  /// Initializes a new instance of the [ProfileData] class.
  ProfileData({
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

  /// The email address of the user.
  String? email;

  /// The image of the user.
  String? image;

  /// Indicates if the user is an admin.
  bool? isAdminBlocked;

  /// Indicates if the user is blocked.
  bool? isBlocked;

  /// Indicates if the user has blocked the current user.
  bool? isBlockedMe;

  /// Indicates if the user is a group admin.
  bool? isGroupAdmin;

  /// Indicates if the group is in offline mode.
  bool? isGroupInOfflineMode;

  /// Indicates if the profile is a group profile.
  bool? isGroupProfile;

  /// Indicates if the contact is saved.
  bool? isItSavedContact;

  /// Indicates if the user is muted.
  bool? isMuted;

  /// Indicates if the user is selected.
  bool? isSelected;

  /// The JID (Jabber ID) of the user.
  String? jid;

  /// The mobile number of the user.
  String? mobileNumber;

  /// The name of the user.
  String? name;

  /// The nickname of the user.
  String? nickName;

  /// The status of the user.
  String? status;

  /// The thumbnail image of the user.
  String? thumbImage;

  /// Converts a JSON object into a [ProfileData] instance.
  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
        email: json["email"],
        image: json["image"],
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
        mobileNumber: json["mobileNumber"],
        name: json["name"],
        nickName: json["nickName"],
        status: json["status"],
        thumbImage: json["thumbImage"],
      );

  /// Converts a [ProfileData] instance into a JSON object.
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
