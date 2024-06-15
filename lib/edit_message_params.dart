class EditMessageParams {
  EditMessageParams({
    required this.messageId,
    required this.editedTextContent, //this.mentionedUsersIds
  });

  String messageId;
  String editedTextContent;
  List<String>? mentionedUsersIds;
}

extension ExtractEditMessage on EditMessageParams {
  Map<String, dynamic> toMap() => {
        'messageId': messageId,
        'editedTextContent': editedTextContent,
        'mentionedUsersIds': mentionedUsersIds
      };
}
