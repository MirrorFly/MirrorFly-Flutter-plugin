// To parse this JSON data, do
//
//     final messageDeliveredStatus = messageDeliveredStatusFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

import 'profile_detail_model.dart';

/// Parses JSON data to create a [MessageStatusDetail] object.
///
/// This function takes a JSON string and decodes it into a [MessageStatusDetail] object,
/// which contains details about the delivery status of a message, including the count of
/// participants who have received the message, the total number of participants, and a list
/// of participant details.
///
/// Parameters:
///   [str] - A JSON string representing the message delivery status.
///
/// Returns:
///   A [MessageStatusDetail] object populated with the data from the JSON string.
MessageStatusDetail messageDeliveredStatusFromJson(String str) =>
    MessageStatusDetail.fromJson(json.decode(str));

/// Converts a [MessageStatusDetail] object to a JSON string.
///
/// This function takes a [MessageStatusDetail] object and encodes it into a JSON string.
/// It is useful for serializing the message delivery status details to store or transmit as a string.
///
/// Parameters:
///   [data] - The [MessageStatusDetail] object to be converted to a JSON string.
///
/// Returns:
///   A JSON string representation of the [MessageStatusDetail] object.
String messageDeliveredStatusToJson(MessageStatusDetail data) =>
    json.encode(data);

/// Parses JSON data to create a [MessageStatusDetail] object for message read status.
///
/// This function is similar to [messageDeliveredStatusFromJson] but specifically used for
/// parsing JSON data related to the read status of a message.
///
/// Parameters:
///   [str] - A JSON string representing the message read status.
///
/// Returns:
///   A [MessageStatusDetail] object populated with the data from the JSON string.
MessageStatusDetail messageReadStatusFromJson(String str) =>
    MessageStatusDetail.fromJson(json.decode(str));

/// Parses JSON data to create a [MessageStatusDetail] object.
///
/// This function is a generic parser for JSON data related to message status, capable of
/// handling various types of message status information.
///
/// Parameters:
///   [str] - A JSON string representing the message status.
///
/// Returns:
///   A [MessageStatusDetail] object populated with the data from the JSON string.
MessageStatusDetail messageStatusDetailFromJson(String str) =>
    MessageStatusDetail.fromJson(json.decode(str));

/// Converts a nullable JSON string to a [MessageStatusDetail] object or an empty string.
///
/// This function checks if the provided JSON string is null or empty. If it is, the function
/// returns an empty string; otherwise, it parses the JSON string into a [MessageStatusDetail]
/// object and then converts it back to a JSON string.
///
/// Parameters:
///   [str] - A nullable JSON string representing the message delivery status.
///
/// Returns:
///   A JSON string representation of the [MessageStatusDetail] object or an empty string if
///   the input is null or empty.
String convertMessageDeliveredStatusToJson(String? str) =>
    (str == null || str.isEmpty)
        ? ""
        : messageDeliveredStatusToJson(messageDeliveredStatusFromJson(str));

/// Represents the detailed status of a message, including delivery and read status.
///
/// This class holds information about the delivery and read status of a message, such as
/// the count of participants who have received or read the message, the total number of
/// participants, and detailed information about each participant.
class MessageStatusDetail {
  /// Creates a new [MessageStatusDetail] object.
  MessageStatusDetail({
    this.count,
    this.totalParticipantCount,
    required this.participantList,
  });

  /// The count of participants who have received or read the message.
  String? count;

  /// The total number of participants in the conversation.
  int? totalParticipantCount;

  /// A list of participants with detailed information about each participant.
  List<ParticipantList> participantList;


  /// Creates a new [MessageStatusDetail] object from a JSON map.
  factory MessageStatusDetail.fromJson(Map<String, dynamic> json) =>
      MessageStatusDetail(
        count: json["count"],
        totalParticipantCount: json["totalParticipantCount"],
        participantList: List<ParticipantList>.from(
            json["participantList"].map((x) => ParticipantList.fromJson(x))),
      );

  /// Converts the [MessageStatusDetail] object to a JSON map.
  Map<String, dynamic> toJson() => {
        "count": count,
        "totalParticipantCount": totalParticipantCount,
        "participantList":
            List<dynamic>.from(participantList.map((x) => x.toJson())),
      };
}

/// A class that represents a list of participants with their profile details, message ID, and time.
class ParticipantList {
  /// Constructs a ParticipantList object with the provided parameters.
  ParticipantList({
    this.profileDetails,
    this.messageId,
    this.time,
  });

  /// The profile details of the participant.
  ProfileDetails? profileDetails;

  /// The ID of the message.
  String? messageId;

  /// The time when the message was sent.
  String? time;

  /// Creates a ParticipantList object from a JSON map.
  ///
  /// The [json] parameter should be a map containing the JSON data.
  ///
  /// Returns a [ParticipantList] object.
  factory ParticipantList.fromJson(Map<String, dynamic> json) =>
      ParticipantList(
        profileDetails: ProfileDetails.fromJson((Platform.isAndroid
            ? json["memberProfileDetails"]
            : json["profileDetails"])),
        messageId: json["messageId"],
        time: json["time"].toString(),
      );

  /// Converts the ParticipantList object to a JSON map.
  ///
  /// Returns a [Map<String, dynamic>] representing the JSON data.
  Map<String, dynamic> toJson() => {
    "profileDetails": profileDetails?.toJson(),
    "messageId": messageId,
    "time": time,
  };
}

/// A class that represents the profile details of a member.
class MemberProfileDetails {
  /// Constructs a MemberProfileDetails object with the provided parameters.
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

  /// The type of contact.
  String? contactType;

  /// The email address of the member.
  String? email;

  /// The time when the group was created.
  String? groupCreatedTime;

  /// The image URL of the member.
  String? image;

  /// The privacy flag for the image.
  String? imagePrivacyFlag;

  /// A flag indicating whether the member is blocked by the admin.
  bool? isAdminBlocked;

  /// A flag indicating whether the member is blocked.
  bool? isBlocked;

  /// A flag indicating whether the member has blocked the user.
  bool? isBlockedMe;

  /// A flag indicating whether the member is a group admin.
  bool? isGroupAdmin;

  /// A flag indicating whether the group is in offline mode.
  bool? isGroupInOfflineMode;

  /// A flag indicating whether the profile is a group profile.
  bool? isGroupProfile;

  /// A flag indicating whether the contact is saved.
  bool? isItSavedContact;

  /// A flag indicating whether the member is muted.
  bool? isMuted;

  /// A flag indicating whether the member is selected.
  bool? isSelected;

  /// The JID of the member.
  String? jid;

  /// The privacy flag for the last seen status.
  String? lastSeenPrivacyFlag;

  /// The privacy flag for the mobile number.
  String? mobileNUmberPrivacyFlag;

  /// The mobile number of the member.
  String? mobileNumber;

  /// The name of the member.
  String? name;

  /// The nickname of the member.
  String? nickName;

  /// The status of the member.
  String? status;

  /// The thumbnail image URL of the member.
  String? thumbImage;

  /// Creates a MemberProfileDetails object from a JSON map.
  ///
  /// The [json] parameter should be a map containing the JSON data.
  ///
  /// Returns a [MemberProfileDetails] object.
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

  /// Converts the MemberProfileDetails object to a JSON map.
  ///
  /// Returns a [Map<String, dynamic>] representing the JSON data.
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

/// Converts the contact type string to a more descriptive string.
///
/// The [contactType] parameter is the contact type string to convert.
///
/// Returns a [String] representing the converted contact type.
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

