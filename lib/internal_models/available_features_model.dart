// To parse this JSON data, do
//
//     final availableFeatures = availableFeaturesFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

AvailableFeatures availableFeaturesFromJson(String str) =>
    AvailableFeatures.fromJson(json.decode(str));

String availableFeaturesToJson(AvailableFeatures data) =>
    json.encode(data.toJson());
String availableFeaturesMapToJson(String str) =>
    availableFeaturesToJson(AvailableFeatures.fromJson(json.decode(str)));

String convertAvailableFeaturesToJson(String? str) => (str == null || str.isEmpty) ? "" : availableFeaturesToJson(availableFeaturesFromJson(str));


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

  factory AvailableFeatures.fromJson(Map<String, dynamic> json) =>
      AvailableFeatures(
        isLocationAttachmentAvailable: Platform.isIOS
            ? json["locationAttachment"]
            : json["isLocationAttachmentEnabled"],
        isClearChatAvailable:
            Platform.isIOS ? json["clearChat"] : json["isClearChatEnabled"],
        isDeleteChatAvailable:
            Platform.isIOS ? json["deleteChat"] : json["isDeleteChatEnabled"],
        isVideoAttachmentAvailable: Platform.isIOS
            ? json["videoAttachment"]
            : json["isVideoAttachmentEnabled"],
        isOneToOneCallAvailable: Platform.isIOS
            ? json["one2oneCall"]
            : json["isOneToOneCallEnabled"],
        isTranslationAvailable:
            Platform.isIOS ? json["translation"] : json["isTranslationEnabled"],
        isViewAllMediaAvailable: Platform.isIOS
            ? json["viewAllMedias"]
            : json["isViewAllMediaEnabled"],
        isDocumentAttachmentAvailable: Platform.isIOS
            ? json["documentAttachment"]
            : json["isDocumentAttachmentEnabled"],
        isGroupCallAvailable:
            Platform.isIOS ? json["groupCall"] : json["isGroupCallEnabled"],
        isRecentChatSearchAvailable: Platform.isIOS
            ? json["recentchatSearch"]
            : json["isRecentChatSearchEnabled"],
        isImageAttachmentAvailable: Platform.isIOS
            ? json["imageAttachment"]
            : json["isImageAttachmentEnabled"],
        isGroupChatAvailable:
            Platform.isIOS ? json["groupChat"] : json["isGroupChatEnabled"],
        isContactAttachmentAvailable: Platform.isIOS
            ? json["contactAttachment"]
            : json["isContactAttachmentEnabled"],
        isStarMessageAvailable:
            Platform.isIOS ? json["starMessage"] : json["isStarMessageEnabled"],
        isAttachmentAvailable:
            Platform.isIOS ? json["attachment"] : json["isAttachmentEnabled"],
        isAudioAttachmentAvailable: Platform.isIOS
            ? json["audioAttachment"]
            : json["isAudioAttachmentEnabled"],
        isBlockAvailable:
            Platform.isIOS ? json["block"] : json["isBlockEnabled"],
        isReportAvailable:
            Platform.isIOS ? json["report"] : json["isReportEnabled"],
        isDeleteMessageAvailable: Platform.isIOS
            ? json["deleteMessage"]
            : json["isDeleteMessageEnabled"],
        isChatHistoryAvailable:
            Platform.isIOS ? json["chatHistory"] : json["isChatHistoryEnabled"],
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
