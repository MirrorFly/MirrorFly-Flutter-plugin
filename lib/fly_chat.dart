
import 'fly_chat_platform_interface.dart';

class FlyChat {
  FlyChat._();
  static Future<String?> getPlatformVersion() {
    return FlyChatFlutterPlatform.instance.getPlatformVersion();
  }

  static Future<bool?> syncContacts(bool isFirstTime) async {
    return FlyChatFlutterPlatform.instance.syncContacts(isFirstTime);
  }

  static Future<String?> getSendData() {
    return FlyChatFlutterPlatform.instance.getSendData();
  }

  static Future<bool> contactSyncStateValue() {
    return FlyChatFlutterPlatform.instance.contactSyncStateValue();
  }

  static Future<dynamic> contactSyncState() {
    return FlyChatFlutterPlatform.instance.contactSyncState();
  }

  static Future<dynamic> revokeContactSync() {
    return FlyChatFlutterPlatform.instance.revokeContactSync();
  }

  static Future<dynamic> getUsersWhoBlockedMe([bool server = false]) {
    return FlyChatFlutterPlatform.instance.getUsersWhoBlockedMe();
  }

  static Future<dynamic> getUnKnownUserProfiles() {
    return FlyChatFlutterPlatform.instance.getUnKnownUserProfiles();
  }

  static Future<dynamic> getMyProfileStatus() {
    return FlyChatFlutterPlatform.instance.getMyProfileStatus();
  }

  static Future<dynamic> getMyBusyStatus() {
    return FlyChatFlutterPlatform.instance.getMyBusyStatus();
  }

  static Future<dynamic> getBusyStatusList() {
    return FlyChatFlutterPlatform.instance.getBusyStatusList();
  }

  static Future<dynamic> getRecalledMessagesOfAConversation(String jid) {
    return FlyChatFlutterPlatform.instance.getRecalledMessagesOfAConversation(jid);
  }

  static Future<bool?> setMyBusyStatus(String busyStatus) {
    return FlyChatFlutterPlatform.instance.setMyBusyStatus(busyStatus);
  }

  static Future<bool?> enableDisableBusyStatus(bool enable) {
    return FlyChatFlutterPlatform.instance.enableDisableBusyStatus(enable);
  }

  static Future<bool?> enableDisableHideLastSeen(bool enable) {
    return FlyChatFlutterPlatform.instance.enableDisableHideLastSeen(enable);
  }

  static Future<bool?> isBusyStatusEnabled() {
    return FlyChatFlutterPlatform.instance.isBusyStatusEnabled();
  }

  static Future<bool?> deleteProfileStatus(
      String id, String status,
      bool isCurrentStatus) {
    return FlyChatFlutterPlatform.instance.deleteProfileStatus(id,status,isCurrentStatus);
  }

  static Future<bool?> deleteBusyStatus(
      String id, String status, bool isCurrentStatus) {
    return FlyChatFlutterPlatform.instance.deleteBusyStatus(id,status,isCurrentStatus);
  }

  static Future<String?> mediaEndPoint() {
    return FlyChatFlutterPlatform.instance.mediaEndPoint();
  }

  static Future<bool?> unFavouriteAllFavouriteMessages() {
    return FlyChatFlutterPlatform.instance.unFavouriteAllFavouriteMessages();
  }

  static Future<bool?> markAsRead(String jid) {
    return FlyChatFlutterPlatform.instance.markAsRead(jid);
  }

  static Future<bool?> uploadMedia(String messageid) {
    return FlyChatFlutterPlatform.instance.uploadMedia(messageid);
  }

  static Future<bool?> deleteUnreadMessageSeparatorOfAConversation(String jid) {
    return FlyChatFlutterPlatform.instance.deleteUnreadMessageSeparatorOfAConversation(jid);
  }

  static Future<int?> getMembersCountOfGroup(String groupJid) {
    return FlyChatFlutterPlatform.instance.getMembersCountOfGroup(groupJid);
  }

  static Future<bool?> doesFetchingMembersListFromServedRequired(
      String groupJid) {
    return FlyChatFlutterPlatform.instance.doesFetchingMembersListFromServedRequired(groupJid);
  }

  static Future<bool?> isHideLastSeenEnabled() {
    return FlyChatFlutterPlatform.instance.isHideLastSeenEnabled();
  }

  static deleteOfflineGroup(String groupJid) {
    return FlyChatFlutterPlatform.instance.deleteOfflineGroup(groupJid);
  }

