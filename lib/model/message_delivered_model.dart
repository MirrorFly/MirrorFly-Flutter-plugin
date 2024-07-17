// To parse this JSON data, do
//
//     final messageDeliveredStatus = messageDeliveredStatusFromJson(jsonString);

import 'dart:convert';

import 'package:mirrorfly_plugin/model/user_list_model.dart';

/// Parses a JSON string and returns a MessageStatusDetail object representing the delivered message status.
///
/// The [str] parameter is a JSON string.
///
/// Returns a [MessageStatusDetail] object.
MessageStatusDetail messageDeliveredStatusFromJson(String str) =>
    MessageStatusDetail.fromJson(json.decode(str));

/// Parses a JSON string and returns a MessageStatusDetail object representing the read message status.
///
/// The [str] parameter is a JSON string.
///
/// Returns a [MessageStatusDetail] object.
MessageStatusDetail messageReadStatusFromJson(String str) =>
    MessageStatusDetail.fromJson(json.decode(str));

/// Parses a JSON string and returns a MessageStatusDetail object.
///
/// The [str] parameter is a JSON string.
///
/// Returns a [MessageStatusDetail] object.
MessageStatusDetail messageStatusDetailFromJson(String str) =>
    MessageStatusDetail.fromJson(json.decode(str));

/// Converts a MessageStatusDetail object to a JSON string.
///
/// The [data] parameter is a MessageStatusDetail object.
///
/// Returns a [String] representing the JSON data.
String messageDeliveredStatusToJson(MessageStatusDetail data) =>
    json.encode(data.toJson());

/// A class that represents the details of a message status.
class MessageStatusDetail {
  /// The number of participants.
  String? count;

  /// The total number of participants.
  int? totalParticipantCount;

  /// A list of participants.
  List<ParticipantList>? participantList;

  /// Initializes a new instance of the MessageStatusDetail class.
  MessageStatusDetail({
    this.count,
    this.totalParticipantCount,
    this.participantList,
  });

  /// Converts a JSON object into a MessageStatusDetail instance.
  factory MessageStatusDetail.fromJson(Map<String, dynamic> json) =>
      MessageStatusDetail(
        count: json["count"],
        totalParticipantCount: json["totalParticipantCount"],
        participantList: json["participantList"] == null
            ? []
            : List<ParticipantList>.from(json["participantList"]!
                .map((x) => ParticipantList.fromJson(x))),
      );

  /// Converts a MessageStatusDetail instance into a JSON object.
  Map<String, dynamic> toJson() => {
        "count": count,
        "totalParticipantCount": totalParticipantCount,
        "participantList": participantList == null
            ? []
            : List<dynamic>.from(participantList!.map((x) => x.toJson())),
      };
}

/// A class that represents the details of a participant.
class ParticipantList {
  /// The profile details of the participant.
  ProfileDetails? profileDetails;

  /// The unique identifier of the message.
  String? messageId;

  /// The time when the message was sent.
  String? time;

  /// Initializes a new instance of the ParticipantList class.
  ParticipantList({
    this.profileDetails,
    this.messageId,
    this.time,
  });

  /// Converts a JSON object into a ParticipantList instance.
  factory ParticipantList.fromJson(Map<String, dynamic> json) =>
      ParticipantList(
        profileDetails: json["profileDetails"] == null
            ? null
            : ProfileDetails.fromJson(json["profileDetails"]),
        messageId: json["messageId"],
        time: json["time"],
      );

  /// Converts a ParticipantList instance into a JSON object.
  Map<String, dynamic> toJson() => {
        "profileDetails": profileDetails?.toJson(),
        "messageId": messageId,
        "time": time,
      };
}
