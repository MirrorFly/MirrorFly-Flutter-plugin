// To parse this JSON data, do
//
//     final statusData = statusDataFromJson(jsonString);

import 'dart:convert';

Status statusFromJson(String str) => Status.fromJson(json.decode(str));

String statusToJson(Status data) => json.encode(data.toJson());

String convertStatusFromJson(String? str) =>
    (str == null || str.isEmpty) ? "" : statusToJson(statusFromJson(str));

List<Status> statusListFromJson(String str) =>
    List<Status>.from(json.decode(str).map((x) => Status.fromJson(x)));

String statusListToJson(List<Status> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

String convertStatusListFromJson(String? str) => (str == null || str.isEmpty)
    ? ""
    : statusListToJson(statusListFromJson(str));

class Status {
  Status({
    this.id,
    this.isCurrentStatus,
    this.status,
  });

  String? id;
  bool? isCurrentStatus;
  String? status;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        id: json["id"].toString(),
        isCurrentStatus: json["isCurrentStatus"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "isCurrentStatus": isCurrentStatus,
        "status": status,
      };
}