  static sendTypingStatus(String toJid, String chattype) {
    return FlyChatFlutterPlatform.instance.sendTypingStatus(toJid,chattype);
  }

  static sendTypingGoneStatus(String toJid, String chattype) {
    return FlyChatFlutterPlatform.instance.sendTypingGoneStatus(toJid,chattype);
  }

  static updateChatMuteStatus(String jid, bool muteStatus) {
    return FlyChatFlutterPlatform.instance.updateChatMuteStatus(jid,muteStatus);
  }

  static updateRecentChatPinStatus(String jid, bool pinStatus) {
    return FlyChatFlutterPlatform.instance.updateRecentChatPinStatus(jid,pinStatus);
  }

  static deleteRecentChat(String jid) {
    return FlyChatFlutterPlatform.instance.deleteRecentChat(jid);
  }

  static setTypingStatusListener() {
    return FlyChatFlutterPlatform.instance.setTypingStatusListener();
  }

  static Future<bool?> isUserUnArchived(String jid) {
    return FlyChatFlutterPlatform.instance.isUserUnArchived(jid);
  }

  static Future<bool?> getIsProfileBlockedByAdmin() {
    return FlyChatFlutterPlatform.instance.getIsProfileBlockedByAdmin();
  }

  static Future<bool?> deleteRecentChats(List<String> jidlist) {
    return FlyChatFlutterPlatform.instance.deleteRecentChats(jidlist);
  }

  static markConversationAsRead(List<String> jidlist) {
    return FlyChatFlutterPlatform.instance.markConversationAsRead(jidlist);
  }

  static markConversationAsUnread(List<String> jidlist) {
    return FlyChatFlutterPlatform.instance.markConversationAsUnread(jidlist);
  }

  static getArchivedChatsFromServer() {
    return FlyChatFlutterPlatform.instance.getArchivedChatsFromServer();
  }

  static setCustomValue(String messageId, String key, String value) {
    return FlyChatFlutterPlatform.instance.setCustomValue(messageId,key,value);
  }

  static removeCustomValue(String messageId, String key) {
    return FlyChatFlutterPlatform.instance.removeCustomValue(messageId,key);
  }

  static inviteUserViaSMS(String mobileNo, String message) {
    return FlyChatFlutterPlatform.instance.inviteUserViaSMS(mobileNo,message);
  }

  static cancelBackup() {
    return FlyChatFlutterPlatform.instance.cancelBackup();
  }

  static startBackup() {
    return FlyChatFlutterPlatform.instance.startBackup();
  }

  static cancelRestore() {
    return FlyChatFlutterPlatform.instance.cancelRestore();
  }

  static clearAllSDKData() {
    return FlyChatFlutterPlatform.instance.clearAllSDKData();
  }

  static getRoster() {
    return FlyChatFlutterPlatform.instance.getRoster();
  }

  static Future<String?> getCustomValue(String messageId, String key) {
    return FlyChatFlutterPlatform.instance.getCustomValue(messageId,key);
  }

  static Future<bool?> clearAllConversation() {
    return FlyChatFlutterPlatform.instance.clearAllConversation();
  }

  static Future<bool?> updateFcmToken(String firebasetoken) {
    return FlyChatFlutterPlatform.instance.updateFcmToken(firebasetoken);
  }

  static Future<bool?> isMuted(String jid) {
    return FlyChatFlutterPlatform.instance.isMuted(jid);
  }

  static Future<dynamic> handleReceivedMessage(Map notificationdata) {
    return FlyChatFlutterPlatform.instance.handleReceivedMessage(notificationdata);
  }

  static Future<dynamic> getLastNUnreadMessages(int messagesCount) {
    return FlyChatFlutterPlatform.instance.getLastNUnreadMessages(messagesCount);
  }

  static Future<dynamic> getNUnreadMessagesOfEachUsers(int messagesCount) {
    return FlyChatFlutterPlatform.instance.getNUnreadMessagesOfEachUsers(messagesCount);
  }

  static Future<bool?> isArchivedSettingsEnabled() {
    return FlyChatFlutterPlatform.instance.isArchivedSettingsEnabled();
  }

  static Future<bool?> enableDisableArchivedSettings(bool enable) {
    return FlyChatFlutterPlatform.instance.enableDisableArchivedSettings(enable);
  }

  static Future<bool?> updateArchiveUnArchiveChat(String jid, bool isArchived) {
    return FlyChatFlutterPlatform.instance.updateArchiveUnArchiveChat(jid,isArchived);
  }

