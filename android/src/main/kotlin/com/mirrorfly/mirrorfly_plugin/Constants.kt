package com.mirrorfly.mirrorfly_plugin

import java.util.regex.Pattern

object Constants {
    //    const val TAG = "FlyChatMethods"
    const val IS_CALL_NOTIFICATION = "IS_CALL_NOTIFICATION"
    const val IS_CHAT_NOTIFICATION = "IS_CHAT_NOTIFICATION"
    const val JID = "JID"
    const val EMPTY_STRING = ""
    const val LOCAL_PATH = "UI Kit"
    const val FILE_LOCAL_PATH = "File"
    const val MSG_SENT_PATH = "Sent"
    const val TEMP_FILE_NAME = "temp_file"
    const val AUDIO_FILE = "audio/*"

    const val YOU = "You"
    const val MAX_NAME_LENGTH: Int = 26
    const val STORAGE = "/storage/emulated/"
    const val regex1 =
        "^[\\s\n\r]*(?:(?:[\u00a9\u00ae\u203c\u2049\u2122\u2139\u2194-\u2199\u21a9-\u21aa\u231a-\u231b\u2328\u23cf\u23e9-\u23f3\u23f8-" +
                "\u23fa\u24c2\u25aa-\u25ab\u25b6\u25c0\u25fb-\u25fe\u2600-\u2604\u260e\u2611\u2614-\u2615\u2618\u261d\u2620\u2622-\u2623\u2626\u262a\u262e-\u262f\u2638-\u263a\u2648-" +
                "\u2653\u2660\u2663\u2665-\u2666\u2668\u267b\u267f\u2692-\u2694\u2696-\u2697\u2699\u269b-\u269c\u26a0-\u26a1\u26aa-\u26ab\u26b0-\u26b1\u26bd-\u26be\u26c4-" +
                "\u26c5\u26c8\u26ce-\u26cf\u26d1\u26d3-\u26d4\u26e9-\u26ea\u26f0-\u26f5\u26f7-\u26fa\u26fd\u2702\u2705\u2708-\u270d\u270f\u2712\u2714\u2716\u271d\u2721\u2728\u2733-" +
                "\u2734\u2744\u2747\u274c\u274e\u2753-\u2755\u2757\u2763-\u2764\u2795-\u2797\u27a1\u27b0\u27bf\u2934-\u2935\u2b05-\u2b07\u2b1b-" +
                "\u2b1c\u2b50\u2b55\u3030\u303d\u3297\u3299\ud83c\udc04\ud83c\udccf\ud83c\udd70-\ud83c\udd71\ud83c\udd7e-\ud83c\udd7f\ud83c\udd8e\ud83c\udd91-\ud83c\udd9a\ud83c\ude01-" +
                "\ud83c\ude02\ud83c\ude1a\ud83c\ude2f\ud83c\ude32-\ud83c\ude3a\ud83c\ude50-\ud83c\ude51\u200d\ud83c\udf00-\ud83d\uddff\ud83d\ude00-\ud83d\ude4f\ud83d\ude80-" +
                "\ud83d\udeff\ud83e\udd00-\ud83e\uddff\udb40\udc20-\udb40\udc7f]|\u200d[\u2640\u2642]|[\ud83c\udde6-\ud83c\uddff]{2}|"
    val emojiPattern: Pattern = Pattern.compile("$regex1.[\u20e0\u20e3\ufe0f]+)+[\\s\n\r]*)+$")

    const val FROM_GALLERY = 2
    const val mirrorflyView = "mirrorfly_view"
    const val Domain = "contus.mirrorfly"
    const val MirrorflyMethodChannel = "$Domain/flyChat"
    const val onMessageReceivedChannel = "$Domain/onMessageReceived"
    const val onMessageStatusUpdatedChannel = "$Domain/onMessageStatusUpdated"
    const val onMediaStatusUpdatedChannel = "$Domain/onMediaStatusUpdated"
    const val onUploadDownloadProgressChangedChannel =
        "$Domain/onUploadDownloadProgressChanged"
    const val showUpdateCancelNotificationChannel =
        "$Domain/showOrUpdateOrCancelNotification"

