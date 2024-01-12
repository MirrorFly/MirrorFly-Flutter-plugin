// To parse this JSON data, do
//
//     final messageDeliveredStatus = messageDeliveredStatusFromJson(jsonString);

import 'dart:convert';

import 'package:mirrorfly_plugin/model/user_list_model.dart';


MessageDeliveredStatus messageDeliveredStatusFromJson(
    String str) =>
    MessageDeliveredStatus.fromJson(json.decode(str));

MessageDeliveredStatus messageReadStatusFromJson(
    String str) =>
    MessageDeliveredStatus.fromJson(json.decode(str));

MessageDeliveredStatus messageStatusDetailFromJson(
    String str) =>
    MessageDeliveredStatus.fromJson(json.decode(str));

String messageDeliveredStatusToJson(MessageDeliveredStatus data) =>
    json.encode(data.toJson());

class MessageDeliveredStatus {
  String? count;
  int? totalParticipantCount;
  List<ParticipantList>? participantList;

  MessageDeliveredStatus({
    this.count,
    this.totalParticipantCount,
    this.participantList,
  });

  factory MessageDeliveredStatus.fromJson(Map<String, dynamic> json) => MessageDeliveredStatus(
    count: json["count"],
    totalParticipantCount: json["totalParticipantCount"],
    participantList: json["participantList"] == null ? [] : List<ParticipantList>.from(json["participantList"]!.map((x) => ParticipantList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "totalParticipantCount": totalParticipantCount,
    "participantList": participantList == null ? [] : List<dynamic>.from(participantList!.map((x) => x.toJson())),
  };
}

class ParticipantList {
  ProfileDetails? profileDetails;
  String? messageId;
  String? time;

  ParticipantList({
    this.profileDetails,
    this.messageId,
    this.time,
  });

  factory ParticipantList.fromJson(Map<String, dynamic> json) => ParticipantList(
    profileDetails: json["profileDetails"] == null ? null : ProfileDetails.fromJson(json["profileDetails"]),
    messageId: json["messageId"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "profileDetails": profileDetails?.toJson(),
    "messageId": messageId,
    "time": time,
  };
}