  static Future<int?> getGroupMessageStatusCount(String messageid) {
    return FlyChatFlutterPlatform.instance.getGroupMessageStatusCount(messageid);
  }

  static Future<int?> getUnreadMessageCountExceptMutedChat() {
    return FlyChatFlutterPlatform.instance.getUnreadMessageCountExceptMutedChat();
  }

  static Future<int?> recentChatPinnedCount() {
    return FlyChatFlutterPlatform.instance.recentChatPinnedCount();
  }

  static Future<int?> getUnreadMessagesCount() {
    return FlyChatFlutterPlatform.instance.getUnreadMessagesCount();
  }

  static Future<String?> getUnsentMessageOfAJid(String jid) {
    return FlyChatFlutterPlatform.instance.getUnsentMessageOfAJid(jid);
  }

  static Future<dynamic> getUsersListToAddMembersInOldGroup(String groupJid) {
    return FlyChatFlutterPlatform.instance.getUsersListToAddMembersInOldGroup(groupJid);
  }

  static Future<dynamic> prepareChatConversationToExport(String jid) {
    return FlyChatFlutterPlatform.instance.prepareChatConversationToExport(jid);
  }

  static Future<dynamic> getArchivedChatList() {
    return FlyChatFlutterPlatform.instance.getArchivedChatList();
  }

  static Future<dynamic> getMessageActions(List<String> messageidlist) {
    return FlyChatFlutterPlatform.instance.getMessageActions(messageidlist);
  }

  static Future<dynamic> getUsersListToAddMembersInNewGroup() {
    return FlyChatFlutterPlatform.instance.getUsersListToAddMembersInNewGroup();
  }

  static Future<bool?> createOfflineGroupInOnline(String groupId) {
    return FlyChatFlutterPlatform.instance.createOfflineGroupInOnline(groupId);
  }

  static Future<dynamic> getGroupProfile(String groupJid, bool server) {
    return FlyChatFlutterPlatform.instance.getGroupProfile(groupJid,server);
  }

  static updateMediaDownloadStatus(String mediaMessageId, int progress,
      int downloadStatus, num dataTransferred) {
    return FlyChatFlutterPlatform.instance.updateMediaDownloadStatus(mediaMessageId,progress,downloadStatus,dataTransferred);
  }

  static updateMediaUploadStatus(String mediaMessageId, int progress, int uploadStatus,
      num dataTransferred) {
    return FlyChatFlutterPlatform.instance.updateMediaUploadStatus(mediaMessageId,progress,uploadStatus,dataTransferred);
  }

  static cancelMediaUploadOrDownload(String messageId) async {
    return FlyChatFlutterPlatform.instance.cancelMediaUploadOrDownload(messageId);
  }

  static setMediaEncryption(String encryption) {
    return FlyChatFlutterPlatform.instance.setMediaEncryption(encryption);
  }

  static deleteAllMessages() {
    return FlyChatFlutterPlatform.instance.deleteAllMessages();
  }

  static Future<String?> getGroupJid(String jid) {
    return FlyChatFlutterPlatform.instance.getGroupJid(jid);
  }

  static Future<String?> getUserLastSeenTime(String jid) {
    return FlyChatFlutterPlatform.instance.getUserLastSeenTime(jid);
  }

  static Future<String?> authToken() {
    return FlyChatFlutterPlatform.instance.authToken();
  }

  static Future<dynamic> registerUser(String userIdentifier, {String token = ""}) {
    return FlyChatFlutterPlatform.instance.registerUser(userIdentifier,token: token);
  }

  static Future<String?> verifyToken(String userName, String token) {
    return FlyChatFlutterPlatform.instance.verifyToken(userName,token);
  }

  static Future<String?> getJid(String username) {
    return FlyChatFlutterPlatform.instance.getJid(username);
  }

  static sendTextMessage(String message, String jid, String replyMessageId) {
    return FlyChatFlutterPlatform.instance.sendTextMessage(message,jid,replyMessageId);
  }

  static sendLocationMessage(String jid, double latitude, double longitude,
      String replyMessageId) {
    return FlyChatFlutterPlatform.instance.sendLocationMessage(jid,latitude,longitude,replyMessageId);
  }

  static sendImageMessage(
      String jid, String filePath, String? caption, String? replyMessageID,
      [String? imageFileUrl]) {
    return FlyChatFlutterPlatform.instance.sendImageMessage(jid,filePath,caption,replyMessageID,imageFileUrl);
  }

