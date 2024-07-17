// To parse this JSON data, do
//
//     final profileData = profileDataFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

/// Converts a JSON string into a [ProfileModel] object.
///
/// This function decodes the provided JSON string into a map,
/// and then uses the [ProfileModel.fromJson] factory constructor to create a [ProfileModel] object.
///
/// [str]: The JSON string to be decoded.
///
/// Returns a [ProfileModel] object.
ProfileModel profileDataFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

/// Converts a [ProfileModel] object into a JSON string.
///
/// This function takes the provided [ProfileModel] object,
/// converts it to a JSON map using the [toJson] method, and then encodes the map as a JSON string.
///
/// [data]: The [ProfileModel] object to be converted.
///
/// Returns a JSON string representation of the [ProfileModel].
String profileDataToJson(ProfileModel data) => json.encode(data.toJson());

/// Converts a nullable JSON string into a non-nullable JSON string representing a [ProfileModel].
///
/// If the input string is null or empty, this function returns an empty string.
/// Otherwise, it decodes the string into a [ProfileModel] object using [profileDataFromJson],
/// and then serializes the object back into a JSON string using [profileDataToJson].
///
/// [str]: The nullable JSON string to convert.
///
/// Returns a non-nullable JSON string.
String convertProfileJsonFromString(String? str) => (str == null || str.isEmpty)
    ? ""
    : json.encode(profileDataFromJson(str).toJson());

/// Represents a profile model with user data.
class ProfileModel {
  /// Constructs an instance of [ProfileModel].
  ProfileModel({
    this.data,
    this.status,
  });

  /// The user data.
  Profile? data;

  /// The status of the user data.
  bool? status;

  /// Creates a [ProfileModel] object from a JSON map.
  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        data: json["data"] == null ? null : Profile.fromJson(json["data"]),
        status: json["status"],
      );

  /// Converts a [ProfileModel] object to a JSON map.
  Map<String, dynamic> toJson() => {
        "data": data ?? data?.toJson(),
        "status": status,
      };
}

/// Represents a profile with user data.
class Profile {
  /// Constructs an instance of [Profile].
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

  /// The email address of the user.
  String? email;

  /// The image URL of the user.
  String? image;

  /// Whether the user is blocked by an admin.
  bool? isAdminBlocked;

  /// Whether the user is blocked.
  bool? isBlocked;

  /// Whether the user has blocked the current user.
  bool? isBlockedMe;

  /// Whether the user is a group admin.
  bool? isGroupAdmin;

  /// Whether the group is in offline mode.
  bool? isGroupInOfflineMode;

  /// Whether the profile is a group profile.
  bool? isGroupProfile;

  /// Whether the contact is saved.
  bool? isItSavedContact;

  /// Whether the user is muted.
  bool? isMuted;

  /// Whether the user is selected.
  bool? isSelected;

  /// The JID of the user.
  String? jid;

  /// The mobile number of the user.
  String? mobileNumber;

  /// The name of the user.
  String? name;

  /// The nickname of the user.
  String? nickName;

  /// The status of the user.
  String? status;

  /// The thumbnail image URL of the user.
  String? thumbImage;

  /// Creates a [Profile] instance from a JSON map.
  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        email: json["email"],
        image: json["image"],
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
        mobileNumber: json["mobileNumber"],
        name: json["name"],
        nickName: json["nickName"],
        status: json["status"],
        thumbImage: json["thumbImage"],
      );

  /// Converts a [Profile] instance to a JSON map.
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
