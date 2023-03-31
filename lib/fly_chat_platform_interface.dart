import 'package:fly_chat/builder.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:fly_chat/fly_chat_method_channel.dart';


abstract class FlyChatFlutterPlatform extends PlatformInterface {
  /// Constructs a UikitFlutterPlatform.
  FlyChatFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlyChatFlutterPlatform _instance = MethodChannelFlyChatFlutter();

  /// The default instance of [FlyChatFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelUikitFlutter].
  static FlyChatFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlyChatFlutterPlatform] when
  /// they register themselves.
  static set instance(FlyChatFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  init(ChatBuilder builder){
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

  Future<dynamic> contactSyncState() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> revokeContactSync() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> getUsersWhoBlockedMe([bool server = false]) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> getUnKnownUserProfiles() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> getMyProfileStatus() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> getMyBusyStatus() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> getBusyStatusList() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> getRecalledMessagesOfAConversation(String jid) {
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

  Future<bool?> deleteProfileStatus(
      String id, String status,
      bool isCurrentStatus) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> deleteBusyStatus(
      String id, String status, bool isCurrentStatus) {
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

  Future<bool?> doesFetchingMembersListFromServedRequired(
      String groupJid) {
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

  Future<dynamic> handleReceivedMessage(Map notificationdata) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> getLastNUnreadMessages(int messagesCount) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> getNUnreadMessagesOfEachUsers(int messagesCount) {
    throw UnimplementedError('has not been implemented.');
  }

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

  Future<dynamic> getUsersListToAddMembersInOldGroup(String groupJid) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> prepareChatConversationToExport(String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> getArchivedChatList() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> getMessageActions(List<String> messageidlist) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> getUsersListToAddMembersInNewGroup() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> createOfflineGroupInOnline(String groupId) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> getGroupProfile(String groupJid, bool server) {
    throw UnimplementedError('has not been implemented.');
  }

  updateMediaDownloadStatus(String mediaMessageId, int progress,
      int downloadStatus, num dataTransferred) {
    throw UnimplementedError('has not been implemented.');
  }

  updateMediaUploadStatus(String mediaMessageId, int progress, int uploadStatus,
      num dataTransferred) {
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

  Future<String?> getGroupJid(String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String?> getUserLastSeenTime(String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String?> authToken() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> registerUser(String userIdentifier, {String token = ""}) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String?> verifyToken(String userName, String token) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<String?> getJid(String username) {
    throw UnimplementedError('has not been implemented.');
  }

  sendTextMessage(String message, String jid, String replyMessageId) {
    throw UnimplementedError('has not been implemented.');
  }

  sendLocationMessage(String jid, double latitude, double longitude,
      String replyMessageId) {
    throw UnimplementedError('has not been implemented.');
  }

  sendImageMessage(
      String jid, String filePath, String? caption, String? replyMessageID,
      [String? imageFileUrl]) {
    throw UnimplementedError('has not been implemented.');
  }

  sendVideoMessage(
      String jid, String filePath, String? caption, String? replyMessageID,
      [String? videoFileUrl,
        num? videoDuration,
        String? thumbImageBase64]) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> getRegisteredUserList({required bool server}) {
    throw UnimplementedError('has not been implemented.');
  }

  getUserList(int page, String search, [int perPageResultSize = 20]) {
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

  Stream<dynamic> get onFetchingGroupMembersCompleted =>
      throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get onDeleteGroup => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get onFetchingGroupListCompleted =>
      throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get onMemberMadeAsAdmin => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get onMemberRemovedAsAdmin => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get onLeftFromGroup => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get onGroupNotificationMessage =>
      throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get onGroupDeletedLocally => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get blockedThisUser => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get myProfileUpdated => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get onAdminBlockedOtherUser => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get onAdminBlockedUser => throw UnimplementedError('has not been implemented.');

  Stream<bool> get onContactSyncComplete => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get onLoggedOut => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get unblockedThisUser => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get userBlockedMe => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get userCameOnline => throw UnimplementedError('has not been implemented.');

  Stream<String> get userDeletedHisProfile => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get userProfileFetched => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get userUnBlockedMe => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get userUpdatedHisProfile => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get userWentOffline => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get usersIBlockedListFetched => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get usersWhoBlockedMeListFetched =>
      throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get onConnected => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get onDisconnected => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get onConnectionNotAuthorized => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get connectionFailed => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get connectionSuccess => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get onWebChatPasswordChanged => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get setTypingStatus => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get onChatTypingStatus => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get onGroupTypingStatus => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get onFailure => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get onProgressChanged => throw UnimplementedError('has not been implemented.');

  Stream<dynamic> get onSuccess => throw UnimplementedError('has not been implemented.');

  Future<String?> imagePath(String imgurl) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> saveProfile(String name, String email) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> sentFileMessage(String? file, String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> getRecentChatList() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> getProfileStatusList() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> insertDefaultStatus(String status) {
    throw UnimplementedError('has not been implemented.');
  }

  updateMyProfile(String name, String email, String mobile, String status,
      String? image) {
    throw UnimplementedError('has not been implemented.');
  }

  getUserProfile(String jid,
      [bool fromserver = false, bool saveasfriend = false]) {
    throw UnimplementedError('has not been implemented.');
  }

  getProfileDetails(String jid, bool fromServer) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> getProfileLocal(String jid, bool server) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> setMyProfileStatus(String status, String statusId) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> insertNewProfileStatus(String status) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> updateMyProfileImage(String image) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> removeProfileImage() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> removeGroupProfileImage(String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> refreshAndGetAuthToken() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> getMessagesOfJid(String jid) {
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

  Future<dynamic> markAsReadDeleteUnreadSeparator(String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> sendContactMessage(List<String> contactList, String jid,
      String contactName, String replyMessageId) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> logoutOfChatSDK() {
    throw UnimplementedError('has not been implemented.');
  }

  setOnGoingChatUser(String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  downloadMedia(String mid) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> sendDocumentMessage(
      String jid, String documentPath, String replyMessageId,
      [String? fileUrl]) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> openFile(String filePath) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> sendAudioMessage(String jid, String filePath, bool isRecorded,
      String duration, String replyMessageId,
      [String? audiofileUrl]) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> getRecentChatListIncludingArchived() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> searchConversation(String searchKey,
      [String? jidForSearch, bool globalSearch = true]) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> getRegisteredUsers(bool server) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> getMessageOfId(String mid) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> getRecentChatOf(String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> clearChat(
      String jid, String chatType, bool clearExceptStarred) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> reportChatOrUser(
      String jid, String chatType, String? messageId) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> getMessagesUsingIds(List<String> messageIds) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> deleteMessagesForMe(String jid, String chatType,
      List<String> messageIds, bool? isMediaDelete) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> deleteMessagesForEveryone(String jid, String chatType,
      List<String> messageIds, bool? isMediaDelete) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> deleteMessages(
      String jid, List<String> messageIds, bool isDeleteForEveryOne) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> getGroupMessageDeliveredToList(String messageId, String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> getGroupMessageReadByList(String messageId, String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> getMessageStatusOfASingleChatMessage(String messageID) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> blockUser(String userJID) {
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

  Future<dynamic> updateFavouriteStatus(
      String messageID, String chatUserJID, bool isFavourite, String chatType) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> forwardMessagesToMultipleUsers(
      List<String> messageIds, List<String> userList) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> forwardMessages(
      List<String> messageIds, String tojid, String chattype) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> createGroup(
      String groupname, List<String> userList, String image) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> addUsersToGroup(String jid, List<String> userList) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> getGroupMembersList(String jid, bool? server) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> getUsersIBlocked(bool? server) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> getMediaMessages(String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> getDocsMessages(String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> getLinkMessages(String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  exportChatConversationToEmail(String jid) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<bool?> reportUserOrMessages(
      String jid, String type, String? messageId) {
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

  Future<dynamic> deleteAccount(String reason, String? feedback) {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> getFavouriteMessages() {
    throw UnimplementedError('has not been implemented.');
  }

  Future<dynamic> getAllGroups([bool? server]) {
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

  cancelNotifications() {
    throw UnimplementedError('has not been implemented.');
  }

  saveMediaSettings(bool photos, bool videos, bool audio, bool documents,
      int networkType) async {
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
  Future<dynamic> getNonChatUsers() async {
    throw UnimplementedError('has not been implemented.');
  }
  Future addContact(String number) async {
    throw UnimplementedError('has not been implemented.');
  }
  Future setRegionCode(String regionCode) async {
    throw UnimplementedError('has not been implemented.');
  }
}
