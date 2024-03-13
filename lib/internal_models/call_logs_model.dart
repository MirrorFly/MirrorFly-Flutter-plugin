// To parse this JSON data, do
//
//     final callLogModel = callLogModelFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

CallLogModel callLogListFromJson(String str) =>
    CallLogModel.fromJson(json.decode(str));

String callLogListToJson(CallLogModel data) => json.encode(data.toJson());

String convertCallLogsToJson(String? str) => (str == null || str.isEmpty)
    ? ""
    : callLogListToJson(callLogListFromJson(str));

class CallLogModel {
  List<CallLog>? data;
  int? totalPages;

  CallLogModel({
    this.data,
    this.totalPages,
  });

  factory CallLogModel.fromJson(Map<String, dynamic> json) => CallLogModel(
        data: json["data"] == null
            ? []
            : List<CallLog>.from(json["data"]!.map((x) => CallLog.fromJson(x))),
        totalPages: json["total_pages"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "total_pages": totalPages,
      };
}

class CallLog {
  String? callMode;
  int? callState;
  int? callTime;
  String? callType;
  String? callerDevice;
  int? endTime;
  String? fromUser;
  String? groupId;
  List<String>? inviteUserList;
  bool? isCarbonAnswered;
  bool? isDeleted;
  bool? isDisplay;
  bool? isSync;
  String? roomId;
  int? rowId;
  String? sessionStatus;
  int? startTime;
  String? toUser;
  List<String>? userList;
  String? nickName;

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
