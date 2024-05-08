import 'dart:io';

class TextMessageParams {
  TextMessageParams({
    required this.messageText,
  });

  // String toJid;
  String messageText;
// String? replyMessageId;
// List<String>? mentionedUsersIds;
// List<MessageMetaData> metaData = [];
// String topicId = "";
// String? editMessageId;
}

extension ExtractTextMessage on TextMessageParams {
  Map<String, dynamic> toMap() => {
        // 'toJid': toJid,
        'messageText': messageText,
        // 'replyMessageId': replyMessageId,
        // 'mentionedUsersIds': mentionedUsersIds,
        // 'metaData': List<dynamic>.from(metaData.map((x) => x.toMap())),
      };
}

class MessageMetaData {
  MessageMetaData({required this.key, required this.value});

  String key;
  String value;

  factory MessageMetaData.fromJson(Map<String, dynamic> json) =>
      MessageMetaData(
        key: json["key"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
      };
}

extension ExtractMessageMetaData on MessageMetaData {
  Map<String, dynamic> toMap() => {'key': key, 'value': value};
}

class FileMessage {
  FileMessage(
      {required this.toJid,
      this.replyMessageId,
      this.messageType,
      // this.mentionedUsersIds,
      // this.metaData = const [],
      this.locationMessage,
      this.contactMessage,
      this.fileMessage,
      this.topicId = ""});

  String toJid;
  String? replyMessageId;
  MessageType? messageType;
  List<String>? mentionedUsersIds;
  List<MessageMetaData> metaData = [];
  LocationMessageParams? locationMessage;
  ContactMessageParams? contactMessage;
  FileMessageParams? fileMessage;
  String topicId = "";
// String? editMessageId;
}

extension ExtractFileMessage on FileMessage {
  Map<String, dynamic> toMap() => {
        'toJid': toJid,
        'replyMessageId': replyMessageId,
        'messageType': messageType?.value,
        'mentionedUsersIds': mentionedUsersIds,
        'metaData': List<dynamic>.from(metaData.map((x) => x.toMap())),
        'locationMessage': locationMessage?.toMap(),
        'contactMessage': contactMessage?.toMap(),
        'fileMessage': fileMessage?.toMap(),
        'topicId': topicId,
      };
}

class MeetMessage {
  MeetMessage(
      {required this.toJid,
      this.replyMessageId,
      // this.mentionedUsersIds,
      // this.metaData = const [],
      this.topicId = "",
      this.title,
      this.scheduledDateTime,
      this.link});

  String toJid;
  String? replyMessageId;
  List<String>? mentionedUsersIds;
  List<MessageMetaData> metaData = const [];
  String topicId = "";
  String? title;
  int? scheduledDateTime;
  String? link;

  // String? editMessageId;

  @override
  String toString() {
    return "MeetMessage(toJid='$toJid', replyMessageId=$replyMessageId, topicId='$topicId', title=$title, scheduledDateTime=$scheduledDateTime, link=$link)";
  }
}

extension ExtractMeetMessage on MeetMessage {
  Map<String, dynamic> toMap() => {
        'toJid': toJid,
        'replyMessageId': replyMessageId,
        'mentionedUsersIds': mentionedUsersIds,
        'metaData': List<dynamic>.from(metaData.map((x) => x.toMap())),
        'topicId': topicId,
        'title': title,
        'scheduledDateTime': scheduledDateTime,
        'link': link
      };
}

class LocationMessageParams {
  LocationMessageParams({required this.latitude, required this.longitude});

  double latitude;
  double longitude;
}

extension ExtractLocationMessageParams on LocationMessageParams {
  Map<String, dynamic> toMap() => {
        'latitude': latitude,
        'longitude': longitude,
      };
}

class ContactMessageParams {
  ContactMessageParams({required this.name, required this.numbers});

  String name;
  List<String> numbers;
}

extension ExtractContactMessageParams on ContactMessageParams {
  Map<String, dynamic> toMap() => {
        'name': name,
        'numbers': numbers,
      };
}

class FileMessageParams {
  FileMessageParams(
      {this.file,
      this.caption = "",
      // this.localFilePath,
      this.thumbImage,
      this.fileSize,
      this.duration,
      // this.fileUrl,
      this.fileName});

