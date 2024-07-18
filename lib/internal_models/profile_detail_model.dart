// To parse this JSON data, do
//
//     final member = memberFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

/// Converts a JSON string into a list of [ProfileDetails] objects.
///
/// This function decodes the provided JSON string into a list of maps,
/// and then maps each one to a [ProfileDetails] object using the [ProfileDetails.fromJson] factory.
///
/// Parameters:
///   [str] - A JSON string representing a list of profile details.
///
/// Returns:
///   A list of [ProfileDetails] objects.
List<ProfileDetails> profileDetailsFromJson(String str) =>
    List<ProfileDetails>.from(
        json.decode(str).map((x) => ProfileDetails.fromJson(x)));

/// Converts a list of [ProfileDetails] objects into a JSON string.
///
/// This function takes a list of [ProfileDetails] objects, converts each object to a map
/// using the [toJson] method, and then encodes the list of maps as a JSON string.
///
/// Parameters:
///   [data] - A list of [ProfileDetails] objects.
///
/// Returns:
///   A JSON string representing the list of profile details.
String profileDetailsToJson(List<ProfileDetails> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

/// Converts a JSON string into a JSON string representing a list of [ProfileDetails] objects.
///
/// This function checks if the provided string is null or empty. If it is, it returns an empty string.
/// Otherwise, it converts the string into a list of [ProfileDetails] objects using [profileDetailsFromJson],
/// and then back into a JSON string using [profileDetailsToJson].
///
/// Parameters:
///   [str] - A JSON string or null.
///
/// Returns:
///   A JSON string representing a list of [ProfileDetails] objects, or an empty string if the input is null or empty.
String convertProfileDetailsJsonFromString(String? str) =>
    (str == null || str.isEmpty)
        ? ""
        : profileDetailsToJson(profileDetailsFromJson(str));

/// Converts a JSON string into a single [ProfileDetails] object.
///
/// This function decodes the provided JSON string into a map and then uses the [ProfileDetails.fromJson]
/// factory to create a [ProfileDetails] object.
///
/// Parameters:
///   [str] - A JSON string representing a single profile detail.
///
/// Returns:
///   A [ProfileDetails] object.
ProfileDetails profileDetailFromJson(String str) =>
    ProfileDetails.fromJson(json.decode(str));

/// Converts a single [ProfileDetails] object into a JSON string.
///
/// This function takes a [ProfileDetails] object, converts it to a map using the [toJson] method,
/// and then encodes the map as a JSON string.
///
/// Parameters:
///   [data] - A [ProfileDetails] object.
///
/// Returns:
///   A JSON string representing the profile detail.
String profileDetailToJson(ProfileDetails data) => json.encode(data.toJson());

/// Converts a JSON string into a JSON string representing a single [ProfileDetails] object.
///
/// This function checks if the provided string is null or empty. If it is, it returns an empty string.
/// Otherwise, it converts the string into a [ProfileDetails] object using [profileDetailFromJson],
/// and then back into a JSON string using [profileDetailToJson].
///
/// Parameters:
///   [str] - A JSON string or null.
///
/// Returns:
///   A JSON string representing a single [ProfileDetails] object, or an empty string if the input is null or empty.
String convertProfileDetailJsonFromString(String? str) =>
    (str == null || str.isEmpty)
        ? ""
        : profileDetailToJson(profileDetailFromJson(str));

/// A class representing a profile detail.
class ProfileDetails {
  /// Constructor for the [ProfileDetails] class.
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

  /// The type of contact.
  String? contactType;

  /// The email address of the contact.
  String? email;

  /// The time the group was created.
  String? groupCreatedTime;

  /// The image of the contact.
  String? image;

  /// The privacy flag for the image.
  String? imagePrivacyFlag;

  /// Whether the contact is blocked by the admin.
  bool? isAdminBlocked;

  /// Whether the contact is blocked.
  bool? isBlocked;

  /// Whether the contact has blocked the user.
  bool? isBlockedMe;

  /// Whether the contact is a group admin.
  bool? isGroupAdmin;

  /// Whether the group is in offline mode.
  bool? isGroupInOfflineMode;

  /// Whether the contact is a group profile.
  bool? isGroupProfile;

  /// Whether the contact is saved.
  bool? isItSavedContact;

  /// Whether the contact is muted.
  bool? isMuted;

  /// Whether the contact is selected.
  bool? isSelected;

  /// The JID of the contact.
  String? jid;

  /// The privacy flag for the last seen time.
  String? lastSeenPrivacyFlag;

  /// The privacy flag for the mobile number.
  String? mobileNUmberPrivacyFlag;

  /// The mobile number of the contact.
  String? mobileNumber;

  /// The name of the contact.
  String? name;

  /// The nickname of the contact.
  String? nickName;

  /// The status of the contact.
  String? status;

  /// The thumbnail image of the contact.
  String? thumbImage;

  /// Factory method to create a [ProfileDetails] object from a map.
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

  /// Converts a [ProfileDetails] object into a map.
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
