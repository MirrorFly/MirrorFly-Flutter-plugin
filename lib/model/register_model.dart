// To parse this JSON data, do
//
//     final registerModel = registerModelFromJson(jsonString);

import 'dart:convert';

/// Converts a JSON string into a [RegisterModel] object.
///
/// This function decodes the given JSON string and uses the [fromJson] constructor
/// of the [RegisterModel] class to create an instance.
///
/// Parameters:
///   [str] - A JSON string representation of a [RegisterModel] object.
///
/// Returns:
///   An instance of [RegisterModel] populated with data from the given JSON string.
RegisterModel registerModelFromJson(String str) =>
    RegisterModel.fromJson(json.decode(str));

/// Converts a [RegisterModel] object into a JSON string.
///
/// This function takes a [RegisterModel] object, converts it into a map
/// using the [toJson] method, and then encodes this map as a JSON string.
///
/// Parameters:
///   [data] - The [RegisterModel] object to be converted into a JSON string.
///
/// Returns:
///   A JSON string representation of the [RegisterModel] object.
String registerModelToJson(RegisterModel data) => json.encode(data.toJson());

/// A model representing the registration details of a user.
///
/// This class holds the details necessary for registering a user, including
/// their JID, data, new user status, and a message.
///
/// Parameters:
///   [userJid] - The Jabber ID of the user.
///   [data] - Additional data associated with the user.
///   [isNewUser] - A boolean indicating if the user is new.
///   [message] - A message associated with the registration.
class RegisterModel {
  /// The Jabber ID of the user.
  String? userJid;

  /// Additional data associated with the user.
  Data? data;

  /// A boolean indicating if the user is new.
  bool? isNewUser;

  /// A message associated with the registration.
  String? message;

  /// Initializes a new instance of the [RegisterModel] class.
  RegisterModel({
    this.userJid,
    this.data,
    this.isNewUser,
    this.message,
  });

  /// Converts a JSON object into a [RegisterModel] instance.
  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
        userJid: json["userJid"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        isNewUser: json["is_new_user"],
        message: json["message"],
      );

  /// Converts a [RegisterModel] instance into a JSON object.
  Map<String, dynamic> toJson() => {
        "userJid": userJid,
        "data": data?.toJson(),
        "is_new_user": isNewUser,
        "message": message,
      };
}

/// Represents the data associated with a user.
class Data {
  /// The token associated with the user.
  String? token;

  /// The username of the user.
  String? username;

  /// The password of the user.
  String? password;

  /// A boolean indicating if the user exists.
  bool? isExisting;

  /// A boolean indicating if the user's profile has been updated.
  bool? isProfileUpdated;

  /// Additional configuration data associated with the user.
  Config? config;

  /// Initializes a new instance of the [Data] class.
  Data({
    this.token,
    this.username,
    this.password,
    this.isExisting,
    this.isProfileUpdated,
    this.config,
  });

  /// Converts a JSON object into a [Data] instance.
  factory Data.fromJson(Map<String, dynamic> json) => Data(
        token: json["token"],
        username: json["username"],
        password: json["password"],
        isExisting: json["isExisting"],
        isProfileUpdated: json["isProfileUpdated"],
        config: json["config"] == null ? null : Config.fromJson(json["config"]),
      );

  /// Converts a [Data] instance into a JSON object.
  Map<String, dynamic> toJson() => {
        "token": token,
        "username": username,
        "password": password,
        "isExisting": isExisting,
        "isProfileUpdated": isProfileUpdated,
        "config": config?.toJson(),
      };
}

/// Represents the configuration data associated with a user.
class Config {
  /// The domain of the user.
  String? domain;

  /// The video limit of the user.
  int? videoLimit;

  /// The audio limit of the user.
  int? audioLimit;

  /// The recall time of the user.
  int? recallTime;

  /// The private time of the user.
  int? privateTime;

  /// The XMPP domain of the user.
  String? xmppDomain;

