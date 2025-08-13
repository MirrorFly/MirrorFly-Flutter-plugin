import 'package:mirrorfly_plugin/model/available_features.dart';

import 'model/callback.dart';
import 'model/chat_message_model.dart';
import 'model/profile_model.dart';

/// A class that provides a set of callback methods that can be used to listen for Message Events in the MirrorFly Flutter Plugin.
abstract class MessageEventListeners {
  /// This listener is triggered whenever a new chat message arrives. Listen to this method to handle
  /// the incoming message, such as updating the UI or storing the message in a database.
  ///
  /// [chatMessage]: The `ChatMessageModel` instance containing the details of the received message.
  void onMessageReceived(ChatMessageModel chatMessage);

  /// This listener is triggered whenever a chat message is sent. Listen to this method to handle
  /// the sent message, such as updating the status in UI.
  ///
  /// [chatMessage]: The `ChatMessageModel` instance containing the details of the sent message.
  void onMessageStatusUpdated(ChatMessageModel chatMessage);

  /// This listener is triggered whenever a media chat message is sent. Listen to this method to handle
  /// the sent media message, such as updating the status in UI.
  ///
  /// [chatMessage]: The `ChatMessageModel` instance containing the details of the deleted message.
  void onMediaStatusUpdated(ChatMessageModel mediaMessage);

  /// This listener is triggered whenever a media chat message is downloaded/uploaded. Listen to this method to handle
  /// the upload/download progress updating in the UI.
  ///
  /// [chatMessage]: The `ChatMessageModel` instance containing the details of the deleted message.
  void onUploadDownloadProgressChanged(
      String messageId, int progressPercentage);

  /// This listener is triggered whenever a local notification to be created in UI.
  ///
  /// [chatMessage]: The `ChatMessageModel` instance containing the details of the deleted message.
  void showOrUpdateOrCancelNotification(
      String jid, ChatMessageModel chatMessageModel);

  /// This listener is triggered whenever a user is composing a message. Listen to this method to handle
  /// the typing status in the UI.
  ///
  /// [singleOrGroupJid]: The JID of the user who is typing.
  void setTypingStatus(String singleOrGroupJid, String userJid, String status);

  /// This listener is triggered whenever a AvailableFeatures is updated. Listen to this method to handle
  /// the features in the UI.
  ///
  /// [availableFeatures]: The `AvailableFeatures` instance containing the details of the features.
  void onAvailableFeaturesUpdated(AvailableFeatures availableFeatures);

  /// This listener is triggered whenever a user comes online. Listen to this method to handle
  /// the online status of the user in the UI.
  ///
  /// [jid]: The JID of the user who came online.
  void userCameOnline(String jid);

  /// This listener is triggered whenever a user goes offline. Listen to this method to handle
  /// the offline status of the user in the UI.
  ///
  /// [jid]: The JID of the user who went offline.
  void userWentOffline(String jid);

  /// This listener is triggered whenever a message is edited. Listen to this method to handle
  /// the edited message in the UI.
  ///
  /// [chatMessage]: The `ChatMessageModel` instance containing the details of the edited message.
  void onMessageEdited(ChatMessageModel chatMessage);

  /// This listener is triggered whenever a message is deleted. Listen to this method to handle
  /// the deletion of a message in the UI.
  ///
  /// [toJid]: The JID (Jabber ID) of the user or group where the message was deleted.
  /// [messageIds]: A list of message IDs that were deleted.
  /// [messageDeleteType]: The type of deletion event, such as "deleteForEveryone" or "deleteForMe".
  void onMessageDeleted(
      String toJid, List<String> messageIds, String messageDeleteType);

  /// This listener is triggered whenever all chats are cleared. Listen to this method to handle
  /// the global clearing of all chat histories in the UI.
  ///
  /// [isChatCleared]: A boolean flag indicating whether all chats have been successfully cleared.
  void onAllChatsCleared(bool isChatCleared);

  /// This listener is triggered whenever a chat is cleared. Listen to this method to handle
  /// the clearing of chat history in the UI.
  ///
  /// [toJid]: The JID (Jabber ID) of the user or group whose chat was cleared.
  /// [chatClearType]: The type of chat clear event, such as "delete" or "clear".
  void onChatCleared(String toJid, String chatClearType);

