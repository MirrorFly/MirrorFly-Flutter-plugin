import 'package:flutter_test/flutter_test.dart';
import 'package:fly_chat/builder.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:fly_chat/fly_chat_method_channel.dart';
import 'package:fly_chat/fly_chat_platform_interface.dart';

class MockFlyChatFlutterPlatform
    with MockPlatformInterfaceMixin
    implements FlyChatFlutterPlatform {


  @override
  init(ChatBuilder builder) {
    // implement init
    throw UnimplementedError();
  }

 /* @override
  Future<String?> getPlatformVersion() => Future.value('42');
*/
  @override
  Future<bool?> addUsersToGroup(String jid, List<String> userList) {
    throw UnimplementedError();
  }

  @override
  Future<String?> authToken() {
    
    throw UnimplementedError();
  }

  @override
  Future blockUser(String userJID) {
    // blockUser
    throw UnimplementedError();
  }

  @override
  // blockedThisUser
  Stream get blockedThisUser => throw UnimplementedError();

  @override
  cancelBackup() {
    // cancelBackup
    throw UnimplementedError();
  }

  @override
  cancelMediaUploadOrDownload(String messageId) {
    // cancelMediaUploadOrDownload
    throw UnimplementedError();
  }

  @override
  cancelNotifications() {
    // cancelNotifications
    throw UnimplementedError();
  }

  @override
  cancelRestore() {
    // cancelRestore
    throw UnimplementedError();
  }

  @override
  Future<bool?> clearAllConversation() {
    // clearAllConversation
    throw UnimplementedError();
  }

  @override
  clearAllSDKData() {
    // clearAllSDKData
    throw UnimplementedError();
  }

  @override
  Future clearChat(String jid, String chatType, bool clearExceptStarred) {
    // clearChat
    throw UnimplementedError();
  }

  @override
  // connectionFailed
  Stream get connectionFailed => throw UnimplementedError();

  @override
  // connectionSuccess
  Stream get connectionSuccess => throw UnimplementedError();

  @override
  Future contactSyncState() {
    // contactSyncState
    throw UnimplementedError();
  }

  @override
  Future<bool> contactSyncStateValue() {
    // contactSyncStateValue
    throw UnimplementedError();
  }

  @override
  copyTextMessages(List<String> messageIds) {
    // copyTextMessages
    throw UnimplementedError();
  }

  @override
  Future createGroup(String groupname, List<String> userList, String image) {
    // createGroup
    throw UnimplementedError();
  }

  @override
  Future<bool?> createOfflineGroupInOnline(String groupId) {
    // createOfflineGroupInOnline
    throw UnimplementedError();
  }

  @override
  Future deleteAccount(String reason, String? feedback) {
    // deleteAccount
    throw UnimplementedError();
  }

  @override
  deleteAllMessages() {
    // deleteAllMessages
    throw UnimplementedError();
  }

  @override
  Future<bool?> deleteBusyStatus(String id, String status, bool isCurrentStatus) {
    // deleteBusyStatus
    throw UnimplementedError();
  }

  @override
  Future<bool?> deleteGroup(String jid) {
    // deleteGroup
    throw UnimplementedError();
  }

  @override
  Future deleteMessages(String jid, List<String> messageIds, bool isDeleteForEveryOne) {
    // deleteMessages
    throw UnimplementedError();
  }

  @override
  Future deleteMessagesForEveryone(String jid, String chatType, List<String> messageIds, bool? isMediaDelete) {
    // deleteMessagesForEveryone
    throw UnimplementedError();
  }

  @override
  Future deleteMessagesForMe(String jid, String chatType, List<String> messageIds, bool? isMediaDelete) {
    // deleteMessagesForMe
    throw UnimplementedError();
  }

  @override
  deleteOfflineGroup(String groupJid) {
    // deleteOfflineGroup
    throw UnimplementedError();
  }

  @override
  Future<bool?> deleteProfileStatus(String id, String status, bool isCurrentStatus) {
    // deleteProfileStatus
    throw UnimplementedError();
  }

  @override
  deleteRecentChat(String jid) {
    // deleteRecentChat
    throw UnimplementedError();
  }

  @override
  Future<bool?> deleteRecentChats(List<String> jidlist) {
    // deleteRecentChats
    throw UnimplementedError();
  }

  @override
  Future<bool?> deleteUnreadMessageSeparatorOfAConversation(String jid) {
    // deleteUnreadMessageSeparatorOfAConversation
    throw UnimplementedError();
  }

  @override
  Future<bool?> doesFetchingMembersListFromServedRequired(String groupJid) {
    // doesFetchingMembersListFromServedRequired
    throw UnimplementedError();
  }

  @override
  downloadMedia(String mid) {
    // downloadMedia
    throw UnimplementedError();
  }

  @override
  Future<bool?> enableDisableArchivedSettings(bool enable) {
    // enableDisableArchivedSettings
    throw UnimplementedError();
  }

  @override
  Future<bool?> enableDisableBusyStatus(bool enable) {
    // enableDisableBusyStatus
    throw UnimplementedError();
  }

  @override
  Future<bool?> enableDisableHideLastSeen(bool enable) {
    // enableDisableHideLastSeen
    throw UnimplementedError();
  }

  @override
  exportChatConversationToEmail(String jid) {
    // exportChatConversationToEmail
    throw UnimplementedError();
  }

  @override
  Future forwardMessages(List<String> messageIds, String tojid, String chattype) {
    // forwardMessages
    throw UnimplementedError();
  }

  @override
  Future forwardMessagesToMultipleUsers(List<String> messageIds, List<String> userList) {
    // forwardMessagesToMultipleUsers
    throw UnimplementedError();
  }

  @override
  Future getAllGroups([bool? server]) {
    // getAllGroups
    throw UnimplementedError();
  }

  @override
  Future getArchivedChatList() {
    // getArchivedChatList
    throw UnimplementedError();
  }

  @override
  getArchivedChatsFromServer() {
    // getArchivedChatsFromServer
    throw UnimplementedError();
  }

  @override
  Future getBusyStatusList() {
    // getBusyStatusList
    throw UnimplementedError();
  }

  @override
  Future<String?> getCustomValue(String messageId, String key) {
    // getCustomValue
    throw UnimplementedError();
  }

  @override
  Future<String?> getDefaultNotificationUri() {
    // getDefaultNotificationUri
    throw UnimplementedError();
  }

  @override
  Future getDocsMessages(String jid) {
    // getDocsMessages
    throw UnimplementedError();
  }

  @override
  Future getFavouriteMessages() {
    // getFavouriteMessages
    throw UnimplementedError();
  }

  @override
  Future<String?> getGroupJid(String jid) {
    // getGroupJid
    throw UnimplementedError();
  }

  @override
  Future getGroupMembersList(String jid, bool? server) {
    // getGroupMembersList
    throw UnimplementedError();
  }

  @override
  Future getGroupMessageDeliveredToList(String messageId, String jid) {
    // getGroupMessageDeliveredToList
    throw UnimplementedError();
  }

  @override
  Future getGroupMessageReadByList(String messageId, String jid) {
    // getGroupMessageReadByList
    throw UnimplementedError();
  }

  @override
  Future<int?> getGroupMessageStatusCount(String messageid) {
    // getGroupMessageStatusCount
    throw UnimplementedError();
  }

  @override
  Future getGroupProfile(String groupJid, bool server) {
    // getGroupProfile
    throw UnimplementedError();
  }

  @override
  Future<bool?> getIsProfileBlockedByAdmin() {
    // getIsProfileBlockedByAdmin
    throw UnimplementedError();
  }

  @override
  Future<String?> getJid(String username) {
    // getJid
    throw UnimplementedError();
  }

  @override
  Future getLastNUnreadMessages(int messagesCount) {
    // getLastNUnreadMessages
    throw UnimplementedError();
  }

  @override
  Future getLinkMessages(String jid) {
    // getLinkMessages
    throw UnimplementedError();
  }

  @override
  Future getMedia(String mid) {
    // getMedia
    throw UnimplementedError();
  }

  @override
  Future getMediaMessages(String jid) {
    // getMediaMessages
    throw UnimplementedError();
  }

  @override
  Future<int?> getMembersCountOfGroup(String groupJid) {
    // getMembersCountOfGroup
    throw UnimplementedError();
  }

  @override
  Future getMessageActions(List<String> messageidlist) {
    // getMessageActions
    throw UnimplementedError();
  }

  @override
  Future getMessageOfId(String mid) {
    // getMessageOfId
    throw UnimplementedError();
  }

  @override
  Future getMessageStatusOfASingleChatMessage(String messageID) {
    // getMessageStatusOfASingleChatMessage
    throw UnimplementedError();
  }

  @override
  Future getMessagesOfJid(String jid) {
    // getMessagesOfJid
    throw UnimplementedError();
  }

  @override
  Future getMessagesUsingIds(List<String> messageIds) {
    // getMessagesUsingIds
    throw UnimplementedError();
  }

  @override
  Future getMyBusyStatus() {
    // getMyBusyStatus
    throw UnimplementedError();
  }

  @override
  Future getMyProfileStatus() {
    // getMyProfileStatus
    throw UnimplementedError();
  }

  @override
  Future getNUnreadMessagesOfEachUsers(int messagesCount) {
    // getNUnreadMessagesOfEachUsers
    throw UnimplementedError();
  }

  @override
  getProfileDetails(String jid, bool fromServer) {
    // getProfileDetails
    throw UnimplementedError();
  }

  @override
  Future getProfileLocal(String jid, bool server) {
    // getProfileLocal
    throw UnimplementedError();
  }

  @override
  Future getProfileStatusList() {
    // getProfileStatusList
    throw UnimplementedError();
  }

  @override
  Future getRecalledMessagesOfAConversation(String jid) {
    // getRecalledMessagesOfAConversation
    throw UnimplementedError();
  }

  @override
  Future getRecentChatList() {
    // getRecentChatList
    throw UnimplementedError();
  }

  @override
  Future getRecentChatListIncludingArchived() {
    // getRecentChatListIncludingArchived
    throw UnimplementedError();
  }

  @override
  Future getRecentChatOf(String jid) {
    // getRecentChatOf
    throw UnimplementedError();
  }

  @override
  Future getRegisteredUserList({required bool server}) {
    // getRegisteredUserList
    throw UnimplementedError();
  }

  @override
  Future getRegisteredUsers(bool server) {
    // getRegisteredUsers
    throw UnimplementedError();
  }

  @override
  Future<String?> getRingtoneName() {
    // getRingtoneName
    throw UnimplementedError();
  }

  @override
  getRoster() {
    // getRoster
    throw UnimplementedError();
  }

  @override
  Future<String?> getSendData() {
    // getSendData
    throw UnimplementedError();
  }

  @override
  Future getUnKnownUserProfiles() {
    // getUnKnownUserProfiles
    throw UnimplementedError();
  }

  @override
  Future<int?> getUnreadMessageCountExceptMutedChat() {
    // getUnreadMessageCountExceptMutedChat
    throw UnimplementedError();
  }

  @override
  Future<int?> getUnreadMessagesCount() {
    // getUnreadMessagesCount
    throw UnimplementedError();
  }

  @override
  Future<String?> getUnsentMessageOfAJid(String jid) {
    // getUnsentMessageOfAJid
    throw UnimplementedError();
  }

  @override
  Future<String?> getUserLastSeenTime(String jid) {
    // getUserLastSeenTime
    throw UnimplementedError();
  }

  @override
  getUserList(int page, String search, [int perPageResultSize = 20]) {
    // getUserList
    throw UnimplementedError();
  }

  @override
  getUserProfile(String jid, [bool fromserver = false, bool saveasfriend = false]) {
    // getUserProfile
    throw UnimplementedError();
  }

  @override
  Future getUsersIBlocked(bool? server) {
    // getUsersIBlocked
    throw UnimplementedError();
  }

  @override
  Future getUsersListToAddMembersInNewGroup() {
    // getUsersListToAddMembersInNewGroup
    throw UnimplementedError();
  }

  @override
  Future getUsersListToAddMembersInOldGroup(String groupJid) {
    // getUsersListToAddMembersInOldGroup
    throw UnimplementedError();
  }

  @override
  Future getUsersWhoBlockedMe([bool server = false]) {
    // getUsersWhoBlockedMe
    throw UnimplementedError();
  }

  @override
  Future getWebLoginDetails() {
    // getWebLoginDetails
    throw UnimplementedError();
  }

  @override
  Future handleReceivedMessage(Map notificationdata) {
    // handleReceivedMessage
    throw UnimplementedError();
  }

  @override
  Future<String?> imagePath(String imgurl) {
    // imagePath
    throw UnimplementedError();
  }

  @override
  Future insertDefaultStatus(String status) {
    // insertDefaultStatus
    throw UnimplementedError();
  }

  @override
  inviteUserViaSMS(String mobileNo, String message) {
    // inviteUserViaSMS
    throw UnimplementedError();
  }

  @override
  Future<bool?> isAdmin(String jid,String groupJid) {
    // isAdmin
    throw UnimplementedError();
  }

  @override
  Future<bool?> isArchivedSettingsEnabled() {
    // isArchivedSettingsEnabled
    throw UnimplementedError();
  }

  @override
  Future<bool?> isBusyStatusEnabled() {
    // isBusyStatusEnabled
    throw UnimplementedError();
  }

  @override
  Future<bool?> isHideLastSeenEnabled() {
    // isHideLastSeenEnabled
    throw UnimplementedError();
  }

  @override
  Future<bool?> isMemberOfGroup(String jid, String? userjid) {
    // isMemberOfGroup
    throw UnimplementedError();
  }

  @override
  Future<bool?> isMuted(String jid) {
    // isMuted
    throw UnimplementedError();
  }

  @override
  Future<bool?> isUserUnArchived(String jid) {
    // isUserUnArchived
    throw UnimplementedError();
  }

  @override
  Future<bool?> leaveFromGroup(String? userJid, String groupJid) {
    // leaveFromGroup
    throw UnimplementedError();
  }

  @override
  Future listenGroupChatEvents() {
    // listenGroupChatEvents
    throw UnimplementedError();
  }

  @override
  Future listenMessageEvents() {
    // listenMessageEvents
    throw UnimplementedError();
  }

  @override
  Future<bool?> loginWebChatViaQRCode(String barcode) {
    // loginWebChatViaQRCode
    throw UnimplementedError();
  }

  @override
  Future logoutOfChatSDK() {
    // logoutOfChatSDK
    throw UnimplementedError();
  }

  @override
  Future<bool?> logoutWebUser(List<String> logins) {
    // logoutWebUser
    throw UnimplementedError();
  }

  @override
  Future<bool?> makeAdmin(String groupjid, String userjid) {
    // makeAdmin
    throw UnimplementedError();
  }

  @override
  Future<bool?> markAsRead(String jid) {
    // markAsRead
    throw UnimplementedError();
  }

  @override
  Future markAsReadDeleteUnreadSeparator(String jid) {
    // markAsReadDeleteUnreadSeparator
    throw UnimplementedError();
  }

  @override
  markConversationAsRead(List<String> jidlist) {
    // markConversationAsRead
    throw UnimplementedError();
  }

  @override
  markConversationAsUnread(List<String> jidlist) {
    // markConversationAsUnread
    throw UnimplementedError();
  }

  @override
  Future<String?> mediaEndPoint() {
    // mediaEndPoint
    throw UnimplementedError();
  }

  @override
  // myProfileUpdated
  Stream<bool> get myProfileUpdated => throw UnimplementedError();

  @override
  // onAdminBlockedOtherUser
  Stream get onAdminBlockedOtherUser => throw UnimplementedError();

  @override
  // onAdminBlockedUser
  Stream get onAdminBlockedUser => throw UnimplementedError();

  @override
  // onChatTypingStatus
  Stream get onChatTypingStatus => throw UnimplementedError();

  @override
  // onConnected
  Stream get onConnected => throw UnimplementedError();

  @override
  // onConnectionNotAuthorized
  Stream get onConnectionNotAuthorized => throw UnimplementedError();

  @override
  // onContactSyncComplete
  Stream<bool> get onContactSyncComplete => throw UnimplementedError();

  @override
  // onDeleteGroup
  Stream get onDeleteGroup => throw UnimplementedError();

  @override
  // onDisconnected
  Stream get onDisconnected => throw UnimplementedError();

  @override
  // onFailure
  Stream get onFailure => throw UnimplementedError();

  @override
  // onFetchingGroupListCompleted
  Stream get onFetchingGroupListCompleted => throw UnimplementedError();

  @override
  // onFetchingGroupMembersCompleted
  Stream<String> get onFetchingGroupMembersCompleted => throw UnimplementedError();

  @override
  // onGroupDeletedLocally
  Stream<String> get onGroupDeletedLocally => throw UnimplementedError();

  @override
  // onGroupNotificationMessage
  Stream get onGroupNotificationMessage => throw UnimplementedError();

  @override
  // onGroupProfileFetched
  Stream<String> get onGroupProfileFetched => throw UnimplementedError();

  @override
  // onGroupProfileUpdated
  Stream<String> get onGroupProfileUpdated => throw UnimplementedError();

  @override
  // onGroupTypingStatus
  Stream get onGroupTypingStatus => throw UnimplementedError();

  @override
  // onLeftFromGroup
  Stream get onLeftFromGroup => throw UnimplementedError();

  @override
  // onLoggedOut
  Stream<bool> get onLoggedOut => throw UnimplementedError();

  @override
  // onMediaStatusUpdated
  Stream get onMediaStatusUpdated => throw UnimplementedError();

  @override
  // implement uploadDownloadProgressChanged
  Stream get onUploadDownloadProgressChanged => throw UnimplementedError();

  @override
  // onMemberMadeAsAdmin
  Stream get onMemberMadeAsAdmin => throw UnimplementedError();

  @override
  // onMemberRemovedAsAdmin
  Stream get onMemberRemovedAsAdmin => throw UnimplementedError();

  @override
  // onMemberRemovedFromGroup
  Stream get onMemberRemovedFromGroup => throw UnimplementedError();

  @override
  // onMessageReceived
  Stream get onMessageReceived => throw UnimplementedError();

  @override
  // onMessageStatusUpdated
  Stream get onMessageStatusUpdated => throw UnimplementedError();

  @override
  // onNewGroupCreated
  Stream<String> get onNewGroupCreated => throw UnimplementedError();

  @override
  // onNewMemberAddedToGroup
  Stream get onNewMemberAddedToGroup => throw UnimplementedError();

  @override
  // onProgressChanged
  Stream get onProgressChanged => throw UnimplementedError();

  @override
  // onSuccess
  Stream get onSuccess => throw UnimplementedError();

  @override
  // onWebChatPasswordChanged
  Stream get onWebChatPasswordChanged => throw UnimplementedError();

  @override
  Future openFile(String filePath) {
    // openFile
    throw UnimplementedError();
  }

  @override
  Future prepareChatConversationToExport(String jid) {
    // prepareChatConversationToExport
    throw UnimplementedError();
  }

  @override
  Future<int?> recentChatPinnedCount() {
    // recentChatPinnedCount
    throw UnimplementedError();
  }

  @override
  Future<bool?> refreshAndGetAuthToken() {
    // refreshAndGetAuthToken
    throw UnimplementedError();
  }

  @override
  Future registerUser(String userIdentifier, {String token = ""}) {
    // registerUser
    throw UnimplementedError();
  }

  @override
  removeCustomValue(String messageId, String key) {
    // removeCustomValue
    throw UnimplementedError();
  }

  @override
  Future<bool?> removeGroupProfileImage(String jid) {
    // removeGroupProfileImage
    throw UnimplementedError();
  }

  @override
  Future<bool?> removeMemberFromGroup(String groupjid, String userjid) {
    // removeMemberFromGroup
    throw UnimplementedError();
  }

  @override
  Future<bool?> removeProfileImage() {
    // removeProfileImage
    throw UnimplementedError();
  }

  @override
  Future reportChatOrUser(String jid, String chatType, String? messageId) {
    // reportChatOrUser
    throw UnimplementedError();
  }

  @override
  Future<bool?> reportUserOrMessages(String jid, String type, String? messageId) {
    // reportUserOrMessages
    throw UnimplementedError();
  }

  @override
  Future revokeContactSync() {
    // revokeContactSync
    throw UnimplementedError();
  }

  @override
  Future saveProfile(String name, String email) {
    // saveProfile
    throw UnimplementedError();
  }

  @override
  saveUnsentMessage(String jid, String message) {
    // saveUnsentMessage
    throw UnimplementedError();
  }

  @override
  Future searchConversation(String searchKey, [String? jidForSearch, bool globalSearch = true]) {
    // searchConversation
    throw UnimplementedError();
  }

  @override
  Future sendAudioMessage(String jid, String filePath, bool isRecorded, String duration, String replyMessageId, [String? audiofileUrl]) {
    // sendAudioMessage
    throw UnimplementedError();
  }

  @override
  Future sendContactMessage(List<String> contactList, String jid, String contactName, String replyMessageId) {
    // sendContactMessage
    throw UnimplementedError();
  }

  @override
  Future<bool?> sendContactUsInfo(String title, String description) {
    // sendContactUsInfo
    throw UnimplementedError();
  }

  @override
  Future sendDocumentMessage(String jid, String documentPath, String replyMessageId, [String? fileUrl]) {
    // sendDocumentMessage
    throw UnimplementedError();
  }

  @override
  sendImageMessage(String jid, String filePath, String? caption, String? replyMessageID, [String? imageFileUrl]) {
    // sendImageMessage
    throw UnimplementedError();
  }

  @override
  sendLocationMessage(String jid, double latitude, double longitude, String replyMessageId) {
    // sendLocationMessage
    throw UnimplementedError();
  }

  @override
  sendTextMessage(String message, String jid, String replyMessageId) {
    // sendTextMessage
    throw UnimplementedError();
  }

  @override
  sendTypingGoneStatus(String toJid, String chattype) {
    // sendTypingGoneStatus
    throw UnimplementedError();
  }

  @override
  sendTypingStatus(String toJid, String chattype) {
    // sendTypingStatus
    throw UnimplementedError();
  }

  @override
  sendVideoMessage(String jid, String filePath, String? caption, String? replyMessageID, [String? videoFileUrl, num? videoDuration, String? thumbImageBase64]) {
    // sendVideoMessage
    throw UnimplementedError();
  }

  @override
  Future sentFileMessage(String? file, String jid) {
    // sentFileMessage
    throw UnimplementedError();
  }

  @override
  setCustomValue(String messageId, String key, String value) {
    // setCustomValue
    throw UnimplementedError();
  }

  @override
  setMediaEncryption(String encryption) {
    // setMediaEncryption
    throw UnimplementedError();
  }

  @override
  setMuteNotification(bool enable) {
    // setMuteNotification
    throw UnimplementedError();
  }

  @override
  Future<bool?> setMyBusyStatus(String busystatus) {
    // setMyBusyStatus
    throw UnimplementedError();
  }

  @override
  Future setMyProfileStatus(String status,[String? statusId]) {
    // setMyProfileStatus
    throw UnimplementedError();
  }

  @override
  setNotificationSound(bool enable) {
    // setNotificationSound
    throw UnimplementedError();
  }

  @override
  setNotificationUri(String uri) {
    // setNotificationUri
    throw UnimplementedError();
  }

  @override
  setNotificationVibration(bool enable) {
    // setNotificationVibration
    throw UnimplementedError();
  }

  @override
  setOnGoingChatUser(String jid) {
    // setOnGoingChatUser
    throw UnimplementedError();
  }

  @override
  // setTypingStatus
  Stream get setTypingStatus => throw UnimplementedError();

  @override
  setTypingStatusListener() {
    // setTypingStatusListener
    throw UnimplementedError();
  }

  @override
  Future<String?> showCustomTones() {
    // showCustomTones
    throw UnimplementedError();
  }

  @override
  startBackup() {
    // startBackup
    throw UnimplementedError();
  }

  @override
  Future<bool?> syncContacts(bool isfirsttime) {
    // syncContacts
    throw UnimplementedError();
  }

  @override
  Future<bool?> unFavouriteAllFavouriteMessages() {
    // unFavouriteAllFavouriteMessages
    throw UnimplementedError();
  }

  @override
  Future<bool?> unblockUser(String userJID) {
    // unblockUser
    throw UnimplementedError();
  }

  @override
  // unblockedThisUser
  Stream get unblockedThisUser => throw UnimplementedError();

  @override
  Future<bool?> updateArchiveUnArchiveChat(String jid, bool isArchived) {
    // updateArchiveUnArchiveChat
    throw UnimplementedError();
  }

  @override
  updateChatMuteStatus(String jid, bool muteStatus) {
    // updateChatMuteStatus
    throw UnimplementedError();
  }

  @override
  Future updateFavouriteStatus(String messageID, String chatUserJID, bool isFavourite, String chatType) {
    // updateFavouriteStatus
    throw UnimplementedError();
  }

  @override
  Future<bool?> updateFcmToken(String firebasetoken) {
    // updateFcmToken
    throw UnimplementedError();
  }

  @override
  Future<bool?> updateGroupName(String jid, String name) {
    // updateGroupName
    throw UnimplementedError();
  }

  @override
  Future<bool?> updateGroupProfileImage(String jid, String file) {
    // updateGroupProfileImage
    throw UnimplementedError();
  }

  @override
  updateMediaDownloadStatus(String mediaMessageId, int progress, int downloadStatus, num dataTransferred) {
    // updateMediaDownloadStatus
    throw UnimplementedError();
  }

  @override
  updateMediaUploadStatus(String mediaMessageId, int progress, int uploadStatus, num dataTransferred) {
    // updateMediaUploadStatus
    throw UnimplementedError();
  }

  @override
  updateMyProfile(String name, String email, String mobile, String status, String? image) {
    // updateMyProfile
    throw UnimplementedError();
  }

  @override
  Future updateMyProfileImage(String image) {
    // updateMyProfileImage
    throw UnimplementedError();
  }

  @override
  updateRecentChatPinStatus(String jid, bool pinStatus) {
    // updateRecentChatPinStatus
    throw UnimplementedError();
  }

  @override
  Future<bool?> uploadMedia(String messageid) {
    // uploadMedia
    throw UnimplementedError();
  }

  @override
  // userBlockedMe
  Stream get userBlockedMe => throw UnimplementedError();

  @override
  // userCameOnline
  Stream get userCameOnline => throw UnimplementedError();

  @override
  // userDeletedHisProfile
  Stream<String> get userDeletedHisProfile => throw UnimplementedError();

  @override
  // userProfileFetched
  Stream get userProfileFetched => throw UnimplementedError();

  @override
  // userUnBlockedMe
  Stream get userUnBlockedMe => throw UnimplementedError();

  @override
  // userUpdatedHisProfile
  Stream get userUpdatedHisProfile => throw UnimplementedError();

  @override
  // userWentOffline
  Stream get userWentOffline => throw UnimplementedError();

  @override
  // usersIBlockedListFetched
  Stream get usersIBlockedListFetched => throw UnimplementedError();

  @override
  // usersWhoBlockedMeListFetched
  Stream get usersWhoBlockedMeListFetched => throw UnimplementedError();

  @override
  Future<String?> verifyToken(String userName, String token) {
    // verifyToken
    throw UnimplementedError();
  }

  @override
  Future<bool?> webLoginDetailsCleared() {
    // webLoginDetailsCleared
    throw UnimplementedError();
  }

  @override
  Future<String?> getJidFromPhoneNumber(String mobileNumber, String countryCode) {
    // getJidFromPhoneNumber
    throw UnimplementedError();
  }

  @override
  Future<bool?> getMediaAutoDownload() {
    // getMediaAutoDownload
    throw UnimplementedError();
  }

  @override
  Future<bool?> getMediaSetting(int networkType, String type) {
    // getMediaSetting
    throw UnimplementedError();
  }

  @override
  Future<bool?> getNotificationSound() {
    // getNotificationSound
    throw UnimplementedError();
  }

  @override
  saveMediaSettings(bool photos, bool videos, bool audio, bool documents, int networkType) {
    // saveMediaSettings
    throw UnimplementedError();
  }

  @override
  setMediaAutoDownload(bool enable) {
    // setMediaAutoDownload
    throw UnimplementedError();
  }

  @override
  Future<bool?> insertBusyStatus(String busyStatus) {
    // insertBusyStatus
    throw UnimplementedError();
  }

  @override
  Future<bool?> addContact(String number, String name) {
    // implement addContact
    throw UnimplementedError();
  }

  @override
  Future getNonChatUsers() {
    // implement getNonChatUsers
    throw UnimplementedError();
  }

  @override
  Future<bool?> isTrailLicence() {
    // implement isTrailLicence
    throw UnimplementedError();
  }

  @override
  Future setRegionCode(String regionCode) {
    // implement setRegionCode
    throw UnimplementedError();
  }

  @override
  Future<bool?> iOSFileExist(String filePath) {
    // implement iOSFileExist
    throw UnimplementedError();
  }

  @override
  Future insertNewProfileStatus(String status) {
    // implement insertNewProfileStatus
    throw UnimplementedError();
  }

  @override
  Future setDefaultNotificationSound() {
    // implement setDefaultNotificationSound
    throw UnimplementedError();
  }

  @override
  // TODO: implement usersProfilesFetched
  Stream<bool> get usersProfilesFetched => throw UnimplementedError();

  @override
  // TODO: implement userProfilesFetched
  Stream get userProfilesFetched => throw UnimplementedError();
}

void main() {
  final FlyChatFlutterPlatform initialPlatform = FlyChatFlutterPlatform.instance;

  test('$MethodChannelFlyChatFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlyChatFlutter>());
  });

  test('getPlatformVersion', () async {
    //FlyChat flychatFlutterPlugin = FlyChat;
    MockFlyChatFlutterPlatform fakePlatform = MockFlyChatFlutterPlatform();
    FlyChatFlutterPlatform.instance = fakePlatform;

    // expect(await FlyChat.getPlatformVersion(), '42');
  });
}
