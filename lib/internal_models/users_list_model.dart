// To parse this JSON data, do
//
//     final userList = userListFromJson(jsonString);

import 'dart:convert';

import 'package:mirrorfly_plugin/internal_models/profile_detail_model.dart';

UserList userListFromJson(String str) => UserList.fromJson(json.decode(str));

String userListToJson(UserList data) => json.encode(data.toJson());

String convertUsersDataJsonFromString(String? str) => (str == null || str.isEmpty) ? "" : userListToJson(userListFromJson(str));

class UserList {
  UserList({
    this.data,
    this.status,
    this.totalPages,
  });

  List<ProfileDetails>? data;
  bool? status;
  int? totalPages;
  String? message;

  factory UserList.fromJson(Map<String, dynamic> json) => UserList(
        data: json["data"] == null
            ? null
            : List<ProfileDetails>.from(json["data"].map((x) => ProfileDetails.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "status": status,
      };
}