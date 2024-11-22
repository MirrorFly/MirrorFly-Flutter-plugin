import 'dart:io';

/// Represents the parameters for a text message.
///
/// This class holds the text content of a message. It is designed to encapsulate
/// the data required to send or manipulate text messages within the application.
///
/// Properties:
///   [messageText] - The text content of the message.
///
/// Constructors:
///   [TextMessageParams] - Initializes a new instance of the [TextMessageParams] class
///                         with the required text content.
class TextMessageParams {
  /// Initializes a new instance of the [TextMessageParams] class.
  TextMessageParams({
    required this.messageText,
  });

  // String toJid;
  /// The text content of the message.
  String messageText;
// String? replyMessageId;
// List<String>? mentionedUsersIds;
// List<MessageMetaData> metaData = [];
// String topicId = "";
// String? editMessageId;
}

/// Extension method to convert a [TextMessageParams] object into a map.
extension ExtractTextMessage on TextMessageParams {
  /// Converts a [TextMessageParams] object into a map.
  Map<String, dynamic> toMap() => {
        // 'toJid': toJid,
        'messageText': messageText,
        // 'replyMessageId': replyMessageId,
        // 'mentionedUsersIds': mentionedUsersIds,
        // 'metaData': List<dynamic>.from(metaData.map((x) => x.toMap())),
      };
}

/// Represents metadata for a message.
///
/// This class is used to encapsulate key-value pairs that provide additional
/// information about a message. It can be used for various purposes such as
/// indicating message status, categorization, or any other metadata.
///
class MessageMetaData {
  /// Initializes a new instance of the [MessageMetaData] class.
  MessageMetaData({required this.key, required this.value});

  /// The key of the metadata.
  String key;

  /// The value of the metadata.
  String value;

  /// Converts a JSON object into a [MessageMetaData] object.
  factory MessageMetaData.fromJson(Map<String, dynamic> json) =>
      MessageMetaData(
        key: json["key"],
        value: json["value"],
      );

  /// Converts a [MessageMetaData] object into a JSON object.
  Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
      };
}

/// Provides an extension on [MessageMetaData] to convert the metadata into a map.
///
/// This extension adds functionality to the [MessageMetaData] class, allowing the
/// metadata to be easily converted into a map. This is particularly useful for
/// serialization or when interfacing with APIs that require data in map form.
///
extension ExtractMessageMetaData on MessageMetaData {
  /// Converts a [MessageMetaData] object into a map.
  Map<String, dynamic> toMap() => {'key': key, 'value': value};
}

/// Represents a file message with various parameters.
///
/// This class is designed to encapsulate all the necessary information required to send a file message,
/// including the recipient's JID, reply message ID, message type, and additional message parameters such as
/// location, contact, and file details.
class FileMessage {
  /// Initializes a new instance of the [FileMessage] class.
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

  /// The Jabber ID (JID) of the recipient.
  String toJid;

  /// The ID of the message being replied to, if any.
  String? replyMessageId;

  /// The type of message, defined by the [MessageType] enum.
  MessageType? messageType;

  /// A list of user IDs mentioned in the message.
  List<String>? mentionedUsersIds;

  /// A list of [MessageMetaData] objects providing additional information about the message.
  List<MessageMetaData> metaData = [];

  /// Parameters for a location message, if applicable.
  LocationMessageParams? locationMessage;

  /// Parameters for a contact message, if applicable.
  ContactMessageParams? contactMessage;

  /// Parameters for the file being sent.
  FileMessageParams? fileMessage;

  /// The ID of the topic under which the message is sent, if any.
  String topicId = "";
// String? editMessageId;
}

/// Provides an extension on [FileMessage] to convert the message into a map.
///
/// This extension adds functionality to the [FileMessage] class, allowing the message and its parameters
/// to be easily converted into a map. This is particularly useful for serialization or when interfacing
/// with APIs that require data in map form.
///
extension ExtractFileMessage on FileMessage {
  /// Converts a [FileMessage] object into a map.
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

/// Represents a meeting message with various parameters.
///
/// This class is designed to encapsulate all the necessary information required to send a meeting message,
/// including the recipient's JID, reply message ID, topic ID, title, scheduled date and time, and a link to the meeting.
///
class MeetMessage {
  /// Initializes a new instance of the [MeetMessage] class.
  MeetMessage(
      {required this.toJid,
      this.replyMessageId,
      // this.mentionedUsersIds,
      // this.metaData = const [],
      this.topicId = "",
      this.title,
      this.scheduledDateTime,
      this.link});