    const val onGroupProfileFetchedChannel = "$Domain/onGroupProfileFetched"
    const val onNewGroupCreatedChannel = "$Domain/onNewGroupCreated"
    const val onGroupProfileUpdatedChannel = "$Domain/onGroupProfileUpdated"
    const val onNewMemberAddedToGroupChannel = "$Domain/onNewMemberAddedToGroup"
    const val onMemberRemovedFromGroupChannel = "$Domain/onMemberRemovedFromGroup"
    const val onFetchingGroupMembersCompletedChannel =
        "$Domain/onFetchingGroupMembersCompleted"
    const val onDeleteGroupChannel = "$Domain/onDeleteGroup"
    const val onFetchingGroupListCompletedChannel =
        "$Domain/onFetchingGroupListCompleted"
    const val onMemberMadeAsAdminChannel = "$Domain/onMemberMadeAsAdmin"
    const val onMemberRemovedAsAdminChannel = "$Domain/onMemberRemovedAsAdmin"
    const val onLeftFromGroupChannel = "$Domain/onLeftFromGroup"
    const val onGroupNotificationMessageChannel = "$Domain/onGroupNotificationMessage"
    const val onGroupDeletedLocallyChannel = "$Domain/onGroupDeletedLocally"

    const val blockedThisUserChannel = "$Domain/blockedThisUser"
    const val myProfileUpdatedChannel = "$Domain/myProfileUpdated"
    const val onAdminBlockedOtherUserChannel = "$Domain/onAdminBlockedOtherUser"
    const val onAdminBlockedUserChannel = "$Domain/onAdminBlockedUser"
    const val onContactSyncCompleteChannel = "$Domain/onContactSyncComplete"
    const val onLoggedOutChannel = "$Domain/onLoggedOut"
    const val unblockedThisUserChannel = "$Domain/unblockedThisUser"
    const val userBlockedMeChannel = "$Domain/userBlockedMe"
    const val userCameOnlineChannel = "$Domain/userCameOnline"
    const val userDeletedHisProfileChannel = "$Domain/userDeletedHisProfile"
    const val userProfileFetchedChannel = "$Domain/userProfileFetched"
    const val userUnBlockedMeChannel = "$Domain/userUnBlockedMe"
    const val userUpdatedHisProfileChannel = "$Domain/userUpdatedHisProfile"
    const val userWentOfflineChannel = "$Domain/userWentOffline"
    const val usersIBlockedListFetchedChannel = "$Domain/usersIBlockedListFetched"
    const val usersProfilesFetchedChannel = "$Domain/usersProfilesFetched"
    const val usersWhoBlockedMeListFetchedChannel =
        "$Domain/usersWhoBlockedMeListFetched"
    const val onConnectedChannel = "$Domain/onConnected"
    const val onDisconnectedChannel = "$Domain/onDisconnected"
    const val onReconnectingChannel = "$Domain/onConnectionReconnecting"

    //  const val onConnectionNotAuthorized_channel = "$domain/onConnectionNotAuthorized"
    const val onConnectionFailedChannel = "$Domain/onConnectionFailed"
    const val connectionFailedChannel = "$Domain/connectionFailed"
    const val connectionSuccessChannel = "$Domain/connectionSuccess"
//    const val onWebChatPasswordChangedChannel = "$Domain/onWebChatPasswordChanged"
    const val setTypingStatusChannel = "$Domain/setTypingStatus"
    const val onChatTypingStatusChannel = "$Domain/onChatTypingStatus"
    const val onGroupTypingStatusChannel = "$Domain/onGroupTypingStatus"
    const val onBackupFailureChannel = "$Domain/onBackupFailure"
    const val onBackupProgressChangedChannel = "$Domain/onBackupProgressChanged"
    const val onBackupSuccessChannel = "$Domain/onBackupSuccess"
    const val onRestoreFailureChannel = "$Domain/onRestoreFailure"
    const val onRestoreProgressChangedChannel = "$Domain/onRestoreProgressChanged"
    const val onRestoreSuccessChannel = "$Domain/onRestoreSuccess"
    const val onAvailableFeaturesUpdatedChannel = "$Domain/onAvailableFeaturesUpdated"
    const val onMessageEditedChannel = "$Domain/onMessageEdited"

