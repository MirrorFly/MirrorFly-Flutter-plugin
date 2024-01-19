import 'package:mirrorfly_plugin/builder.dart';
import 'package:mirrorfly_plugin/fly_chat_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'model/callback.dart';
import 'model/topic_metadata.dart';

abstract class FlyChatFlutterPlatform extends PlatformInterface {
  /// Constructs a UikitFlutterPlatform.
  FlyChatFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlyChatFlutterPlatform _instance = MethodChannelFlyChatFlutter();

  /// The default instance of [FlyChatFlutterPlatform] to use.
  ///
  /// Defaults to MethodChannelUikitFlutter.
  static FlyChatFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlyChatFlutterPlatform] when
  /// they register themselves.
  static set instance(FlyChatFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  init(ChatBuilder builder) {
    throw UnimplementedError('build() has not been implemented.');
  }

  Future<void> initializeSDK(InitializeSDKBuilder builder, Function(FlyResponse response) callback) {
    throw UnimplementedError('build() has not been implemented.');
  }

  /*Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }*/

  Future<bool?> syncContacts(bool isfirsttime) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String?> getSendData() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool> contactSyncStateValue() {
    throw UnimplementedError('has not been implemented.');
  }

  /*Future<dynamic> contactSyncState() {
    throw UnimplementedError('has not been implemented.');
  }*/

  Future<dynamic> revokeContactSync() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> getUsersWhoBlockedMe([bool server = false]) {
    throw UnimplementedError('has not been implemented.');
  }

  /*Future<dynamic> getUnKnownUserProfiles() {
    throw UnimplementedError('has not been implemented.');
  }*/

  /*Future<dynamic> getMyProfileStatus() {
    throw UnimplementedError('has not been implemented.');
  }*/

  Future<String> getMyBusyStatus() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String?> getBusyStatusList() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String?> getRecalledMessagesOfAConversation(String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> setMyBusyStatus(String busyStatus) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> enableDisableBusyStatus(bool enable) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> enableDisableHideLastSeen(bool enable) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> isBusyStatusEnabled() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> deleteProfileStatus(String id, String status, bool isCurrentStatus) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> deleteBusyStatus(String id, String status, bool isCurrentStatus) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String?> mediaEndPoint() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> unFavouriteAllFavouriteMessages() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> markAsRead(String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> uploadMedia(String messageid) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> deleteUnreadMessageSeparatorOfAConversation(String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<int?> getMembersCountOfGroup(String groupJid) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> doesFetchingMembersListFromServedRequired(String groupJid) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> isHideLastSeenEnabled() {
    throw UnimplementedError('has not been implemented.');
  }

  deleteOfflineGroup(String groupJid) {
    throw UnimplementedError('has not been implemented.');
  }

  sendTypingStatus(String toJid, String chattype) {
    throw UnimplementedError('has not been implemented.');
  }

  sendTypingGoneStatus(String toJid, String chattype) {
    throw UnimplementedError('has not been implemented.');
  }

  updateChatMuteStatus(String jid, bool muteStatus) {
    throw UnimplementedError('has not been implemented.');
  }

  updateRecentChatPinStatus(String jid, bool pinStatus) {
    throw UnimplementedError('has not been implemented.');
  }

  deleteRecentChat(String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  setTypingStatusListener() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> isUserUnArchived(String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> getIsProfileBlockedByAdmin() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> deleteRecentChats(List<String> jidlist) {
    throw UnimplementedError('has not been implemented.');
  }

  markConversationAsRead(List<String> jidlist) {
    throw UnimplementedError('has not been implemented.');
  }

  markConversationAsUnread(List<String> jidlist) {
    throw UnimplementedError('has not been implemented.');
  }

  getArchivedChatsFromServer() {
    throw UnimplementedError('has not been implemented.');
  }

  setCustomValue(String messageId, String key, String value) {
    throw UnimplementedError('has not been implemented.');
  }

  removeCustomValue(String messageId, String key) {
    throw UnimplementedError('has not been implemented.');
  }

  inviteUserViaSMS(String mobileNo, String message) {
    throw UnimplementedError('has not been implemented.');
  }

  cancelBackup() {
    throw UnimplementedError('has not been implemented.');
  }

  startBackup() {
    throw UnimplementedError('has not been implemented.');
  }

  cancelRestore() {
    throw UnimplementedError('has not been implemented.');
  }

  clearAllSDKData() {
    throw UnimplementedError('has not been implemented.');
  }

  getRoster() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String?> getCustomValue(String messageId, String key) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> clearAllConversation() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> updateFcmToken(String firebasetoken) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> isMuted(String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String?> handleReceivedMessage(Map notificationData) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String?> getLastNUnreadMessages(int messagesCount) {
    throw UnimplementedError('has not been implemented.');
  }

  /*Future<dynamic> getNUnreadMessagesOfEachUsers(int messagesCount) {
    throw UnimplementedError('has not been implemented.');
  }*/

  Future<bool?> isArchivedSettingsEnabled() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> enableDisableArchivedSettings(bool enable) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> updateArchiveUnArchiveChat(String jid, bool isArchived) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<int?> getGroupMessageStatusCount(String messageid) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<int?> getUnreadMessageCountExceptMutedChat() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<int?> recentChatPinnedCount() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<int?> getUnreadMessagesCount() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String?> getUnsentMessageOfAJid(String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  /*Future<String?> getUsersListToAddMembersInOldGroup(String groupJid) {
    throw UnimplementedError('has not been implemented.');
  }*/

  /*Future<dynamic> prepareChatConversationToExport(String jid) {
    throw UnimplementedError('has not been implemented.');
  }*/

  Future<String?> getArchivedChatList() {
    throw UnimplementedError('has not been implemented.');
  }

  /*Future<dynamic> getMessageActions(List<String> messageidlist) {
    throw UnimplementedError('has not been implemented.');
  }*/

  /*Future<String?> getUsersListToAddMembersInNewGroup() {
    throw UnimplementedError('has not been implemented.');
  }*/

  Future<bool?> createOfflineGroupInOnline(String groupId) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String?> getGroupProfile(String groupJid, bool server) {
    throw UnimplementedError('has not been implemented.');
  }

  updateMediaDownloadStatus(String mediaMessageId, int progress, int downloadStatus, num dataTransferred) {
    throw UnimplementedError('has not been implemented.');
  }

  updateMediaUploadStatus(String mediaMessageId, int progress, int uploadStatus, num dataTransferred) {
    throw UnimplementedError('has not been implemented.');
  }

  cancelMediaUploadOrDownload(String messageId) async {
    throw UnimplementedError('has not been implemented.');
  }

  setMediaEncryption(String encryption) {
    throw UnimplementedError('has not been implemented.');
  }

  deleteAllMessages() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String?> getGroupJid(String groupId) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String?> getUserLastSeenTime(String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String?> authToken() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<void> registerUser(String userIdentifier,
      {String fcmToken = "", bool isForceRegister = true, required Function(FlyResponse response) callback}) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String?> verifyToken(String userName, String token) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String?> getJid(String username) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String> sendTextMessage(String message, String jid, String replyMessageId, {String? topicId}) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String> sendLocationMessage(String jid, double latitude, double longitude, String replyMessageId,
      {String? topicId}) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String> sendImageMessage(String jid, String filePath, String? caption, String? replyMessageID,
      {String? imageFileUrl, String? topicId}) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String> sendVideoMessage(String jid, String filePath, String? caption, String? replyMessageID,
      {String? videoFileUrl, num? videoDuration, String? thumbImageBase64, String? topicId}) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String?> getRegisteredUserList({required bool server}) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<void> getUserList(int page, String search, Function(FlyResponse response) callback,
      {int perPageResultSize = 20}) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String?> getCallLogsList(int currentPage) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String> getLocalCallLogs() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool> deleteCallLog(List<String> jidlist, bool isClearAll) {
    throw UnimplementedError('has not been implemented.');
  }

  Stream<dynamic> get onMessageReceived => throw UnimplementedError('has not been implemented.');

  //messageOnReceivedChannel.receiveBroadcastStream().cast();

  Stream<dynamic> get onMessageStatusUpdated => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get onMediaStatusUpdated => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get onUploadDownloadProgressChanged => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get onGroupProfileFetched => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get onNewGroupCreated => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get onGroupProfileUpdated => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get onNewMemberAddedToGroup => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get onMemberRemovedFromGroup => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get onFetchingGroupMembersCompleted => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get onDeleteGroup => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get onFetchingGroupListCompleted => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get onMemberMadeAsAdmin => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get onMemberRemovedAsAdmin => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get onLeftFromGroup => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get onGroupNotificationMessage => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get showOrUpdateOrCancelNotification => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get onGroupDeletedLocally => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get blockedThisUser => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get myProfileUpdated => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get onAdminBlockedOtherUser => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get onAdminBlockedUser => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get onContactSyncComplete => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get onLoggedOut => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get unblockedThisUser => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get userBlockedMe => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get userCameOnline => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get userDeletedHisProfile => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get usersProfilesFetched => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get userProfileFetched => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get userUnBlockedMe => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get userUpdatedHisProfile => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get userWentOffline => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get usersIBlockedListFetched => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get usersWhoBlockedMeListFetched => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get onConnected => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get onDisconnected => throw UnimplementedError('has not been implemented.');

  /*Stream<dynamic> get onConnectionNotAuthorized =>
      throw UnimplementedError('has not been implemented.');*/

  Stream<dynamic> get onConnectionFailed => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get connectionFailed => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get connectionSuccess => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get onWebChatPasswordChanged => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get setTypingStatus => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get onChatTypingStatus => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get onGroupTypingStatus => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get onFailure => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get onProgressChanged => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get onSuccess => throw UnimplementedError('has not been implemented.');

  // Stream<dynamic> get onCallReceiving =>
  //     throw UnimplementedError('onCallReceiving has not been implemented.');

  Stream<dynamic> get onLocalVideoTrackAdded =>
      throw UnimplementedError('onLocalVideoTrackAdded has not been implemented.');

  Stream<dynamic> get onRemoteVideoTrackAdded =>
      throw UnimplementedError('onRemoteVideoTrackAdded has not been implemented.');

  Stream<dynamic> get onTrackAdded => throw UnimplementedError('onTrackAdded has not been implemented.');

  Stream<dynamic> get onCallStatusUpdated => throw UnimplementedError('onCallStatusUpdated has not been implemented.');

  Stream<dynamic> get onCallAction => throw UnimplementedError('onCallAction has not been implemented.');

  Stream<dynamic> get onMuteStatusUpdated => throw UnimplementedError('onMuteStatusUpdated has not been implemented.');

  Stream<dynamic> get onUserSpeaking => throw UnimplementedError('onUserSpeaking has not been implemented.');

  Stream<dynamic> get onUserStoppedSpeaking =>
      throw UnimplementedError('onUserStoppedSpeaking has not been implemented.');

  Stream<dynamic> get onMissedCall => throw UnimplementedError('onMissedCall has not been implemented.');

  Stream<dynamic> get onAvailableFeaturesUpdated =>
      throw UnimplementedError('onUpdateAvailableFeatures has not been implemented.');

  Stream<dynamic> get onCallLogsUpdated => throw UnimplementedError('onCallLogsUpdated has not been implemented.');

  Stream<dynamic> get onCallLogsDeleted => throw UnimplementedError('onCallLogsDeleted has not been implemented.');

  Future<String?> imagePath(String imgurl) {
    throw UnimplementedError('has not been implemented.');
  }

  /*Future<dynamic> saveProfile(String name, String email) {
    throw UnimplementedError('has not been implemented.');
  }*/

  Future<String?> sentFileMessage(String? file, String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String> getRecentChatList() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<void> getRecentChatListHistory(
      {required bool firstSet, int limit = 15, required Function(FlyResponse response) callback}) {
    throw UnimplementedError('getRecentChatListHistory has not been implemented.');
  }

  Future<void> loadMessages(Function(FlyResponse response) callback) {
    throw UnimplementedError('loadMessages has not been implemented.');
  }

  Future<bool> hasPreviousMessages() {
    throw UnimplementedError('hasPreviousMessages has not been implemented.');
  }

  Future<void> loadPreviousMessages(Function(FlyResponse response) callback) {
    throw UnimplementedError('loadPreviousMessages has not been implemented.');
  }

  Future<bool> hasNextMessages() {
    throw UnimplementedError('hasNextMessages has not been implemented.');
  }

  Future<void> loadNextMessages(Function(FlyResponse response) callback) {
    throw UnimplementedError('loadNextMessages has not been implemented.');
  }

  Future<dynamic> initializeMessageList(
      {required String userJid,
      String? messageId,
      double? messageTime,
      bool? exclude,
      int limit = 25,
      String? topicId,
      bool ascendingOrder = true}) {
    throw UnimplementedError('initializeMessageList has not been implemented.');
  }

  Future<String?> getProfileStatusList() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> insertDefaultStatus(String status) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<void> updateMyProfile(
      String name, String email, String mobile, String status, String? image, Function(FlyResponse response) callback) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<void> getUserProfile(String jid, Function(FlyResponse response) callback,
      [bool fromserver = false, bool saveasfriend = false]) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String?> getProfileDetails(String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  /*Future<dynamic> getProfileLocal(String jid, bool server) {
    throw UnimplementedError('has not been implemented.');
  }*/

  Future<dynamic> setMyProfileStatus(String status, String statusId) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> insertNewProfileStatus(String status) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<void> updateMyProfileImage(String image, Function(FlyResponse response) callback) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> removeProfileImage() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> removeGroupProfileImage(String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String?> refreshAndGetAuthToken() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String> getCurrentAuthToken() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String?> getMessagesOfJid(String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> listenMessageEvents() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> listenGroupChatEvents() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> getMedia(String mid) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> markAsReadDeleteUnreadSeparator(String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String> sendContactMessage(List<String> contactList, String jid, String contactName, String replyMessageId,
      {String? topicId}) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool> logoutOfChatSDK() {
    throw UnimplementedError('has not been implemented.');
  }

  setOnGoingChatUser(String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  downloadMedia(String mid) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String> sendDocumentMessage(String jid, String documentPath, String replyMessageId,
      {String? fileUrl, String? topicId}) {
    throw UnimplementedError('has not been implemented.');
  }

  /*Future<dynamic> openFile(String filePath) {
    throw UnimplementedError('has not been implemented.');
  }*/

  Future<String> sendAudioMessage(String jid, String filePath, bool isRecorded, String duration, String replyMessageId,
      {String? audioFileUrl, String? topicId}) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> getRecentChatListIncludingArchived() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String> searchConversation(String searchKey, [String? jidForSearch, bool globalSearch = true]) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<void> getRegisteredUsers(bool server, Function(FlyResponse response) callback) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String?> getMessageOfId(String mid) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String> getRecentChatOf(String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool> clearChat(String jid, String chatType, bool clearExceptStarred) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> reportChatOrUser(String jid, String chatType, String? messageId) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String?> getMessagesUsingIds(List<String> messageIds) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> deleteMessagesForMe(String jid, String chatType, List<String> messageIds, bool? isMediaDelete) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool> deleteMessagesForEveryone(String jid, String chatType, List<String> messageIds, bool? isMediaDelete) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> deleteMessages(String jid, List<String> messageIds, bool isDeleteForEveryOne) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> getGroupMessageDeliveredToList(String messageId, String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String> getGroupMessageReadByList(String messageId, String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> getMessageStatusOfASingleChatMessage(String messageID) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> blockUser(String userJID) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> unblockUser(String userJID) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String?> showCustomTones() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String?> getRingtoneName() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> loginWebChatViaQRCode(String barcode) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> webLoginDetailsCleared() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> logoutWebUser(List<String> logins) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> iOSFileExist(String filePath) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> getWebLoginDetails() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> updateFavouriteStatus(String messageID, String chatUserJID, bool isFavourite, String chatType) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> forwardMessagesToMultipleUsers(List<String> messageIds, List<String> userList) {
    throw UnimplementedError('has not been implemented.');
  }

  /*Future<dynamic> forwardMessages(
      List<String> messageIds, String tojid, String chattype) {
    throw UnimplementedError('has not been implemented.');
  }*/

  Future<bool?> createGroup(String groupName, List<String> userJidList, String imageFilePath) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> addUsersToGroup(String jid, List<String> userList) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String> getGroupMembersList(String jid, bool? server) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> getUsersIBlocked(bool? server) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String?> getMediaMessages(String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String?> getDocsMessages(String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String?> getLinkMessages(String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String> exportChatConversationToEmail(String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> reportUserOrMessages(String jid, String type, String? messageId) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> makeAdmin(String groupjid, String userjid) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> removeMemberFromGroup(String groupjid, String userjid) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> leaveFromGroup(String? userJid, String groupJid) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> deleteGroup(String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> isAdmin(String userJid, String groupJID) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> updateGroupProfileImage(String jid, String file) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> updateGroupName(String jid, String name) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> isMemberOfGroup(String jid, String? userJid) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> sendContactUsInfo(String title, String description) {
    throw UnimplementedError('has not been implemented.');
  }

  copyTextMessages(List<String> messageIds) {
    throw UnimplementedError('has not been implemented.');
  }

  saveUnsentMessage(String jid, String message) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> deleteAccount(String reason, String? feedback) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String> getFavouriteMessages() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String?> getAllGroups([bool? server]) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String?> getDefaultNotificationUri() {
    throw UnimplementedError('has not been implemented.');
  }

  Future setDefaultNotificationSound() {
    throw UnimplementedError('has not been implemented.');
  }

  setNotificationUri(String uri) {
    throw UnimplementedError('has not been implemented.');
  }

  setNotificationSound(bool enable) {
    throw UnimplementedError('has not been implemented.');
  }

  setMuteNotification(bool enable) {
    throw UnimplementedError('has not been implemented.');
  }

  setNotificationVibration(bool enable) {
    throw UnimplementedError('has not been implemented.');
  }

  /*cancelNotifications() {
    throw UnimplementedError('has not been implemented.');
  }*/

  saveMediaSettings(bool photos, bool videos, bool audio, bool documents, int networkType) async {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> getMediaSetting(int networkType, String type) async {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> getMediaAutoDownload() async {
    throw UnimplementedError('has not been implemented.');
  }

  setMediaAutoDownload(bool enable) async {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String?> getJidFromPhoneNumber(String mobileNumber, String countryCode) async {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> getNotificationSound() async {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> insertBusyStatus(String busyStatus) async {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> isTrailLicence() async {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String?> getNonChatUsers() async {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> addContact(String number, String name) async {
    throw UnimplementedError('has not been implemented.');
  }

  Future setRegionCode(String regionCode) async {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String> getValueFromManifestOrInfoPlist({String? androidManifestKey, String? iOSPlistKey}) async {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String?> createTopic({required String topicName, List<TopicMetaData> metaData = const []}) async {
    throw UnimplementedError('createTopic has not been implemented.');
  }

  Future<String?> getTopics({required List<String> topicIds}) async {
    throw UnimplementedError('getTopics has not been implemented.');
  }

  Future<void> getRecentChatListHistoryByTopic(
      {String? topicId,
      required bool firstSet,
      int limit = 15,
      required Function(FlyResponse response) callback}) async {
    throw UnimplementedError('getRecentChatListHistoryByTopic has not been implemented.');
  }

  Future<bool> makeVideoCall(String userJid) async {
    throw UnimplementedError('makeVideoCall has not been implemented.');
  }

  Future<bool> makeVoiceCall(String userJid) async {
    throw UnimplementedError('makeVoiceCall has not been implemented.');
  }

  Future<bool> makeGroupVoiceCall(String groupJid, List<String>? jidList) async {
    throw UnimplementedError('makeGroupVoiceCall has not been implemented.');
  }

  Future<bool> makeGroupVideoCall(String groupJid, List<String>? jidList) async {
    throw UnimplementedError('makeGroupVideoCall has not been implemented.');
  }

  Future<dynamic> getCallUsersList() async {
    throw UnimplementedError('getCallUsers has not been implemented.');
  }

  Future<String> getCallType() async {
    throw UnimplementedError('getCallType has not been implemented.');
  }

  Future<String> getCallGroupJid() async {
    throw UnimplementedError('getCallGroupJid has not been implemented.');
  }

  Future<String> getCallDirection() async {
    throw UnimplementedError('getCallDirection has not been implemented.');
  }

  Future<String> getAllAvailableAudioInput() async {
    throw UnimplementedError('getAllAvailableAudioInput has not been implemented.');
  }

  Future switchCamera() async {
    throw UnimplementedError('switchCamera has not been implemented.');
  }

  Future<bool?> declineCall() async {
    throw UnimplementedError('declineCall has not been implemented.');
  }

  Future<bool?> muteAudio(bool status) async {
    throw UnimplementedError('muteAudio has not been implemented.');
  }

  Future<bool?> muteVideo(bool status) async {
    throw UnimplementedError('muteVideo has not been implemented.');
  }

  Future<bool?> routeAudioTo({required String routeType}) async {
    throw UnimplementedError('routeAudioTo has not been implemented.');
  }

  Future<bool?> isOnGoingCall() async {
    throw UnimplementedError('isOnGoingCall has not been implemented.');
  }

  Future<bool?> disconnectCall() async {
    throw UnimplementedError('disconnectCall has not been implemented.');
  }

  Future<String?> selectedAudioDevice() async {
    throw UnimplementedError('selectedAudioDevice has not been implemented.');
  }

  Future<bool?> isUserAudioMuted([String? userJid]) async {
    throw UnimplementedError('isUserAudioMuted has not been implemented.');
  }

  Future<bool?> isUserVideoMuted([String? userJid]) async {
    throw UnimplementedError('isUserVideoMuted has not been implemented.');
  }

  Future<int?> getUnreadMissedCallCount() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> appLaunchedFromMissedCall() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String?> openAudioFilePicker() async {
    throw UnimplementedError('openAudioFilePicker has not been implemented.');
  }

  Future<String> getAvailableFeatures() async {
    throw UnimplementedError('getAvailableFeatures has not been implemented.');
  }

  Future<dynamic> requestVideoCallSwitch() async {
    throw UnimplementedError('requestVideoCallSwitch has not been implemented.');
  }

  Future<dynamic> cancelVideoCallSwitch() async {
    throw UnimplementedError('cancelVideoCallSwitch has not been implemented.');
  }

  Future<dynamic> acceptVideoCallSwitchRequest() async {
    throw UnimplementedError('acceptVideoCallSwitchRequest has not been implemented.');
  }

  Future<dynamic> declineVideoCallSwitchRequest() async {
    throw UnimplementedError('declineVideoCallSwitchRequest has not been implemented.');
  }

  Future<int?> getMaxCallUsersCount() async {
    throw UnimplementedError('getMaxCallUsersCount has not been implemented.');
  }

  Future inviteUsersToOngoingCall(List<String> jidList) async {
    throw UnimplementedError('inviteUsersToOngoingCall has not been implemented.');
  }

  Future<List<String>> getInvitedUsersList() async {
    throw UnimplementedError('getInvitedUsersList has not been implemented.');
  }

  Future<bool?> markAllUnreadMissedCallsAsRead() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> isCallConversionRequestAvailable() {
    throw UnimplementedError('isCallConversionRequestAvailable has not been implemented.');
  }

  Future<bool?> syncCallLogs() {
    throw UnimplementedError('syncCallLogs has not been implemented.');
  }

/*Future<dynamic> changeCallType({required String switchType}) async {
    throw UnimplementedError('changeCallType has not been implemented.');
  }

  Future reRouteAudio() async {
    throw UnimplementedError('reRouteAudio has not been implemented.');
  }*/
}
