// To parse this JSON data, do
//
//     final exportModel = exportModelFromJson(jsonString);

import 'dart:convert';

/// Converts a JSON string into an [ExportModel] object.
///
/// This function decodes the provided JSON string into a map,
/// and then uses the [ExportModel.fromJson] factory constructor to create an [ExportModel] object.
///
/// [str]: The JSON string to be decoded.
///
/// Returns an [ExportModel] object.
ExportModel exportModelFromJson(String str) =>
    ExportModel.fromJson(json.decode(str));

/// Converts an [ExportModel] object into a JSON string.
///
/// This function takes the provided [ExportModel] object,
/// converts it to a JSON map using the [toJson] method, and then encodes the map as a JSON string.
///
/// [data]: The [ExportModel] object to be converted.
///
/// Returns a JSON string representation of the [ExportModel].
String exportModelToJson(ExportModel data) => json.encode(data.toJson());

/// Converts a nullable JSON string into a non-nullable JSON string representing an [ExportModel].
///
/// If the input string is null or empty, this function returns an empty string.
/// Otherwise, it decodes the string into an [ExportModel] object using [exportModelFromJson],
/// and then serializes the object back into a JSON string using [exportModelToJson].
///
/// [str]: The nullable JSON string to convert.
///
/// Returns a non-nullable JSON string.
String convertExportJsonFromString(String? str) => (str == null || str.isEmpty)
    ? ""
    : exportModelToJson(exportModelFromJson(str));

/// Represents an export model with a subject, message content, and media attachments.
class ExportModel {
  /// The subject of the export.
  String? subject;

  /// The content of the message.
  String? messageContent;

  /// The URLs of the media attachments.
  List<String>? mediaAttachmentsUrl;

  /// Constructs an instance of [ExportModel].
  ExportModel({
    this.subject,
    this.messageContent,
    this.mediaAttachmentsUrl,
  });

  /// Creates an [ExportModel] object from a JSON map.
  factory ExportModel.fromJson(Map<String, dynamic> json) => ExportModel(
        subject: json["subject"],
        messageContent: json["messageContent"],
        mediaAttachmentsUrl: json["mediaAttachmentsUrl"] == null
            ? []
            : List<String>.from(json["mediaAttachmentsUrl"]!.map((x) => x)),
      );

  /// Converts an [ExportModel] object to a JSON map.
  Map<String, dynamic> toJson() => {
        "subject": subject,
        "messageContent": messageContent,
        "mediaAttachmentsUrl": mediaAttachmentsUrl == null
            ? []
            : List<dynamic>.from(mediaAttachmentsUrl!.map((x) => x)),
      };
}
