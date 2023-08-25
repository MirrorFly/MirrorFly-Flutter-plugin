package com.mirrorfly.mirrorfly_plugin

object Constants {
    const val EMPTY_STRING = ""
    const val LOCAL_PATH = "UI Kit"
    const val FILE_LOCAL_PATH = "File"
    const val MSG_SENT_PATH = "Sent"
    const val TEMP_FILE_NAME = "temp_file"
    const val AUDIO_FILE = "audio/*"

    const val FROM_GALLERY = 2
    const val mirrorflyMethodChannel = "contus.mirrorfly/flyChat"
    const val onMessageReceivedChannel = "contus.mirrorfly/onMessageReceived"
    const val onMessageStatusUpdatedChannel = "contus.mirrorfly/onMessageStatusUpdated"
    const val onMediaStatusUpdatedChannel = "contus.mirrorfly/onMediaStatusUpdated"
    const val onUploadDownloadProgressChangedChannel =
        "contus.mirrorfly/onUploadDownloadProgressChanged"
    const val showUpdateCancelNotificationChannel =
        "contus.mirrorfly/showOrUpdateOrCancelNotification"

    const val onGroupProfileFetchedChannel = "contus.mirrorfly/onGroupProfileFetched"
    const val onNewGroupCreatedChannel = "contus.mirrorfly/onNewGroupCreated"
    const val onGroupProfileUpdatedChannel = "contus.mirrorfly/onGroupProfileUpdated"
    const val onNewMemberAddedToGroupChannel = "contus.mirrorfly/onNewMemberAddedToGroup"
    const val onMemberRemovedFromGroupChannel = "contus.mirrorfly/onMemberRemovedFromGroup"
    const val onFetchingGroupMembersCompletedChannel =
        "contus.mirrorfly/onFetchingGroupMembersCompleted"
    const val onDeleteGroupChannel = "contus.mirrorfly/onDeleteGroup"
    const val onFetchingGroupListCompletedChannel =
        "contus.mirrorfly/onFetchingGroupListCompleted"
    const val onMemberMadeAsAdminChannel = "contus.mirrorfly/onMemberMadeAsAdmin"
    const val onMemberRemovedAsAdminChannel = "contus.mirrorfly/onMemberRemovedAsAdmin"
    const val onLeftFromGroupChannel = "contus.mirrorfly/onLeftFromGroup"
    const val onGroupNotificationMessageChannel = "contus.mirrorfly/onGroupNotificationMessage"
    const val onGroupDeletedLocallyChannel = "contus.mirrorfly/onGroupDeletedLocally"

    const val blockedThisUserChannel = "contus.mirrorfly/blockedThisUser"
    const val myProfileUpdatedChannel = "contus.mirrorfly/myProfileUpdated"
    const val onAdminBlockedOtherUserChannel = "contus.mirrorfly/onAdminBlockedOtherUser"
    const val onAdminBlockedUserChannel = "contus.mirrorfly/onAdminBlockedUser"
    const val onContactSyncCompleteChannel = "contus.mirrorfly/onContactSyncComplete"
    const val onLoggedOutChannel = "contus.mirrorfly/onLoggedOut"
    const val unblockedThisUserChannel = "contus.mirrorfly/unblockedThisUser"
    const val userBlockedMeChannel = "contus.mirrorfly/userBlockedMe"
    const val userCameOnlineChannel = "contus.mirrorfly/userCameOnline"
    const val userDeletedHisProfileChannel = "contus.mirrorfly/userDeletedHisProfile"
    const val userProfileFetchedChannel = "contus.mirrorfly/userProfileFetched"
    const val userUnBlockedMeChannel = "contus.mirrorfly/userUnBlockedMe"
    const val userUpdatedHisProfileChannel = "contus.mirrorfly/userUpdatedHisProfile"
    const val userWentOfflineChannel = "contus.mirrorfly/userWentOffline"
    const val usersIBlockedListFetchedChannel = "contus.mirrorfly/usersIBlockedListFetched"
    const val usersProfilesFetchedChannel = "contus.mirrorfly/usersProfilesFetched"
    const val usersWhoBlockedMeListFetchedChannel =
        "contus.mirrorfly/usersWhoBlockedMeListFetched"
    const val onConnectedChannel = "contus.mirrorfly/onConnected"
    const val onDisconnectedChannel = "contus.mirrorfly/onDisconnected"

