// To parse this JSON data, do
//
//     final callLogModel = callLogModelFromJson(jsonString);

import 'dart:convert';

/// Converts a JSON string into a [CallLogModel] object.
///
/// This function decodes the given JSON string and uses the [fromJson] constructor
/// of the [CallLogModel] class to create an instance.
///
/// Parameters:
///   [str] - A JSON string representation of a [CallLogModel] object.
///
/// Returns:
///   An instance of [CallLogModel] populated with data from the given JSON string.
CallLogModel callLogListFromJson(String str) =>
    CallLogModel.fromJson(json.decode(str));

/// Converts a [CallLogModel] object into a JSON string.
///
/// This function takes a [CallLogModel] object, converts it into a map
/// using the [toJson] method, and then encodes this map as a JSON string.
///
/// Parameters:
///   [data] - The [CallLogModel] object to be converted into a JSON string.
///
/// Returns:
///   A JSON string representation of the [CallLogModel] object.
String callLogListToJson(CallLogModel data) => json.encode(data.toJson());

/// Represents the model for call log data.
///
/// This class holds the data for call logs, including a list of [CallLogData] and the total number of pages.
///
class CallLogModel {

  /// A list of [CallLogData] objects representing individual call logs.
  List<CallLogData>? data;

  /// The total number of pages of call log data available.
  int? totalPages;

  /// Constructs a [CallLogModel] instance.
  CallLogModel({
    this.data,
    this.totalPages,
  });

  /// Converts a JSON object into a [CallLogModel] instance.
  factory CallLogModel.fromJson(Map<String, dynamic> json) => CallLogModel(
        data: json["data"] == null
            ? []
            : List<CallLogData>.from(
                json["data"]!.map((x) => CallLogData.fromJson(x))),
        totalPages: json["total_pages"],
      );

  /// Converts a [CallLogModel] instance into a JSON object.
  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "total_pages": totalPages,
      };
}

/// Represents the model for call log data.
class CallLogData {

  /// Represents the mode of the call.
  String? callMode;

  /// Represents the state of the call.
  int? callState;

  /// Represents the time of the call.
  int? callTime;

  /// Represents the type of the call.
  String? callType;

  /// Represents the device of the caller.
  String? callerDevice;

  /// Represents the end time of the call.
  int? endTime;

  /// Represents the user who initiated the call.
  String? fromUser;

  /// Represents the group ID of the call.
  String? groupId;

  /// Represents the list of users invited to the call.
  List<String>? inviteUserList;

  /// Represents whether the call was answered.
  bool? isCarbonAnswered;

  /// Represents whether the call was deleted.
  bool? isDeleted;

  /// Represents whether the call is displayed.
  bool? isDisplay;

  /// Represents whether the call is synchronized.
  bool? isSync;

  /// Represents the room ID of the call.
  String? roomId;

  /// Represents the row ID of the call.
  int? rowId;

  /// Represents the status of the call session.
  String? sessionStatus;

  /// Represents the start time of the call.
  int? startTime;

  /// Represents the user who received the call.
  String? toUser;

  /// Represents the list of users in the call.
  List<String>? userList;

  /// Represents the nickname of the user.
  String? nickName;

  /// Constructs a [CallLogData] instance.
  CallLogData(
      {this.callMode,
      this.callState,
      this.callTime,
      this.callType,
      this.callerDevice,
      this.endTime,
      this.fromUser,
      this.groupId,
      this.inviteUserList,
      this.isCarbonAnswered,
      this.isDeleted,
      this.isDisplay,
      this.isSync,
      this.roomId,
      this.rowId,
      this.sessionStatus,
      this.startTime,
      this.toUser,
      this.userList,
      this.nickName});

  /// Converts a JSON object into a [CallLogData] instance.
  factory CallLogData.fromJson(Map<String, dynamic> json) => CallLogData(
      callMode: json["callMode"],
      callState: json['callState'],
      callTime: json["callTime"],
      callType: json["callType"],
      callerDevice: json["callerDevice"],
      endTime: json["endTime"],
      fromUser: json["fromUser"],
      groupId: json["groupId"],
      inviteUserList: json["inviteUserList"] == null
          ? []
          : List<String>.from(json["inviteUserList"]!.map((x) => x)),
      isCarbonAnswered: json["isCarbonAnswered"],
      isDeleted: json["isDeleted"],
      isDisplay: json["isDisplay"],
      isSync: json["isSync"],
      roomId: json["roomId"],
      rowId: json["rowId"],
      sessionStatus: json["sessionStatus"],
      startTime: json["startTime"],
      toUser: json["toUser"],
      userList: json["userList"] == null
          ? []
          : List<String>.from(json["userList"]!.map((x) => x)),
      nickName: json['nickName']);

  /// Converts a [CallLogData] instance into a JSON object.
  Map<String, dynamic> toJson() => {
        "callMode": callMode,
        "callState": callState,
        "callTime": callTime,
        "callType": callType,
        "callerDevice": callerDevice,
        "endTime": endTime,
        "fromUser": fromUser,
        "groupId": groupId,
        "inviteUserList": inviteUserList == null
            ? []
            : List<String>.from(inviteUserList!.map((x) => x)),
        "isCarbonAnswered": isCarbonAnswered,
        "isDeleted": isDeleted,
        "isDisplay": isDisplay,
        "isSync": isSync,
        "roomId": roomId,
        "rowId": rowId,
        "sessionStatus": sessionStatus,
        "startTime": startTime,
        "toUser": toUser,
        "userList":
            userList == null ? [] : List<dynamic>.from(userList!.map((x) => x)),
        "nickName": nickName
      };
}