  /// The XMPP host of the user.
  String? xmppHost;

  /// The XMPP port of the user.
  int? xmppPort;

  /// The admin user of the user.
  String? adminUser;

  /// The Google Translate of the user.
  String? googleTranslate;

  /// The signal server domain of the user.
  String? signalServerDomain;

  /// The notification help URL of the user.
  String? notificationHelpUrl;

  /// The SDK URL of the user.
  String? sdkUrl;

  /// The PIN expire days of the user.
  int? pinExpireDays;

  /// The PIN timeout of the user.
  int? pinTimeOut;

  /// The file size limit of the user.
  int? fileSizeLimit;

  /// The STUN servers of the user.
  List<String>? stuns;

  /// The TURN servers of the user.
  List<Turn>? turns;

  /// The live streaming signal server of the user.
  dynamic liveStreamingSignalServer;

  /// A boolean indicating if live streaming is enabled.
  bool? isLiveStreamingEnabled;

  /// A boolean indicating if SIP calling is enabled.
  bool? sipcallEnabled;

  /// The SIP server of the user.
  dynamic sipServer;

  /// The call routing server of the user.
  String? callRoutingServer;

  /// The chat backup type of the user.
  dynamic chatBackupType;

  /// The chat backup frequency of the user.
  dynamic chatBackupFrequency;

  /// The XMPP web port of the user.
  String? xmppPortWeb;

  /// The IV of the user.
  String? iv;

  /// The profile IV of the user.
  String? ivProfile;

  /// A boolean indicating if group chat is enabled.
  bool? groupChat;

  /// A boolean indicating if attachments are enabled.
  bool? attachment;

  /// A boolean indicating if image attachments are enabled.
  bool? imageAttachment;

  /// A boolean indicating if video attachments are enabled.
  bool? videoAttachment;

  /// A boolean indicating if audio attachments are enabled.
  bool? audioAttachment;

  /// A boolean indicating if document attachments are enabled.
  bool? documentAttachment;

  /// A boolean indicating if contact attachments are enabled.
  bool? contactAttachment;

  /// A boolean indicating if location attachments are enabled.
  bool? locationAttachment;

  /// A boolean indicating if one-to-one calls are enabled.
  bool? one2OneCall;

  /// A boolean indicating if group calls are enabled.
  bool? groupCall;

  /// A boolean indicating if recent chat search is enabled.
  bool? recentchatSearch;

  /// A boolean indicating if starred messages are enabled.
  bool? starMessage;

  /// A boolean indicating if chat clearing is enabled.
  bool? clearChat;

  /// A boolean indicating if chat deletion is enabled.
  bool? deleteChat;

  /// A boolean indicating if translation is enabled.
  bool? translation;

  /// A boolean indicating if blocking is enabled.
  bool? block;

  /// A boolean indicating if reporting is enabled.
  bool? report;

  /// A boolean indicating if message deletion is enabled.
  bool? deleteMessage;

  /// A boolean indicating if viewing all media is enabled.
  bool? viewAllMedias;

  /// A boolean indicating if chat history is enabled.
  bool? chatHistory;

  /// Initializes a new instance of the [Config] class.
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

  /// Converts a JSON object into a [Config] instance.
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

  /// Converts a [Config] instance into a JSON object.
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

/// Represents the TURN server details.
class Turn {
  /// The TURN server.
  String? turn;

  /// The username for the TURN server.
  String? username;

  /// The password for the TURN server.
  String? password;

  /// Initializes a new instance of the [Turn] class.
  Turn({
    this.turn,
    this.username,
    this.password,
  });

  /// Converts a JSON object into a [Turn] instance.
  factory Turn.fromJson(Map<String, dynamic> json) => Turn(
        turn: json["turn"],
        username: json["username"],
        password: json["password"],
      );

  /// Converts a [Turn] instance into a JSON object.
  Map<String, dynamic> toJson() => {
        "turn": turn,
        "username": username,
        "password": password,
      };
}
