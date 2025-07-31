import 'package:mirrorfly_plugin/android_call_config_builder.dart';
import 'package:mirrorfly_plugin/builder.dart';
import 'package:mirrorfly_plugin/edit_message_params.dart';
import 'package:mirrorfly_plugin/event_handlers.dart';
import 'package:mirrorfly_plugin/fly_chat_method_channel.dart';
import 'package:mirrorfly_plugin/message_params.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'model/callback.dart';
import 'model/notification_applaunch_details.dart';
import 'model/topic_metadata.dart';

/// An abstract base class for the FlyChat platform interface.
///
/// This class serves as a contract for the implementation of the MirrorFly functionality
/// across different platforms. It defines a set of methods that platform-specific implementations
/// of MirrorFly must provide. This ensures a consistent API surface for the higher-level
/// Dart code that interacts with these platform-specific implementations.
///
/// The class extends [PlatformInterface], leveraging the token verification mechanism
/// to ensure that a proper subclass is provided as the implementation.
///
/// Usage:
/// Implementations should override the methods defined in this class to provide
/// platform-specific behavior. The static `instance` field should be set to the
/// platform-specific implementation of [FlyChatFlutterPlatform] that is being used.

abstract class FlyChatFlutterPlatform extends PlatformInterface {
  /// Constructs a [FlyChatFlutterPlatform].
  ///
  /// This constructor initializes the platform interface with a unique token
  /// used for verifying that a platform-specific implementation has been provided.
  FlyChatFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlyChatFlutterPlatform _instance = MethodChannelFlyChatFlutter();

  /// isSDKInitialized is used to check whether the sdk isInitialized or not.
  bool get isSDKInitialized =>
      throw UnimplementedError('isSDKInitialized has not been implemented.');

  /// Gets the current instance of [FlyChatFlutterPlatform].
  ///
  /// This instance should be the platform-specific implementation of the
  /// FlyChat functionality. By default, it uses [MethodChannelFlyChatFlutter].
  ///
  /// Returns the current instance of [FlyChatFlutterPlatform].
  static FlyChatFlutterPlatform get instance => _instance;