    const val onMessagesClearedChannel = "$Domain/onMessagesCleared"
    const val onMessagesClearedOrDeletedChannel = "$Domain/onMessagesClearedOrDeleted"
    const val onUpdateFavouriteChannel = "$Domain/onUpdateFavourites"
    const val onClearAllConversationChannel = "$Domain/onClearAllConversation"

    const val onWebLogoutChannel = "$Domain/onWebLogout"
    const val onChatMuteStatusUpdatedChannel = "$Domain/onChatMuteStatusUpdated"
    const val didUpdateMuteSettingsChannel = "$Domain/didUpdateMuteSettings"
    const val updateArchiveUnArchiveChatsChannel = "$Domain/updateArchiveUnArchiveChats"
    const val updateArchivedSettingsChannel = "$Domain/updateArchivedSettings"



    //call Method channel constants
    const val callMethodChannel = "$Domain/flyCall"

    //    const val onCallReceiving = "$domain/onCallReceiving"
    const val onLocalVideoTrackAdded = "$Domain/onLocalVideoTrackAdded"
    const val onRemoteVideoTrackAdded = "$Domain/onRemoteVideoTrackAdded"
    const val onTrackAdded = "$Domain/onTrackAdded"
    const val onCallStatusUpdated = "$Domain/onCallStatusUpdated"
    const val onCallAction = "$Domain/onCallAction"
    const val onMuteStatusUpdated = "$Domain/onMuteStatusUpdated"
    const val onUserSpeaking = "$Domain/onUserSpeaking"
    const val onUserStoppedSpeaking = "$Domain/onUserStoppedSpeaking"
    const val onMissedCall = "$Domain/onMissedCall"
    // call Linking channel
    const val onSubscribeSuccess = "$Domain/onSubscribeSuccess"
    const val onConnectedToSignalServer = "$Domain/onConnectedToSignalServer"
    const val onError = "$Domain/onError"
//    const val onLocalTrack = "$Domain/onLocalTrack"
    const val onUsersUpdated = "$Domain/onUsersUpdated"

    const val onCallLogsUpdatedChannel = "$Domain/onCallLog"
    const val onCallLogDeletedChannel = "$Domain/onCallLogDeleted"
    const val clearAllCallLogChannel = "$Domain/clearAllCallLog"

    const val ACTION_CALL_INCOMING =
        "com.mirrorfly.mirrorfly_plugin.ACTION_CALL_INCOMING"

