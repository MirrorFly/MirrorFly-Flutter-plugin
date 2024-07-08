// To parse this JSON data, do
//
//     final userList = userListFromJson(jsonString);

import 'dart:convert';

import 'package:mirrorfly_plugin/internal_models/profile_detail_model.dart';

/// Converts a JSON string into a [UserList] object.
///
/// This function decodes the provided JSON string into a map and then uses the [UserList.fromJson]
/// constructor to create a [UserList] object.
///
/// Parameters:
///   [str] - A JSON string representing a list of users.
///
/// Returns:
///   A [UserList] object.
UserList userListFromJson(String str) => UserList.fromJson(json.decode(str));

/// Converts a [UserList] object into a JSON string.
///
/// This function takes a [UserList] object, converts it to a map using the [toJson] method,
/// and then encodes the map as a JSON string.
///
/// Parameters:
///   [data] - A [UserList] object.
///
/// Returns:
///   A JSON string representing the list of users.
String userListToJson(UserList data) => json.encode(data.toJson());

/// Converts a JSON string into a JSON string representing a [UserList] object.
///
/// This function checks if the provided string is null or empty. If it is, it returns an empty string.
/// Otherwise, it converts the string into a [UserList] object using [userListFromJson],
/// and then back into a JSON string using [userListToJson].
///
/// Parameters:
///   [str] - A JSON string or null.
///
/// Returns:
///   A JSON string representing a [UserList] object, or an empty string if the input is null or empty.
String convertUsersDataJsonFromString(String? str) =>
    (str == null || str.isEmpty) ? "" : userListToJson(userListFromJson(str));

/// UserList model class.
class UserList {
  /// Initializes a new instance of the [UserList] class.
  UserList({
    this.data,
    this.status,
    this.totalPages,
  });

  /// The list of user profiles.
  List<ProfileDetails>? data;

  /// The status of the user list.
  bool? status;

  /// The total number of pages in the user list.
  int? totalPages;

  /// The message related to the user list.
  String? message;

  /// Converts a [UserList] object into a map.
  factory UserList.fromJson(Map<String, dynamic> json) => UserList(
        data: json["data"] == null
            ? null
            : List<ProfileDetails>.from(
                json["data"].map((x) => ProfileDetails.fromJson(x))),
        status: json["status"],
      );

  /// Converts a [UserList] object into a map.
  Map<String, dynamic> toJson() => {
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "status": status,
      };
}
