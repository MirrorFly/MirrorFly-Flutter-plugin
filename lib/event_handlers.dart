

import 'model/chat_message_model.dart';

abstract class MessageEventsListener {

  void onMessageReceived(ChatMessageModel chatMessage);
  void onMessageStatusUpdated(ChatMessageModel chatMessage);
  void onMediaStatusUpdated(ChatMessageModel mediaMessage);
  void onUploadDownloadProgressChanged(String messageId, int progressPercentage);
  void showOrUpdateOrCancelNotification(String jid, ChatMessageModel chatMessageModel);
  void setTypingStatus(setTypingStatus);
  void onAvailableFeaturesUpdated(onAvailableFeaturesUpdated);
  void userCameOnline(userCameOnline);
  void userWentOffline(userWentOffline);

}

abstract class ConnectionEventsListener{
  void onConnected(onConnected);
  void onDisconnected(onDisconnected);
  void onConnectionFailed(onConnectionFailed);
  void onLoggedOut(onLoggedOut);
}

abstract class ProfileEventsListener{
  void usersProfilesFetched(usersProfilesFetched);
  void userBlockedMe(userBlockedMe);
  void userUnBlockedMe(userUnBlockedMe);
  void userUpdatedHisProfile(userUpdatedHisProfile);
  void userDeletedHisProfile(userDeletedHisProfile);
  void myProfileUpdated(myProfileUpdated);
  void usersWhoBlockedMeListFetched(usersWhoBlockedMeListFetched);
  void usersIBlockedListFetched(usersIBlockedListFetched);
  void userProfileFetched(userProfileFetched);
  void blockedThisUser(blockedThisUser);
  void unblockedThisUser(unblockedThisUser);
  void onContactSyncComplete(onContactSyncComplete);
  void onAdminBlockedOtherUser(onAdminBlockedOtherUser);
  void onAdminBlockedUser(onAdminBlockedUser);
}

abstract class GroupEventsListener{
  void onGroupDeletedLocally(onGroupDeletedLocally);
  void onNewMemberAddedToGroup(String groupJid, String newMemberJid, String addedByMemberJid);
  void onMemberRemovedFromGroup(String groupJid, String removedMemberJid, String removedByMemberJid);
  void onFetchingGroupMembersCompleted(String groupJid);
  void onDeleteGroup(onDeleteGroup);
  void onFetchingGroupListCompleted(onFetchingGroupListCompleted);
  void onMemberMadeAsAdmin(onMemberMadeAsAdmin);
  void onMemberRemovedAsAdmin(onMemberRemovedAsAdmin);
  void onLeftFromGroup(onLeftFromGroup);
  void onGroupNotificationMessage(onGroupNotificationMessage);
  void onGroupProfileUpdated(String groupJid);
  void onGroupProfileFetched(String groupJid);
  void onNewGroupCreated(String groupJid);
}

abstract class CallEventsListener{
  void onMessageStatusUpdated(dynamic status);
  void onCallLogsUpdated(onCallLogsUpdated);
  void onCallLogsDeleted(onCallLogsDeleted);
  void onMissedCall(onMissedCall);
  void onLocalVideoTrackAdded(onLocalVideoTrackAdded);
  void onRemoteVideoTrackAdded(onRemoteVideoTrackAdded);
  void onTrackAdded(onTrackAdded);
  void onCallStatusUpdated(onCallStatusUpdated);
  void onCallAction(onCallAction);
  void onMuteStatusUpdated(onMuteStatusUpdated);
  void onUserSpeaking(onUserSpeaking);
  void onUserStoppedSpeaking(onUserStoppedSpeaking);
}