  /// This listener is triggered whenever a chat is archived or unarchived. Listen to this method to handle
  /// the archive status change of a chat in the UI.
  ///
  /// [toUser]: The JID (Jabber ID) of the user or group whose chat archive status has changed.
  /// [archiveStatus]: A boolean flag indicating the new archive status — `true` for archived, `false` for unarchived.
  void onArchiveUnArchiveChats(String chatJid, bool archiveStatus);

  /// This listener is triggered whenever the archive settings are updated. Listen to this method to handle
  /// changes in the archive chat settings in the UI.
  ///
  /// [archiveSettingStatus]: A boolean flag indicating the updated archive setting status —
  /// `true` if the setting is enabled, `false` if it is disabled.
  void onArchivedSettingsUpdated(bool archiveSettingStatus);

  /// This listener is triggered whenever the mute settings for a chat are updated. Listen to this method to handle
  /// the result of a mute or unmute operation in the UI.
  ///
  /// [isSuccess]: A boolean flag indicating whether the mute/unmute operation was successful.
  /// [message]: A message string providing additional context or details about the result.
  /// [isMuteStatus]: A boolean indicating the updated mute status — `true` if muted, `false` if unmuted.
  void onUpdateMuteSettings(bool isSuccess, String message, bool isMuteStatus);

  /// This listener is triggered whenever the mute status for one or more chats is updated.
  /// Listen to this method to handle bulk mute/unmute operations in the UI.
  ///
  /// [isSuccess]: A boolean flag indicating whether the operation was successful.
  /// [message]: A message string providing additional context or information about the result.
  /// [jidList]: A list of JIDs (Jabber IDs) representing the users or groups whose mute status has changed.
  /// [muteStatus]: A boolean indicating the new mute status — `true` if muted, `false` if unmuted.
  void onChatMuteStatusUpdated(
      bool isSuccess, String message, List<String> jidList, bool muteStatus);
}

/// A class that provides a set of callback methods that can be used to listen for Connection Events in the MirrorFly Flutter Plugin.
abstract class ConnectionEventListeners {
  /// This listener is triggered whenever the connection is established.
  void onConnected();

  /// This listener is triggered whenever the connection is disconnected.
  void onDisconnected();

  /// This listener is triggered whenever the connection is failed.
  void onConnectionFailed(String connectionError);

  /// This listener is triggered whenever the reconnecting.
  void onReconnecting();

  /// This listener is triggered whenever the user logged in is logged out by the server.
  void onLoggedOut();
}

/// A class that provides a set of callback methods that can be used to listen for User Events in the MirrorFly Flutter Plugin.
abstract class ProfileEventListeners {
  /// This listener is triggered whenever the user's profiles are fetched.
  void usersProfilesFetched();

  /// This listener is triggered whenever the user blocked you.
  void userBlockedMe(String jid);

  /// This listener is triggered whenever the user unblocked you.
  void userUnBlockedMe(String jid);

  /// This listener is triggered whenever the user updated his profile.
  void userUpdatedHisProfile(String jid);

  /// This listener is triggered whenever the user deleted his profile.
  void userDeletedHisProfile(String jid);

  /// This listener is triggered whenever you updated your profile.
  void myProfileUpdated();

  /// This listener is triggered whenever the user's profile who blocked you is fetched and synced.
  void usersWhoBlockedMeListFetched(List<String> jidList);

  /// This listener is triggered whenever the user's profile who you blocked is fetched and synced.
  void usersIBlockedListFetched(List<String> jidList);

  /// This listener is triggered whenever the user's profile is fetched.
  void userProfileFetched(String jid, ProfileData profileData);

  /// This listener is triggered whenever you blocked the user.
  void blockedThisUser(String userJid);

  /// This listener is triggered whenever you unblocked the user.
  void unblockedThisUser(String jid);

  /// This listener is triggered when the local contact sync is completed.
  void onContactSyncComplete(bool isSuccess);

  /// This listener is triggered when Admin blocked other user.
  void onAdminBlockedOtherUser(String jid, String chatType, String isBlocked);

  /// This listener is triggered when Admin blocked the user.
  void onAdminBlockedUser(String jid, String isBlocked);
}

