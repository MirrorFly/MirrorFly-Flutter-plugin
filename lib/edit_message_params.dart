/// Encapsulates the information necessary for performing an edit operation on a message.
class EditMessageParams {
  /// Constructs an instance of [EditMessageParams].
  EditMessageParams({
    required this.messageId,
    required this.editedTextContent, this.mentionedUsersIds
  });

  /// The unique identifier of the message to be edited.
  String messageId;

  /// The new text content for the message.
  String editedTextContent;

  /// The IDs of users mentioned in the message. Optional.
  List<String>? mentionedUsersIds;
}

/// An extension on [EditMessageParams] that provides a method to convert an instance of [EditMessageParams] to a map.
extension ExtractEditMessage on EditMessageParams {
  /// Converts an instance of [EditMessageParams] to a map.
  Map<String, dynamic> toMap() => {
        'messageId': messageId,
        'editedTextContent': editedTextContent,
        'mentionedUsersIds': mentionedUsersIds
      };
}
