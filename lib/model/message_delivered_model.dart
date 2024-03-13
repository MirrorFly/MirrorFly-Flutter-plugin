// To parse this JSON data, do
//
//     final messageDeliveredStatus = messageDeliveredStatusFromJson(jsonString);

import 'dart:convert';

import 'package:mirrorfly_plugin/model/user_list_model.dart';

MessageStatusDetail messageDeliveredStatusFromJson(String str) =>
    MessageStatusDetail.fromJson(json.decode(str));

MessageStatusDetail messageReadStatusFromJson(String str) =>
    MessageStatusDetail.fromJson(json.decode(str));

MessageStatusDetail messageStatusDetailFromJson(String str) =>
    MessageStatusDetail.fromJson(json.decode(str));

String messageDeliveredStatusToJson(MessageStatusDetail data) =>
    json.encode(data.toJson());

class MessageStatusDetail {
  String? count;
  int? totalParticipantCount;
  List<ParticipantList>? participantList;

  MessageStatusDetail({
    this.count,
    this.totalParticipantCount,
    this.participantList,
  });

  factory MessageStatusDetail.fromJson(Map<String, dynamic> json) =>
      MessageStatusDetail(
        count: json["count"],
        totalParticipantCount: json["totalParticipantCount"],
        participantList: json["participantList"] == null
            ? []
            : List<ParticipantList>.from(json["participantList"]!
                .map((x) => ParticipantList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "totalParticipantCount": totalParticipantCount,
        "participantList": participantList == null
            ? []
            : List<dynamic>.from(participantList!.map((x) => x.toJson())),
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

  factory ParticipantList.fromJson(Map<String, dynamic> json) =>
      ParticipantList(
        profileDetails: json["profileDetails"] == null
            ? null
            : ProfileDetails.fromJson(json["profileDetails"]),
        messageId: json["messageId"],
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "profileDetails": profileDetails?.toJson(),
        "messageId": messageId,
        "time": time,
      };
}