  static sendVideoMessage(
      String jid, String filePath, String? caption, String? replyMessageID,
      [String? videoFileUrl,
        num? videoDuration,
        String? thumbImageBase64]) {
    return FlyChatFlutterPlatform.instance.sendVideoMessage(jid,filePath,caption,replyMessageID,videoFileUrl,videoDuration,thumbImageBase64);
  }

  static Future<dynamic> getRegisteredUserList({required bool server}) {
    return FlyChatFlutterPlatform.instance.getRegisteredUserList(server: server);
  }

  static getUserList(int page, String search, [int perPageResultSize = 20]) {
    return FlyChatFlutterPlatform.instance.getUserList(page,search,perPageResultSize);
  }

  static Stream<dynamic> get onMessageReceived => FlyChatFlutterPlatform.instance.onMessageReceived;

  //messageOnReceivedChannel.receiveBroadcastStream().cast();

  static Stream<dynamic> get onMessageStatusUpdated =>  FlyChatFlutterPlatform.instance.onMessageStatusUpdated;

  static Stream<dynamic> get onMediaStatusUpdated =>  FlyChatFlutterPlatform.instance.onMediaStatusUpdated;

  static Stream<dynamic> get onUploadDownloadProgressChanged =>  FlyChatFlutterPlatform.instance.onUploadDownloadProgressChanged;

  static Stream<dynamic> get onGroupProfileFetched =>  FlyChatFlutterPlatform.instance.onGroupProfileFetched;

  static Stream<dynamic> get onNewGroupCreated =>  FlyChatFlutterPlatform.instance.onNewGroupCreated;

  static Stream<dynamic> get onGroupProfileUpdated =>  FlyChatFlutterPlatform.instance.onGroupProfileUpdated;

  static Stream<dynamic> get onNewMemberAddedToGroup =>  FlyChatFlutterPlatform.instance.onNewMemberAddedToGroup;

  static Stream<dynamic> get onMemberRemovedFromGroup =>  FlyChatFlutterPlatform.instance.onMemberRemovedFromGroup;

  static Stream<dynamic> get onFetchingGroupMembersCompleted => FlyChatFlutterPlatform.instance.onFetchingGroupMembersCompleted;

  static Stream<dynamic> get onDeleteGroup => FlyChatFlutterPlatform.instance.onDeleteGroup;

  static Stream<dynamic> get onFetchingGroupListCompleted => FlyChatFlutterPlatform.instance.onFetchingGroupListCompleted;

  static Stream<dynamic> get onMemberMadeAsAdmin => FlyChatFlutterPlatform.instance.onMemberMadeAsAdmin;

  static Stream<dynamic> get onMemberRemovedAsAdmin => FlyChatFlutterPlatform.instance.onMemberRemovedAsAdmin;

  static Stream<dynamic> get onLeftFromGroup => FlyChatFlutterPlatform.instance.onLeftFromGroup;

  static Stream<dynamic> get onGroupNotificationMessage => FlyChatFlutterPlatform.instance.onGroupNotificationMessage;

  static Stream<dynamic> get onGroupDeletedLocally => FlyChatFlutterPlatform.instance.onGroupDeletedLocally;

  static Stream<dynamic> get blockedThisUser => FlyChatFlutterPlatform.instance.blockedThisUser;

  static Stream<dynamic> get myProfileUpdated => FlyChatFlutterPlatform.instance.myProfileUpdated;

  static Stream<dynamic> get onAdminBlockedOtherUser => FlyChatFlutterPlatform.instance.onAdminBlockedOtherUser;

  static Stream<dynamic> get onAdminBlockedUser => FlyChatFlutterPlatform.instance.onAdminBlockedUser;

  static Stream<bool> get onContactSyncComplete => FlyChatFlutterPlatform.instance.onContactSyncComplete;

  static Stream<dynamic> get onLoggedOut => FlyChatFlutterPlatform.instance.onLoggedOut;

  static Stream<dynamic> get unblockedThisUser => FlyChatFlutterPlatform.instance.unblockedThisUser;

  static Stream<dynamic> get userBlockedMe => FlyChatFlutterPlatform.instance.userBlockedMe;

  static Stream<dynamic> get userCameOnline => FlyChatFlutterPlatform.instance.userCameOnline;

  static Stream<String> get userDeletedHisProfile => FlyChatFlutterPlatform.instance.userDeletedHisProfile;

  static Stream<dynamic> get userProfileFetched => FlyChatFlutterPlatform.instance.userProfileFetched;

