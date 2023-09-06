// To parse this JSON data, do
//
//     final topics = topicsFromJson(jsonString);

import 'dart:convert';

List<Topics> topicsFromJson(String str) => List<Topics>.from(json.decode(str).map((x) => Topics.fromJson(x)));

String topicsToJson(List<Topics> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Topics {
  String? topicName;
  String? topicId;
  dynamic metaData;

  Topics({
    this.topicName,
    this.topicId,
    this.metaData,
  });

  factory Topics.fromJson(Map<String, dynamic> json) => Topics(
        topicName: json["topicName"],
        topicId: json["topicId"],
        metaData: json["metaData"],
      );

  Map<String, dynamic> toJson() => {
        "topicName": topicName,
        "topicId": topicId,
        "metaData": metaData,
      };
}
