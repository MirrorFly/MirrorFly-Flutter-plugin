import 'chat_message_model.dart';

/// An abstract class representing a grouped media item.
///
/// This class serves as a base for different types of media items that can be grouped together.
/// It declares an `id` property that uniquely identifies each item within a group.
abstract class GroupedMedia {
  /// The unique identifier of the media item.
  late double id;
}

/// A class representing a message item within a group.
///
/// This class implements the [GroupedMedia] interface and represents a specific message item.
/// It contains a [ChatMessageModel] representing the chat message and an optional map of links.
///
/// Properties:
///   - `chatMessage`: The chat message associated with this item.
///   - `linkMap`: An optional map containing links related to the chat message.
///
/// The `id` property is overridden to provide a unique identifier for the message item.
class MessageItem implements GroupedMedia {
  /// The chat message associated with this item.
  final ChatMessageModel chatMessage;

  /// An optional map containing links related to the chat message.
  Map? linkMap = {};
  @override
  var id = -double.infinity + 0;

  /// Initializes a new instance of the [MessageItem] class.
  MessageItem(this.chatMessage, [this.linkMap]);
}

/// A class representing a header item within a group.
class Header implements GroupedMedia {
  /// The title of the header.
  final String titleName;
  @override
  var id = -double.infinity + 1;

  /// Initializes a new instance of the [Header] class.
  Header(this.titleName);
}
