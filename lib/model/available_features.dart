// To parse this JSON data, do
//
//     final availableFeatures = availableFeaturesFromJson(jsonString);

import 'dart:convert';

AvailableFeatures availableFeaturesFromJson(String str) => AvailableFeatures.fromJson(json.decode(str));

String availableFeaturesToJson(AvailableFeatures data) => json.encode(data.toJson());

class AvailableFeatures {
  bool? isLocationAttachmentAvailable;
  bool? isClearChatAvailable;
  bool? isDeleteChatAvailable;
  bool? isVideoAttachmentAvailable;
  bool? isOneToOneCallAvailable;
  bool? isTranslationAvailable;
  bool? isViewAllMediasAvailable;
  bool? isDocumentAttachmentAvailable;
  bool? isGroupCallAvailable;
  bool? recentChatSearch;
  bool? imageAttachment;
  bool? groupChat;
  bool? contactAttachment;
  bool? starMessage;
  bool? attachment;
  bool? audioAttachment;
  bool? block;
  bool? report;
  bool? deleteMessage;

  AvailableFeatures({
    this.isLocationAttachmentAvailable,
    this.isClearChatAvailable,
    this.isDeleteChatAvailable,
    this.isVideoAttachmentAvailable,
    this.isOneToOneCallAvailable,
    this.isTranslationAvailable,
    this.isViewAllMediasAvailable,
    this.isDocumentAttachmentAvailable,
    this.isGroupCallAvailable,
    this.recentChatSearch,
    this.imageAttachment,
    this.groupChat,
    this.contactAttachment,
    this.starMessage,
    this.attachment,
    this.audioAttachment,
    this.block,
    this.report,
    this.deleteMessage,
  });

  factory AvailableFeatures.fromJson(Map<String, dynamic> json) => AvailableFeatures(
    isLocationAttachmentAvailable: json["locationAttachment"],
    isClearChatAvailable: json["clearChat"],
    isDeleteChatAvailable: json["deleteChat"],
    isVideoAttachmentAvailable: json["videoAttachment"],
    isOneToOneCallAvailable: json["one2oneCall"],
    isTranslationAvailable: json["translation"],
    isViewAllMediasAvailable: json["viewAllMedias"],
    isDocumentAttachmentAvailable: json["documentAttachment"],
    isGroupCallAvailable: json["groupCall"],
    recentChatSearch: json["recentchatSearch"],
    imageAttachment: json["imageAttachment"],
    groupChat: json["groupChat"],
    contactAttachment: json["contactAttachment"],
    starMessage: json["starMessage"],
    attachment: json["attachment"],
    audioAttachment: json["audioAttachment"],
    block: json["block"],
    report: json["report"],
    deleteMessage: json["deleteMessage"],
  );

  Map<String, dynamic> toJson() => {
    "locationAttachment": isLocationAttachmentAvailable,
    "clearChat": isClearChatAvailable,
    "deleteChat": isDeleteChatAvailable,
    "videoAttachment": isVideoAttachmentAvailable,
    "one2oneCall": isOneToOneCallAvailable,
    "translation": isTranslationAvailable,
    "viewAllMedias": isViewAllMediasAvailable,
    "documentAttachment": isDocumentAttachmentAvailable,
    "groupCall": isGroupCallAvailable,
    "recentchatSearch": recentChatSearch,
    "imageAttachment": imageAttachment,
    "groupChat": groupChat,
    "contactAttachment": contactAttachment,
    "starMessage": starMessage,
    "attachment": attachment,
    "audioAttachment": audioAttachment,
    "block": block,
    "report": report,
    "deleteMessage": deleteMessage,
  };
}
