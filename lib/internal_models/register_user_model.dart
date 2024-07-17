// To parse this JSON data, do
//
//     final registerModel = registerModelFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

/// Converts a JSON string into a [RegisterModel] object.
///
/// This function decodes the provided JSON string into a map and then uses the [RegisterModel.fromJson]
/// constructor to create a [RegisterModel] object.
///
/// Parameters:
///   [str] - A JSON string representing a register model.
///
/// Returns:
///   A [RegisterModel] object.
RegisterModel registerModelFromJson(String str) =>
    RegisterModel.fromJson(json.decode(str));

/// Converts a [RegisterModel] object into a JSON string.
///
/// This function takes a [RegisterModel] object, converts it to a map using the [toJson] method,
/// and then encodes the map as a JSON string.
///
/// Parameters:
///   [data] - A [RegisterModel] object.
///
/// Returns:
///   A JSON string representing the register model.
String registerModelToJson(RegisterModel data) => json.encode(data.toJson());

/// Converts a JSON string into a JSON string representing a [RegisterModel] object.
///
/// This function checks if the provided string is null or empty. If it is, it returns an empty string.
/// Otherwise, it converts the string into a [RegisterModel] object using [registerModelFromJson],
/// and then back into a JSON string using [registerModelToJson].
///
/// Parameters:
///   [str] - A JSON string or null.
///
/// Returns:
///   A JSON string representing a [RegisterModel] object, or an empty string if the input is null or empty.
String convertRegisterUserJsonFromString(String? str) =>
    (str == null || str.isEmpty)
        ? ""
        : json.encode(registerModelFromJson(str).toJson());

/// Represents the model for registering a user.
///
/// This class encapsulates the data related to a user registration, including the user's JID, registration data,
/// a flag indicating if the user is new, and a message.
///
/// Properties:
///   [userJid] - The Jabber ID (JID) of the user.
///   [data] - The registration data as a [Data] object.
///   [isNewUser] - A boolean indicating if the user is new.
///   [message] - A message related to the registration process.
///
/// Constructors:
///   [RegisterModel] - Initializes a new instance of the [RegisterModel] class with optional parameters for user JID,
///                     registration data, new user flag, and message.
class RegisterModel {
  /// The Jabber ID (JID) of the user.
  String? userJid;

  /// The registration data as a [Data] object.
  Data? data;

  /// A boolean indicating if the user is new.
  bool? isNewUser;

  /// A message related to the registration process.
  String? message;

  /// Initializes a new instance of the [RegisterModel] class.
  RegisterModel({
    this.userJid,
    this.data,
    this.isNewUser,
    this.message,
  });

  /// Converts a map into a [RegisterModel] object.
  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
        userJid: Platform.isAndroid ? json["userJid"] : json["data"]["userJid"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        isNewUser: json["is_new_user"],
        message: Platform.isAndroid ? json["message"] : "Register Success",
      );

  /// Converts a [RegisterModel] object into a map.
  Map<String, dynamic> toJson() => {
        "userJid": userJid,
        "data": data?.toJson(),
        "is_new_user": isNewUser,
        "message": message,
      };
}

/// Represents the data model for a user registration.
class Data {
  /// The user's token.
  String? token;

  /// The user's username.
  String? username;

  /// The user's password.
  String? password;

  /// A flag indicating if the user already exists.
  bool? isExisting;

  /// A flag indicating if the user's profile has been updated.
  bool? isProfileUpdated;

  /// The user's configuration data.
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

  /// Converts a map into a [Data] object.
  factory Data.fromJson(Map<String, dynamic> json) => Data(
        token: json["token"],
        username: json["username"],
        password: json["password"],
        isExisting: json["isExisting"],
        isProfileUpdated: json["isProfileUpdated"],
        config: json["config"] == null ? null : Config.fromJson(json["config"]),
      );

  /// Converts a [Data] object into a map.
  Map<String, dynamic> toJson() => {
        "token": token,
        "username": username,
        "password": password,
        "isExisting": isExisting,
        "isProfileUpdated": isProfileUpdated,
        "config": config?.toJson(),
      };
}

