// To parse this JSON data, do
//
//     final availableFeatures = availableFeaturesFromJson(jsonString);

import 'dart:convert';

/// Converts a JSON string into an [AvailableFeatures] object.
///
/// This function decodes the given JSON string and uses the [fromJson] constructor
/// of the [AvailableFeatures] class to create an instance.
///
/// Parameters:
///   [str] - A JSON string representation of an [AvailableFeatures] object.
///
/// Returns:
///   An instance of [AvailableFeatures] populated with data from the given JSON string.
AvailableFeatures availableFeaturesFromJson(String str) =>
    AvailableFeatures.fromJson(json.decode(str));

/// Converts an [AvailableFeatures] object into a JSON string.
///
/// This function takes an [AvailableFeatures] object, converts it into a map
/// using the [toJson] method, and then encodes this map as a JSON string.
///
/// Parameters:
///   [data] - The [AvailableFeatures] object to be converted into a JSON string.
///
/// Returns:
///   A JSON string representation of the [AvailableFeatures] object.
String availableFeaturesToJson(AvailableFeatures data) =>
    json.encode(data.toJson());

/// Converts a JSON string into a JSON string representation of an [AvailableFeatures] object.
///
/// This function is a convenience wrapper around [availableFeaturesFromJson] and [availableFeaturesToJson].
/// It decodes the given JSON string to an [AvailableFeatures] object and then encodes this object back into a JSON string.
///
/// Parameters:
///   [str] - A JSON string representation of an [AvailableFeatures] object.
///
/// Returns:
///   A JSON string representation of the [AvailableFeatures] object.
String availableFeaturesMapToJson(String str) =>
    availableFeaturesToJson(AvailableFeatures.fromJson(json.decode(str)));

/// Represents the available features in a chat application.
class AvailableFeatures {

  /// Indicates whether location attachment is available.
  bool? isLocationAttachmentAvailable;

  /// Indicates whether the clear chat feature is available.
  bool? isClearChatAvailable;

  /// Indicates whether the delete chat feature is available.
  bool? isDeleteChatAvailable;

  /// Indicates whether video attachment is available.
  bool? isVideoAttachmentAvailable;

  /// Indicates whether one-to-one call is available.
  bool? isOneToOneCallAvailable;

  /// Indicates whether translation is available.
  bool? isTranslationAvailable;

  /// Indicates whether view all media is available.
  bool? isViewAllMediaAvailable;

  /// Indicates whether document attachment is available.
  bool? isDocumentAttachmentAvailable;

  /// Indicates whether group call is available.
  bool? isGroupCallAvailable;

  /// Indicates whether recent chat search is available.
  bool? isRecentChatSearchAvailable;

  /// Indicates whether image attachment is available.
  bool? isImageAttachmentAvailable;

  /// Indicates whether group chat is available.
  bool? isGroupChatAvailable;

  /// Indicates whether contact attachment is available.
  bool? isContactAttachmentAvailable;

  /// Indicates whether star message is available.
  bool? isStarMessageAvailable;

  /// Indicates whether attachment is available.
  bool? isAttachmentAvailable;

  /// Indicates whether audio attachment is available.
  bool? isAudioAttachmentAvailable;

  /// Indicates whether block is available.
  bool? isBlockAvailable;

  /// Indicates whether report is available.
  bool? isReportAvailable;

  /// Indicates whether delete message is available.
  bool? isDeleteMessageAvailable;

  /// Indicates whether chat history is available.
  bool? isChatHistoryAvailable;

  /// Initializes a new instance of the [AvailableFeatures] class.
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

  /// Converts a map into an [AvailableFeatures] object.
  factory AvailableFeatures.fromJson(Map<String, dynamic> json) =>
      AvailableFeatures(
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

  /// Converts an [AvailableFeatures] object into a map.
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
