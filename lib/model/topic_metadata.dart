class TopicMetaData {
  TopicMetaData({required this.key, required this.value});

  String key;
  String value;
}

extension ExtractTopicData on TopicMetaData {
  Map<String, dynamic> toMap() => {'key': key, 'value': value};
}

class MetaData {
  MetaData({required this.key, required this.value});

  String key;
  String value;
}

extension ExtractMetaData on MetaData {
  Map<String, dynamic> toMap() => {'key': key, 'value': value};
}

class MetaDataUserList {
  MetaDataUserList({required this.key, required this.value});

  String key;
  List<String> value;
}

extension ExtractMetaDataUserList on MetaData {
  Map<String, dynamic> toMap() => {'key': key, 'value': value};
}
