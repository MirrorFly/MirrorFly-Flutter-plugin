import 'dart:convert';

class TopicMetaData {
  TopicMetaData({required this.key, required this.value});

  String key;
  String value;
}

extension ExtractTopicData on TopicMetaData {
  Map<String, dynamic> toMap() => {'key': key, 'value': value};
}

List<IdentifierMetaData> identifierMetaDataFromJson(String str) =>
    List<IdentifierMetaData>.from(
        json.decode(str).map((x) => IdentifierMetaData.fromJson(x)));

String identifierMetaDataToJson(List<IdentifierMetaData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class IdentifierMetaData {
  IdentifierMetaData({required this.key, required this.value});

  String key;
  String value;

  factory IdentifierMetaData.fromJson(Map<String, dynamic> json) =>
      IdentifierMetaData(
        key: json["key"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
      };
}

extension IdentifierMetaDataToMap on IdentifierMetaData {
  Map<String, dynamic> toMap() => {'key': key, 'value': value};
}

extension IdentifierMetaDataListToMap on List<IdentifierMetaData> {
  String toJson() => json.encode(List<dynamic>.from(map((x) => x.toJson())));
}

class MetaDataUserList {
  MetaDataUserList({required this.key, required this.value});

  String key;
  List<String> value;
}

extension MetaDataUserListToMap on MetaDataUserList {
  Map<String, dynamic> toMap() => {'key': key, 'value': value};
}

class MetaDataMessageList {
  MetaDataMessageList({required this.key, required this.value});

  String key;
  List<String> value;
}

extension MetaDataMessageListToMap on MetaDataMessageList {
  Map<String, dynamic> toMap() => {'key': key, 'value': value};
}
