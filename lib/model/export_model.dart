// To parse this JSON data, do
//
//     final exportModel = exportModelFromJson(jsonString);

import 'dart:convert';

ExportModel exportModelFromJson(String str) =>
    ExportModel.fromJson(json.decode(str));

String exportModelToJson(ExportModel data) => json.encode(data.toJson());

class ExportModel {
  String? subject;
  String? messageContent;
  List<String>? mediaAttachmentsUrl;

  ExportModel({
    this.subject,
    this.messageContent,
    this.mediaAttachmentsUrl,
  });

  factory ExportModel.fromJson(Map<String, dynamic> json) => ExportModel(
        subject: json["subject"],
        messageContent: json["messageContent"],
        mediaAttachmentsUrl: json["mediaAttachmentsUrl"] == null
            ? []
            : List<String>.from(json["mediaAttachmentsUrl"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "subject": subject,
        "messageContent": messageContent,
        "mediaAttachmentsUrl": mediaAttachmentsUrl == null
            ? []
            : List<dynamic>.from(mediaAttachmentsUrl!.map((x) => x)),
      };
}
