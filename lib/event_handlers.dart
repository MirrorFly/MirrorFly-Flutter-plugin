

abstract class MessageEventsListener {

  void onMessageReceived(String message);
  void onMessageStatusUpdated(dynamic status);

  void onMediaStatusUpdated(onMediaStatusUpdated);

  void onUploadDownloadProgressChanged(onUploadDownloadProgressChanged);

  void showOrUpdateOrCancelNotification(showOrUpdateOrCancelNotification);

  void setTypingStatus(setTypingStatus);

  void onAvailableFeaturesUpdated(onAvailableFeaturesUpdated);

  void userCameOnline(userCameOnline);
  void userWentOffline(userWentOffline);

}

abstract class ConnectionEventListener{
  void onConnected(onConnected);

  void onDisconnected(onDisconnected);

  void onConnectionFailed(onConnectionFailed);

  void onLoggedOut(onLoggedOut);
}

abstract class ProfileEventListener{
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

abstract class GroupEventListener{
  void onGroupDeletedLocally(onGroupDeletedLocally);
  void onNewMemberAddedToGroup(onNewMemberAddedToGroup);

  void onMemberRemovedFromGroup(onMemberRemovedFromGroup);

  void onFetchingGroupMembersCompleted(onFetchingGroupMembersCompleted);

  void onDeleteGroup(onDeleteGroup);

  void onFetchingGroupListCompleted(onFetchingGroupListCompleted);

  void onMemberMadeAsAdmin(onMemberMadeAsAdmin);

  void onMemberRemovedAsAdmin(onMemberRemovedAsAdmin);

  void onLeftFromGroup(onLeftFromGroup);

  void onGroupNotificationMessage(onGroupNotificationMessage);
  void onGroupProfileUpdated(onGroupProfileUpdated);

  void onGroupProfileFetched(onGroupProfileFetched);

  void onNewGroupCreated(onNewGroupCreated);
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
