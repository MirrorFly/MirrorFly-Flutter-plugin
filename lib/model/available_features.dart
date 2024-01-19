// To parse this JSON data, do
//
//     final availableFeatures = availableFeaturesFromJson(jsonString);

import 'dart:convert';

AvailableFeatures availableFeaturesFromJson(String str) => AvailableFeatures.fromJson(json.decode(str));

String availableFeaturesToJson(AvailableFeatures data) => json.encode(data.toJson());

String availableFeaturesMapToJson(String str) => availableFeaturesToJson(AvailableFeatures.fromJson(json.decode(str)));

class AvailableFeatures {
  bool? isLocationAttachmentAvailable;
  bool? isClearChatAvailable;
  bool? isDeleteChatAvailable;
  bool? isVideoAttachmentAvailable;
  bool? isOneToOneCallAvailable;
  bool? isTranslationAvailable;
  bool? isViewAllMediaAvailable;
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
  bool? isChatHistoryAvailable;

  AvailableFeatures({
    this.isLocationAttachmentAvailable,
    this.isClearChatAvailable,
    this.isDeleteChatAvailable,
    this.isVideoAttachmentAvailable,
    this.isOneToOneCallAvailable,
    this.isTranslationAvailable,
    this.isViewAllMediaAvailable,
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
    this.isChatHistoryAvailable,
  });

  factory AvailableFeatures.fromJson(Map<String, dynamic> json) => AvailableFeatures(
        isLocationAttachmentAvailable: json["isLocationAttachmentEnabled"],
        isClearChatAvailable: json["isClearChatEnabled"],
        isDeleteChatAvailable: json["isDeleteChatEnabled"],
        isVideoAttachmentAvailable: json["isVideoAttachmentEnabled"],
        isOneToOneCallAvailable: json["isOneToOneCallEnabled"],
        isTranslationAvailable: json["isTranslationEnabled"],
        isViewAllMediaAvailable: json["isViewAllMediaEnabled"],
        isDocumentAttachmentAvailable: json["isDocumentAttachmentEnabled"],
        isGroupCallAvailable: json["isGroupCallEnabled"],
        isRecentChatSearchAvailable: json["isRecentChatSearchEnabled"],
        isImageAttachmentAvailable: json["isImageAttachmentEnabled"],
        isGroupChatAvailable: json["isGroupChatEnabled"],
        isContactAttachmentAvailable: json["isContactAttachmentEnabled"],
        isStarMessageAvailable: json["isStarMessageEnabled"],
        isAttachmentAvailable: json["isAttachmentEnabled"],
        isAudioAttachmentAvailable: json["isAudioAttachmentEnabled"],
        isBlockAvailable: json["isBlockEnabled"],
        isReportAvailable: json["isReportEnabled"],
        isDeleteMessageAvailable: json["isDeleteMessageEnabled"],
        isChatHistoryAvailable: json["isChatHistoryEnabled"],
      );

  Map<String, dynamic> toJson() => {
        "isLocationAttachmentEnabled": isLocationAttachmentAvailable,
        "isClearChatEnabled": isClearChatAvailable,
        "isDeleteChatEnabled": isDeleteChatAvailable,
        "isVideoAttachmentEnabled": isVideoAttachmentAvailable,
        "isOneToOneCallEnabled": isOneToOneCallAvailable,
        "isTranslationEnabled": isTranslationAvailable,
        "isViewAllMediaEnabled": isViewAllMediaAvailable,
        "isDocumentAttachmentEnabled": isDocumentAttachmentAvailable,
        "isGroupCallEnabled": isGroupCallAvailable,
        "isRecentChatSearchEnabled": isRecentChatSearchAvailable,
        "isImageAttachmentEnabled": isImageAttachmentAvailable,
        "isGroupChatEnabled": isGroupChatAvailable,
        "isContactAttachmentEnabled": isContactAttachmentAvailable,
        "isStarMessageEnabled": isStarMessageAvailable,
        "isAttachmentEnabled": isAttachmentAvailable,
        "isAudioAttachmentEnabled": isAudioAttachmentAvailable,
        "isBlockEnabled": isBlockAvailable,
        "isReportEnabled": isReportAvailable,
        "isDeleteMessageEnabled": isDeleteMessageAvailable,
        "isChatHistoryEnabled": isChatHistoryAvailable,
      };
}