  /// The Jabber ID (JID) of the recipient.
  String toJid;

  /// The ID of the message being replied to, if any.
  String? replyMessageId;

  /// A list of user IDs mentioned in the message.
  List<String>? mentionedUsersIds;

  /// A list of [MessageMetaData] objects providing additional information about the message.
  List<MessageMetaData> metaData = const [];

  /// The ID of the topic under which the message is sent, if any.
  String topicId = "";

  /// The title of the meeting.
  String? title;

  /// The scheduled date and time of the meeting.
  int? scheduledDateTime;

  /// A link to the meeting.
  String? link;

  // String? editMessageId;

  @override
  String toString() {
    return "MeetMessage(toJid='$toJid', replyMessageId=$replyMessageId, topicId='$topicId', title=$title, scheduledDateTime=$scheduledDateTime, link=$link)";
  }
}

/// Provides an extension on [MeetMessage] to convert the meeting message into a map.
///
/// This extension adds functionality to the [MeetMessage] class, allowing the meeting message and its parameters
/// to be easily converted into a map. This is particularly useful for serialization or when interfacing
/// with APIs that require data in map form.
///
extension ExtractMeetMessage on MeetMessage {
  /// Converts a [MeetMessage] object into a map.
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

/// Represents the parameters for a location message.
///
/// This class holds the latitude and longitude values for a location. It is designed to encapsulate
/// the geographical coordinates required to send or manipulate location messages within the application.
class LocationMessageParams {
  /// Initializes a new instance of the [LocationMessageParams] class.
  LocationMessageParams({required this.latitude, required this.longitude});

  /// The latitude of the location.
  double latitude;

  /// The longitude of the location.
  double longitude;
}

/// Provides an extension on [LocationMessageParams] to convert the location parameters to a map.
///
/// This extension adds functionality to the [LocationMessageParams] class, allowing the
/// location parameters to be easily converted into a map. This is particularly useful
/// for serialization or when interfacing with APIs that require data in map form.
extension ExtractLocationMessageParams on LocationMessageParams {
  /// Converts a [LocationMessageParams] object into a map.
  Map<String, dynamic> toMap() => {
        'latitude': latitude,
        'longitude': longitude,
      };
}

/// Represents the parameters for a contact message.
///
/// This class holds the name and a list of numbers associated with a contact. It is designed to encapsulate
/// the data required to send or manipulate contact messages within the application.
class ContactMessageParams {
  /// Initializes a new instance of the [ContactMessageParams] class.
  ContactMessageParams({required this.name, required this.numbers});

  /// The name of the contact.
  String name;

  /// A list of phone numbers associated with the contact.
  List<String> numbers;
}

/// Provides an extension on [ContactMessageParams] to convert the contact parameters to a map.
///
/// This extension adds functionality to the [ContactMessageParams] class, allowing the
/// contact parameters to be easily converted into a map. This is particularly useful
/// for serialization or when interfacing with APIs that require data in map form.
extension ExtractContactMessageParams on ContactMessageParams {
  /// Converts a [ContactMessageParams] object into a map.
  Map<String, dynamic> toMap() => {
        'name': name,
        'numbers': numbers,
      };
}

/// Represents the parameters for a file message.
///
/// This class holds the details of a file to be sent or manipulated within the application. It includes
/// information such as the file itself, a caption, thumbnail image, file size, duration, and file name.
class FileMessageParams {
  /// Initializes a new instance of the [FileMessageParams] class.
  FileMessageParams(
      {this.file,
      this.caption = "",
      // this.localFilePath,
      this.thumbImage,
      this.fileSize,
      this.duration,
      // this.fileUrl,
      this.fileName});

  /// The file to be sent. This is an optional parameter.
  File? file;

  /// A caption for the file. Defaults to an empty string if not provided.
  String? caption = "";

  // String? localFilePath; //this for file url purpose
  /// A thumbnail image for the file. This is an optional parameter.
  String? thumbImage;

  /// The size of the file in bytes. This is an optional parameter.
  int? fileSize;

  /// The duration of the file if it is a video or audio file. This is measured in seconds and is optional.
  int? duration;

  // String? fileUrl; //not implemented in iOS
  /// The name of the file. This is an optional parameter.
  String? fileName;
}

/// Provides an extension on [FileMessageParams] to convert the file message parameters into a map.
///
/// This extension adds functionality to the [FileMessageParams] class, allowing the file message parameters
/// to be easily converted into a map. This is particularly useful for serialization or when interfacing
/// with APIs that require data in map form.
extension ExtractFileMessageParams on FileMessageParams {
  /// Converts a [FileMessageParams] object into a map.
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
  /// The Jabber ID (JID) of the recipient.
  String toJid;

