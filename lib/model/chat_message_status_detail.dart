import 'dart:convert';

ChatMessageStatusDetail chatMessageStatusDetailFromJson(String str) =>
    ChatMessageStatusDetail.fromJson(json.decode(str));

String chatMessageStatusDetailToJson(ChatMessageStatusDetail data) =>
    json.encode(data.toJson());

class ChatMessageStatusDetail {
  String? deliveredTime;
  String? messageId;
  String? seenTime;
  String? sentTime;

  ChatMessageStatusDetail({
    this.deliveredTime,
    this.messageId,
    this.seenTime,
    this.sentTime,
  });

  factory ChatMessageStatusDetail.fromJson(Map<String, dynamic> json) =>
      ChatMessageStatusDetail(
        deliveredTime: json["deliveredTime"],
        messageId: json["messageId"],
        seenTime: json["seenTime"],
        sentTime: json["sentTime"],
      );

  Map<String, dynamic> toJson() => {
        "deliveredTime": deliveredTime,
        "messageId": messageId,
        "seenTime": seenTime,
        "sentTime": sentTime,
      };
}
