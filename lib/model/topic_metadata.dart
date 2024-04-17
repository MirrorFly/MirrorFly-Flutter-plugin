class TopicMetaData {
  TopicMetaData({this.key, this.value});

  String? key;
  String? value;
}

extension ExtractTopicData on TopicMetaData {
  Map<String, dynamic> toMap() => {'key': key, 'value': value};
}

/*class MetaData {
  MetaData({this.key, this.value});

  String? key;
  String? value;
}

extension ExtractMetaData on MetaData {
  Map<String, dynamic> toMap() => {'key': key, 'value': value};
}

class MessageMetaData {
  MessageMetaData({this.key, this.value});

  String? key;
  String? value;
}

extension ExtractMessageMetaData on MessageMetaData {
  Map<String, dynamic> toMap() => {'key': key, 'value': value};
}*/