  static Stream<dynamic> get userUnBlockedMe => FlyChatFlutterPlatform.instance.userUnBlockedMe;

  static Stream<dynamic> get userUpdatedHisProfile => FlyChatFlutterPlatform.instance.userUpdatedHisProfile;

  static Stream<dynamic> get userWentOffline => FlyChatFlutterPlatform.instance.userWentOffline;

  static Stream<dynamic> get usersIBlockedListFetched => FlyChatFlutterPlatform.instance.usersIBlockedListFetched;

  static Stream<dynamic> get usersWhoBlockedMeListFetched => FlyChatFlutterPlatform.instance.usersWhoBlockedMeListFetched;

  static Stream<dynamic> get onConnected => FlyChatFlutterPlatform.instance.onConnected;

  static Stream<dynamic> get onDisconnected => FlyChatFlutterPlatform.instance.onDisconnected;

  static Stream<dynamic> get onConnectionNotAuthorized => FlyChatFlutterPlatform.instance.onConnectionNotAuthorized;

  static Stream<dynamic> get connectionFailed => FlyChatFlutterPlatform.instance.connectionFailed;

  static Stream<dynamic> get connectionSuccess => FlyChatFlutterPlatform.instance.connectionSuccess;

  static Stream<dynamic> get onWebChatPasswordChanged => FlyChatFlutterPlatform.instance.onWebChatPasswordChanged;

  static Stream<dynamic> get setTypingStatus => FlyChatFlutterPlatform.instance.setTypingStatus;

  static Stream<dynamic> get onChatTypingStatus => FlyChatFlutterPlatform.instance.onChatTypingStatus;

  static Stream<dynamic> get onGroupTypingStatus => FlyChatFlutterPlatform.instance.onGroupTypingStatus;

  static Stream<dynamic> get onFailure => FlyChatFlutterPlatform.instance.onFailure;

  static Stream<dynamic> get onProgressChanged => FlyChatFlutterPlatform.instance.onProgressChanged;

  static Stream<dynamic> get onSuccess => FlyChatFlutterPlatform.instance.onSuccess;

  static Future<String?> imagePath(String imgurl) {
    return FlyChatFlutterPlatform.instance.imagePath(imgurl);
  }

  static Future<dynamic> saveProfile(String name, String email) {
    return FlyChatFlutterPlatform.instance.saveProfile(name, email);
  }

  static Future<dynamic> sentFileMessage(String? file, String jid) {
    return FlyChatFlutterPlatform.instance.sentFileMessage(file, jid);
  }

  static Future<dynamic> getRecentChatList() {
    return FlyChatFlutterPlatform.instance.getRecentChatList();
  }

  static Future<dynamic> getProfileStatusList() {
    return FlyChatFlutterPlatform.instance.getProfileStatusList();
  }

  static Future<dynamic> insertDefaultStatus(String status) {
    return FlyChatFlutterPlatform.instance.insertDefaultStatus(status);
  }

  static updateMyProfile(String name, String email, String mobile, String status,
      String? image) {
    return FlyChatFlutterPlatform.instance.updateMyProfile(name, email, mobile, status, image);
  }

  static getUserProfile(String jid,
      [bool fromserver = false, bool saveasfriend = false]) {
    return FlyChatFlutterPlatform.instance.getUserProfile(jid,fromserver,saveasfriend);
  }

  static getProfileDetails(String jid, bool fromServer) {
    return FlyChatFlutterPlatform.instance.getProfileDetails(jid, fromServer);
  }

  static Future<dynamic> getProfileLocal(String jid, bool server) {
    return FlyChatFlutterPlatform.instance.getProfileLocal(jid, server);
  }

  static Future<dynamic> setMyProfileStatus(String status, [String? statusId]) {
    return FlyChatFlutterPlatform.instance.setMyProfileStatus(status,statusId);
  }

  static Future<dynamic> insertNewProfileStatus(String status) {
    return FlyChatFlutterPlatform.instance.insertNewProfileStatus(status);
  }

  static Future<dynamic> updateMyProfileImage(String image) {
    return FlyChatFlutterPlatform.instance.updateMyProfileImage(image);
  }

  static Future<bool?> removeProfileImage() {
    return FlyChatFlutterPlatform.instance.removeProfileImage();
  }

  static Future<bool?> removeGroupProfileImage(String jid) {
    return FlyChatFlutterPlatform.instance.removeGroupProfileImage(jid);
  }