/// Represents the configuration data for a user.
class Config {
  /// The domain of the user.
  String? domain;

  /// The video limit for the user.
  int? videoLimit;

  /// The audio limit for the user.
  int? audioLimit;

  /// The recall time for the user.
  int? recallTime;

  /// The private time for the user.
  int? privateTime;

  /// The XMPP domain for the user.
  String? xmppDomain;

  /// The XMPP host for the user.
  String? xmppHost;

  /// The XMPP port for the user.
  int? xmppPort;

  /// The admin user for the user.
  String? adminUser;

  /// The Google Translate data for the user.
  String? googleTranslate;

  /// The signal server domain for the user.
  String? signalServerDomain;

  /// The notification help URL for the user.
  String? notificationHelpUrl;

  /// The SDK URL for the user.
  String? sdkUrl;

  /// The number of days before a PIN expires.
  int? pinExpireDays;

  /// The timeout for a PIN.
  int? pinTimeOut;

  /// The file size limit for the user.
  int? fileSizeLimit;

  /// The STUN servers for the user.
  List<String>? stuns;

  /// The TURN servers for the user.
  List<Turn>? turns;

  /// The live streaming signal server for the user.
  dynamic liveStreamingSignalServer;

  /// A flag indicating if live streaming is enabled for the user.
  bool? isLiveStreamingEnabled;

  /// A flag indicating if SIP calling is enabled for the user.
  bool? sipcallEnabled;

  /// The SIP server for the user.
  dynamic sipServer;

  /// The call routing server for the user.
  String? callRoutingServer;

  /// The chat backup type for the user.
  dynamic chatBackupType;

  /// The chat backup frequency for the user.
  dynamic chatBackupFrequency;

  /// The XMPP port for the user's web connection.
  String? xmppPortWeb;

  /// The IV for the user.
  String? iv;

  /// The IV for the user's profile.
  String? ivProfile;

  /// A flag indicating if group chat is enabled for the user.
  bool? groupChat;

  /// A flag indicating if attachments are enabled for the user.
  bool? attachment;

  /// A flag indicating if image attachments are enabled for the user.
  bool? imageAttachment;

  /// A flag indicating if video attachments are enabled for the user.
  bool? videoAttachment;

  /// A flag indicating if audio attachments are enabled for the user.
  bool? audioAttachment;

  /// A flag indicating if document attachments are enabled for the user.
  bool? documentAttachment;

  /// A flag indicating if contact attachments are enabled for the user.
  bool? contactAttachment;

  /// A flag indicating if location attachments are enabled for the user.
  bool? locationAttachment;

  /// A flag indicating if one-to-one calling is enabled for the user.
  bool? one2OneCall;

  /// A flag indicating if group calling is enabled for the user.
  bool? groupCall;

  /// A flag indicating if recent chat search is enabled for the user.
  bool? recentchatSearch;

  /// A flag indicating if starred messages are enabled for the user.
  bool? starMessage;

  /// A flag indicating if chat clearing is enabled for the user.
  bool? clearChat;

  /// A flag indicating if chat deletion is enabled for the user.
  bool? deleteChat;

  /// A flag indicating if translation is enabled for the user.
  bool? translation;

  /// A flag indicating if blocking is enabled for the user.
  bool? block;

  /// A flag indicating if reporting is enabled for the user.
  bool? report;

  /// A flag indicating if message deletion is enabled for the user.
  bool? deleteMessage;

  /// A flag indicating if viewing all media is enabled for the user.
  bool? viewAllMedias;

  /// A flag indicating if chat history is enabled for the user.
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

  /// Converts a map into a [Config] object.
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

  /// Converts a [Config] object into a map.
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

/// Represents the TURN server data for a user.
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

  /// Converts a map into a [Turn] object.
  factory Turn.fromJson(Map<String, dynamic> json) => Turn(
        turn: json["turn"],
        username: json["username"],
        password: json["password"],
      );

  /// Converts a [Turn] object into a map.
  Map<String, dynamic> toJson() => {
        "turn": turn,
        "username": username,
        "password": password,
      };
}
