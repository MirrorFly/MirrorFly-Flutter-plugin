// To parse this JSON data, do
//
//     final userList = userListFromJson(jsonString);

import 'dart:convert';

/// Converts a JSON string into a [UserList] object.
///
/// This function decodes the given JSON string and uses the [fromJson]
/// constructor of the [UserList] class to create an instance.
///
/// Parameters:
///   [str] - A JSON string representation of a [UserList] object.
///
/// Returns:
///   An instance of [UserList] populated with data from the given JSON string.
UserList userListFromJson(String str) => UserList.fromJson(json.decode(str));

/// Converts a [UserList] object into a JSON string.
///
/// This function takes a [UserList] object, converts it into a map
/// using the [toJson] method, and then encodes this map as a JSON string.
///
/// Parameters:
///   [data] - The [UserList] object to be converted into a JSON string.
///
/// Returns:
///   A JSON string representation of the [UserList] object.
String userListToJson(UserList data) => json.encode(data.toJson());

/// Represents a list of user profiles.
///
/// This class holds a list of [ProfileDetails] representing individual user profiles,
/// and a status flag indicating the success or failure of data retrieval.
///
/// Parameters:
///   [data] - A list of [ProfileDetails] objects representing user profiles.
///   [status] - A boolean flag indicating the success or failure of data retrieval.
class UserList {
  /// Initializes a new instance of the [UserList] class.
  UserList({
    this.data,
    this.status,
  });

  /// A list of [ProfileDetails] objects representing user profiles.
  List<ProfileDetails>? data;

  /// A boolean flag indicating the success or failure of data retrieval.
  bool? status;

  /// Creates a [UserList] instance from a JSON map.
  ///
  /// This factory constructor is used to create an instance of [UserList]
  /// from a map structure representing JSON data. This is useful for
  /// deserializing JSON data retrieved from a database or an API.
  ///
  /// Parameters:
  ///   [json] - A map representing JSON data.
  ///
  /// Returns:
  ///   An instance of [UserList].
  factory UserList.fromJson(Map<String, dynamic> json) => UserList(
        data: json["data"] == null
            ? null
            : List<ProfileDetails>.from(
                json["data"].map((x) => ProfileDetails.fromJson(x))),
        status: json["status"],
      );

  /// Converts an instance of [UserList] to a JSON map.
  ///
  /// This method is used to serialize [UserList] instances into a map
  /// structure that can easily be converted to JSON. This is useful for
  /// storing the instance in a database or sending it over a network.
  ///
  /// Returns:
  ///   A map representing the serialized form of the [UserList] instance.
  Map<String, dynamic> toJson() => {
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "status": status,
      };
}

/// Converts a JSON string into a list of [ProfileDetails].
///
/// This function decodes the given JSON string and maps each JSON object
/// to a [ProfileDetails] instance using the [ProfileDetails.fromJson] constructor.
///
/// Parameters:
///   [str] - A JSON string representation of a list of [ProfileDetails] objects.
///
/// Returns:
///   A list of [ProfileDetails] instances populated with data from the given JSON string.
List<ProfileDetails> profileFromJson(String str) => List<ProfileDetails>.from(
    json.decode(str).map((x) => ProfileDetails.fromJson(x)));

/// Converts a JSON string into a [ProfileDetails] object.
///
/// This function decodes the given JSON string and uses the [fromJson]
/// constructor of the [ProfileDetails] class to create an instance.
///
/// Parameters:
///   [str] - A JSON string representation of a [ProfileDetails] object.
///
/// Returns:
///   An instance of [ProfileDetails] populated with data from the given JSON string.
ProfileDetails profiledata(String str) =>
    ProfileDetails.fromJson(json.decode(str.toString()));

/// Converts a [ProfileDetails] object into a JSON string.
class ProfileDetails {
  /// Initializes a new instance of the [ProfileDetails] class.
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

  /// The email address of the user.
  String? email;

  /// The time the group was created.
  String? groupCreatedTime;

  /// The image URL of the user.
  String? image;

  /// The privacy flag for the user's image.
  String? imagePrivacyFlag;

  /// Indicates whether the user is blocked by the admin.
  bool? isAdminBlocked;

  /// Indicates whether the user is blocked.
  bool? isBlocked;

  /// Indicates whether the user has blocked the current user.
  bool? isBlockedMe;

  /// Indicates whether the user is a group admin.
  bool? isGroupAdmin;

  /// Indicates whether the group is in offline mode.
  bool? isGroupInOfflineMode;

  /// Indicates whether the profile is a group profile.
  bool? isGroupProfile;

  /// Indicates whether the contact is saved.
  bool? isItSavedContact;

  /// Indicates whether the chat is muted.
  bool? isMuted;

  /// Indicates whether the chat is selected.
  bool? isSelected;

  /// The unique identifier of the chat.
  String? jid;

  /// The privacy flag for the user's last seen status.
  String? lastSeenPrivacyFlag;

  /// The privacy flag for the user's mobile number.
  String? mobileNUmberPrivacyFlag;

  /// The mobile number of the user.
  String? mobileNumber;

  /// The name of the user.
  String? name;

  /// The nickname of the user.
  String? nickName;

  /// The status of the user.
  String? status;

  /// The URL of the user's profile image.
  String? thumbImage;

  /// Creates a [ProfileDetails] instance from a JSON map.
  factory ProfileDetails.fromJson(Map<String, dynamic> json) => ProfileDetails(
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

  /// Converts an instance of [ProfileDetails] to a JSON map.
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