/// A class that provides a set of callback methods that can be used to listen for Group Events in the MirrorFly Flutter Plugin.
abstract class GroupEventListeners {
  /// This listener is triggered whenever the group is deleted locally.
  void onGroupDeletedLocally(String groupJid);

  /// This listener is triggered whenever a new member is added to the group.
  void onNewMemberAddedToGroup(
      String groupJid, String newMemberJid, String addedByMemberJid);

  /// This listener is triggered whenever a member is removed from the group.
  void onMemberRemovedFromGroup(
      String groupJid, String removedMemberJid, String removedByMemberJid);

  /// This listener is triggered whenever the group members are fetched.
  void onFetchingGroupMembersCompleted(String groupJid);

  /// This listener is triggered whenever a member is made an admin.
  void onMemberMadeAsAdmin(
      String groupJid, String newAdminMemberJid, String madeByMemberJid);

  /// This listener is triggered whenever a member is removed as an admin.
  void onMemberRemovedAsAdmin(
      String groupJid, String removedAdminMemberJid, String removedByMemberJid);

  /// This listener is triggered whenever a member leaves the group.
  void onLeftFromGroup(String groupJid, String leftUserJid);

  /// This listener is triggered when the notification is received for the group.
  void onGroupNotificationMessage(ChatMessageModel groupNotificationMessage);

  /// This listener is triggered whenever the group profile is updated.
  void onGroupProfileUpdated(String groupJid);

  /// This listener is triggered whenever the group profile is fetched.
  void onGroupProfileFetched(String groupJid);

  /// This listener is triggered whenever the group is created.
  void onNewGroupCreated(String groupJid);

  /// This listener is triggered whenever the super admin deletes the group.
  void onSuperAdminDeleteGroup(String groupJid, String groupName);
}

/// A class that provides a set of callback methods that can be used to listen for Call Events in the MirrorFly Flutter Plugin.
abstract class CallEventListeners {
  /// This listener is triggered whenever the call is synced with call logs. listen to this method and update the UI.
  void onCallLogsUpdated();

  /// This listener is triggered whenever the call log is deleted.
  void onCallLogDeleted(String callLogId);

  /// This listener is triggered whenever the call logs are cleared.
  void onCallLogsCleared();

  /// This listener is triggered whenever the call is missed or not answered.
  void onMissedCall(String userJid, String groupId, bool isOneToOneCall,
      String callType, List<String> userList);

  /// This listener is triggered whenever the video call is answered and local stream started.
  void onLocalVideoTrackAdded(String userJid);

  /// This listener is triggered whenever the video call is answered and remote stream started.
  void onRemoteVideoTrackAdded(String userJid);

  /// This listener is triggered whenever the local and remote streams are added. It's the combination of [onLocalVideoTrackAdded] and [onRemoteVideoTrackAdded].
  void onTrackAdded(String userJid);

  /// This listener is triggered whenever the call status is updated.
  void onCallStatusUpdated(
      String userJid, String callMode, String callType, String callStatus);

  /// This listener is triggered whenever the call related action are received.
  void onCallAction(
      String userJid, String callMode, String callType, String callAction);

  /// This listener is triggered whenever the User is muted or un-muted in the call.
  void onMuteStatusUpdated(String userJid, String muteEvent);

  /// This listener is triggered whenever the User is speaking in the call, with the audio level.
  void onUserSpeaking(String userJid, int audioLevel);

  /// This listener is triggered whenever the User stopped speaking in the call.
  void onUserStoppedSpeaking(String userJid);

  /// This listener is triggered whenever the incoming call is arriving
  void onIncomingCallReceived(String callAction);
}

/// A class that provides a set of callback methods that can be used to listen for Call Link Events in the MirrorFly Flutter Plugin.
abstract class CallLinkEventListeners {
  /// This listener is triggered when the call link is Subscribed success.
  void onSubscribeSuccess();

  /// This listener is triggered whenever the error occurred in the call link subscription.
  void onError(FlyException error);

  /// This Listener is triggered when the local video track added.
  void onLocalVideoTrackAdded(String userJid);

  /// This Listener is triggered whenever the user list updated.
  void onUsersUpdated(List<String> users);
}
