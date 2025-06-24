import 'package:flutter_test/flutter_test.dart';
import 'package:mirrorfly_plugin/builder.dart';
import 'package:mirrorfly_plugin/edit_message_params.dart';
import 'package:mirrorfly_plugin/event_handlers.dart';
import 'package:mirrorfly_plugin/fly_chat_method_channel.dart';
import 'package:mirrorfly_plugin/fly_chat_platform_interface.dart';
import 'package:mirrorfly_plugin/message_params.dart';
import 'package:mirrorfly_plugin/model/callback.dart';
import 'package:mirrorfly_plugin/model/notification_applaunch_details.dart';
import 'package:mirrorfly_plugin/model/topic_metadata.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlyChatFlutterPlatform
    with MockPlatformInterfaceMixin
    implements FlyChatFlutterPlatform {
  @override
  Future<bool> acceptVideoCallSwitchRequest() {
    //  implement acceptVideoCallSwitchRequest
    throw UnimplementedError();
  }

  @override
  Future<bool?> addContact(String number, String name) {
    //  implement addContact
    throw UnimplementedError();
  }

  @override
  Future<void> addUsersToGroup(String jid, List<String> userList,
      Function(FlyResponse response)? callback) {
    //  implement addUsersToGroup
    throw UnimplementedError();
  }

  @override
  Future<bool?> appLaunchedFromMissedCall() {
    //  implement appLaunchedFromMissedCall
    throw UnimplementedError();
  }

  @override
  Future<MirrorflyNotificationAppLaunchDetails?> getAppLaunchedDetails() {
    //  implement appLaunchedDetails
    throw UnimplementedError();
  }

  @override
  Future<String?> authToken() {
    //  implement authToken
    throw UnimplementedError();
  }

  @override
  Future<void> blockUser(
      String userJID, Function(FlyResponse response)? callback) {
    //  implement blockUser
    throw UnimplementedError();
  }

  @override
  //  implement blockedThisUser
  Stream get blockedThisUser => throw UnimplementedError();

  @override
  cancelMediaUploadOrDownload(String messageId) {
    //  implement cancelMediaUploadOrDownload
    throw UnimplementedError();
  }

  /*@override
  cancelRestore() {
    //  implement cancelRestore
    throw UnimplementedError();
  }*/

  @override
  Future<bool> cancelVideoCallSwitch() {
    //  implement cancelVideoCallSwitch
    throw UnimplementedError();
  }

  @override
  Future<void> clearAllConversation(Function(FlyResponse response)? callback) {
    //  implement clearAllConversation
    throw UnimplementedError();
  }

  /* @override
  clearAllSDKData() {
    //  implement clearAllSDKData
    throw UnimplementedError();
  }*/

  @override
  Future<void> clearChat(String jid, String chatType, bool clearExceptStarred,
      Function(FlyResponse response)? callback) {
    //  implement clearChat
    throw UnimplementedError();
  }

  // @override
  // connectionFailed
  // Stream get connectionFailed => throw UnimplementedError();

  // @override
  // // connectionSuccess
  // Stream get connectionSuccess => throw UnimplementedError();

  @override
  Future<bool> contactSyncStateValue() {
    //  implement contactSyncStateValue
    throw UnimplementedError();
  }

  @override
  copyTextMessages(List<String> messageIds) {
    //  implement copyTextMessages
    throw UnimplementedError();
  }

  @override
  Future<void> createGroup(String groupName, List<String> userJidList,
      String imageFilePath, Function(FlyResponse response)? callback) {
    //  implement createGroup
    throw UnimplementedError();
  }

  @override
  Future<bool?> createOfflineGroupInOnline(String groupId) {
    //  implement createOfflineGroupInOnline
    throw UnimplementedError();
  }

  @override
  Future<void> createTopic(
      {required String topicName,
      List<TopicMetaData> metaData = const [],
      Function(FlyResponse response)? callback}) {
    //  implement createTopic
    throw UnimplementedError();
  }

  @override
  Future<bool?> declineCall() {
    //  implement declineCall
    throw UnimplementedError();
  }

  @override
  Future<bool> declineVideoCallSwitchRequest() {
    //  implement declineVideoCallSwitchRequest
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAccount(String reason, String? feedback,
      Function(FlyResponse response)? callback) {
    //  implement deleteAccount
    throw UnimplementedError();
  }

  @override
  deleteAllMessages() {
    //  implement deleteAllMessages
    throw UnimplementedError();
  }

  @override
  Future<bool?> deleteBusyStatus(
      String id, String status, bool isCurrentStatus) {
    //  implement deleteBusyStatus
    throw UnimplementedError();
  }

  @override
  Future<void> deleteCallLog(List<String> jidlist, bool isClearAll,
      Function(FlyResponse response)? callback) {
    //  implement deleteCallLog
    throw UnimplementedError();
  }

  @override
  Future<void> deleteGroup(
      String jid, Function(FlyResponse response)? callback) {
    //  implement deleteGroup
    throw UnimplementedError();
  }

  /*@override
  Future deleteMessages(
      String jid, List<String> messageIds, bool isDeleteForEveryOne) {
    //  implement deleteMessages
    throw UnimplementedError();
  }*/

  @override
  Future<void> deleteMessagesForEveryone(
      String jid,
      String chatType,
      List<String> messageIds,
      bool? isMediaDelete,
      Function(FlyResponse response)? callback) {
    //  implement deleteMessagesForEveryone
    throw UnimplementedError();
  }

  @override
  Future<void> deleteMessagesForMe(
      String jid,
      String chatType,
      List<String> messageIds,
      bool? isMediaDelete,
      Function(FlyResponse response)? callback) {
    //  implement deleteMessagesForMe
    throw UnimplementedError();
  }

  @override
  deleteOfflineGroup(String groupJid) {
    //  implement deleteOfflineGroup
    throw UnimplementedError();
  }

  @override
  Future<bool?> deleteProfileStatus(
      String id, String status, bool isCurrentStatus) {
    //  implement deleteProfileStatus
    throw UnimplementedError();
  }

  @override
  Future<void> deleteRecentChat(
      String jid, Function(FlyResponse response)? callback) {
    //  implement deleteRecentChat
    throw UnimplementedError();
  }

  @override
  Future<void> deleteRecentChats(
      List<String> jidlist, Function(FlyResponse response)? callback) {
    //  implement deleteRecentChats
    throw UnimplementedError();
  }

  @override
  Future<bool?> deleteUnreadMessageSeparatorOfAConversation(String jid) {
    //  implement deleteUnreadMessageSeparatorOfAConversation
    throw UnimplementedError();
  }

  @override
  Future<void> disconnectCall(Function(FlyResponse response)? callback) {
    //  implement disconnectCall
    throw UnimplementedError();
  }

  @override
  Future<bool?> doesFetchingMembersListFromServedRequired(String groupJid) {
    //  implement doesFetchingMembersListFromServedRequired
    throw UnimplementedError();
  }

  @override
  downloadMedia(String mid) {
    //  implement downloadMedia
    throw UnimplementedError();
  }

  @override
  Future<void> enableDisableArchivedSettings(
      bool enable, Function(FlyResponse response)? callback) {
    //  implement enableDisableArchivedSettings
    throw UnimplementedError();
  }

  @override
  Future<void> enableDisableBusyStatus(
      bool enable, Function(FlyResponse response)? callback) {
    //  implement enableDisableBusyStatus
    throw UnimplementedError();
  }

  @override
  Future<bool?> enableDisableHideLastSeen(bool enable) {
    //  implement enableDisableHideLastSeen
    throw UnimplementedError();
  }

  @override
  Future<void> setLastSeenVisibility(
      bool enable, Function(FlyResponse response)? callback) {
    //  implement setLastSeenVisibility
    throw UnimplementedError();
  }

  @override
  Future<void> exportChatConversationToEmail(
      String jid, Function(FlyResponse response)? callback) {
    //  implement exportChatConversationToEmail
    throw UnimplementedError();
  }

  @override
  Future<void> forwardMessagesToMultipleUsers(List<String> messageIds,
      List<String> userList, Function(FlyResponse response)? callback) {
    //  implement forwardMessagesToMultipleUsers
    throw UnimplementedError();
  }

  @override
  Future<String> getAllAvailableAudioInput() {
    //  implement getAllAvailableAudioInput
    throw UnimplementedError();
  }

  @override
  Future<void> getAllGroups(
      [bool? server, Function(FlyResponse response)? callback]) {
    //  implement getAllGroups
    throw UnimplementedError();
  }

  @override
  Future<void> getArchivedChatList(Function(FlyResponse response)? callback) {
    //  implement getArchivedChatList
    throw UnimplementedError();
  }

  @override
  getArchivedChatsFromServer() {
    //  implement getArchivedChatsFromServer
    throw UnimplementedError();
  }

  @override
  Future<String> getAvailableFeatures() {
    //  implement getAvailableFeatures
    throw UnimplementedError();
  }

  @override
  Future<String?> getBusyStatusList() {
    //  implement getBusyStatusList
    throw UnimplementedError();
  }

  @override
  Future<String> getCallDirection() {
    //  implement getCallDirection
    throw UnimplementedError();
  }

  @override
  Future<String> getCallGroupJid() {
    //  implement getCallGroupJid
    throw UnimplementedError();
  }

  @override
  Future<void> getCallLogsList(
      int currentPage, Function(FlyResponse response)? callback) {
    //  implement getCallLogsList
    throw UnimplementedError();
  }

  @override
  Future<String> getCallType() {
    //  implement getCallType
    throw UnimplementedError();
  }

  @override
  Future<String> getCallUsersList() {
    //  implement getCallUsersList
    throw UnimplementedError();
  }

  @override
  Future<String> getCurrentAuthToken() {
    //  implement getCurrentAuthToken
    throw UnimplementedError();
  }

  /*@override
  Future<String?> getCustomValue(String messageId, String key) {
    //  implement getCustomValue
    throw UnimplementedError();
  }*/

  @override
  Future<String?> getDefaultNotificationUri() {
    //  implement getDefaultNotificationUri
    throw UnimplementedError();
  }

  @override
  Future<String?> getDocsMessages(String jid) {
    //  implement getDocsMessages
    throw UnimplementedError();
  }

  @override
  Future<String> getFavouriteMessages() {
    //  implement getFavouriteMessages
    throw UnimplementedError();
  }

  @override
  Future<String?> getGroupJid(String groupId) {
    //  implement getGroupJid
    throw UnimplementedError();
  }

  @override
  Future<void> getGroupMembersList(
      String jid, bool? server, Function(FlyResponse response)? callback) {
    //  implement getGroupMembersList
    throw UnimplementedError();
  }

  @override
  Future<String> getGroupMessageDeliveredToList(String messageId, String jid) {
    //  implement getGroupMessageDeliveredToList
    throw UnimplementedError();
  }

  @override
  Future<void> getGroupMessageDeliveredRecipients(
      String messageId, String jid, Function(FlyResponse response)? callback) {
    //  implement getGroupMessageDeliveredRecipients
    throw UnimplementedError();
  }

  @override
  Future<String> getGroupMessageReadByList(String messageId, String jid) {
    //  implement getGroupMessageReadByList
    throw UnimplementedError();
  }

  @override
  Future<void> getGroupMessageSeenRecipients(
      String messageId, String jid, Function(FlyResponse response)? callback) {
    //  implement getGroupMessageSeenRecipients
    throw UnimplementedError();
  }

  @override
  Future<int?> getGroupMessageStatusCount(String messageid) {
    //  implement getGroupMessageStatusCount
    throw UnimplementedError();
  }

  @override
  Future<void> getGroupProfile(
      String groupJid, bool server, Function(FlyResponse response)? callback) {
    //  implement getGroupProfile
    throw UnimplementedError();
  }

  @override
  Future<List<String>> getInvitedUsersList() {
    //  implement getInvitedUsersList
    throw UnimplementedError();
  }

  @override
  Future<bool?> getIsProfileBlockedByAdmin() {
    //  implement getIsProfileBlockedByAdmin
    throw UnimplementedError();
  }

  @override
  Future<String?> getJid(String username) {
    //  implement getJid
    throw UnimplementedError();
  }

  @override
  Future<String?> getJidFromPhoneNumber(
      String mobileNumber, String countryCode) {
    //  implement getJidFromPhoneNumber
    throw UnimplementedError();
  }

  @override
  Future<String?> getLastNUnreadMessages(int messagesCount) {
    //  implement getLastNUnreadMessages
    throw UnimplementedError();
  }

  @override
  Future<String?> getLinkMessages(String jid) {
    //  implement getLinkMessages
    throw UnimplementedError();
  }

  @override
  Future<String> getLocalCallLogs() {
    //  implement getLocalCallLogs
    throw UnimplementedError();
  }

  @override
  Future<int?> getMaxCallUsersCount() {
    //  implement getMaxCallUsersCount
    throw UnimplementedError();
  }

  @override
  Future<bool?> getMediaAutoDownload() {
    //  implement getMediaAutoDownload
    throw UnimplementedError();
  }

  @override
  Future<String?> getMediaMessages(String jid) {
    //  implement getMediaMessages
    throw UnimplementedError();
  }

  @override
  Future<bool?> getMediaSetting(int networkType, String type) {
    //  implement getMediaSetting
    throw UnimplementedError();
  }

  @override
  Future<int?> getMembersCountOfGroup(String groupJid) {
    //  implement getMembersCountOfGroup
    throw UnimplementedError();
  }

  @override
  Future<String?> getMessageOfId(String mid) {
    //  implement getMessageOfId
    throw UnimplementedError();
  }

  @override
  Future<String> getMessageStatusOfASingleChatMessage(String messageID) {
    //  implement getMessageStatusOfASingleChatMessage
    throw UnimplementedError();
  }

  @override
  Future<String?> getMessagesOfJid(String jid) {
    //  implement getMessagesOfJid
    throw UnimplementedError();
  }

  @override
  Future<String?> getMessagesUsingIds(List<String> messageIds) {
    //  implement getMessagesUsingIds
    throw UnimplementedError();
  }

  @override
  Future<String> getMyBusyStatus() {
    //  implement getMyBusyStatus
    throw UnimplementedError();
  }

  @override
  Future<String?> getNonChatUsers() {
    //  implement getNonChatUsers
    throw UnimplementedError();
  }

  @override
  Future<bool?> getNotificationSound() {
    //  implement getNotificationSound
    throw UnimplementedError();
  }

  @override
  Future<String?> getProfileDetails(String jid) {
    //  implement getProfileDetails
    throw UnimplementedError();
  }

  @override
  Future<String?> getProfileStatusList() {
    //  implement getProfileStatusList
    throw UnimplementedError();
  }

  @override
  Future<String?> getRecalledMessagesOfAConversation(String jid) {
    //  implement getRecalledMessagesOfAConversation
    throw UnimplementedError();
  }

  @override
  Future<void> getRecentChatList(Function(FlyResponse response)? callback) {
    //  implement getRecentChatList
    throw UnimplementedError();
  }

  @override
  Future<void> getRecentChatListHistory(
      {required bool firstSet,
      int limit = 15,
      required Function(FlyResponse response) callback}) {
    //  implement getRecentChatListHistory
    throw UnimplementedError();
  }

  @override
  Future<void> getRecentChatListHistoryByTopic(
      {String? topicId,
      required bool firstSet,
      int limit = 15,
      required Function(FlyResponse response) callback}) {
    //  implement getRecentChatListHistoryByTopic
    throw UnimplementedError();
  }

  @override
  Future<String> getRecentChatListIncludingArchived() {
    //  implement getRecentChatListIncludingArchived
    throw UnimplementedError();
  }

  @override
  Future<String> getRecentChatOf(String jid) {
    //  implement getRecentChatOf
    throw UnimplementedError();
  }

  @override
  Future<String?> getRegisteredUserList({required bool server}) {
    //  implement getRegisteredUserList
    throw UnimplementedError();
  }

  @override
  Future<void> getRegisteredUsers(
      bool server, Function(FlyResponse response) callback) {
    //  implement getRegisteredUsers
    throw UnimplementedError();
  }

  /* @override
  Future<String?> getRingtoneName() {
    //  implement getRingtoneName
    throw UnimplementedError();
  }

  @override
  getRoster() {
    //  implement getRoster
    throw UnimplementedError();
  }*/

  @override
  Future<void> getTopics(
      {required List<String> topicIds,
      Function(FlyResponse response)? callback}) {
    //  implement getTopics
    throw UnimplementedError();
  }

  @override
  Future<int?> getUnreadMessageCountExceptMutedChat() {
    //  implement getUnreadMessageCountExceptMutedChat
    throw UnimplementedError();
  }

  @override
  Future<int?> getUnreadMessagesCount() {
    //  implement getUnreadMessagesCount
    throw UnimplementedError();
  }

  @override
  Future<int?> getUnreadMissedCallCount() {
    //  implement getUnreadMissedCallCount
    throw UnimplementedError();
  }

  @override
  Future<String?> getUnsentMessageOfAJid(String jid) {
    //  implement getUnsentMessageOfAJid
    throw UnimplementedError();
  }

  @override
  Future<void> getUserLastSeenTime(
      String jid, Function(FlyResponse response)? callback) {
    //  implement getUserLastSeenTime
    throw UnimplementedError();
  }

  @override
  Future<void> getUserList(
      int page,
      String search,
      MetaDataUserList? metaDataUserList,
      Function(FlyResponse response) callback,
      {int perPageResultSize = 20}) {
    //  implement getUserList
    throw UnimplementedError();
  }

  @override
  Future<void> getUserProfile(
      String jid, Function(FlyResponse response) callback,
      [bool fromserver = false, bool saveasfriend = false]) {
    //  implement getUserProfile
    throw UnimplementedError();
  }

  @override
  Future<void> getUsersIBlocked(
      bool? server, Function(FlyResponse response)? callback) {
    //  implement getUsersIBlocked
    throw UnimplementedError();
  }

  @override
  Future<void> getUsersWhoBlockedMe(
      [bool server = false, Function(FlyResponse response)? callback]) {
    //  implement getUsersWhoBlockedMe
    throw UnimplementedError();
  }

  @override
  Future<String> getValueFromManifestOrInfoPlist(
      {String? androidManifestKey, String? iOSPlistKey}) {
    //  implement getValueFromManifestOrInfoPlist
    throw UnimplementedError();
  }

  /*@override
  Future getWebLoginDetails() {
    //  implement getWebLoginDetails
    throw UnimplementedError();
  }*/

  @override
  Future<void> handleReceivedMessage(
      Map notificationData, Function(FlyResponse response)? callback) {
    //  implement handleReceivedMessage
    throw UnimplementedError();
  }

  @override
  Future<bool> hasNextMessages() {
    //  implement hasNextMessages
    throw UnimplementedError();
  }

  @override
  Future<bool> hasPreviousMessages() {
    //  implement hasPreviousMessages
    throw UnimplementedError();
  }

  /* @override
  Future<bool?> iOSFileExist(String filePath) {
    //  implement iOSFileExist
    throw UnimplementedError();
  }

  @override
  Future<String?> imagePath(String imgurl) {
    //  implement imagePath
    throw UnimplementedError();
  }*/

  @override
  init(ChatBuilder builder) {
    //  implement init
    throw UnimplementedError();
  }

  @override
  Future<bool> initializeMessageList(
      {required String userJid,
      String? messageId,
      double? messageTime,
      bool? exclude,
      int limit = 25,
      String? topicId,
      MetaDataMessageList? metaDataMessageList,
      bool ascendingOrder = true}) {
    //  implement initializeMessageList
    throw UnimplementedError();
  }

  @override
  Future<void> initializeSDK(
      InitializeSDKBuilder builder, Function(FlyResponse response) callback) {
    //  implement initializeSDK
    throw UnimplementedError();
  }

  @override
  Future<bool> isPrivateStorageEnabledOrNot() {
    //  implement isPrivateStorageEnabled
    throw UnimplementedError();
  }

  @override
  Future<bool?> insertBusyStatus(String busyStatus) {
    //  implement insertBusyStatus
    throw UnimplementedError();
  }

  @override
  Future<bool?> insertDefaultStatus(String status) {
    //  implement insertDefaultStatus
    throw UnimplementedError();
  }

  @override
  Future<bool?> insertNewProfileStatus(String status) {
    //  implement insertNewProfileStatus
    throw UnimplementedError();
  }

  /*@override
  inviteUserViaSMS(String mobileNo, String message) {
    //  implement inviteUserViaSMS
    throw UnimplementedError();
  }*/

  @override
  Future<void> inviteUsersToOngoingCall(
      List<String> jidList, Function(FlyResponse response)? callback) {
    //  implement inviteUsersToOngoingCall
    throw UnimplementedError();
  }

  @override
  Future<bool?> isAdmin(String userJid, String groupJID) {
    //  implement isAdmin
    throw UnimplementedError();
  }

  @override
  Future<bool?> isArchivedSettingsEnabled() {
    //  implement isArchivedSettingsEnabled
    throw UnimplementedError();
  }

  @override
  Future<bool> isBusyStatusEnabled() {
    //  implement isBusyStatusEnabled
    throw UnimplementedError();
  }

  @override
  Future<bool?> isCallConversionRequestAvailable() {
    //  implement isCallConversionRequestAvailable
    throw UnimplementedError();
  }

  @override
  Future<bool?> isHideLastSeenEnabled() {
    //  implement isHideLastSeenEnabled
    throw UnimplementedError();
  }

  @override
  Future<bool?> isMemberOfGroup(String jid, String? userJid) {
    //  implement isMemberOfGroup
    throw UnimplementedError();
  }

  @override
  Future<bool?> isMuted(String jid) {
    //  implement isMuted
    throw UnimplementedError();
  }

  @override
  Future<bool?> isOnGoingCall() {
    //  implement isOnGoingCall
    throw UnimplementedError();
  }

  @override
  Future<int?> getCurrentCallDuration() {
    //  implement getCurrentCallDuration
    throw UnimplementedError();
  }

  @override
  Future<bool?> isTrailLicence() {
    //  implement isTrailLicence
    throw UnimplementedError();
  }

  @override
  Future<bool?> isUserAudioMuted([String? userJid]) {
    //  implement isUserAudioMuted
    throw UnimplementedError();
  }

  @override
  Future<bool?> isUserUnArchived(String jid) {
    //  implement isUserUnArchived
    throw UnimplementedError();
  }

  @override
  Future<bool?> isUserVideoMuted([String? userJid]) {
    //  implement isUserVideoMuted
    throw UnimplementedError();
  }

  @override
  Future<void> leaveFromGroup(String? userJid, String groupJid,
      Function(FlyResponse response)? callback) {
    //  implement leaveFromGroup
    throw UnimplementedError();
  }

  /*@override
  Future listenGroupChatEvents() {
    //  implement listenGroupChatEvents
    throw UnimplementedError();
  }

  @override
  Future listenMessageEvents() {
    //  implement listenMessageEvents
    throw UnimplementedError();
  }*/

  @override
  Future<void> loadMessages(Function(FlyResponse response) callback) {
    //  implement loadMessages
    throw UnimplementedError();
  }

  @override
  Future<void> loadNextMessages(Function(FlyResponse response) callback) {
    //  implement loadNextMessages
    throw UnimplementedError();
  }

  @override
  Future<void> loadPreviousMessages(Function(FlyResponse response) callback) {
    //  implement loadPreviousMessages
    throw UnimplementedError();
  }

  /*@override
  Future<void> loginWebChatViaQRCode(
      String barcode, Function(FlyResponse response)? callback) {
    //  implement loginWebChatViaQRCode
    throw UnimplementedError();
  }*/

  @override
  Future<void> logoutOfChatSDK(Function(FlyResponse response)? callback) {
    //  implement logoutOfChatSDK
    throw UnimplementedError();
  }

  /*@override
  Future<bool?> logoutWebUser(List<String> logins) {
    //  implement logoutWebUser
    throw UnimplementedError();
  }*/

  @override
  Future<void> makeAdmin(String groupjid, String userjid,
      Function(FlyResponse response)? callback) {
    //  implement makeAdmin
    throw UnimplementedError();
  }

  @override
  Future<void> makeGroupVideoCall(String groupJid, List<String>? jidList,
      Function(FlyResponse response)? callback) {
    //  implement makeGroupVideoCall
    throw UnimplementedError();
  }

  @override
  Future<void> makeGroupVoiceCall(String groupJid, List<String>? jidList,
      Function(FlyResponse response)? callback) {
    //  implement makeGroupVoiceCall
    throw UnimplementedError();
  }

  @override
  Future<void> makeVideoCall(
      String userJid, Function(FlyResponse response)? callback) {
    //  implement makeVideoCall
    throw UnimplementedError();
  }

  @override
  Future<void> makeVoiceCall(
      String userJid, Function(FlyResponse response)? callback) {
    //  implement makeVoiceCall
    throw UnimplementedError();
  }

  @override
  Future<bool?> markAllUnreadMissedCallsAsRead() {
    //  implement markAllUnreadMissedCallsAsRead
    throw UnimplementedError();
  }

  @override
  Future<bool?> markAsRead(String jid) {
    //  implement markAsRead
    throw UnimplementedError();
  }

  @override
  Future<bool?> markAsReadDeleteUnreadSeparator(String jid) {
    //  implement markAsReadDeleteUnreadSeparator
    throw UnimplementedError();
  }

  @override
  markConversationAsRead(List<String> jidlist) {
    //  implement markConversationAsRead
    throw UnimplementedError();
  }

  @override
  markConversationAsUnread(List<String> jidlist) {
    //  implement markConversationAsUnread
    throw UnimplementedError();
  }

  @override
  Future<String?> mediaEndPoint() {
    //  implement mediaEndPoint
    throw UnimplementedError();
  }

  @override
  Future<void> muteAudio(
      bool status, Function(FlyResponse response)? callback) {
    //  implement muteAudio
    throw UnimplementedError();
  }

  @override
  Future<void> muteVideo(
      bool status, Function(FlyResponse response)? callback) {
    //  implement muteVideo
    throw UnimplementedError();
  }

  @override
  //  implement myProfileUpdated
  Stream get myProfileUpdated => throw UnimplementedError();

  @override
  //  implement onAdminBlockedOtherUser
  Stream get onAdminBlockedOtherUser => throw UnimplementedError();

  @override
  //  implement onAdminBlockedUser
  Stream get onAdminBlockedUser => throw UnimplementedError();

  @override
  //  implement onAvailableFeaturesUpdated
  Stream get onAvailableFeaturesUpdated => throw UnimplementedError();

  @override
  //  implement onCallAction
  Stream get onCallAction => throw UnimplementedError();

  @override
  //  implement onCallLogDeleted
  Stream get onCallLogDeleted => throw UnimplementedError();

  @override
  //  implement onCallLogDeleted
  Stream get onClearAllCallLog => throw UnimplementedError();

  @override
  //  implement onCallLogsUpdated
  Stream get onCallLogsUpdated => throw UnimplementedError();

  @override
  //  implement onCallStatusUpdated
  Stream get onCallStatusUpdated => throw UnimplementedError();

  @override
  //  implement onChatTypingStatus
  Stream get onChatTypingStatus => throw UnimplementedError();

  @override
  //  implement onConnected
  Stream get onConnected => throw UnimplementedError();

  @override
  //  implement onConnectionFailed
  Stream get onConnectionFailed => throw UnimplementedError();

  @override
  //  implement onContactSyncComplete
  Stream get onContactSyncComplete => throw UnimplementedError();

  // @override
  // //  implement onDeleteGroup
  // Stream get onDeleteGroup => throw UnimplementedError();

  @override
  //  implement onDisconnected
  Stream get onDisconnected => throw UnimplementedError();

  // @override
  // onFailure
  // Stream get onFailure => throw UnimplementedError();

  // @override
  // //  implement onFetchingGroupListCompleted
  // Stream get onFetchingGroupListCompleted => throw UnimplementedError();

  @override
  //  implement onFetchingGroupMembersCompleted
  Stream get onFetchingGroupMembersCompleted => throw UnimplementedError();

  @override
  //  implement onGroupDeletedLocally
  Stream get onGroupDeletedLocally => throw UnimplementedError();

  @override
  //  implement onGroupNotificationMessage
  Stream get onGroupNotificationMessage => throw UnimplementedError();

  @override
  //  implement onGroupProfileFetched
  Stream get onGroupProfileFetched => throw UnimplementedError();

  @override
  //  implement onGroupProfileUpdated
  Stream get onGroupProfileUpdated => throw UnimplementedError();

  @override
  //  implement onGroupTypingStatus
  Stream get onGroupTypingStatus => throw UnimplementedError();

  @override
  //  implement onLeftFromGroup
  Stream get onLeftFromGroup => throw UnimplementedError();

  @override
  //  implement onLocalVideoTrackAdded
  Stream get onLocalVideoTrackAdded => throw UnimplementedError();

  @override
  //  implement onLoggedOut
  Stream get onLoggedOut => throw UnimplementedError();

  @override
  //  implement onMediaStatusUpdated
  Stream get onMediaStatusUpdated => throw UnimplementedError();

  @override
  //  implement onMemberMadeAsAdmin
  Stream get onMemberMadeAsAdmin => throw UnimplementedError();

  @override
  //  implement onMemberRemovedAsAdmin
  Stream get onMemberRemovedAsAdmin => throw UnimplementedError();

  @override
  //  implement onMemberRemovedFromGroup
  Stream get onMemberRemovedFromGroup => throw UnimplementedError();

  @override
  //  implement onMessageReceived
  Stream get onMessageReceived => throw UnimplementedError();

  @override
  //  implement onMessageStatusUpdated
  Stream get onMessageStatusUpdated => throw UnimplementedError();

  @override
  //  implement onMissedCall
  Stream get onMissedCall => throw UnimplementedError();

  @override
  //  implement onMuteStatusUpdated
  Stream get onMuteStatusUpdated => throw UnimplementedError();

  @override
  //  implement onNewGroupCreated
  Stream get onNewGroupCreated => throw UnimplementedError();

  @override
  //  implement onNewMemberAddedToGroup
  Stream get onNewMemberAddedToGroup => throw UnimplementedError();

  // @override
  // //  implement onProgressChanged
  // Stream get onProgressChanged => throw UnimplementedError();

  @override
  //  implement onRemoteVideoTrackAdded
  Stream get onRemoteVideoTrackAdded => throw UnimplementedError();

  // @override
  // //  implement onSuccess
  // Stream get onSuccess => throw UnimplementedError();

  @override
  //  implement onTrackAdded
  Stream get onTrackAdded => throw UnimplementedError();

  @override
  //  implement onUploadDownloadProgressChanged
  Stream get onUploadDownloadProgressChanged => throw UnimplementedError();

  @override
  //  implement onUserSpeaking
  Stream get onUserSpeaking => throw UnimplementedError();

  @override
  //  implement onUserStoppedSpeaking
  Stream get onUserStoppedSpeaking => throw UnimplementedError();

  // @override
  // //  implement onWebChatPasswordChanged
  // Stream get onWebChatPasswordChanged => throw UnimplementedError();

  @override
  Future<String?> openAudioFilePicker() {
    //  implement openAudioFilePicker
    throw UnimplementedError();
  }

  @override
  Future<int?> recentChatPinnedCount() {
    //  implement recentChatPinnedCount
    throw UnimplementedError();
  }

  @override
  Future<void> refreshAndGetAuthToken(
      Function(FlyResponse response)? callback) {
    //  implement refreshAndGetAuthToken
    throw UnimplementedError();
  }

  @override
  Future<void> registerUser(String userIdentifier,
      {String fcmToken = "",
      String userType = "",
      bool isForceRegister = true,
      List<IdentifierMetaData>? identifierMetaData,
      required Function(FlyResponse response) callback}) {
    //  implement registerUser
    throw UnimplementedError();
  }

  /*@override
  removeCustomValue(String messageId, String key) {
    //  implement removeCustomValue
    throw UnimplementedError();
  }*/

  @override
  Future<void> removeGroupProfileImage(
      String jid, Function(FlyResponse response)? callback) {
    //  implement removeGroupProfileImage
    throw UnimplementedError();
  }

  @override
  Future<void> removeMemberFromGroup(String groupjid, String userjid,
      Function(FlyResponse response)? callback) {
    //  implement removeMemberFromGroup
    throw UnimplementedError();
  }

  @override
  Future<void> removeProfileImage(Function(FlyResponse response)? callback) {
    //  implement removeProfileImage
    throw UnimplementedError();
  }

  @override
  Future reportChatOrUser(String jid, String chatType, String? messageId) {
    //  implement reportChatOrUser
    throw UnimplementedError();
  }

  @override
  Future<void> reportUserOrMessages(String jid, String type, String? messageId,
      Function(FlyResponse response)? callback) {
    //  implement reportUserOrMessages
    throw UnimplementedError();
  }

  @override
  Future<bool> requestVideoCallSwitch() {
    //  implement requestVideoCallSwitch
    throw UnimplementedError();
  }

  @override
  Future<void> revokeContactSync(Function(FlyResponse response)? callback) {
    //  implement revokeContactSync
    throw UnimplementedError();
  }

  @override
  Future<bool?> routeAudioTo({required String routeType}) {
    //  implement routeAudioTo
    throw UnimplementedError();
  }

  @override
  saveMediaSettings(
      bool photos, bool videos, bool audio, bool documents, int networkType) {
    //  implement saveMediaSettings
    throw UnimplementedError();
  }

  @override
  saveUnsentMessage(String jid, String message, List<String>? mentionedUsers) {
    //  implement saveUnsentMessage
    throw UnimplementedError();
  }

  @override
  Future<void> searchConversation(String searchKey,
      [String? jidForSearch,
      bool globalSearch = true,
      Function(FlyResponse response)? callback]) {
    //  implement searchConversation
    throw UnimplementedError();
  }

  @override
  Future<String?> selectedAudioDevice() {
    //  implement selectedAudioDevice
    throw UnimplementedError();
  }

  @override
  Future<String> sendAudioMessage(String jid, String filePath, bool isRecorded,
      String duration, String replyMessageId,
      {String? audioFileUrl, String? topicId}) {
    //  implement sendAudioMessage
    throw UnimplementedError();
  }

  @override
  Future<String> sendContactMessage(List<String> contactList, String jid,
      String contactName, String replyMessageId,
      {String? topicId}) {
    //  implement sendContactMessage
    throw UnimplementedError();
  }

  @override
  Future<void> sendContactUsInfo(String title, String description,
      Function(FlyResponse response)? callback) {
    //  implement sendContactUsInfo
    throw UnimplementedError();
  }

  @override
  Future<String> sendDocumentMessage(
      String jid, String documentPath, String replyMessageId,
      {String? fileUrl, String? topicId}) {
    //  implement sendDocumentMessage
    throw UnimplementedError();
  }

  @override
  Future<String> sendImageMessage(
      String jid, String filePath, String? caption, String? replyMessageID,
      {String? imageFileUrl, String? topicId}) {
    //  implement sendImageMessage
    throw UnimplementedError();
  }

  @override
  Future<String> sendLocationMessage(
      String jid, double latitude, double longitude, String replyMessageId,
      {String? topicId}) {
    //  implement sendLocationMessage
    throw UnimplementedError();
  }

  @override
  Future<void> sendMediaFileMessage(
      {required FileMessage messageParams,
      required Function(FlyResponse response) callback}) {
    //  implement sendMediaFileMessage
    throw UnimplementedError();
  }

  @override
  Future<void> sendMessage(
      {required MessageParams messageParams,
      required Function(FlyResponse response) callback}) {
    //  implement sendMessage
    throw UnimplementedError();
  }

  @override
  Future<void> editTextMessage(
      {required EditMessageParams editMessageParams,
      required Function(FlyResponse response) callback}) {
    //  implement editTextMessage
    throw UnimplementedError();
  }

  @override
  Future<void> editMediaCaption(
      {required EditMessageParams editMessageParams,
      required Function(FlyResponse response) callback}) {
    //  implement editMediaCaption
    throw UnimplementedError();
  }

  @override
  Future<String> sendTextMessage(
      String message, String jid, String replyMessageId,
      {String? topicId}) {
    //  implement sendTextMessage
    throw UnimplementedError();
  }

  @override
  sendTypingGoneStatus(String toJid, String chattype) {
    //  implement sendTypingGoneStatus
    throw UnimplementedError();
  }

  @override
  sendTypingStatus(String toJid, String chattype) {
    //  implement sendTypingStatus
    throw UnimplementedError();
  }

  @override
  Future<String> sendVideoMessage(
      String jid, String filePath, String? caption, String? replyMessageID,
      {String? videoFileUrl,
      num? videoDuration,
      String? thumbImageBase64,
      String? topicId}) {
    //  implement sendVideoMessage
    throw UnimplementedError();
  }

  /*@override
  Future<String?> sentFileMessage(String? file, String jid) {
    //  implement sentFileMessage
    throw UnimplementedError();
  }

  @override
  setCustomValue(String messageId, String key, String value) {
    //  implement setCustomValue
    throw UnimplementedError();
  }*/

  @override
  Future setDefaultNotificationSound() {
    //  implement setDefaultNotificationSound
    throw UnimplementedError();
  }

  @override
  setMediaAutoDownload(bool enable) {
    //  implement setMediaAutoDownload
    throw UnimplementedError();
  }

  @override
  setMediaEncryption(bool encryption) {
    //  implement setMediaEncryption
    throw UnimplementedError();
  }

  @override
  setMuteNotification(bool enable) {
    //  implement setMuteNotification
    throw UnimplementedError();
  }

  @override
  Future<void> setMyBusyStatus(
      String busyStatus, Function(FlyResponse response)? callback) {
    //  implement setMyBusyStatus
    throw UnimplementedError();
  }

  @override
  Future<void> setMyProfileStatus(String status, String statusId,
      Function(FlyResponse response)? callback) {
    //  implement setMyProfileStatus
    throw UnimplementedError();
  }

  @override
  setNotificationSound(bool enable) {
    //  implement setNotificationSound
    throw UnimplementedError();
  }

  @override
  setNotificationUri(String uri) {
    //  implement setNotificationUri
    throw UnimplementedError();
  }

  @override
  setNotificationVibration(bool enable) {
    //  implement setNotificationVibration
    throw UnimplementedError();
  }

  @override
  setOnGoingChatUser(String jid) {
    //  implement setOnGoingChatUser
    throw UnimplementedError();
  }

  @override
  Future setRegionCode(String regionCode) {
    //  implement setRegionCode
    throw UnimplementedError();
  }

  @override
  //  implement setTypingStatus
  Stream get setTypingStatus => throw UnimplementedError();

  @override
  setTypingStatusListener() {
    //  implement setTypingStatusListener
    throw UnimplementedError();
  }

  /*@override
  Future<String?> showCustomTones() {
    //  implement showCustomTones
    throw UnimplementedError();
  }*/

  @override
  //  implement showOrUpdateOrCancelNotification
  Stream get showOrUpdateOrCancelNotification => throw UnimplementedError();

  /*@override
  startBackup() {
    //  implement startBackup
    throw UnimplementedError();
  }*/

  @override
  Future switchCamera() {
    //  implement switchCamera
    throw UnimplementedError();
  }

  @override
  Future<bool?> syncCallLogs() {
    //  implement syncCallLogs
    throw UnimplementedError();
  }

  @override
  Future<void> syncContacts(
      bool isfirsttime, Function(FlyResponse response)? callback) {
    //  implement syncContacts
    throw UnimplementedError();
  }

  @override
  Future<void> unFavouriteAllFavouriteMessages(
      Function(FlyResponse response)? callback) {
    //  implement unFavouriteAllFavouriteMessages
    throw UnimplementedError();
  }

  @override
  Future<void> unblockUser(
      String userJID, Function(FlyResponse response)? callback) {
    //  implement unblockUser
    throw UnimplementedError();
  }

  @override
  //  implement unblockedThisUser
  Stream get unblockedThisUser => throw UnimplementedError();

  @override
  Future<bool?> updateArchiveUnArchiveChat(String jid, bool isArchived) {
    //  implement updateArchiveUnArchiveChat
    throw UnimplementedError();
  }

  @override
  Future<void> setChatArchived(
      String jid, bool isArchived, Function(FlyResponse response)? callback) {
    //  implement setChatArchived
    throw UnimplementedError();
  }

  @override
  updateChatMuteStatus(String jid, bool muteStatus) {
    //  implement updateChatMuteStatus
    throw UnimplementedError();
  }

  @override
  Future<void> updateFavouriteStatus(
      String messageID,
      String chatUserJID,
      bool isFavourite,
      String chatType,
      Function(FlyResponse response)? callback) {
    //  implement updateFavouriteStatus
    throw UnimplementedError();
  }

  @override
  Future<void> updateFcmToken(
      String firebasetoken, Function(FlyResponse response)? callback) {
    //  implement updateFcmToken
    throw UnimplementedError();
  }

  @override
  Future<void> updateGroupName(
      String jid, String name, Function(FlyResponse response)? callback) {
    //  implement updateGroupName
    throw UnimplementedError();
  }

  @override
  Future<void> updateGroupProfileImage(
      String jid, String file, Function(FlyResponse response)? callback) {
    //  implement updateGroupProfileImage
    throw UnimplementedError();
  }

  @override
  updateMediaDownloadStatus(String mediaMessageId, int progress,
      int downloadStatus, num dataTransferred) {
    //  implement updateMediaDownloadStatus
    throw UnimplementedError();
  }

  @override
  updateMediaUploadStatus(String mediaMessageId, int progress, int uploadStatus,
      num dataTransferred) {
    //  implement updateMediaUploadStatus
    throw UnimplementedError();
  }

  @override
  Future<void> updateMyProfile(String name, String? email, String? mobile,
      String? status, String? image, Function(FlyResponse response) callback) {
    //  implement updateMyProfile
    throw UnimplementedError();
  }

  @override
  Future<void> updateMyProfileImage(
      String image, Function(FlyResponse response) callback) {
    //  implement updateMyProfileImage
    throw UnimplementedError();
  }

  @override
  updateRecentChatPinStatus(String jid, bool pinStatus) {
    //  implement updateRecentChatPinStatus
    throw UnimplementedError();
  }

  @override
  Future<bool?> uploadMedia(String messageid) {
    //  implement uploadMedia
    throw UnimplementedError();
  }

  @override
  //  implement userBlockedMe
  Stream get userBlockedMe => throw UnimplementedError();

  @override
  //  implement userCameOnline
  Stream get userCameOnline => throw UnimplementedError();

  @override
  //  implement userDeletedHisProfile
  Stream get userDeletedHisProfile => throw UnimplementedError();

  @override
  //  implement userProfileFetched
  Stream get userProfileFetched => throw UnimplementedError();

  @override
  //  implement userUnBlockedMe
  Stream get userUnBlockedMe => throw UnimplementedError();

  @override
  //  implement userUpdatedHisProfile
  Stream get userUpdatedHisProfile => throw UnimplementedError();

  @override
  //  implement userWentOffline
  Stream get userWentOffline => throw UnimplementedError();

  @override
  //  implement usersIBlockedListFetched
  Stream get usersIBlockedListFetched => throw UnimplementedError();

  @override
  //  implement usersProfilesFetched
  Stream get usersProfilesFetched => throw UnimplementedError();

  @override
  //  implement usersWhoBlockedMeListFetched
  Stream get usersWhoBlockedMeListFetched => throw UnimplementedError();

  @override
  Future<String?> verifyToken(String userName, String token) {
    //  implement verifyToken
    throw UnimplementedError();
  }

  /*@override
  Future<bool?> webLoginDetailsCleared() {
    //  implement webLoginDetailsCleared
    throw UnimplementedError();
  }*/

  @override
  setMessageEventListener(MessageEventListeners? messageEventListeners) {
    // implement setMessageEventListener
    throw UnimplementedError();
  }

  @override
  setConnectionEventListener(
      ConnectionEventListeners? connectionEventListeners) {
    // implement setConnectionEventListener
    throw UnimplementedError();
  }

  @override
  setProfileEventsListener(ProfileEventListeners? profileEventListeners) {
    // implement setProfileEventsListener
    throw UnimplementedError();
  }

  @override
  setGroupEventsListener(GroupEventListeners? groupEventListeners) {
    // implement setGroupEventsListener
    throw UnimplementedError();
  }

  @override
  setCallEventListener(CallEventListeners? callEventListeners) {
    // implement setCallEventListener
    throw UnimplementedError();
  }

  @override
  // implement onMessageEdited
  Stream get onMessageEdited => throw UnimplementedError();

  @override
  Future<void> getMetaData(Function(FlyResponse response)? callback) {
    //  implement getMetaData
    throw UnimplementedError();
  }

  @override
  Future<void> updateMetaData(List<IdentifierMetaData>? identifierMetaData,
      Function(FlyResponse response)? callback) {
    //  implement getMetaData
    throw UnimplementedError();
  }

  @override
  void setCallLinkEventListener(CallLinkEventListeners callLinkEventsListener) {
    throw UnimplementedError();
  }

  @override
  Future<void> createMeetLink(Function(FlyResponse response)? callback) {
    throw UnimplementedError();
  }

  @override
  Future<void> disposePreview() {
    throw UnimplementedError();
  }

  @override
  Future<String> getCallLink() {
    throw UnimplementedError();
  }

  @override
  Future<String> getMeetUsername(String jid) {
    throw UnimplementedError();
  }

  @override
  Future<void> initializeMeet(String callLink, String userName,
      Function(FlyResponse response)? callback) {
    throw UnimplementedError();
  }

  @override
  Future<void> joinCall(Function(FlyResponse response)? callback) {
    throw UnimplementedError();
  }

  @override
  Future<void> startVideoCapture(Function(FlyResponse response)? callback) {
    throw UnimplementedError();
  }

  @override
  Stream get onSubscribeSuccess => throw UnimplementedError();

  @override
  Stream get onError => throw UnimplementedError();

  @override
  Stream get onUsersUpdated => throw UnimplementedError();

  @override
  Future<bool> isLockScreen() {
    // implement isLockScreen
    throw UnimplementedError();
  }

  @override
  Future<String?> getUnsentMessageOf(String jid) {
    throw UnimplementedError();
  }

  @override
  bool get isSDKInitialized => throw UnimplementedError();

  @override
  Future<void> startBackup(bool enableEncryption) {
    // implement startBackup
    throw UnimplementedError();
  }

  @override
  Future<void> restoreBackup({required String backupPath}) {
    // implement restoreBackup
    throw UnimplementedError();
  }

  @override
  Future<void> cancelBackup() {
    // implement cancelBackup
    throw UnimplementedError();
  }

  @override
  Future<void> cancelRestore() {
    // implement cancelRestore
    throw UnimplementedError();
  }

  @override
  Future<String> getCurrentCameraPosition() {
    // implement getCurrentCameraPosition
    throw UnimplementedError();
  }

  @override
  // implement onBackupFailure
  Stream get onBackupFailure => throw UnimplementedError();

  @override
  // implement onBackupProgressChanged
  Stream get onBackupProgressChanged => throw UnimplementedError();

  @override
  // implement onBackupSuccess
  Stream get onBackupSuccess => throw UnimplementedError();

  @override
  // implement onRestoreFailure
  Stream get onRestoreFailure => throw UnimplementedError();

  @override
  // implement onRestoreProgressChanged
  Stream get onRestoreProgressChanged => throw UnimplementedError();

  @override
  // implement onRestoreSuccess
  Stream get onRestoreSuccess => throw UnimplementedError();

  @override
  // implement onChatCleared
  Stream get onChatCleared => throw UnimplementedError();

  @override
  // implement onMessageDeleted
  Stream get onMessageDeleted => throw UnimplementedError();

  @override
  // implement onAllChatsCleared
  Stream get onAllChatsCleared => throw UnimplementedError();

  @override
  // implement onUpdateFavourites
  Stream get onUpdateFavourites => throw UnimplementedError();

  @override
  // implement onWebLogout
  Stream get onWebLogout => throw UnimplementedError();

  @override
  // implement onChatMuteStatusUpdated
  Stream get onChatMuteStatusUpdated => throw UnimplementedError();

  @override
  // implement onUpdateMuteSettings
  Stream get onUpdateMuteSettings => throw UnimplementedError();

  @override
  // implement onArchiveUnArchiveChats
  Stream get onArchiveUnArchiveChats => throw UnimplementedError();

  @override
  // implement onArchiveUnArchiveChats
  Stream get onArchivedSettingsUpdated => throw UnimplementedError();

  @override
  // implement onSuperAdminDeleteGroup
  Stream get onSuperAdminDeleteGroup => throw UnimplementedError();

  @override
  Future getWebLoginDetails() {
    throw UnimplementedError();
  }

  @override
  Future<void> loginWebChatViaQRCode(
      String barcode, Function(FlyResponse response)? callback) {
    throw UnimplementedError();
  }

  @override
  Future<bool?> logoutWebUser() {
    throw UnimplementedError();
  }

  @override
  // implement onReconnecting
  Stream get onReconnecting => throw UnimplementedError();

  @override
  Future<bool?> webLoginDetailsCleared() {
    // implement webLoginDetailsCleared
    throw UnimplementedError();
  }

  @override
  updateChatMuteStatusList(List<String> jidList, bool muteStatus) {
    // implement updateChatMuteStatusList
    throw UnimplementedError();
  }

  @override
  Future<void> setTranslations({required String fileName,
    required Function(FlyResponse response) callback}) {
    throw UnimplementedError();
  }

  /* @override
  Future<bool?> webLoginDetailsCleared() {
    throw UnimplementedError();
  }*/
}

void main() {
  final FlyChatFlutterPlatform initialPlatform =
      FlyChatFlutterPlatform.instance;

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
