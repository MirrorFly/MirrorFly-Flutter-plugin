class TopicMetaData {
  TopicMetaData({this.key, this.value});

  String? key;
  String? value;
}

extension ExtractTopicData on TopicMetaData {
  Map<String, dynamic> toMap() => {'key': key, 'value': value};
}

class MetaData {
  MetaData({this.key, this.value});

  String? key;
  String? value;
}

extension ExtractMetaData on MetaData {
  Map<String, dynamic> toMap() => {'key': key, 'value': value};
}

class MetaDataUserList {
  MetaDataUserList({this.key, this.value});

  String? key;
  List<String>? value;
}

extension ExtractMetaDataUserList on MetaData {
  Map<String, dynamic> toMap() => {'key': key, 'value': value};
}