    //  const val onConnectionNotAuthorized_channel = "contus.mirrorfly/onConnectionNotAuthorized"
    const val onConnectionFailedChannel = "contus.mirrorfly/onConnectionFailed"
    const val connectionFailedChannel = "contus.mirrorfly/connectionFailed"
    const val connectionSuccessChannel = "contus.mirrorfly/connectionSuccess"
    const val onWebChatPasswordChangedChannel = "contus.mirrorfly/onWebChatPasswordChanged"
    const val setTypingStatusChannel = "contus.mirrorfly/setTypingStatus"
    const val onChatTypingStatusChannel = "contus.mirrorfly/onChatTypingStatus"
    const val onGroupTypingStatusChannel = "contus.mirrorfly/onGroupTypingStatus"
    const val onFailureChannel = "contus.mirrorfly/onFailure"
    val onProgressChangedChannel = "contus.mirrorfly/onProgressChanged"
    const val onSuccessChannel = "contus.mirrorfly/onSuccess"
    //call Method channel constants
    private const val domain = "contus.mirrorfly"
    const val callMethodChannel = "$domain/flyCall"
//    const val onCallReceiving = "$domain/onCallReceiving"
    const val onLocalVideoTrackAdded = "$domain/onLocalVideoTrackAdded"
    const val onRemoteVideoTrackAdded = "$domain/onRemoteVideoTrackAdded"
    const val onTrackAdded = "$domain/onTrackAdded"
    const val onCallStatusUpdated = "$domain/onCallStatusUpdated"
    const val onCallAction = "$domain/onCallAction"
    const val onMuteStatusUpdated = "$domain/onMuteStatusUpdated"
    const val onUserSpeaking = "$domain/onUserSpeaking"
    const val onUserStoppedSpeaking = "$domain/onUserStoppedSpeaking"
    const val onMissedCall = "$domain/onMissedCall"

    const val ACTION_CALL_INCOMING =
        "com.mirrorfly.mirrorfly_plugin.ACTION_CALL_INCOMING"
    const val ACTION_CALL_START = "com.mirrorfly.mirrorfly_plugin.ACTION_CALL_START"
    const val ACTION_CALL_ACCEPT =
        "com.mirrorfly.mirrorfly_plugin.ACTION_CALL_ACCEPT"
    const val ACTION_CALL_DECLINE =
        "com.mirrorfly.mirrorfly_plugin.ACTION_CALL_DECLINE"
    const val ACTION_CALL_ENDED =
        "com.mirrorfly.mirrorfly_plugin.ACTION_CALL_ENDED"
    const val ACTION_CALL_TOGGLE_MUTE =
        "com.mirrorfly.mirrorfly_plugin.ACTION_CALL_TOGGLE_MUTE"
    const val ACTION_CALL_TOGGLE_HOLD =
        "com.mirrorfly.mirrorfly_plugin.ACTION_CALL_TOGGLE_HOLD"
    const val ACTION_CALL_TIMEOUT =
        "com.mirrorfly.mirrorfly_plugin.ACTION_CALL_TIMEOUT"
    const val ACTION_CALL_CALLBACK =
        "com.mirrorfly.mirrorfly_plugin.ACTION_CALL_CALLBACK"
    const val ACTION_CALL_CUSTOM =
        "com.mirrorfly.mirrorfly_plugin.ACTION_CALL_CUSTOM"


    const val EXTRA_CALLKIT_INCOMING_DATA = "EXTRA_CALLKIT_INCOMING_DATA"