  static Future<bool?> refreshAndGetAuthToken() {
    return FlyChatFlutterPlatform.instance.refreshAndGetAuthToken();
  }

  static Future<dynamic> getMessagesOfJid(String jid) {
    return FlyChatFlutterPlatform.instance.getMessagesOfJid(jid);
  }

  static Future<dynamic> listenMessageEvents() {
    return FlyChatFlutterPlatform.instance.listenMessageEvents();
  }

  static Future<dynamic> listenGroupChatEvents() {
    return FlyChatFlutterPlatform.instance.listenGroupChatEvents();
  }

  static Future<dynamic> getMedia(String mid) {
    return FlyChatFlutterPlatform.instance.getMedia(mid);
  }

  static Future<dynamic> markAsReadDeleteUnreadSeparator(String jid) {
    return FlyChatFlutterPlatform.instance.markAsReadDeleteUnreadSeparator(jid);
  }

  static Future<dynamic> sendContactMessage(List<String> contactList, String jid,
      String contactName, String replyMessageId) {
    return FlyChatFlutterPlatform.instance.sendContactMessage(contactList, jid, contactName, replyMessageId);
  }

  static Future<dynamic> logoutOfChatSDK() {
    return FlyChatFlutterPlatform.instance.logoutOfChatSDK();
  }

  static setOnGoingChatUser(String jid) {
    return FlyChatFlutterPlatform.instance.setOnGoingChatUser(jid);
  }

  static downloadMedia(String mid) {
    return FlyChatFlutterPlatform.instance.downloadMedia(mid);
  }

  static Future<dynamic> sendDocumentMessage(
      String jid, String documentPath, String replyMessageId,
      [String? fileUrl]) {
    return FlyChatFlutterPlatform.instance.sendDocumentMessage(jid, documentPath, replyMessageId,fileUrl);
  }

  static Future<dynamic> openFile(String filePath) {
    return FlyChatFlutterPlatform.instance.openFile(filePath);
  }

  static Future<dynamic> sendAudioMessage(String jid, String filePath, bool isRecorded,
      String duration, String replyMessageId,
      [String? audiofileUrl]) {
    return FlyChatFlutterPlatform.instance.sendAudioMessage(jid, filePath, isRecorded, duration, replyMessageId,audiofileUrl);
  }

  static Future<dynamic> getRecentChatListIncludingArchived() {
    return FlyChatFlutterPlatform.instance.getRecentChatListIncludingArchived();
  }

  static Future<dynamic> searchConversation(String searchKey,
      [String? jidForSearch, bool globalSearch = true]) {
    return FlyChatFlutterPlatform.instance.searchConversation(searchKey,jidForSearch,globalSearch);
  }

  static Future<dynamic> getRegisteredUsers(bool server) {
    return FlyChatFlutterPlatform.instance.getRegisteredUsers(server);
  }

  static Future<dynamic> getMessageOfId(String mid) {
    return FlyChatFlutterPlatform.instance.getMessageOfId(mid);
  }

  static Future<dynamic> getRecentChatOf(String jid) {
    return FlyChatFlutterPlatform.instance.getRecentChatOf(jid);
  }

  static Future<dynamic> clearChat(
      String jid, String chatType, bool clearExceptStarred) {
    return FlyChatFlutterPlatform.instance.clearChat(jid, chatType, clearExceptStarred);
  }

  static Future<dynamic> reportChatOrUser(
      String jid, String chatType, String? messageId) {
    return FlyChatFlutterPlatform.instance.reportChatOrUser(jid, chatType, messageId);
  }

  static Future<dynamic> getMessagesUsingIds(List<String> messageIds) {
    return FlyChatFlutterPlatform.instance.getMessagesUsingIds(messageIds);
  }

  static Future<dynamic> deleteMessagesForMe(String jid, String chatType,
      List<String> messageIds, bool? isMediaDelete) {
    return FlyChatFlutterPlatform.instance.deleteMessagesForMe(jid, chatType, messageIds, isMediaDelete);
  }

  static Future<dynamic> deleteMessagesForEveryone(String jid, String chatType,
      List<String> messageIds, bool? isMediaDelete) {
    return FlyChatFlutterPlatform.instance.deleteMessagesForEveryone(jid, chatType, messageIds, isMediaDelete);
  }

  static Future<dynamic> deleteMessages(
      String jid, List<String> messageIds, bool isDeleteForEveryOne) {
    return FlyChatFlutterPlatform.instance.deleteMessages(jid, messageIds, isDeleteForEveryOne);
  }

