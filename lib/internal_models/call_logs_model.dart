// To parse this JSON data, do
//
//     final callLogModel = callLogModelFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

/// Parses a JSON string into a [CallLogModel].
///
/// This function decodes a JSON string to a Map, and then creates a [CallLogModel]
/// object from it using the `fromJson` factory constructor.
///
/// [str]: The JSON string to be parsed.
///
/// Returns a [CallLogModel] object.
CallLogModel callLogListFromJson(String str) =>
    CallLogModel.fromJson(json.decode(str));

/// Converts a [CallLogModel] to a JSON string.
///
/// This function takes a [CallLogModel] object, converts it to a Map
/// using the `toJson` method, and then encodes this Map as a JSON string.
///
/// [data]: The [CallLogModel] object to be converted.
///
/// Returns a JSON string representation of the [CallLogModel].
String callLogListToJson(CallLogModel data) => json.encode(data.toJson());

/// Converts a nullable JSON string to a JSON string representation of a [CallLogModel], or returns an empty string if null or empty.
///
/// This function checks if the input string is null or empty. If it is, it returns an empty string.
/// Otherwise, it converts the string to a [CallLogModel] object and then back to a JSON string.
///
/// [str]: The nullable JSON string to be converted.
///
/// Returns a JSON string representation of the [CallLogModel] if [str] is not null or empty; otherwise, returns an empty string.
String convertCallLogsToJson(String? str) => (str == null || str.isEmpty)
    ? ""
    : callLogListToJson(callLogListFromJson(str));

/// Represents the model for call logs, including a list of [CallLog] and total pages.
class CallLogModel {
  /// A list of [CallLog] objects representing individual call logs.
  /// This list may be null if no call logs are available.
  List<CallLog>? data;

  /// An integer representing the total number of pages of call logs available.
  /// This may be null if the total number of pages is unknown.
  int? totalPages;

  /// Constructor for [CallLogModel].
  ///
  /// Initializes a new instance of the [CallLogModel] class with optional parameters for
  /// the list of call logs ([data]) and the total number of pages ([totalPages]).
  CallLogModel({
    this.data,
    this.totalPages,
  });

  /// Creates a [CallLogModel] instance from a JSON map.
  ///
  /// This factory constructor parses a JSON map and creates a [CallLogModel]
  /// instance. It is used for decoding JSON data fetched from an API or stored locally.
  ///
  /// [json]: The JSON map to parse.
  factory CallLogModel.fromJson(Map<String, dynamic> json) => CallLogModel(
        data: json["data"] == null
            ? []
            : List<CallLog>.from(json["data"]!.map((x) => CallLog.fromJson(x))),
        totalPages: json["total_pages"],
      );

  /// Converts a [CallLogModel] instance to a JSON map.
  ///
  /// This method serializes the [CallLogModel] instance into a JSON map,
  /// making it easy to encode the call log data into a JSON string for storage
  /// or transmission.
  ///
  /// Returns a JSON map representation of the [CallLogModel].
  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "total_pages": totalPages,
      };
}

/// This class holds information about a specific call event, including details
/// about the call mode, state, timing, participants, and other relevant attributes.
class CallLog {
  /// The mode of the call (e.g., voice, video).
  String? callMode;

  /// The state of the call (e.g., missed, outgoing, incoming).
  int? callState;

  /// The duration of the call in seconds.
  int? callTime;

  /// The type of the call (e.g., group, single).
  String? callType;

  /// The device from which the call was made.
  String? callerDevice;

  ///The timestamp when the call ended.
  int? endTime;

  ///The identifier of the user who initiated the call.
  String? fromUser;

  /// The identifier of the group in which the call was made, if applicable.
  String? groupId;

  /// A list of users invited to the call.
  List<String>? inviteUserList;

  /// Indicates whether the call was answered on another device.
  bool? isCarbonAnswered;

  /// Indicates whether the call log has been deleted.
  bool? isDeleted;

  /// Indicates whether the call log should be displayed.
  bool? isDisplay;

  /// Indicates whether the call log has been synchronized.
  bool? isSync;

  /// The identifier of the room associated with the call.
  String? roomId;

  /// The database row identifier for the call log.
  int? rowId;

  /// The status of the call session (e.g., completed, failed).
  String? sessionStatus;

  /// The timestamp when the call started.
  int? startTime;

  /// The identifier of the user on the receiving end of the call.
  String? toUser;

  /// A list of users involved in the call.
  List<String>? userList;

  ///The nickname of the user associated with the call log.
  String? nickName;

  /// Constructor for [CallLog].
  CallLog(
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

  /// Factory constructor that creates a [CallLog] instance from a JSON map.
  ///
  /// This constructor parses a JSON map and initializes a [CallLog] instance with the
  /// values from the map. It is used for decoding JSON data fetched from an API or stored locally.
  ///
  /// [json]: The JSON map to parse.
  factory CallLog.fromJson(Map<String, dynamic> json) => CallLog(
      callMode: json["callMode"],
      callState: Platform.isAndroid
          ? json['callState']
          : getCallState(stateValue: json['callState']),
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

  /// Converts a [CallLog] instance to a JSON map.
  ///
  /// This method serializes the [CallLog] instance into a JSON map, making it easy to
  /// encode the call log data into a JSON string for storage or transmission.
  ///
  /// Returns a JSON map representation of the [CallLog].
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

/// Determines the call state from a string value.
///
/// This function maps a string representation of a call state to its corresponding integer value.
/// It is used to convert JSON string values to the integer values expected by the application logic.
///
/// [stateValue]: The string representation of the call state.
///
/// Returns an integer representing the call state.
int getCallState({required String stateValue}) {
  switch (stateValue) {
    case "MissedCall":
      return 0;
    case "OutgoingCall":
      return 1;
    case "IncomingCall":
      return 2;
    default:
      return 1;
  }
}
