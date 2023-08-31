
class TopicMetaData{
  TopicMetaData({this.key,this.value});
  String? key;
  String? value;
}
extension ExtractTopicData on TopicMetaData{
  Map<String,dynamic> toMap()=>{
    'key':key,
    'value':value
  };
}