  File? file;
  String? caption = "";

  // String? localFilePath; //this for file url purpose
  String? thumbImage;
  int? fileSize;
  int? duration;

  // String? fileUrl; //not implemented in iOS
  String? fileName;
}

extension ExtractFileMessageParams on FileMessageParams {
  Map<String, dynamic> toMap() => {
        'file': file?.path,
        'caption': caption,
        'thumbImage': thumbImage,
        'fileSize': fileSize,
        'duration': duration,
        'fileName': fileName,
      };
}

/// Represents parameters for constructing a message.
class MessageParams {
  String toJid;
  String? replyMessageId;
  MessageType messageType;

  // List<String>? mentionedUsersIds;
  List<MessageMetaData> metaData;
  TextMessageParams? textMessageParams;
  LocationMessageParams? locationMessageParams;
  ContactMessageParams? contactMessageParams;
  FileMessageParams? fileMessageParams;
  String topicId;

  MessageParams._({
    required this.toJid,
    this.replyMessageId,
    required this.messageType,
    // this.mentionedUsersIds,
    this.metaData = const [],
    this.textMessageParams,
    this.locationMessageParams,
    this.contactMessageParams,
    this.fileMessageParams,
    this.topicId = "",
  });

  /// Constructs a [MessageParams] object for a Text message.
  factory MessageParams.text({
    required String toJid,
    String? replyMessageId,
    required TextMessageParams textMessageParams,
    List<MessageMetaData> metaData = const [],
    String topicId = "",
  }) {
    return MessageParams._(
      toJid: toJid,
      replyMessageId: replyMessageId,
      messageType: MessageType.text,
      textMessageParams: textMessageParams,
      metaData: metaData,
      topicId: topicId,
    );
  }

  /// Constructs a [MessageParams] object for a Location message.
  factory MessageParams.location({
    required String toJid,
    String? replyMessageId,
    required LocationMessageParams locationMessageParams,
    List<MessageMetaData> metaData = const [],
    String topicId = "",
  }) {
    return MessageParams._(
      toJid: toJid,
      replyMessageId: replyMessageId,
      messageType: MessageType.location,
      locationMessageParams: locationMessageParams,
      metaData: metaData,
      topicId: topicId,
    );
  }

  /// Constructs a [MessageParams] object for a Contact message.
  factory MessageParams.contact({
    required String toJid,
    String? replyMessageId,
    required ContactMessageParams contactMessageParams,
    List<MessageMetaData> metaData = const [],
    String topicId = "",
  }) {
    return MessageParams._(
      toJid: toJid,
      replyMessageId: replyMessageId,
      messageType: MessageType.contact,
      contactMessageParams: contactMessageParams,
      metaData: metaData,
      topicId: topicId,
    );
  }

  /// Constructs a [MessageParams] object for a Image message.
  factory MessageParams.image({
    required String toJid,
    String? replyMessageId,
    required FileMessageParams fileMessageParams,
    List<MessageMetaData> metaData = const [],
    String topicId = "",
  }) {
    return MessageParams._(
      toJid: toJid,
      replyMessageId: replyMessageId,
      messageType: MessageType.image,
      fileMessageParams: fileMessageParams,
      metaData: metaData,
      topicId: topicId,
    );
  }

  /// Constructs a [MessageParams] object for a Audio message.
  factory MessageParams.audio({
    required String toJid,
    String? replyMessageId,
    required FileMessageParams fileMessageParams,
    List<MessageMetaData> metaData = const [],
    required bool isRecorded,
    String topicId = "",
  }) {
    return MessageParams._(
      toJid: toJid,
      replyMessageId: replyMessageId,
      messageType: isRecorded ? MessageType.audioRecorded : MessageType.audio,
      fileMessageParams: fileMessageParams,
      metaData: metaData,
      topicId: topicId,
    );
  }

  /// Constructs a [MessageParams] object for a Video message.
  factory MessageParams.video({
    required String toJid,
    String? replyMessageId,
    required FileMessageParams fileMessageParams,
    List<MessageMetaData> metaData = const [],
    String topicId = "",
  }) {
    return MessageParams._(
      toJid: toJid,
      replyMessageId: replyMessageId,
      messageType: MessageType.video,
      fileMessageParams: fileMessageParams,
      metaData: metaData,
      topicId: topicId,
    );
  }

