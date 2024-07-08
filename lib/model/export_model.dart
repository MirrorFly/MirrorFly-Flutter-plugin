// To parse this JSON data, do
//
//     final exportModel = exportModelFromJson(jsonString);

import 'dart:convert';

/// Converts a JSON string into an [ExportModel] object.
///
/// This function decodes the given JSON string and uses the [fromJson] constructor
/// of the [ExportModel] class to create an instance.
///
/// Parameters:
///   [str] - A JSON string representation of an [ExportModel] object.
///
/// Returns:
///   An instance of [ExportModel] populated with data from the given JSON string.
ExportModel exportModelFromJson(String str) =>
    ExportModel.fromJson(json.decode(str));

/// Converts an [ExportModel] object into a JSON string.
///
/// This function takes an [ExportModel] object, converts it into a map
/// using the [toJson] method, and then encodes this map as a JSON string.
///
/// Parameters:
///   [data] - The [ExportModel] object to be converted into a JSON string.
///
/// Returns:
///   A JSON string representation of the [ExportModel] object.
String exportModelToJson(ExportModel data) => json.encode(data.toJson());

/// Represents the data to be exported.
class ExportModel {

  /// The subject of the message.
  String? subject;

  /// The content of the message.
  String? messageContent;

  /// The URLs of the media attachments.
  List<String>? mediaAttachmentsUrl;

  /// Initializes a new instance of the [ExportModel] class.
  ExportModel({
    this.subject,
    this.messageContent,
    this.mediaAttachmentsUrl,
  });

  /// Converts a JSON object into an [ExportModel] instance.
  factory ExportModel.fromJson(Map<String, dynamic> json) => ExportModel(
        subject: json["subject"],
        messageContent: json["messageContent"],
        mediaAttachmentsUrl: json["mediaAttachmentsUrl"] == null
            ? []
            : List<String>.from(json["mediaAttachmentsUrl"]!.map((x) => x)),
      );

  /// Converts an [ExportModel] instance into a JSON object.
  Map<String, dynamic> toJson() => {
        "subject": subject,
        "messageContent": messageContent,
        "mediaAttachmentsUrl": mediaAttachmentsUrl == null
            ? []
            : List<dynamic>.from(mediaAttachmentsUrl!.map((x) => x)),
      };
}