    //    const val ACTION_CALL_START = "com.mirrorfly.mirrorfly_plugin.ACTION_CALL_START"
    const val ACTION_CALL_ACCEPT =
        "com.mirrorfly.mirrorfly_plugin.ACTION_CALL_ACCEPT"
//    const val ACTION_CALL_DECLINE =
//        "com.mirrorfly.mirrorfly_plugin.ACTION_CALL_DECLINE"
//    const val ACTION_CALL_ENDED =
//        "com.mirrorfly.mirrorfly_plugin.ACTION_CALL_ENDED"
//    const val ACTION_CALL_TOGGLE_MUTE =
//        "com.mirrorfly.mirrorfly_plugin.ACTION_CALL_TOGGLE_MUTE"
//    const val ACTION_CALL_TOGGLE_HOLD =
//        "com.mirrorfly.mirrorfly_plugin.ACTION_CALL_TOGGLE_HOLD"
//    const val ACTION_CALL_TIMEOUT =
//        "com.mirrorfly.mirrorfly_plugin.ACTION_CALL_TIMEOUT"
//    const val ACTION_CALL_CALLBACK =
//        "com.mirrorfly.mirrorfly_plugin.ACTION_CALL_CALLBACK"
//    const val ACTION_CALL_CUSTOM =
//        "com.mirrorfly.mirrorfly_plugin.ACTION_CALL_CUSTOM"
//
//
//    const val EXTRA_CALLKIT_INCOMING_DATA = "EXTRA_CALLKIT_INCOMING_DATA"
//
//    const val EXTRA_CALLKIT_ID = "EXTRA_CALLKIT_ID"
//    const val EXTRA_CALLKIT_NAME_CALLER = "EXTRA_CALLKIT_NAME_CALLER"
//    const val EXTRA_CALLKIT_APP_NAME = "EXTRA_CALLKIT_APP_NAME"
//    const val EXTRA_CALLKIT_HANDLE = "EXTRA_CALLKIT_HANDLE"
//    const val EXTRA_CALLKIT_TYPE = "EXTRA_CALLKIT_TYPE"
//    const val EXTRA_CALLKIT_AVATAR = "EXTRA_CALLKIT_AVATAR"
//    const val EXTRA_CALLKIT_DURATION = "EXTRA_CALLKIT_DURATION"
//    const val EXTRA_CALLKIT_TEXT_ACCEPT = "EXTRA_CALLKIT_TEXT_ACCEPT"
//    const val EXTRA_CALLKIT_TEXT_DECLINE = "EXTRA_CALLKIT_TEXT_DECLINE"
//
//    const val EXTRA_CALLKIT_MISSED_CALL_ID = "EXTRA_CALLKIT_MISSED_CALL_ID"
//    const val EXTRA_CALLKIT_MISSED_CALL_SHOW = "EXTRA_CALLKIT_MISSED_CALL_SHOW"
//    const val EXTRA_CALLKIT_MISSED_CALL_COUNT = "EXTRA_CALLKIT_MISSED_CALL_COUNT"
//    const val EXTRA_CALLKIT_MISSED_CALL_SUBTITLE = "EXTRA_CALLKIT_MISSED_CALL_SUBTITLE"
//    const val EXTRA_CALLKIT_MISSED_CALL_CALLBACK_SHOW = "EXTRA_CALLKIT_MISSED_CALL_CALLBACK_SHOW"
//    const val EXTRA_CALLKIT_MISSED_CALL_CALLBACK_TEXT =
//        "EXTRA_CALLKIT_MISSED_CALL_CALLBACK_TEXT"
//
//    const val EXTRA_CALLKIT_EXTRA = "EXTRA_CALLKIT_EXTRA"
//    const val EXTRA_CALLKIT_HEADERS = "EXTRA_CALLKIT_HEADERS"
//    const val EXTRA_CALLKIT_IS_CUSTOM_NOTIFICATION = "EXTRA_CALLKIT_IS_CUSTOM_NOTIFICATION"
//    const val EXTRA_CALLKIT_IS_CUSTOM_SMALL_EX_NOTIFICATION =
//        "EXTRA_CALLKIT_IS_CUSTOM_SMALL_EX_NOTIFICATION"
//    const val EXTRA_CALLKIT_IS_SHOW_LOGO = "EXTRA_CALLKIT_IS_SHOW_LOGO"
//    const val EXTRA_CALLKIT_RINGTONE_PATH = "EXTRA_CALLKIT_RINGTONE_PATH"
//    const val EXTRA_CALLKIT_BACKGROUND_COLOR = "EXTRA_CALLKIT_BACKGROUND_COLOR"
//    const val EXTRA_CALLKIT_BACKGROUND_URL = "EXTRA_CALLKIT_BACKGROUND_URL"
//    const val EXTRA_CALLKIT_ACTION_COLOR = "EXTRA_CALLKIT_ACTION_COLOR"
//    const val EXTRA_CALLKIT_INCOMING_CALL_NOTIFICATION_CHANNEL_NAME =
//        "EXTRA_CALLKIT_INCOMING_CALL_NOTIFICATION_CHANNEL_NAME"
//    const val EXTRA_CALLKIT_MISSED_CALL_NOTIFICATION_CHANNEL_NAME =
//        "EXTRA_CALLKIT_MISSED_CALL_NOTIFICATION_CHANNEL_NAME"
//
//    const val EXTRA_CALLKIT_ACTION_FROM = "EXTRA_CALLKIT_ACTION_FROM"

    const val AUDIO_CALL_PERMISSION =
        "Microphone and PhoneState permissions are needed for Audio calling features"
    const val AUDIO_CALL_PERMISSION12 =
        "Microphone, PhoneState and Nearby devices permissions are needed for Audio calling features"
    const val VIDEO_CALL_PERMISSION =
        "Microphone, Camera and PhoneState permissions are needed for Video calling features"
    const val VIDEO_CALL_PERMISSION12 =
        "Microphone, Camera, PhoneState and Nearby devices permissions are needed for Video calling features"
}