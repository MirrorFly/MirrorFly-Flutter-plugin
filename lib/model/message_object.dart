/// A class that represents a message object with various attributes.
class MessageObject {
  /// Constructs a MessageObject with the required and optional parameters.
  ///
  /// The [toJid] and [messageType] parameters are required.
  MessageObject({
    required this.toJid,
    required this.messageType,
    this.textMessage,
    this.replyMessageId,
    this.latitude,
    this.longitude,
    this.contactName,
    this.contactNumbers,
    this.file,
    this.fileName,
    this.caption,
    this.base64Thumbnail,
    this.audioDuration,
    this.isAudioRecorded,
  });

  /// The JID (Jabber ID) of the recipient.
  String toJid;

  /// The type of the message (e.g., text, image, video).
  String messageType;

  /// The text content of the message.
  String? textMessage;

  /// The ID of the message being replied to.
  String? replyMessageId;

  /// The latitude for a location message.
  double? latitude;

  /// The longitude for a location message.
  double? longitude;

  /// The name of the contact for a contact message.
  String? contactName;

  /// The phone numbers of the contact for a contact message.
  List<String>? contactNumbers;

  /// The file path for a file message.
  String? file;

  /// The name of the file for a file message.
  String? fileName;

  /// The caption for an image or video message.
  String? caption;

  /// The base64 encoded thumbnail for an image or video message.
  String? base64Thumbnail;

  /// The duration of an audio message.
  String? audioDuration;

  /// Indicates if the audio is recorded.
  bool? isAudioRecorded;
}