  static Future<dynamic> getGroupMessageDeliveredToList(String messageId) {
    return FlyChatFlutterPlatform.instance.getGroupMessageDeliveredToList(messageId);
  }

  static Future<dynamic> getGroupMessageReadByList(String messageId) {
    return FlyChatFlutterPlatform.instance.getGroupMessageReadByList(messageId);
  }

  static Future<dynamic> getMessageStatusOfASingleChatMessage(String messageID) {
    return FlyChatFlutterPlatform.instance.getMessageStatusOfASingleChatMessage(messageID);
  }

  static Future<dynamic> blockUser(String userJID) {
    return FlyChatFlutterPlatform.instance.blockUser(userJID);
  }

  static Future<bool?> unblockUser(String userJID) {
    return FlyChatFlutterPlatform.instance.unblockUser(userJID);
  }

  static Future<String?> showCustomTones() {
    return FlyChatFlutterPlatform.instance.showCustomTones();
  }

  static Future<String?> getRingtoneName() {
    return FlyChatFlutterPlatform.instance.getRingtoneName();
  }

  static Future<bool?> loginWebChatViaQRCode(String barcode) {
    return FlyChatFlutterPlatform.instance.loginWebChatViaQRCode(barcode);
  }

  static Future<bool?> webLoginDetailsCleared() {
    return FlyChatFlutterPlatform.instance.webLoginDetailsCleared();
  }

  static Future<bool?> logoutWebUser(List<String> logins) {
    return FlyChatFlutterPlatform.instance.logoutWebUser(logins);
  }

  static Future<bool?> iOSFileExist(String filePath) {
    return FlyChatFlutterPlatform.instance.iOSFileExist(filePath);
  }

  static Future<dynamic> getWebLoginDetails() {
    return FlyChatFlutterPlatform.instance.getWebLoginDetails();
  }

  static Future<dynamic> updateFavouriteStatus(
      String messageID, String chatUserJID, bool isFavourite, String chatType) {
    return FlyChatFlutterPlatform.instance.updateFavouriteStatus(messageID, chatUserJID, isFavourite, chatType);
  }

  static Future<dynamic> forwardMessagesToMultipleUsers(
      List<String> messageIds, List<String> userList) {
    return FlyChatFlutterPlatform.instance.forwardMessagesToMultipleUsers(messageIds, userList);
  }

  static Future<dynamic> forwardMessages(
      List<String> messageIds, String tojid, String chattype) {
    return FlyChatFlutterPlatform.instance.forwardMessages(messageIds, tojid, chattype);
  }

  static Future<dynamic> createGroup(
      String groupname, List<String> userList, String image) {
    return FlyChatFlutterPlatform.instance.createGroup(groupname, userList, image);
  }

  static Future<bool?> addUsersToGroup(String jid, List<String> userList) {
    return FlyChatFlutterPlatform.instance.addUsersToGroup(jid, userList);
  }

  static Future<dynamic> getGroupMembersList(String jid, bool? server) {
    return FlyChatFlutterPlatform.instance.getGroupMembersList(jid, server);
  }

  static Future<dynamic> getUsersIBlocked(bool? server) {
    return FlyChatFlutterPlatform.instance.getUsersIBlocked(server);
  }

  static Future<dynamic> getMediaMessages(String jid) {
    return FlyChatFlutterPlatform.instance.getMediaMessages(jid);
  }

  static Future<dynamic> getDocsMessages(String jid) {
    return FlyChatFlutterPlatform.instance.getDocsMessages(jid);
  }

  static Future<dynamic> getLinkMessages(String jid) {
    return FlyChatFlutterPlatform.instance.getLinkMessages(jid);
  }

  static exportChatConversationToEmail(String jid) {
    return FlyChatFlutterPlatform.instance.exportChatConversationToEmail(jid);
  }

  static Future<bool?> reportUserOrMessages(
      String jid, String type, String? messageId) {
    return FlyChatFlutterPlatform.instance.reportUserOrMessages(jid, type, messageId);
  }

  static Future<bool?> makeAdmin(String groupjid, String userjid) {
    return FlyChatFlutterPlatform.instance.makeAdmin(groupjid, userjid);
  }

  static Future<bool?> removeMemberFromGroup(String groupjid, String userjid) {
    return FlyChatFlutterPlatform.instance.removeMemberFromGroup(groupjid, userjid);
  }