  /// Constructs a [MessageParams] object for a Document message.
  factory MessageParams.document({
    required String toJid,
    String? replyMessageId,
    required FileMessageParams fileMessageParams,
    List<MessageMetaData> metaData = const [],
    String topicId = "",
  }) {
    return MessageParams._(
      toJid: toJid,
      replyMessageId: replyMessageId,
      messageType: MessageType.document,
      fileMessageParams: fileMessageParams,
      metaData: metaData,
      topicId: topicId,
    );
  }
}

//
// class MessageParams {
//   MessageParams(
//       {required this.toJid,
//       this.replyMessageId,
//       this.messageType,
//       // this.mentionedUsersIds,
//       // this.metaData = const [],
//       this.textMessage,
//       this.locationMessage,
//       this.contactMessage,
//       this.fileMessage,
//       this.topicId = ""});
//
//   String toJid;
//   String? replyMessageId;
//   MessageType? messageType;
//   List<String>? mentionedUsersIds;
//   List<MessageMetaData> metaData = [];
//   TextMessageParams? textMessage;
//   LocationMessageParams? locationMessage;
//   ContactMessageParams? contactMessage;
//   FileMessageParams? fileMessage;
//   String topicId = "";
// // String? editMessageId;
// }

extension ExtractMessageParams on MessageParams {
  Map<String, dynamic> toMap() => {
        'toJid': toJid,
        'replyMessageId': replyMessageId,
        'messageType': messageType.value,
        'mentionedUsersIds': null,
        //List<String>.from(mentionedUsersIds.map((x) => x)),
        'metaData': List<dynamic>.from(metaData.map((x) => x.toMap())),
        'textMessage': textMessageParams?.toMap(),
        'locationMessage': locationMessageParams?.toMap(),
        'contactMessage': contactMessageParams?.toMap(),
        'fileMessage': fileMessageParams?.toMap(),
        'topicId': topicId,
      };
}

enum MessageType {
  text('TEXT'),
  image('IMAGE'),
  audio('AUDIO'),
  audioRecorded('AUDIO_RECORDED'),
  video('VIDEO'),
  contact('CONTACT'),
  document('DOCUMENT'),
  location('LOCATION'),
  notification('NOTIFICATION');

  // meet('MEET'),
  // autoText('AUTO_TEXT'),
  // chatSummary('CHAT_SUMMARY');

  static const isText = "TEXT";
  static const isImage = "IMAGE";
  static const isAudio = "AUDIO";
  static const isAudioRecorded = "AUDIO_RECORDED";
  static const isVideo = "VIDEO";
  static const isContact = "CONTACT";
  static const isDocument = "DOCUMENT";
  static const isLocation = "LOCATION";
  static const isNotification = "NOTIFICATION";

  const MessageType(this.value);

  final String value;
}

enum MediaDownloadStatus {
  mediaDownloading(3),
  mediaDownloaded(4),
  mediaNotDownloaded(5),
  mediaDownloadedNotAvailable(6),
  mediaDownloadFailed(401),
  storageNotEnough(8);

  static const isMediaDownloading = 3;
  static const isMediaDownloaded = 4;
  static const isMediaNotDownloaded = 5;
  static const isMediaDownloadedNotAvailable = 6;
  static const isMediaDownloadFailed = 401;
  static const isStorageNotEnough = 8;

  const MediaDownloadStatus(this.value);

  final int value;
}

enum MediaUploadStatus {
  mediaNotUploaded(0),
  mediaUploading(1),
  mediaUploaded(2),
  mediaUploadedNotAvailable(7);
  // mediaUploadFailed(401);

  static const isMediaNotUploaded = 0;
  static const isMediaUploading = 1;
  static const isMediaUploaded = 2;
  static const isMediaUploadedNotAvailable = 7;
  // static const isMediaUploadFailed = 401;

  const MediaUploadStatus(this.value);

  final int value;
}

class ChatType {
  static const String singleChat = "chat";
  static const String groupChat = "groupchat";
  static const String broadcastChat = "broadcast";
}
