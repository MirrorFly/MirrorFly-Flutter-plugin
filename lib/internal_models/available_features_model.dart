// To parse this JSON data, do
//
//     final availableFeatures = availableFeaturesFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

/// Converts a JSON string into an [AvailableFeatures] object.
///
/// This function decodes a JSON string to a Map, and then creates an
/// [AvailableFeatures] object from it using the `fromJson` factory constructor.
///
/// [str]: The JSON string to be converted.
///
/// Returns an [AvailableFeatures] object.
AvailableFeatures availableFeaturesFromJson(String str) =>
    AvailableFeatures.fromJson(json.decode(str));

/// Converts an [AvailableFeatures] object to a JSON string.
///
/// This function takes an [AvailableFeatures] object, converts it to a Map
/// using the `toJson` method, and then encodes this Map as a JSON string.
///
/// [data]: The [AvailableFeatures] object to be converted.
///
/// Returns a JSON string representation of the [AvailableFeatures] object.
String availableFeaturesToJson(AvailableFeatures data) =>
    json.encode(data.toJson());

/// Converts a JSON string to a JSON string representation of an [AvailableFeatures] object.
///
/// This function is a convenience wrapper that first converts a JSON string to an
/// [AvailableFeatures] object and then back to a JSON string. It is useful for
/// ensuring the JSON string represents a valid [AvailableFeatures] object.
///
/// [str]: The JSON string to be converted.
///
/// Returns a JSON string representation of the [AvailableFeatures] object.
String availableFeaturesMapToJson(String str) =>
    availableFeaturesToJson(AvailableFeatures.fromJson(json.decode(str)));

/// Converts a nullable JSON string to a JSON string representation of an [AvailableFeatures] object, or an empty string if null or empty.
///
/// This function checks if the input string is null or empty. If it is, it returns an empty string.
/// Otherwise, it converts the string to an [AvailableFeatures] object and then back to a JSON string.
///
/// [str]: The nullable JSON string to be converted.
///
/// Returns a JSON string representation of the [AvailableFeatures] object if [str] is not null or empty; otherwise, returns an empty string.
String convertAvailableFeaturesToJson(String? str) =>
    (str == null || str.isEmpty)
        ? ""
        : availableFeaturesToJson(availableFeaturesFromJson(str));

/// Provides functionality to parse and manage available features from JSON.
///
/// This class handles the conversion of JSON data into an [AvailableFeatures] object,
/// allowing easy access to various feature flags that indicate the availability of
/// specific functionalities within the application. It supports conditional parsing
/// for platform-specific feature availability.
///
/// Example usage:
/// ```dart
/// AvailableFeatures features = availableFeaturesFromJson(jsonString);
/// print(features.isLocationAttachmentAvailable); // true or false based on platform and JSON
/// ```
class AvailableFeatures {
  /// Indicates whether location attachment is available.
  bool? isLocationAttachmentAvailable;

  /// Indicates whether clearing chat is available.
  bool? isClearChatAvailable;

  /// Indicates whether deleting chat is available.
  bool? isDeleteChatAvailable;

  /// Indicates whether video attachment is available.
  bool? isVideoAttachmentAvailable;

  /// Indicates whether one-to-one call is available.
  bool? isOneToOneCallAvailable;

  /// Indicates whether translation is available.
  bool? isTranslationAvailable;

  /// Indicates whether viewing all media is available.
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

  /// Indicates whether starring messages is available.
  bool? isStarMessageAvailable;

  /// Indicates whether any form of attachment is available.
  bool? isAttachmentAvailable;

  /// Indicates whether audio attachment is available.
  bool? isAudioAttachmentAvailable;

  /// Indicates whether blocking users is available.
  bool? isBlockAvailable;

  /// Indicates whether reporting is available.
  bool? isReportAvailable;

  /// Indicates whether deleting messages is available.
  bool? isDeleteMessageAvailable;

  /// Indicates whether accessing chat history is available.
  bool? isChatHistoryAvailable;

  /// Constructs an [AvailableFeatures] instance from a JSON map.
  ///
  /// The constructor uses platform checks to determine the correct keys to use
  /// for initializing the instance variables. This allows for flexible JSON structures
  /// that may vary between platforms (iOS and Android).
  ///
  /// [json]: The JSON map containing the feature flags.

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

  /// Creates an [AvailableFeatures] instance from a JSON map.
  ///
  /// This factory constructor parses a JSON map and creates an [AvailableFeatures]
  /// instance. It uses platform-specific logic to accommodate differences in JSON
  /// structure between iOS and Android.
  ///
  /// [json]: The JSON map to parse.
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

  /// Converts an [AvailableFeatures] instance to a JSON map.
  ///
  /// This method serializes the [AvailableFeatures] instance into a JSON map,
  /// making it easy to encode the feature flags into a JSON string for storage
  /// or transmission.
  ///
  /// Returns a JSON map representation of the [AvailableFeatures] instance.
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