  /// The ID of the message being replied to, if any.
  String? replyMessageId;

  /// The type of message, defined by the [MessageType] enum.
  MessageType messageType;

  /// A list of [userJid] for mentioning the message
  List<String>? mentionedUsersIds;

  /// A list of [MessageMetaData] objects providing additional information about the message.
  List<MessageMetaData> metaData;

  /// Parameters for a text message, if applicable.
  TextMessageParams? textMessageParams;

  /// Parameters for a location message, if applicable.
  LocationMessageParams? locationMessageParams;

  /// Parameters for a contact message, if applicable.
  ContactMessageParams? contactMessageParams;

  /// Parameters for a file message, if applicable.
  FileMessageParams? fileMessageParams;

  /// The ID of the topic under which the message is sent, if any.
  String topicId;

  /// Initializes a new instance of the [MessageParams] class.
  MessageParams._({
    required this.toJid,
    this.replyMessageId,
    required this.messageType,
    this.mentionedUsersIds,
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
    List<String>? mentionedUsersIds,
    required TextMessageParams textMessageParams,
    List<MessageMetaData> metaData = const [],
    String topicId = "",
  }) {
    return MessageParams._(
      toJid: toJid,
      replyMessageId: replyMessageId,
      mentionedUsersIds: mentionedUsersIds,
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
    List<String>? mentionedUsersIds,
    required LocationMessageParams locationMessageParams,
    List<MessageMetaData> metaData = const [],
    String topicId = "",
  }) {
    return MessageParams._(
      toJid: toJid,
      replyMessageId: replyMessageId,
      mentionedUsersIds: mentionedUsersIds,
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
    List<String>? mentionedUsersIds,
    required ContactMessageParams contactMessageParams,
    List<MessageMetaData> metaData = const [],
    String topicId = "",
  }) {
    return MessageParams._(
      toJid: toJid,
      replyMessageId: replyMessageId,
      mentionedUsersIds: mentionedUsersIds,
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
    List<String>? mentionedUsersIds,
    required FileMessageParams fileMessageParams,
    List<MessageMetaData> metaData = const [],
    String topicId = "",
  }) {
    return MessageParams._(
      toJid: toJid,
      replyMessageId: replyMessageId,
      mentionedUsersIds: mentionedUsersIds,
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
    List<String>? mentionedUsersIds,
    required FileMessageParams fileMessageParams,
    List<MessageMetaData> metaData = const [],
    required bool isRecorded,
    String topicId = "",
  }) {
    return MessageParams._(
      toJid: toJid,
      replyMessageId: replyMessageId,
      mentionedUsersIds: mentionedUsersIds,
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
    List<String>? mentionedUsersIds,
    required FileMessageParams fileMessageParams,
    List<MessageMetaData> metaData = const [],
    String topicId = "",
  }) {
    return MessageParams._(
      toJid: toJid,
      replyMessageId: replyMessageId,
      mentionedUsersIds: mentionedUsersIds,
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
    List<String>? mentionedUsersIds,
    required FileMessageParams fileMessageParams,
    List<MessageMetaData> metaData = const [],
    String topicId = "",
  }) {
    return MessageParams._(
      toJid: toJid,
      replyMessageId: replyMessageId,
      mentionedUsersIds: mentionedUsersIds,
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

/// Provides an extension on [MessageParams] to convert the message into a map.
extension ExtractMessageParams on MessageParams {
  /// Converts a [MessageParams] object into a map.
  Map<String, dynamic> toMap() => {
        'toJid': toJid,
        'replyMessageId': replyMessageId,
        'messageType': messageType.value,
        'mentionedUsersIds': mentionedUsersIds != null ? List<String>.from(mentionedUsersIds!.map((x) => x)) : null,
        'metaData': List<dynamic>.from(metaData.map((x) => x.toMap())),
        'textMessage': textMessageParams?.toMap(),
        'locationMessage': locationMessageParams?.toMap(),
        'contactMessage': contactMessageParams?.toMap(),
        'fileMessage': fileMessageParams?.toMap(),
        'topicId': topicId,
      };
}

/// An enumeration of message types.
///
/// This enum defines the various types of messages that can be sent or received within the application.
/// Each message type is associated with a specific string value that represents the type in a more readable format.
enum MessageType {
  /// Represents a text message.
  text('TEXT'),

  /// Represents an image message.
  image('IMAGE'),

  /// Represents an audio message.
  audio('AUDIO'),

  /// Represents an audio message that has been recorded.
  audioRecorded('AUDIO_RECORDED'),

  /// Represents a video message.
  video('VIDEO'),

  /// Represents a contact message.
  contact('CONTACT'),

  /// Represents a document message.
  document('DOCUMENT'),

  /// Represents a location message.
  location('LOCATION'),

  /// Represents a notification message.
  notification('NOTIFICATION');

  // meet('MEET'),
  // autoText('AUTO_TEXT'),
  // chatSummary('CHAT_SUMMARY');

  /// The string representation for a text message.
  static const isText = "TEXT";

  /// The string representation for an image message.
  static const isImage = "IMAGE";

  /// The string representation for an audio message.
  static const isAudio = "AUDIO";

  /// The string representation for an audio message that has been recorded.
  static const isAudioRecorded = "AUDIO_RECORDED";

  /// The string representation for a video message.
  static const isVideo = "VIDEO";

  /// The string representation for a contact message.
  static const isContact = "CONTACT";

  /// The string representation for a document message.
  static const isDocument = "DOCUMENT";

  /// The string representation for a location message.
  static const isLocation = "LOCATION";

  /// The string representation for a notification message.
  static const isNotification = "NOTIFICATION";

  const MessageType(this.value);

  /// The enum constructor takes a [value] parameter which is the string representation of the message type.
  final String value;
}

/// An enumeration of media download statuses.
///
/// This enum defines the various states of media download within the application, providing a clear
/// representation of the download status through integer values.
///
enum MediaDownloadStatus {
  /// Represents the state when media is currently downloading. Associated with the value 3.
  mediaDownloading(3),

  /// Represents the state when media has been downloaded. Associated with the value 4.
  mediaDownloaded(4),

  /// Represents the state when media has not been downloaded. Associated with the value 5.
  mediaNotDownloaded(5),

  /// Represents the state when media has been downloaded but is not available. Associated with the value 6.
  mediaDownloadedNotAvailable(6),

  /// Represents the state when media download has failed. Associated with the value 401.
  mediaDownloadFailed(401),

  /// Represents the state when there is not enough storage space for media download. Associated with the value 8.
  storageNotEnough(8);

  /// The integer value associated with the media download status.
  static const isMediaDownloading = 3;

  /// The integer value associated with the media download status.
  static const isMediaDownloaded = 4;

  /// The integer value associated with the media download status.
  static const isMediaNotDownloaded = 5;

  /// The integer value associated with the media download status.
  static const isMediaDownloadedNotAvailable = 6;

  /// The integer value associated with the media download status.
  static const isMediaDownloadFailed = 401;

  /// The integer value associated with the media download status.
  static const isStorageNotEnough = 8;

  const MediaDownloadStatus(this.value);

  /// The enum constructor takes a [value] parameter which is the integer representation of the download status.
  final int value;
}

/// Enum representing the status of media upload.
enum MediaUploadStatus {
  /// Media has not been uploaded.
  mediaNotUploaded(0),

  /// Media is currently being uploaded.
  mediaUploading(1),

  /// Media has been successfully uploaded.
  mediaUploaded(2),

  /// Media was uploaded but is no longer available.
  mediaUploadedNotAvailable(7);

  // Uncomment to include a failed upload status.
  // mediaUploadFailed(401);

  /// Status value indicating media has not been uploaded.
  static const isMediaNotUploaded = 0;

  /// Status value indicating media is currently being uploaded.
  static const isMediaUploading = 1;

  /// Status value indicating media has been successfully uploaded.
  static const isMediaUploaded = 2;

  /// Status value indicating media was uploaded but is no longer available.
  static const isMediaUploadedNotAvailable = 7;

  // Uncomment to include a failed upload status value.
  // static const isMediaUploadFailed = 401;

  /// Constructs a MediaUploadStatus enum with the provided integer value.
  const MediaUploadStatus(this.value);

  /// The integer value associated with the media upload status.
  final int value;
}

/// Class representing the types of chat.
class ChatType {
  /// Represents a single chat.
  static const String singleChat = "chat";

  /// Represents a group chat.
  static const String groupChat = "groupchat";

  /// Represents a broadcast chat.
  static const String broadcastChat = "broadcast";
}