    const val EXTRA_CALLKIT_ID = "EXTRA_CALLKIT_ID"
    const val EXTRA_CALLKIT_NAME_CALLER = "EXTRA_CALLKIT_NAME_CALLER"
    const val EXTRA_CALLKIT_APP_NAME = "EXTRA_CALLKIT_APP_NAME"
    const val EXTRA_CALLKIT_HANDLE = "EXTRA_CALLKIT_HANDLE"
    const val EXTRA_CALLKIT_TYPE = "EXTRA_CALLKIT_TYPE"
    const val EXTRA_CALLKIT_AVATAR = "EXTRA_CALLKIT_AVATAR"
    const val EXTRA_CALLKIT_DURATION = "EXTRA_CALLKIT_DURATION"
    const val EXTRA_CALLKIT_TEXT_ACCEPT = "EXTRA_CALLKIT_TEXT_ACCEPT"
    const val EXTRA_CALLKIT_TEXT_DECLINE = "EXTRA_CALLKIT_TEXT_DECLINE"

    const val EXTRA_CALLKIT_MISSED_CALL_ID = "EXTRA_CALLKIT_MISSED_CALL_ID"
    const val EXTRA_CALLKIT_MISSED_CALL_SHOW = "EXTRA_CALLKIT_MISSED_CALL_SHOW"
    const val EXTRA_CALLKIT_MISSED_CALL_COUNT = "EXTRA_CALLKIT_MISSED_CALL_COUNT"
    const val EXTRA_CALLKIT_MISSED_CALL_SUBTITLE = "EXTRA_CALLKIT_MISSED_CALL_SUBTITLE"
    const val EXTRA_CALLKIT_MISSED_CALL_CALLBACK_SHOW = "EXTRA_CALLKIT_MISSED_CALL_CALLBACK_SHOW"
    const val EXTRA_CALLKIT_MISSED_CALL_CALLBACK_TEXT =
        "EXTRA_CALLKIT_MISSED_CALL_CALLBACK_TEXT"

    const val EXTRA_CALLKIT_EXTRA = "EXTRA_CALLKIT_EXTRA"
    const val EXTRA_CALLKIT_HEADERS = "EXTRA_CALLKIT_HEADERS"
    const val EXTRA_CALLKIT_IS_CUSTOM_NOTIFICATION = "EXTRA_CALLKIT_IS_CUSTOM_NOTIFICATION"
    const val EXTRA_CALLKIT_IS_CUSTOM_SMALL_EX_NOTIFICATION =
        "EXTRA_CALLKIT_IS_CUSTOM_SMALL_EX_NOTIFICATION"
    const val EXTRA_CALLKIT_IS_SHOW_LOGO = "EXTRA_CALLKIT_IS_SHOW_LOGO"
    const val EXTRA_CALLKIT_RINGTONE_PATH = "EXTRA_CALLKIT_RINGTONE_PATH"
    const val EXTRA_CALLKIT_BACKGROUND_COLOR = "EXTRA_CALLKIT_BACKGROUND_COLOR"
    const val EXTRA_CALLKIT_BACKGROUND_URL = "EXTRA_CALLKIT_BACKGROUND_URL"
    const val EXTRA_CALLKIT_ACTION_COLOR = "EXTRA_CALLKIT_ACTION_COLOR"
    const val EXTRA_CALLKIT_INCOMING_CALL_NOTIFICATION_CHANNEL_NAME =
        "EXTRA_CALLKIT_INCOMING_CALL_NOTIFICATION_CHANNEL_NAME"
    const val EXTRA_CALLKIT_MISSED_CALL_NOTIFICATION_CHANNEL_NAME =
        "EXTRA_CALLKIT_MISSED_CALL_NOTIFICATION_CHANNEL_NAME"

    const val EXTRA_CALLKIT_ACTION_FROM = "EXTRA_CALLKIT_ACTION_FROM"
}