  static Future<bool?> leaveFromGroup(String? userJid, String groupJid) {
    return FlyChatFlutterPlatform.instance.leaveFromGroup(userJid, groupJid);
  }

  static Future<bool?> deleteGroup(String jid) {
    return FlyChatFlutterPlatform.instance.deleteGroup(jid);
  }

  static Future<bool?> isAdmin(String userJid, String groupJID) {
    return FlyChatFlutterPlatform.instance.isAdmin(userJid,groupJID);
  }

  static Future<bool?> updateGroupProfileImage(String jid, String file) {
    return FlyChatFlutterPlatform.instance.updateGroupProfileImage(jid, file);
  }

  static Future<bool?> updateGroupName(String jid, String name) {
    return FlyChatFlutterPlatform.instance.updateGroupName(jid, name);
  }

  static Future<bool?> isMemberOfGroup(String jid, String? userJid) {
    return FlyChatFlutterPlatform.instance.isMemberOfGroup(jid, userJid);
  }

  static Future<bool?> sendContactUsInfo(String title, String description) {
    return FlyChatFlutterPlatform.instance.sendContactUsInfo(title, description);
  }

  static copyTextMessages(List<String> messageIds) {
    return FlyChatFlutterPlatform.instance.copyTextMessages(messageIds);
  }

  static saveUnsentMessage(String jid, String message) {
    return FlyChatFlutterPlatform.instance.saveUnsentMessage(jid, message);
  }

  static Future<dynamic> deleteAccount(String reason, String? feedback) {
    return FlyChatFlutterPlatform.instance.deleteAccount(reason, feedback);
  }

  static Future<dynamic> getFavouriteMessages() {
    return FlyChatFlutterPlatform.instance.getFavouriteMessages();
  }

  static Future<dynamic> getAllGroups([bool? server]) {
    return FlyChatFlutterPlatform.instance.getAllGroups(server);
  }

  static Future<String?> getDefaultNotificationUri() {
    return FlyChatFlutterPlatform.instance.getDefaultNotificationUri();
  }

  static Future setDefaultNotificationSound() {
    return FlyChatFlutterPlatform.instance.setDefaultNotificationSound();
  }

  static setNotificationUri(String uri) {
    return FlyChatFlutterPlatform.instance.setNotificationUri(uri);
  }

  static setNotificationSound(bool enable) {
    return FlyChatFlutterPlatform.instance.setNotificationSound(enable);
  }

  static setMuteNotification(bool enable) {
    return FlyChatFlutterPlatform.instance.setMuteNotification(enable);
  }

  static setNotificationVibration(bool enable) {
    return FlyChatFlutterPlatform.instance.setNotificationVibration(enable);
  }

  static cancelNotifications() {
    return FlyChatFlutterPlatform.instance.cancelNotifications();
  }
  static saveMediaSettings(bool photos, bool videos, bool audio, bool documents,
      int networkType) async {
    return FlyChatFlutterPlatform.instance.saveMediaSettings(photos, videos, audio, documents, networkType);
  }

  static Future<bool?> getMediaSetting(int networkType, String type) async {
    return FlyChatFlutterPlatform.instance.getMediaSetting(networkType, type);
  }

  static Future<bool?> getMediaAutoDownload() async {
    return FlyChatFlutterPlatform.instance.getMediaAutoDownload();
  }

  static setMediaAutoDownload(bool enable) async {
    return FlyChatFlutterPlatform.instance.setMediaAutoDownload(enable);
  }

  static Future<String?> getJidFromPhoneNumber(String mobileNumber, String countryCode) async {
    return FlyChatFlutterPlatform.instance.getJidFromPhoneNumber(mobileNumber, countryCode);
  }

  static Future<bool?> getNotificationSound() async {
   return FlyChatFlutterPlatform.instance.getNotificationSound();
  }

  static Future<bool?> insertBusyStatus(String busyStatus) async {
   return FlyChatFlutterPlatform.instance.insertBusyStatus(busyStatus);
  }
  static Future<bool?> isTrailLicence() async {
   return FlyChatFlutterPlatform.instance.isTrailLicence();
  }
  static Future<dynamic> getNonChatUsers() async {
   return FlyChatFlutterPlatform.instance.getNonChatUsers();
  }
  static Future addContact(String number) async {
   return FlyChatFlutterPlatform.instance.addContact(number);
  }
  static Future<dynamic> setRegionCode(String regionCode) async {
   return FlyChatFlutterPlatform.instance.setRegionCode(regionCode);
  }
}
