// To parse this JSON data, do
//
//     final registerModel = registerModelFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

RegisterModel registerModelFromJson(String str) =>
    RegisterModel.fromJson(json.decode(str));

String registerModelToJson(RegisterModel data) => json.encode(data.toJson());

String convertRegisterUserJsonFromString(String? str) =>
    (str == null || str.isEmpty)
        ? ""
        : json.encode(registerModelFromJson(str).toJson());

class RegisterModel {
  String? userJid;
  Data? data;
  bool? isNewUser;
  String? message;

  RegisterModel({
    this.userJid,
    this.data,
    this.isNewUser,
    this.message,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
        userJid: Platform.isAndroid ? json["userJid"] : json["data"]["userJid"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        isNewUser: json["is_new_user"],
        message: Platform.isAndroid ? json["message"] : "Register Success",
      );

  Map<String, dynamic> toJson() => {
        "userJid": userJid,
        "data": data?.toJson(),
        "is_new_user": isNewUser,
        "message": message,
      };
}

class Data {
  String? token;
  String? username;
  String? password;
  bool? isExisting;
  bool? isProfileUpdated;
  Config? config;

  Data({
    this.token,
    this.username,
    this.password,
    this.isExisting,
    this.isProfileUpdated,
    this.config,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        token: json["token"],
        username: json["username"],
        password: json["password"],
        isExisting: json["isExisting"],
        isProfileUpdated: json["isProfileUpdated"],
        config: json["config"] == null ? null : Config.fromJson(json["config"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "username": username,
        "password": password,
        "isExisting": isExisting,
        "isProfileUpdated": isProfileUpdated,
        "config": config?.toJson(),
      };
}

class Config {
  String? domain;
  int? videoLimit;
  int? audioLimit;
  int? recallTime;
  int? privateTime;
  String? xmppDomain;
  String? xmppHost;
  int? xmppPort;
  String? adminUser;
  String? googleTranslate;
  String? signalServerDomain;
  String? notificationHelpUrl;
  String? sdkUrl;
  int? pinExpireDays;
  int? pinTimeOut;
  int? fileSizeLimit;
  List<String>? stuns;
  List<Turn>? turns;
  dynamic liveStreamingSignalServer;
  bool? isLiveStreamingEnabled;
  bool? sipcallEnabled;
  dynamic sipServer;
  String? callRoutingServer;
  dynamic chatBackupType;
  dynamic chatBackupFrequency;
  String? xmppPortWeb;
  String? iv;
  String? ivProfile;
  bool? groupChat;
  bool? attachment;
  bool? imageAttachment;
  bool? videoAttachment;
  bool? audioAttachment;
  bool? documentAttachment;
  bool? contactAttachment;
  bool? locationAttachment;
  bool? one2OneCall;
  bool? groupCall;
  bool? recentchatSearch;
  bool? starMessage;
  bool? clearChat;
  bool? deleteChat;
  bool? translation;
  bool? block;
  bool? report;
  bool? deleteMessage;
  bool? viewAllMedias;
  bool? chatHistory;

  Config({
    this.domain,
    this.videoLimit,
    this.audioLimit,
    this.recallTime,
    this.privateTime,
    this.xmppDomain,
    this.xmppHost,
    this.xmppPort,
    this.adminUser,
    this.googleTranslate,
    this.signalServerDomain,
    this.notificationHelpUrl,
    this.sdkUrl,
    this.pinExpireDays,
    this.pinTimeOut,
    this.fileSizeLimit,
    this.stuns,
    this.turns,
    this.liveStreamingSignalServer,
    this.isLiveStreamingEnabled,
    this.sipcallEnabled,
    this.sipServer,
    this.callRoutingServer,
    this.chatBackupType,
    this.chatBackupFrequency,
    this.xmppPortWeb,
    this.iv,
    this.ivProfile,
    this.groupChat,
    this.attachment,
    this.imageAttachment,
    this.videoAttachment,
    this.audioAttachment,
    this.documentAttachment,
    this.contactAttachment,
    this.locationAttachment,
    this.one2OneCall,
    this.groupCall,
    this.recentchatSearch,
    this.starMessage,
    this.clearChat,
    this.deleteChat,
    this.translation,
    this.block,
    this.report,
    this.deleteMessage,
    this.viewAllMedias,
    this.chatHistory,
  });

  factory Config.fromJson(Map<String, dynamic> json) => Config(
        domain: json["domain"],
        videoLimit: json["videoLimit"],
        audioLimit: json["audioLimit"],
        recallTime: json["recallTime"],
        privateTime: json["privateTime"],
        xmppDomain: json["xmppDomain"],
        xmppHost: json["xmppHost"],
        xmppPort: json["xmppPort"],
        adminUser: json["adminUser"],
        googleTranslate: json["googleTranslate"],
        signalServerDomain: json["signalServerDomain"],
        notificationHelpUrl: json["notificationHelpUrl"],
        sdkUrl: json["sdkUrl"],
        pinExpireDays: json["pinExpireDays"],
        pinTimeOut: json["pinTimeOut"],
        fileSizeLimit: json["fileSizeLimit"],
        stuns: json["stuns"] == null
            ? []
            : List<String>.from(json["stuns"]!.map((x) => x)),
        turns: json["turns"] == null
            ? []
            : List<Turn>.from(json["turns"]!.map((x) => Turn.fromJson(x))),
        liveStreamingSignalServer: json["liveStreamingSignalServer"],
        isLiveStreamingEnabled: json["isLiveStreamingEnabled"],
        sipcallEnabled: json["sipcallEnabled"],
        sipServer: json["sipServer"],
        callRoutingServer: json["callRoutingServer"],
        chatBackupType: json["chatBackupType"],
        chatBackupFrequency: json["chatBackupFrequency"],
        xmppPortWeb: json["xmppPortWeb"],
        iv: json["iv"],
        ivProfile: json["ivProfile"],
        groupChat: json["groupChat"],
        attachment: json["attachment"],
        imageAttachment: json["imageAttachment"],
        videoAttachment: json["videoAttachment"],
        audioAttachment: json["audioAttachment"],
        documentAttachment: json["documentAttachment"],
        contactAttachment: json["contactAttachment"],
        locationAttachment: json["locationAttachment"],
        one2OneCall: json["one2oneCall"],
        groupCall: json["groupCall"],
        recentchatSearch: json["recentchatSearch"],
        starMessage: json["starMessage"],
        clearChat: json["clearChat"],
        deleteChat: json["deleteChat"],
        translation: json["translation"],
        block: json["block"],
        report: json["report"],
        deleteMessage: json["deleteMessage"],
        viewAllMedias: json["viewAllMedias"],
        chatHistory: json["chatHistory"],
      );

  Map<String, dynamic> toJson() => {
        "domain": domain,
        "videoLimit": videoLimit,
        "audioLimit": audioLimit,
        "recallTime": recallTime,
        "privateTime": privateTime,
        "xmppDomain": xmppDomain,
        "xmppHost": xmppHost,
        "xmppPort": xmppPort,
        "adminUser": adminUser,
        "googleTranslate": googleTranslate,
        "signalServerDomain": signalServerDomain,
        "notificationHelpUrl": notificationHelpUrl,
        "sdkUrl": sdkUrl,
        "pinExpireDays": pinExpireDays,
        "pinTimeOut": pinTimeOut,
        "fileSizeLimit": fileSizeLimit,
        "stuns": stuns == null ? [] : List<dynamic>.from(stuns!.map((x) => x)),
        "turns": turns == null
            ? []
            : List<dynamic>.from(turns!.map((x) => x.toJson())),
        "liveStreamingSignalServer": liveStreamingSignalServer,
        "isLiveStreamingEnabled": isLiveStreamingEnabled,
        "sipcallEnabled": sipcallEnabled,
        "sipServer": sipServer,
        "callRoutingServer": callRoutingServer,
        "chatBackupType": chatBackupType,
        "chatBackupFrequency": chatBackupFrequency,
        "xmppPortWeb": xmppPortWeb,
        "iv": iv,
        "ivProfile": ivProfile,
        "groupChat": groupChat,
        "attachment": attachment,
        "imageAttachment": imageAttachment,
        "videoAttachment": videoAttachment,
        "audioAttachment": audioAttachment,
        "documentAttachment": documentAttachment,
        "contactAttachment": contactAttachment,
        "locationAttachment": locationAttachment,
        "one2oneCall": one2OneCall,
        "groupCall": groupCall,
        "recentchatSearch": recentchatSearch,
        "starMessage": starMessage,
        "clearChat": clearChat,
        "deleteChat": deleteChat,
        "translation": translation,
        "block": block,
        "report": report,
        "deleteMessage": deleteMessage,
        "viewAllMedias": viewAllMedias,
        "chatHistory": chatHistory,
      };
}

class Turn {
  String? turn;
  String? username;
  String? password;

  Turn({
    this.turn,
    this.username,
    this.password,
  });

  factory Turn.fromJson(Map<String, dynamic> json) => Turn(
        turn: json["turn"],
        username: json["username"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "turn": turn,
        "username": username,
        "password": password,
      };
}
