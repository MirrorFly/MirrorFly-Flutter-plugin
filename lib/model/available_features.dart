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
  bool? isRecentChatSearchAvailable;
  bool? isImageAttachmentAvailable;
  bool? isGroupChatAvailable;
  bool? isContactAttachmentAvailable;
  bool? isStarMessageAvailable;
  bool? isAttachmentAvailable;
  bool? isAudioAttachmentAvailable;
  bool? isBlockAvailable;
  bool? isReportAvailable;
  bool? isDeleteMessageAvailable;

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
    this.isRecentChatSearchAvailable,
    this.isImageAttachmentAvailable,
    this.isGroupChatAvailable,
    this.isContactAttachmentAvailable,
    this.isStarMessageAvailable,
    this.isAttachmentAvailable,
    this.isAudioAttachmentAvailable,
    this.isBlockAvailable,
    this.isReportAvailable,
    this.isDeleteMessageAvailable,
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
    isRecentChatSearchAvailable: json["recentchatSearch"],
    isImageAttachmentAvailable: json["imageAttachment"],
    isGroupChatAvailable: json["groupChat"],
    isContactAttachmentAvailable: json["contactAttachment"],
    isStarMessageAvailable: json["starMessage"],
    isAttachmentAvailable: json["attachment"],
    isAudioAttachmentAvailable: json["audioAttachment"],
    isBlockAvailable: json["block"],
    isReportAvailable: json["report"],
    isDeleteMessageAvailable: json["deleteMessage"],
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
    "recentchatSearch": isRecentChatSearchAvailable,
    "imageAttachment": isImageAttachmentAvailable,
    "groupChat": isGroupChatAvailable,
    "contactAttachment": isContactAttachmentAvailable,
    "starMessage": isStarMessageAvailable,
    "attachment": isAttachmentAvailable,
    "audioAttachment": isAudioAttachmentAvailable,
    "block": isBlockAvailable,
    "report": isReportAvailable,
    "deleteMessage": isDeleteMessageAvailable,
  };
}