  /// Sets the current instance of [FlyChatFlutterPlatform].
  ///
  /// This method allows platform-specific implementations to set themselves as the
  /// instance of [FlyChatFlutterPlatform] that should be used.
  ///
  /// [instance] The instance of [FlyChatFlutterPlatform] to use.
  static set instance(FlyChatFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Initializes the MirrorFly platform with the given [builder] configuration.
  ///
  /// This method sets up the initial configuration for the MirrorFly platform using the provided
  /// [ChatBuilder] instance. It is essential to call this method before performing any operations
  /// with the MirrorFly SDK to ensure that the SDK is properly configured.
  ///
  /// [builder]: A [ChatBuilder] instance containing the configuration settings for the FlyChat SDK.
  ///
  /// Throws [UnimplementedError] if the method has not been implemented in the subclass.
  /// This has been deprecated in favor of [initializeSDK].
  init(ChatBuilder builder) {
    throw UnimplementedError('build() has not been implemented.');
  }

  /// Initializes the SDK with the specified configuration and callback.
  ///
  /// This method configures the SDK using the provided [InitializeSDKBuilder] settings. It is crucial
  /// to invoke this method at the start of your application to ensure the SDK is correctly set up.
  /// The [callback] is executed once the initialization process is complete, providing feedback on
  /// the success or failure of the operation.
  ///
  /// [builder]: The [InitializeSDKBuilder] instance containing the SDK configuration settings.
  /// [callback]: A callback function that receives a [FlyResponse] indicating the result of the SDK initialization.
  ///
  /// Throws [UnimplementedError] if the method has not been implemented in the subclass.
  Future<void> initializeSDK(
      InitializeSDKBuilder builder, Function(FlyResponse response) callback) {
    throw UnimplementedError('build() has not been implemented.');
  }

  /// Configures the Android CallKit settings such as ringtone and UI visibility.
  Future<bool?> configureAndroidCallKit(
      AndroidCallKitSettings builder){
    throw UnimplementedError('build() has not been implemented.');
  }


  /// Checks if private storage is enabled in the SDK settings.
  Future<bool> isPrivateStorageEnabledOrNot() {
    throw UnimplementedError(
        'isPrivateStorageEnabled() has not been implemented.');
  }

  /*Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }*/

  /// Synchronizes contacts with the server.
  Future<void> syncContacts(
      bool isfirsttime, Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /// Queries the current contact sync state.
  Future<bool> contactSyncStateValue() {
    throw UnimplementedError('has not been implemented.');
  }

  /*Future<dynamic> contactSyncState() {
    throw UnimplementedError('has not been implemented.');
  }*/

  /// Revokes the current contact sync operation.
  Future<void> revokeContactSync(Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /// Retrieves a list of users who have blocked the current user.
  Future<void> getUsersWhoBlockedMe(
      [bool server = false, Function(FlyResponse response)? callback]) {
    throw UnimplementedError('has not been implemented.');
  }

  /*Future<dynamic> getUnKnownUserProfiles() {
    throw UnimplementedError('has not been implemented.');
  }*/

  /*Future<dynamic> getMyProfileStatus() {
    throw UnimplementedError('has not been implemented.');
  }*/

  /// Retrieves the current busy status of the user.
  Future<String> getMyBusyStatus() {
    throw UnimplementedError('has not been implemented.');
  }

  /// Retrieves a list of all available busy statuses.
  Future<String?> getBusyStatusList() {
    throw UnimplementedError('has not been implemented.');
  }

  /// Retrieves all messages that have been recalled in a conversation.
  Future<String?> getRecalledMessagesOfAConversation(String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  /// Retrieves the current user's profile status.
  Future<void> setMyBusyStatus(
      String busyStatus, Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to enable or disable the busy status for the current user.
  Future<void> enableDisableBusyStatus(
      bool enable, Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to enable or disable the last seen time for the current user.
  Future<bool?> enableDisableHideLastSeen(bool enable) {
    throw UnimplementedError('has not been implemented.');
  }

  /// Sets the visibility of the last seen time for the current user.
  Future<void> setLastSeenVisibility(
      bool enable, Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /// Retrieves the current user's busy status.
  Future<bool> isBusyStatusEnabled() {
    throw UnimplementedError('has not been implemented.');
  }

  /// Deletes a profile status.
  Future<bool?> deleteProfileStatus(
      String id, String status, bool isCurrentStatus) {
    throw UnimplementedError('has not been implemented.');
  }

  /// Deletes a busy status.
  Future<bool?> deleteBusyStatus(
      String id, String status, bool isCurrentStatus) {
    throw UnimplementedError('has not been implemented.');
  }

  /// Retrieves the media endpoint URL.
  Future<String?> mediaEndPoint() {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to un-favourite all favourite messages.
  Future<void> unFavouriteAllFavouriteMessages(
      Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to mark the conversation as read.
  Future<bool?> markAsRead(String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to start uploading a media file.
  Future<bool?> uploadMedia(String messageid) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to remove all unread message separators.
  /// [jid]: The JID of the conversation.
  Future<bool?> deleteUnreadMessageSeparatorOfAConversation(String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get the group members count.
  Future<int?> getMembersCountOfGroup(String groupJid) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get fetch the group members list from the server is required.
  Future<bool?> doesFetchingMembersListFromServedRequired(String groupJid) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to check if the user last seen is enabled or not.
  Future<bool?> isHideLastSeenEnabled() {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to delete group in offline.
  deleteOfflineGroup(String groupJid) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to set the current user's typing status.
  sendTypingStatus(String toJid, String chattype) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to remove the current user's typing status.
  sendTypingGoneStatus(String toJid, String chattype) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to update the chat mute status.
  updateChatMuteStatus(String jid, bool muteStatus) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to update the list chat mute status.
  updateChatMuteStatusList(List<String> jidList, bool muteStatus) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to update the recent chat pin status.
  updateRecentChatPinStatus(String jid, bool pinStatus) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to delete the recent chat.
  Future<void> deleteRecentChat(
      String jid, Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to set typing status listener.
  setTypingStatusListener() {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to check if the user is unarchived.
  Future<bool?> isUserUnArchived(String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to check if the user is blocked by the admin.
  Future<bool?> getIsProfileBlockedByAdmin() {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to delete the recent chats for the provided JIDs.
  Future<void> deleteRecentChats(
      List<String> jidlist, Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to mark the conversation as read.
  markConversationAsRead(List<String> jidlist) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to mark the conversation as unread.
  markConversationAsUnread(List<String> jidlist) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get the Archived chat list from server.
  getArchivedChatsFromServer() {
    throw UnimplementedError('has not been implemented.');
  }

  /*setCustomValue(String messageId, String key, String value) {
    throw UnimplementedError('has not been implemented.');
  }

  removeCustomValue(String messageId, String key) {
    throw UnimplementedError('has not been implemented.');
  }*/

  /*inviteUserViaSMS(String mobileNo, String message) {
    throw UnimplementedError('has not been implemented.');
  }

  cancelBackup() {
    throw UnimplementedError('has not been implemented.');
  }

  startBackup() {
    throw UnimplementedError('has not been implemented.');
  }*/

  /*cancelRestore() {
    throw UnimplementedError('has not been implemented.');
  }

  clearAllSDKData() {
    throw UnimplementedError('has not been implemented.');
  }*/

  /*getRoster() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String?> getCustomValue(String messageId, String key) {
    throw UnimplementedError('has not been implemented.');
  }*/

  /// This method is used to clear all the conversation.
  Future<void> clearAllConversation(Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to update the FCM Token to the MirrorFly server.
  Future<void> updateFcmToken(
      String firebasetoken, Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get the user is muted or not.
  Future<bool?> isMuted(String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to handle the FCM Push Notification Payload.
  Future<void> handleReceivedMessage(
      Map notificationData, Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get the unread message count.
  Future<String?> getLastNUnreadMessages(int messagesCount) {
    throw UnimplementedError('has not been implemented.');
  }

  /*Future<dynamic> getNUnreadMessagesOfEachUsers(int messagesCount) {
    throw UnimplementedError('has not been implemented.');
  }*/

  /// This method is used to check if archived settings are enabled or not.
  Future<bool?> isArchivedSettingsEnabled() {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to enable/disable the archived settings.
  Future<void> enableDisableArchivedSettings(
      bool enable, Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to update the Archive status of the chat.
  Future<bool?> updateArchiveUnArchiveChat(String jid, bool isArchived) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to set the chat is archived.
  Future<void> setChatArchived(
      String jid, bool isArchived, Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get the group message status count.
  Future<int?> getGroupMessageStatusCount(String messageid) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get the unread message count except muted chat.
  Future<int?> getUnreadMessageCountExceptMutedChat() {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get the recent chat pinned count.
  Future<int?> recentChatPinnedCount() {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get the unread message count.
  Future<int?> getUnreadMessagesCount() {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get the Unsent message of a JID.
  Future<String?> getUnsentMessageOfAJid(String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get the Unsent message of a JID.
  Future<String?> getUnsentMessageOf(String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  /*Future<String?> getUsersListToAddMembersInOldGroup(String groupJid) {
    throw UnimplementedError('has not been implemented.');
  }*/

  /*Future<dynamic> prepareChatConversationToExport(String jid) {
    throw UnimplementedError('has not been implemented.');
  }*/

  /// This method is used to get the Archived chat list.
  Future<void> getArchivedChatList(Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /*Future<dynamic> getMessageActions(List<String> messageidlist) {
    throw UnimplementedError('has not been implemented.');
  }*/

  /*Future<String?> getUsersListToAddMembersInNewGroup() {
    throw UnimplementedError('has not been implemented.');
  }*/

  /// This method is used to get create the group in offline
  Future<bool?> createOfflineGroupInOnline(String groupId) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get the group profile.
  Future<void> getGroupProfile(
      String groupJid, bool server, Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to update the media download status.
  updateMediaDownloadStatus(String mediaMessageId, int progress,
      int downloadStatus, num dataTransferred) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to update the media upload status.
  updateMediaUploadStatus(String mediaMessageId, int progress, int uploadStatus,
      num dataTransferred) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to cancel the media upload or download.
  cancelMediaUploadOrDownload(String messageId) async {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to set the media encryption.
  setMediaEncryption(bool encryption) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to delete all the messages.
  deleteAllMessages() {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get the group JID from the group ID.
  Future<String?> getGroupJid(String groupId) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get user's last seen time.
  Future<void> getUserLastSeenTime(
      String jid, Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get the Authentication Token.
  Future<String?> authToken() {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to register the user.
  Future<void> registerUser(String userIdentifier,
      {String fcmToken = "",
      String userType = "",
      bool isForceRegister = true,
      List<IdentifierMetaData>? identifierMetaData,
      required Function(FlyResponse response) callback}) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to verify the Token.
  Future<String?> verifyToken(String userName, String token) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get the JID of the user from the username.
  Future<String?> getJid(String username) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to send the text message.
  Future<String> sendTextMessage(
      String message, String jid, String replyMessageId,
      {String? topicId}) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to send the location message.
  Future<String> sendLocationMessage(
      String jid, double latitude, double longitude, String replyMessageId,
      {String? topicId}) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to send the image message.
  Future<String> sendImageMessage(
      String jid, String filePath, String? caption, String? replyMessageID,
      {String? imageFileUrl, String? topicId}) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to send the video message.
  Future<String> sendVideoMessage(
      String jid, String filePath, String? caption, String? replyMessageID,
      {String? videoFileUrl,
      num? videoDuration,
      String? thumbImageBase64,
      String? topicId}) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to send the document message.
  Future<String> sendDocumentMessage(
      String jid, String documentPath, String replyMessageId,
      {String? fileUrl, String? topicId}) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to send the audio message.
  Future<String> sendAudioMessage(String jid, String filePath, bool isRecorded,
      String duration, String replyMessageId,
      {String? audioFileUrl, String? topicId}) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to send the file message.
  Future<void> sendMediaFileMessage(
      {required FileMessage messageParams,
      required Function(FlyResponse response) callback}) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to send the message with message params type.
  Future<void> sendMessage(
      {required MessageParams messageParams,
      required Function(FlyResponse response) callback}) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to edit the text message sent previously.
  Future<void> editTextMessage(
      {required EditMessageParams editMessageParams,
      required Function(FlyResponse response) callback}) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to edit the media caption sent previously.
  Future<void> editMediaCaption(
      {required EditMessageParams editMessageParams,
      required Function(FlyResponse response) callback}) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get the registered user list.
  Future<String?> getRegisteredUserList({required bool server}) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get the user list.
  Future<void> getUserList(
      int page,
      String search,
      MetaDataUserList? metaDataUserList,
      Function(FlyResponse response) callback,
      {int perPageResultSize = 20}) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get the call log list.
  Future<void> getCallLogsList(
      int currentPage, Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get the local call log list.
  Future<String> getLocalCallLogs() {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to delete the call log from the list.
  Future<void> deleteCallLog(List<String> jidlist, bool isClearAll,
      Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /// Stream that emits events when a message is received.
  Stream<dynamic> get onMessageReceived =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when a message is edited.
  Stream<dynamic> get onMessageEdited =>
      throw UnimplementedError('has not been implemented.');

  //messageOnReceivedChannel.receiveBroadcastStream().cast();

  /// Stream that emits events when a message status is updated.
  Stream<dynamic> get onMessageStatusUpdated =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when a media status is updated.
  Stream<dynamic> get onMediaStatusUpdated =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when a upload/ downlaod progress is changed.
  Stream<dynamic> get onUploadDownloadProgressChanged =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when a group message is fetched.
  Stream<dynamic> get onGroupProfileFetched =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when a new group is created.
  Stream<dynamic> get onNewGroupCreated =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when a group profile is updated.
  Stream<dynamic> get onGroupProfileUpdated =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when new members are added to a group.
  Stream<dynamic> get onNewMemberAddedToGroup =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when a member is removed from a group.
  Stream<dynamic> get onMemberRemovedFromGroup =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when members are fetched from a group.
  Stream<dynamic> get onFetchingGroupMembersCompleted =>
      throw UnimplementedError('has not been implemented.');

  // Stream<dynamic> get onDeleteGroup => throw UnimplementedError('has not been implemented.');

  // Stream<dynamic> get onFetchingGroupListCompleted => throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when a member is made an admin in a group.
  Stream<dynamic> get onMemberMadeAsAdmin =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when a member is removed as an admin in a group.
  Stream<dynamic> get onMemberRemovedAsAdmin =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when a user leaves a group.
  Stream<dynamic> get onLeftFromGroup =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when a message is received in a group.
  Stream<dynamic> get onGroupNotificationMessage =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when notification is needed to be shown or updated or cancelled.
  Stream<dynamic> get showOrUpdateOrCancelNotification =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when a group is deleted locally.
  Stream<dynamic> get onGroupDeletedLocally =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when user is blocked.
  Stream<dynamic> get blockedThisUser =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when the current user profile is updated.
  Stream<dynamic> get myProfileUpdated =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when the admin blocks another user.
  Stream<dynamic> get onAdminBlockedOtherUser =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when the current user is blocked by admin.
  Stream<dynamic> get onAdminBlockedUser =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when the contact sync is completed.
  Stream<dynamic> get onContactSyncComplete =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when the current user is logged out of the SDK.
  Stream<dynamic> get onLoggedOut =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when the user is unblocked.
  Stream<dynamic> get unblockedThisUser =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when the current user is blocked by another user.
  Stream<dynamic> get userBlockedMe =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when the user came online.
  Stream<dynamic> get userCameOnline =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when the user deleted his profile.
  Stream<dynamic> get userDeletedHisProfile =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when the user's profile is fetched.
  Stream<dynamic> get usersProfilesFetched =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when the user profile is updated.
  Stream<dynamic> get userProfileFetched =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when the user unblocks current user.
  Stream<dynamic> get userUnBlockedMe =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when the user updated his profile.
  Stream<dynamic> get userUpdatedHisProfile =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when the user went offline.
  Stream<dynamic> get userWentOffline =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when the user i blocked list is fetched.
  Stream<dynamic> get usersIBlockedListFetched =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when the user who blocked me list is fetched.
  Stream<dynamic> get usersWhoBlockedMeListFetched =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when the server connection is connected.
  Stream<dynamic> get onConnected =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when the server connection is disconnected.
  Stream<dynamic> get onDisconnected =>
      throw UnimplementedError('has not been implemented.');

  /*Stream<dynamic> get onConnectionNotAuthorized =>
      throw UnimplementedError('has not been implemented.');*/

  /// Stream that emits events when the server connection is failed.
  Stream<dynamic> get onConnectionFailed =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when the server is reconnecting.
  Stream<dynamic> get onReconnecting =>
      throw UnimplementedError('has not been implemented.');

  // Stream<dynamic> get connectionFailed => throw UnimplementedError('has not been implemented.');

  // Stream<dynamic> get connectionSuccess => throw UnimplementedError('has not been implemented.');

  // Stream<dynamic> get onWebChatPasswordChanged =>
  //     throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when the user is typing.
  Stream<dynamic> get setTypingStatus =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when the user is typing in a single chat.
  Stream<dynamic> get onChatTypingStatus =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when the user is typing in a group chat.
  Stream<dynamic> get onGroupTypingStatus =>
      throw UnimplementedError('has not been implemented.');

  // Stream<dynamic> get onFailure => throw UnimplementedError('has not been implemented.');

  // Stream<dynamic> get onProgressChanged => throw UnimplementedError('has not been implemented.');
  //
  // Stream<dynamic> get onSuccess => throw UnimplementedError('has not been implemented.');

  // Stream<dynamic> get onCallReceiving =>
  //     throw UnimplementedError('onCallReceiving has not been implemented.');

  /// Stream that emits events when the video call is connected and the local video track is added.
  Stream<dynamic> get onLocalVideoTrackAdded => throw UnimplementedError(
      'onLocalVideoTrackAdded has not been implemented.');

  /// Stream that emits events when the video call is connected and the remote video track is added.
  Stream<dynamic> get onRemoteVideoTrackAdded => throw UnimplementedError(
      'onRemoteVideoTrackAdded has not been implemented.');

  /// Stream that emits events when the call is connected and the track (local and remote video) tracks is added.
  Stream<dynamic> get onTrackAdded =>
      throw UnimplementedError('onTrackAdded has not been implemented.');

  /// Stream that emits events when the call status is updated.
  Stream<dynamic> get onCallStatusUpdated =>
      throw UnimplementedError('onCallStatusUpdated has not been implemented.');

  /// Stream that emits events when the call action is performed.
  Stream<dynamic> get onCallAction =>
      throw UnimplementedError('onCallAction has not been implemented.');

  /// Stream that emits events when the users in call are muted or un-muted.
  Stream<dynamic> get onMuteStatusUpdated =>
      throw UnimplementedError('onMuteStatusUpdated has not been implemented.');

  /// Stream that emits events when the user in call is speaking.
  Stream<dynamic> get onUserSpeaking =>
      throw UnimplementedError('onUserSpeaking has not been implemented.');

  /// Stream that emits events when the user in call stops speaking.
  Stream<dynamic> get onUserStoppedSpeaking => throw UnimplementedError(
      'onUserStoppedSpeaking has not been implemented.');

  /// Stream that emits events when the call is missed / not answered.
  Stream<dynamic> get onMissedCall =>
      throw UnimplementedError('onMissedCall has not been implemented.');

  /// Stream that emits events when the available features are updated.
  Stream<dynamic> get onAvailableFeaturesUpdated => throw UnimplementedError(
      'onUpdateAvailableFeatures has not been implemented.');

  /// Stream that emits events when the call logs are updated.
  Stream<dynamic> get onCallLogsUpdated =>
      throw UnimplementedError('onCallLogsUpdated has not been implemented.');

  /// Stream that emits events when the call log is deleted.
  Stream<dynamic> get onCallLogDeleted =>
      throw UnimplementedError('onCallLogDeleted has not been implemented.');

  /// Stream that emits events when the call log is cleared.
  Stream<dynamic> get onClearAllCallLog =>
      throw UnimplementedError('onClearAllCallLog has not been implemented.');

  /*Future<String?> imagePath(String imgurl) {
    throw UnimplementedError('has not been implemented.');
  }*/

  /*Future<dynamic> saveProfile(String name, String email) {
    throw UnimplementedError('has not been implemented.');
  }*/

  /*Future<String?> sentFileMessage(String? file, String jid) {
    throw UnimplementedError('has not been implemented.');
  }*/

  /// This method is used to get the recent chat list.
  Future<void> getRecentChatList(Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get the recent chat history.
  Future<void> getRecentChatListHistory(
      {required bool firstSet,
      int limit = 15,
      required Function(FlyResponse response) callback}) {
    throw UnimplementedError(
        'getRecentChatListHistory has not been implemented.');
  }

  /// This method is used to load the messages.
  Future<void> loadMessages(Function(FlyResponse response) callback) {
    throw UnimplementedError('loadMessages has not been implemented.');
  }

  /// This method is used to check if there is any previous messages.
  Future<bool> hasPreviousMessages() {
    throw UnimplementedError('hasPreviousMessages has not been implemented.');
  }

  /// This method is used to load the previous messages.
  Future<void> loadPreviousMessages(Function(FlyResponse response) callback) {
    throw UnimplementedError('loadPreviousMessages has not been implemented.');
  }

  /// This method is used to check if there is any next messages.
  Future<bool> hasNextMessages() {
    throw UnimplementedError('hasNextMessages has not been implemented.');
  }

  /// This method is used to load the next messages.
  Future<void> loadNextMessages(Function(FlyResponse response) callback) {
    throw UnimplementedError('loadNextMessages has not been implemented.');
  }

  /// This method is used to get the message list.
  Future<bool> initializeMessageList(
      {required String userJid,
      String? messageId,
      double? messageTime,
      bool? exclude,
      int limit = 25,
      String? topicId,
      MetaDataMessageList? metaDataMessageList,
      bool ascendingOrder = true}) {
    throw UnimplementedError('initializeMessageList has not been implemented.');
  }

  /// This method is used to get the profile status list.
  Future<String?> getProfileStatusList() {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to insert the default status list.
  Future<bool?> insertDefaultStatus(String status) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to update the current user profile.
  Future<void> updateMyProfile(String name, String? email, String? mobile,
      String? status, String? image, Function(FlyResponse response) callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get the user profile.
  Future<void> getUserProfile(
      String jid, Function(FlyResponse response) callback,
      [bool fromserver = false, bool saveasfriend = false]) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get the user profile details.
  Future<String?> getProfileDetails(String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  /*Future<dynamic> getProfileLocal(String jid, bool server) {
    throw UnimplementedError('has not been implemented.');
  }*/

  /// This method is used to set the user profile status.
  Future<void> setMyProfileStatus(String status, String statusId,
      Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to insert new profile status.
  Future<bool?> insertNewProfileStatus(String status) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to update the profile image.
  Future<void> updateMyProfileImage(
      String image, Function(FlyResponse response) callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to remove the profile image.
  Future<void> removeProfileImage(Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to remove the group profile image.
  Future<void> removeGroupProfileImage(
      String jid, Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to refresh and get the AuthToken.
  Future<void> refreshAndGetAuthToken(
      Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get the AuthToken.
  Future<String> getCurrentAuthToken() {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get the message of a JID / user.
  Future<String?> getMessagesOfJid(String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  /*Future<dynamic> listenMessageEvents() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> listenGroupChatEvents() {
    throw UnimplementedError('has not been implemented.');
  }*/

  /*Future<dynamic> getMedia(String mid) {
    throw UnimplementedError('has not been implemented.');
  }*/

  /// This method is used to delete the unread message separator.
  Future<bool?> markAsReadDeleteUnreadSeparator(String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to send the contact message.
  Future<String> sendContactMessage(List<String> contactList, String jid,
      String contactName, String replyMessageId,
      {String? topicId}) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to logout the user from the SDK.
  Future<void> logoutOfChatSDK(Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to set the current user's chat page/ chat screen.
  setOnGoingChatUser(String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to download the media using the message ID.
  downloadMedia(String mid) {
    throw UnimplementedError('has not been implemented.');
  }

  /*Future<dynamic> openFile(String filePath) {
    throw UnimplementedError('has not been implemented.');
  }*/

  /// This method is used to get the recent chat list including archived.
  Future<String> getRecentChatListIncludingArchived() {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to search the conversation using the keyword.
  Future<void> searchConversation(String searchKey,
      [String? jidForSearch,
      bool globalSearch = true,
      Function(FlyResponse response)? callback]) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get the registered user list.
  Future<void> getRegisteredUsers(
      bool server, Function(FlyResponse response) callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get the message using Message ID.
  Future<String?> getMessageOfId(String mid) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get the recent chat message of a user using JID.
  Future<String> getRecentChatOf(String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to clear the chat of a user using JID.
  Future<void> clearChat(String jid, String chatType, bool clearExceptStarred,
      Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to report the chat or user.
  Future<dynamic> reportChatOrUser(
      String jid, String chatType, String? messageId) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get the messages using the message ID's.
  Future<String?> getMessagesUsingIds(List<String> messageIds) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to delete the messages locally for the user.
  Future<void> deleteMessagesForMe(
      String jid,
      String chatType,
      List<String> messageIds,
      bool? isMediaDelete,
      Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to delete the messages for everyone.
  Future<void> deleteMessagesForEveryone(
      String jid,
      String chatType,
      List<String> messageIds,
      bool? isMediaDelete,
      Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /*/// This method is used to delete the messages.
  Future<dynamic> deleteMessages(
      String jid, List<String> messageIds, bool isDeleteForEveryOne) {
    throw UnimplementedError('has not been implemented.');
  }*/

  /// This method is used to get the message delivered users list in a group.
  Future<String> getGroupMessageDeliveredToList(String messageId, String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get the message delivered users list in a group.
  Future<void> getGroupMessageDeliveredRecipients(
      String messageId, String jid, Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get the message read users list in a group.
  Future<String> getGroupMessageReadByList(String messageId, String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get the message read users list in a group.
  Future<void> getGroupMessageSeenRecipients(
      String messageId, String jid, Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get the message status of a single chat message.
  Future<String> getMessageStatusOfASingleChatMessage(String messageID) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to block the user.
  Future<void> blockUser(
      String userJID, Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to unblock the user.
  Future<void> unblockUser(
      String userJID, Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /*Future<String?> showCustomTones() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String?> getRingtoneName() {
    throw UnimplementedError('has not been implemented.');
  }
  Future<bool?> iOSFileExist(String filePath) {
    throw UnimplementedError('has not been implemented.');
  }

  */

  /// This method is used to login in Web using QR Code
  Future<void> loginWebChatViaQRCode(
      String barcode, Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to clear the web login details
  Future<bool?> webLoginDetailsCleared() {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to logout the user from web
  Future<bool?> logoutWebUser() {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get web login details
  Future<dynamic> getWebLoginDetails() {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to update the favourite status of a message.
  Future<void> updateFavouriteStatus(
      String messageID,
      String chatUserJID,
      bool isFavourite,
      String chatType,
      Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to forward the multiple messages.
  Future<void> forwardMessagesToMultipleUsers(List<String> messageIds,
      List<String> userList, Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /*Future<dynamic> forwardMessages(
      List<String> messageIds, String tojid, String chattype) {
    throw UnimplementedError('has not been implemented.');
  }*/

  /// This method is used to create the group.
  Future<void> createGroup(String groupName, List<String> userJidList,
      String imageFilePath, Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to add the members to the group.
  Future<void> addUsersToGroup(String jid, List<String> userList,
      Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get the group members list.
  Future<void> getGroupMembersList(
      String jid, bool? server, Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get the users blocked by current user.
  Future<void> getUsersIBlocked(
      bool? server, Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get the Media messages.
  Future<String?> getMediaMessages(String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get the Document messages.
  Future<String?> getDocsMessages(String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get the Link messages.
  Future<String?> getLinkMessages(String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to export the chat conversation to email.
  Future<void> exportChatConversationToEmail(
      String jid, Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to report the user or messages.
  Future<void> reportUserOrMessages(String jid, String type, String? messageId,
      Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to make the user as admin in a group.
  Future<void> makeAdmin(String groupjid, String userjid,
      Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to remove the user from group.
  Future<void> removeMemberFromGroup(String groupjid, String userjid,
      Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to leave the group.
  Future<void> leaveFromGroup(String? userJid, String groupJid,
      Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to delete the group.
  Future<void> deleteGroup(
      String jid, Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to check if the user is admin in a group.
  Future<bool?> isAdmin(String userJid, String groupJID) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to update the group profile Image.
  Future<void> updateGroupProfileImage(
      String jid, String file, Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to update the group profile name.
  Future<void> updateGroupName(
      String jid, String name, Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to check the member is in a group.
  Future<bool?> isMemberOfGroup(String jid, String? userJid) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to send contact us information.
  Future<void> sendContactUsInfo(String title, String description,
      Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to copy the text messages.
  copyTextMessages(List<String> messageIds) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to save the unsent message.
  saveUnsentMessage(String jid, String message, List<String>? mentionedUsers) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to delete the account.
  Future<void> deleteAccount(String reason, String? feedback,
      Function(FlyResponse response)? callback) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get the favourite messages.
  Future<String> getFavouriteMessages() {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get All the groups.
  Future<void> getAllGroups(
      [bool? server, Function(FlyResponse response)? callback]) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get the default notification sound URI.
  Future<String?> getDefaultNotificationUri() {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to set the default notification sound.
  Future setDefaultNotificationSound() {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to set the notification URI.
  setNotificationUri(String uri) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to set the notification sound.
  setNotificationSound(bool enable) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to set mute notification.
  setMuteNotification(bool enable) {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to set the notification vibration.
  setNotificationVibration(bool enable) {
    throw UnimplementedError('has not been implemented.');
  }

  /*cancelNotifications() {
    throw UnimplementedError('has not been implemented.');
  }*/

  /// This method is used to save the media settings.
  saveMediaSettings(bool photos, bool videos, bool audio, bool documents,
      int networkType) async {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get the media settings.
  Future<bool?> getMediaSetting(int networkType, String type) async {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get the media auto download settings.
  Future<bool?> getMediaAutoDownload() async {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to set the media auto download settings.
  setMediaAutoDownload(bool enable) async {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get JID from the phone number.
  Future<String?> getJidFromPhoneNumber(
      String mobileNumber, String countryCode) async {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get the notification sound.
  Future<bool?> getNotificationSound() async {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to insert the busy status.
  Future<bool?> insertBusyStatus(String busyStatus) async {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to check if the license is trail or not.
  Future<bool?> isTrailLicence() async {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get the non chat users.
  Future<String?> getNonChatUsers() async {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to add the contact.
  Future<bool?> addContact(String number, String name) async {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to set the region code.
  Future setRegionCode(String regionCode) async {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get the value from the manifest or info.plist based on the platform.
  Future<String> getValueFromManifestOrInfoPlist(
      {String? androidManifestKey, String? iOSPlistKey}) async {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to create the topic.
  Future<void> createTopic(
      {required String topicName,
      List<TopicMetaData> metaData = const [],
      Function(FlyResponse response)? callback}) async {
    throw UnimplementedError('createTopic has not been implemented.');
  }

  /// This method is used to get the topic list.
  Future<void> getTopics(
      {required List<String> topicIds,
      Function(FlyResponse response)? callback}) async {
    throw UnimplementedError('getTopics has not been implemented.');
  }

  /// This method is used to get the recent chat list history by topic.
  Future<void> getRecentChatListHistoryByTopic(
      {String? topicId,
      required bool firstSet,
      int limit = 15,
      required Function(FlyResponse response) callback}) async {
    throw UnimplementedError(
        'getRecentChatListHistoryByTopic has not been implemented.');
  }

  /// Stream that emits events when a backup is completed successfully.
  Stream<dynamic> get onBackupSuccess =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when a backup is failed.
  Stream<dynamic> get onBackupFailure =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when a restore is failed.
  Stream<dynamic> get onRestoreFailure =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when a restore is completed successfully.
  Stream<dynamic> get onRestoreSuccess =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when a backup is progress changes.
  Stream<dynamic> get onBackupProgressChanged =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when a backup is progress changes.
  Stream<dynamic> get onRestoreProgressChanged =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when a chat is cleared.
  Stream<dynamic> get onChatCleared =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when a message is deleted
  Stream<dynamic> get onMessageDeleted =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when a all chats is cleared
  Stream<dynamic> get onAllChatsCleared =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when a message favourites has been updated
  Stream<dynamic> get onUpdateFavourites =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when a corresponding web login is logged out
  Stream<dynamic> get onWebLogout =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when a chat is mute/un-muted
  Stream<dynamic> get onChatMuteStatusUpdated =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when a mute/un-mute setting is updated
  Stream<dynamic> get onUpdateMuteSettings =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when chat is Archived/Unarchived
  Stream<dynamic> get onArchiveUnArchiveChats =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when Archived/Unarchive settings is toggled
  Stream<dynamic> get onArchivedSettingsUpdated =>
      throw UnimplementedError('has not been implemented.');

  /// Stream that emits events when Super Admin deletes the Group
  Stream<dynamic> get onSuperAdminDeleteGroup =>
      throw UnimplementedError('has not been implemented.');

  /// This method is used to make the video call.
  Future<void> makeVideoCall(
      String userJid, Function(FlyResponse response)? callback) async {
    throw UnimplementedError('makeVideoCall has not been implemented.');
  }

  /// This method is used to make the voice call.
  Future<void> makeVoiceCall(
      String userJid, Function(FlyResponse response)? callback) async {
    throw UnimplementedError('makeVoiceCall has not been implemented.');
  }

  /// This method is used to make the group voice call.
  Future<void> makeGroupVoiceCall(String groupJid, List<String>? jidList,
      Function(FlyResponse response)? callback) async {
    throw UnimplementedError('makeGroupVoiceCall has not been implemented.');
  }

  /// This method is used to make the group video call.
  Future<void> makeGroupVideoCall(String groupJid, List<String>? jidList,
      Function(FlyResponse response)? callback) async {
    throw UnimplementedError('makeGroupVideoCall has not been implemented.');
  }

  /// This method is used to get the call users list.
  Future<String> getCallUsersList() async {
    throw UnimplementedError('getCallUsers has not been implemented.');
  }

  /// This method is used to get the call type.
  Future<String> getCallType() async {
    throw UnimplementedError('getCallType has not been implemented.');
  }

  /// This method is used to get the call group JID.
  Future<String> getCallGroupJid() async {
    throw UnimplementedError('getCallGroupJid has not been implemented.');
  }

  /// This method is used to get the call direction.
  Future<String> getCallDirection() async {
    throw UnimplementedError('getCallDirection has not been implemented.');
  }

  /// This method is used to get all the available audio input.
  Future<String> getAllAvailableAudioInput() async {
    throw UnimplementedError(
        'getAllAvailableAudioInput has not been implemented.');
  }

  /// This method is used to switch the camera.
  Future switchCamera() async {
    throw UnimplementedError('switchCamera has not been implemented.');
  }

  /// This method is used to decline the call.
  Future<bool?> declineCall() async {
    throw UnimplementedError('declineCall has not been implemented.');
  }

  /// This method is used to mute the audio.
  Future<void> muteAudio(
      bool status, Function(FlyResponse response)? callback) async {
    throw UnimplementedError('muteAudio has not been implemented.');
  }

  /// This method is used to mute the video.
  Future<void> muteVideo(
      bool status, Function(FlyResponse response)? callback) async {
    throw UnimplementedError('muteVideo has not been implemented.');
  }

  /// This method is used to route the audio to different devices.
  Future<bool?> routeAudioTo({required String routeType}) async {
    throw UnimplementedError('routeAudioTo has not been implemented.');
  }

  /// This method is used to check if the call is ongoing.
  Future<bool?> isOnGoingCall() async {
    throw UnimplementedError('isOnGoingCall has not been implemented.');
  }

  /// This method is used to get current call duration only for Android.
  Future<int?> getCurrentCallDuration() async {
    throw UnimplementedError(
        'getCurrentCallDuration has not been implemented.');
  }

  /// This method is used to disconnect the call.
  Future<void> disconnectCall(Function(FlyResponse response)? callback) async {
    throw UnimplementedError('disconnectCall has not been implemented.');
  }

  /// This method is used to select the audio device.
  Future<String?> selectedAudioDevice() async {
    throw UnimplementedError('selectedAudioDevice has not been implemented.');
  }

  /// This method is used to check if the user audio is muted.
  Future<bool?> isUserAudioMuted([String? userJid]) async {
    throw UnimplementedError('isUserAudioMuted has not been implemented.');
  }

  /// This method is used to check if the user video is muted.
  Future<bool?> isUserVideoMuted([String? userJid]) async {
    throw UnimplementedError('isUserVideoMuted has not been implemented.');
  }

  /// This method is used to get unread missed call count.
  Future<int?> getUnreadMissedCallCount() {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get whether the app is launched from missed call.
  Future<bool?> appLaunchedFromMissedCall() {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to get the app launch details.
  Future<MirrorflyNotificationAppLaunchDetails?> getAppLaunchedDetails() {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to open the audio file picker only for the android platform.
  Future<String?> openAudioFilePicker() async {
    throw UnimplementedError('openAudioFilePicker has not been implemented.');
  }

  /// This method is used to get available features.
  Future<String> getAvailableFeatures() async {
    throw UnimplementedError('getAvailableFeatures has not been implemented.');
  }

  /// This method is used to request the video call switch.
  Future<bool> requestVideoCallSwitch() async {
    throw UnimplementedError(
        'requestVideoCallSwitch has not been implemented.');
  }

  /// This method is used to cancel the video call switch.
  Future<bool> cancelVideoCallSwitch() async {
    throw UnimplementedError('cancelVideoCallSwitch has not been implemented.');
  }

  /// This method is used to accept the video call switch request.
  Future<bool> acceptVideoCallSwitchRequest() async {
    throw UnimplementedError(
        'acceptVideoCallSwitchRequest has not been implemented.');
  }

  /// This method is used to decline the video call switch request.
  Future<bool> declineVideoCallSwitchRequest() async {
    throw UnimplementedError(
        'declineVideoCallSwitchRequest has not been implemented.');
  }

  /// This method is used to get the max call users count.
  Future<int?> getMaxCallUsersCount() async {
    throw UnimplementedError('getMaxCallUsersCount has not been implemented.');
  }

  /// This method is used to invite the users to the ongoing call.
  Future<void> inviteUsersToOngoingCall(
      List<String> jidList, Function(FlyResponse response)? callback) async {
    throw UnimplementedError(
        'inviteUsersToOngoingCall has not been implemented.');
  }

  /// This method is used to get the invited users list.
  Future<List<String>> getInvitedUsersList() async {
    throw UnimplementedError('getInvitedUsersList has not been implemented.');
  }

  /// This method is used to mark all the unread missed calls as read.
  Future<bool?> markAllUnreadMissedCallsAsRead() {
    throw UnimplementedError('has not been implemented.');
  }

  /// This method is used to check if the call conversion request is available.
  Future<bool?> isCallConversionRequestAvailable() {
    throw UnimplementedError(
        'isCallConversionRequestAvailable has not been implemented.');
  }

  /// This method is used to sync the call logs.
  Future<bool?> syncCallLogs() {
    throw UnimplementedError('syncCallLogs has not been implemented.');
  }

  /// This method is used to get screen is from locked state or not.
  Future<bool> isLockScreen() {
    throw UnimplementedError('isLockScreen has not been implemented.');
  }

  /// This method is used to start the backup.
  Future<void> startBackup(bool enableEncryption) {
    throw UnimplementedError('startBackup has not been implemented.');
  }

  /// This method is used to restore the backup.
  Future<void> restoreBackup({required String backupPath}) {
    throw UnimplementedError('restoreBackup has not been implemented.');
  }

  /// This method is used to cancel the backup started.
  Future<void> cancelBackup() {
    throw UnimplementedError('cancelBackup has not been implemented.');
  }

  /// This method is used to cancel the restore started.
  Future<void> cancelRestore() {
    throw UnimplementedError('cancelBackup has not been implemented.');
  }

  /// This method is used to cancel the restore started.
  Future<String> getCurrentCameraPosition() {
    throw UnimplementedError(
        'getCurrentCameraPosition has not been implemented.');
  }

  /// Sets custom translations for the MirrorFly platform.
  Future<void> setTranslations({
    required String fileNameOrPath,
    String? packageName,
    required Function(FlyResponse response) callback,
  }) {
    throw UnimplementedError('setTranslations() has not been implemented.');
  }

  /// This method is used to answer the call
  Future<void> answerCall({required Function(FlyResponse response) callback}) {
    throw UnimplementedError('answerCall() has not been implemented.');
  }

  /// This method is used to whether the call is connected or not
  Future<bool?> isCallConnected({required Function(FlyResponse response) callback}) {
    throw UnimplementedError('answerCall() has not been implemented.');
  }

  /// This listener is set to listen the message events.
  setMessageEventListener(MessageEventListeners? messageEventsListener) {
    throw UnimplementedError(
        'setMessageEventListener has not been implemented.');
  }

  /// This listener is set to listen the connection events.
  setConnectionEventListener(
      ConnectionEventListeners? connectionEventsListener) {
    throw UnimplementedError(
        'setConnectionEventListener has not been implemented.');
  }

  /// This listener is set to listen the group events.
  setGroupEventsListener(GroupEventListeners? groupEventsListener) {
    throw UnimplementedError(
        'setGroupEventsListener has not been implemented.');
  }

  /// This listener is set to listen the profile events.
  setProfileEventsListener(ProfileEventListeners? profileEventsListener) {
    throw UnimplementedError(
        'setProfileEventsListener has not been implemented.');
  }

  /// This listener is set to listen the call events.
  setCallEventListener(CallEventListeners? callEventsListener) {
    throw UnimplementedError('setCallEventListener has not been implemented.');
  }

/*Future<dynamic> changeCallType({required String switchType}) async {
    throw UnimplementedError('changeCallType has not been implemented.');
  }

  Future reRouteAudio() async {
    throw UnimplementedError('reRouteAudio has not been implemented.');
  }*/

  /// This method is used to get the metadata.
  getMetaData(Function(FlyResponse response) callback) {
    throw UnimplementedError('getMetaData has not been implemented.');
  }

  /// This method is used to update the metadata.
  updateMetaData(List<IdentifierMetaData>? identifierMetaData,
      Function(FlyResponse response)? callback) {
    throw UnimplementedError('getMetaData has not been implemented.');
  }

  /// This listener is set to listen the call link events.
  void setCallLinkEventListener(CallLinkEventListeners callLinkEventsListener) {
    throw UnimplementedError(
        'setCallLinkEventListener has not been implemented.');
  }

  /// This method is used to create the meet link.
  Future<void> createMeetLink(Function(FlyResponse response)? callback) {
    throw UnimplementedError('createMeetLink has not been implemented.');
  }

  /// This method is used to get the ongoing call link.
  Future<String> getCallLink() {
    throw UnimplementedError('getCallLink has not been implemented.');
  }

  /// This method is used to initialize the meet.
  Future<void> initializeMeet(String callLink, String userName,
      Function(FlyResponse response)? callback) {
    throw UnimplementedError('initializeMeet has not been implemented.');
  }

  /// This method is used to clear the resources observers.
  Future<void> disposePreview() {
    throw UnimplementedError('disposePreview has not been implemented.');
  }

  /// This method is used to join the call.
  Future<void> joinCall(Function(FlyResponse response)? callback) {
    throw UnimplementedError('joinCall has not been implemented.');
  }

  /// This method is used to start the video capture in joined via link call.
  Future<void> startVideoCapture(Function(FlyResponse response)? callback) {
    throw UnimplementedError('startVideoCapture has not been implemented.');
  }

  /// This method is used to get the Meet username.
  Future<String> getMeetUsername(String jid) {
    throw UnimplementedError('getMeetUsername has not been implemented.');
  }

  /// Stream that emits events when the call link subscribed success.
  Stream<dynamic> get onSubscribeSuccess =>
      throw UnimplementedError('onSubscribeSuccess has not been implemented');

  /// Stream that emits events when the call link subscribe error
  Stream<dynamic> get onError =>
      throw UnimplementedError('onError has not been implemented');

  /// Stream that emits events when the call link users are updated
  Stream<dynamic> get onUsersUpdated =>
      throw UnimplementedError('onUsersUpdated has not been implemented');

  /// Stream that emits events when the incoming call is arrived
  Stream<dynamic> get onIncomingCallReceived =>
      throw UnimplementedError('onIncomingCallReceived has not been implemented');

}
