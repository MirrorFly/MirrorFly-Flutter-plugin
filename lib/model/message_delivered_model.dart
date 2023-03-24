// To parse this JSON data, do
//
//     final messageDelivered = messageDeliveredFromJson(jsonString);

import 'dart:convert';

import 'group_members_model.dart';


List<MessageDeliveredStatus> messageDeliveredStatusFromJson(String str) => List<MessageDeliveredStatus>.from(json.decode(str).map((x) => MessageDeliveredStatus.fromJson(x)));

String messageDeliveredStatusToJson(List<MessageDeliveredStatus> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MessageDeliveredStatus {
  MessageDeliveredStatus({
    this.memberProfileDetails,
    this.messageId,
    this.status,
    this.time,
    this.userJid,
  });

  Member? memberProfileDetails;
  String? messageId;
  Status? status;
  String? time;
  String? userJid;

  factory MessageDeliveredStatus.fromJson(Map<String, dynamic> json) => MessageDeliveredStatus(
    memberProfileDetails: json["memberProfileDetails"] ?? Member.fromJson(json["memberProfileDetails"]),
    messageId: json["messageId"] ?? json["messageId"],
    status: json["status"] ?? Status.fromJson(json["status"]),
    time: json["time"] ?? json["time"],
    userJid: json["userJid"] ?? json["userJid"],
  );

  Map<String, dynamic> toJson() => {
    "memberProfileDetails": memberProfileDetails ?? memberProfileDetails?.toJson(),
    "messageId": messageId ?? messageId,
    "status": status ?? status?.toJson(),
    "time": time ?? time,
    "userJid": userJid ?? userJid,
  };
}

class Status {
  Status({
    required this.status,
  });

  String status;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
  };
}
