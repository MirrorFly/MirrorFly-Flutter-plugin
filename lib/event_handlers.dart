

import 'package:mirrorfly_plugin/model/available_features.dart';

import 'model/chat_message_model.dart';
import 'model/profile_model.dart';

abstract class MessageEventListeners {
  void onMessageReceived(ChatMessageModel chatMessage);
  void onMessageStatusUpdated(ChatMessageModel chatMessage);
  void onMediaStatusUpdated(ChatMessageModel mediaMessage);
  void onUploadDownloadProgressChanged(String messageId, int progressPercentage);
  void showOrUpdateOrCancelNotification(String jid, ChatMessageModel chatMessageModel);
  void setTypingStatus(String singleOrGroupJid, String userJid, String status);
  void onAvailableFeaturesUpdated(AvailableFeatures availableFeatures);
  void userCameOnline(String jid);
  void userWentOffline(String jid);
}

abstract class ConnectionEventListeners{
  void onConnected();
  void onDisconnected();
  void onConnectionFailed(String connectionError);
  void onLoggedOut();
}

abstract class ProfileEventListeners{
  void usersProfilesFetched();
  void userBlockedMe(String jid);
  void userUnBlockedMe(String jid);
  void userUpdatedHisProfile(String jid);
  void userDeletedHisProfile(String jid);
  void myProfileUpdated();
  void usersWhoBlockedMeListFetched(String jidList);
  void usersIBlockedListFetched(List<String> jidList);
  void userProfileFetched(String jid, ProfileData profileData);
  void blockedThisUser(String userJid);
  void unblockedThisUser(String jid);
  void onContactSyncComplete(bool isSuccess);
  void onAdminBlockedOtherUser(String jid, String chatType, String isBlocked);
  void onAdminBlockedUser(String jid, String isBlocked);
}

abstract class GroupEventListeners{
  void onGroupDeletedLocally(String groupJid);
  void onNewMemberAddedToGroup(String groupJid, String newMemberJid, String addedByMemberJid);
  void onMemberRemovedFromGroup(String groupJid, String removedMemberJid, String removedByMemberJid);
  void onFetchingGroupMembersCompleted(String groupJid);
  void onMemberMadeAsAdmin(String groupJid, String newAdminMemberJid, String madeByMemberJid);
  void onMemberRemovedAsAdmin(String groupJid, String removedAdminMemberJid, String removedByMemberJid);
  void onLeftFromGroup(String groupJid, String leftUserJid);
  void onGroupNotificationMessage(ChatMessageModel groupNotificationMessage);
  void onGroupProfileUpdated(String groupJid);
  void onGroupProfileFetched(String groupJid);
  void onNewGroupCreated(String groupJid);
}

abstract class CallEventListeners{
  void onCallLogsUpdated();
  void onCallLogDeleted(String callLogId);
  void onCallLogsCleared();
  void onMissedCall(String userJid, String groupId, bool isOneToOneCall, String callType, List<String> userList);
  void onLocalVideoTrackAdded(String userJid);
  void onRemoteVideoTrackAdded(String userJid);
  void onTrackAdded(String userJid);
  void onCallStatusUpdated(String userJid, String callMode, String callType, String callStatus);
  void onCallAction(String userJid, String callMode, String callType, String callAction);
  void onMuteStatusUpdated(String userJid, String muteEvent);
  void onUserSpeaking(String userJid, String audioLevel);
  void onUserStoppedSpeaking(String userJid);
}
